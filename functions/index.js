const { onRequest } = require('firebase-functions/v2/https');
const admin = require('firebase-admin');

admin.initializeApp();

const GEMINI_API_KEY = process.env.GEMINI_API_KEY || '';
const GEMINI_MODEL = process.env.GEMINI_MODEL || 'gemini-2.5-flash';
const ALLOWED_ORIGINS = (process.env.ALLOWED_ORIGINS || '')
  .split(',')
  .map((origin) => origin.trim())
  .filter(Boolean);
const MAX_PAYLOAD_BYTES = Number(process.env.MAX_PAYLOAD_BYTES || 200000);
const RATE_LIMIT_PER_MINUTE = Number(process.env.RATE_LIMIT_PER_MINUTE || 20);
const RATE_LIMIT_WINDOW_MS = 60 * 1000;
const RATE_LIMIT_COLLECTION = 'rate_limits';
const firestore = admin.firestore();

function setCors(req, res) {
  const origin = req.headers.origin;

  if (ALLOWED_ORIGINS.length > 0 && origin && ALLOWED_ORIGINS.includes(origin)) {
    res.set('Access-Control-Allow-Origin', origin);
    res.set('Vary', 'Origin');
  }

  res.set('Access-Control-Allow-Headers', 'Authorization, Content-Type, X-Firebase-AppCheck');
  res.set('Access-Control-Allow-Methods', 'POST, OPTIONS');
}

function parseBearerToken(authHeader) {
  if (typeof authHeader !== 'string' || !authHeader.startsWith('Bearer ')) {
    return null;
  }
  const token = authHeader.substring('Bearer '.length).trim();
  return token.length > 0 ? token : null;
}

function parseAppCheckToken(appCheckHeader) {
  if (typeof appCheckHeader !== 'string') {
    return null;
  }
  const token = appCheckHeader.trim();
  return token.length > 0 ? token : null;
}

function validatePayload(payload) {
  if (!payload || typeof payload !== 'object' || Array.isArray(payload)) {
    return false;
  }

  if (!Array.isArray(payload.contents) || payload.contents.length === 0) {
    return false;
  }

  return true;
}

function resolveRateLimitState({ windowStartMs, count, now }) {
  let nextWindowStartMs = Number(windowStartMs) || now;
  let nextCount = Number(count) || 0;

  if (now - nextWindowStartMs >= RATE_LIMIT_WINDOW_MS) {
    nextWindowStartMs = now;
    nextCount = 0;
  }

  const limited = nextCount >= RATE_LIMIT_PER_MINUTE;
  if (!limited) {
    nextCount += 1;
  }

  return {
    limited,
    windowStartMs: nextWindowStartMs,
    count: nextCount,
  };
}

async function isRateLimited(uid, now = Date.now()) {
  const docRef = firestore.collection(RATE_LIMIT_COLLECTION).doc(uid);

  return firestore.runTransaction(async (tx) => {
    const snap = await tx.get(docRef);
    const data = snap.exists ? snap.data() : {};
    const next = resolveRateLimitState({
      windowStartMs: data.windowStartMs,
      count: data.count,
      now,
    });

    tx.set(
      docRef,
      {
        uid,
        windowStartMs: next.windowStartMs,
        count: next.count,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true }
    );

    return next.limited;
  });
}

exports.generateContent = onRequest(
  { cors: false, region: 'europe-west1', secrets: ['GEMINI_API_KEY'] },
  async (req, res) => {
    setCors(req, res);

    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    if (req.method !== 'POST') {
      res.status(405).json({ error: 'Method not allowed' });
      return;
    }

    if (!GEMINI_API_KEY) {
      res.status(500).json({ error: 'Server is missing GEMINI_API_KEY' });
      return;
    }

    try {
      const appCheckToken = parseAppCheckToken(req.headers['x-firebase-appcheck']);
      if (!appCheckToken) {
        res.status(401).json({ error: 'Missing App Check token' });
        return;
      }

      try {
        await admin.appCheck().verifyToken(appCheckToken);
      } catch (err) {
        console.error('App Check verification failed', err);
        res.status(401).json({ error: 'Invalid App Check token' });
        return;
      }

      const token = parseBearerToken(req.headers.authorization || '');
      if (!token) {
        res.status(401).json({ error: 'Unauthorized' });
        return;
      }

      const decoded = await admin.auth().verifyIdToken(token);
      if (!decoded?.uid) {
        res.status(401).json({ error: 'Unauthorized' });
        return;
      }

      if (await isRateLimited(decoded.uid)) {
        res.status(429).json({ error: 'Too many requests' });
        return;
      }

      const payload = req.body || {};
      const payloadBytes = Buffer.byteLength(JSON.stringify(payload), 'utf8');

      if (payloadBytes > MAX_PAYLOAD_BYTES) {
        res.status(413).json({ error: 'Payload too large' });
        return;
      }

      if (!validatePayload(payload)) {
        res.status(400).json({ error: 'Invalid request payload' });
        return;
      }

      const url = `https://generativelanguage.googleapis.com/v1/models/${GEMINI_MODEL}:generateContent?key=${GEMINI_API_KEY}`;
      const response = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      });

      const data = await response.json();
      res.status(response.status).json(data);
    } catch (error) {
      console.error('generateContent failed', error);
      res.status(500).json({ error: 'Proxy request failed' });
    }
  }
);

module.exports._internal = {
  parseBearerToken,
  parseAppCheckToken,
  validatePayload,
  resolveRateLimitState,
  isRateLimited,
};
