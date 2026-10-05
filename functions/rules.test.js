const test = require('node:test');
const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const path = require('node:path');
const {
  initializeTestEnvironment,
  assertSucceeds,
  assertFails,
} = require('@firebase/rules-unit-testing');

const PROJECT_ID = 'ai-roast-battle-rules-test';

const firestoreRules = readFileSync(
  path.resolve(__dirname, '..', 'firestore.rules'),
  'utf8',
);
const storageRules = readFileSync(
  path.resolve(__dirname, '..', 'storage.rules'),
  'utf8',
);

let testEnv;

test.before(async () => {
  testEnv = await initializeTestEnvironment({
    projectId: PROJECT_ID,
    firestore: { rules: firestoreRules },
    storage: { rules: storageRules },
  });
});

test.after(async () => {
  if (testEnv) {
    await testEnv.cleanup();
  }
});

test.afterEach(async () => {
  if (testEnv) {
    await testEnv.clearFirestore();
  }
});

test('firestore: allows owner to create valid vitrin document', async () => {
  const ownerCtx = testEnv.authenticatedContext('uid_owner');
  const db = ownerCtx.firestore();

  await assertSucceeds(
    db.collection('vitrin').doc('share_1').set({
      id: 'share_1',
      tip: 'tekli',
      tekliRoast: { metin: 'x' },
      fotograf1Url: 'https://example.com/f1.jpg',
      thumbnail1Url: 'https://example.com/t1.jpg',
      paylasanId: 'uid_owner',
      paylasanAdi: 'tester',
      tepkiler: { rip: 0, boom: 0, fire: 0 },
      tarih: '2026-01-01T00:00:00.000Z',
    }),
  );
});

test('firestore: rejects create when paylasanId is not auth uid', async () => {
  const attackerCtx = testEnv.authenticatedContext('uid_attacker');
  const db = attackerCtx.firestore();

  await assertFails(
    db.collection('vitrin').doc('share_2').set({
      id: 'share_2',
      tip: 'tekli',
      tekliRoast: { metin: 'x' },
      fotograf1Url: 'https://example.com/f1.jpg',
      thumbnail1Url: 'https://example.com/t1.jpg',
      paylasanId: 'uid_owner',
      paylasanAdi: 'owner',
      tepkiler: { rip: 0, boom: 0, fire: 0 },
      tarih: '2026-01-01T00:00:00.000Z',
    }),
  );
});

test('firestore: allows exactly +1 reaction increment in update', async () => {
  await testEnv.withSecurityRulesDisabled(async (ctx) => {
    await ctx.firestore().collection('vitrin').doc('share_3').set({
      id: 'share_3',
      tip: 'tekli',
      tekliRoast: { metin: 'x' },
      fotograf1Url: 'https://example.com/f1.jpg',
      thumbnail1Url: 'https://example.com/t1.jpg',
      paylasanId: 'uid_owner',
      paylasanAdi: 'owner',
      tepkiler: { rip: 0, boom: 0, fire: 0 },
      tarih: '2026-01-01T00:00:00.000Z',
    });
  });

  const userCtx = testEnv.authenticatedContext('uid_any');
  const doc = userCtx.firestore().collection('vitrin').doc('share_3');

  await assertSucceeds(doc.update({ tepkiler: { rip: 1, boom: 0, fire: 0 } }));
});

test('firestore: rejects multi-field or multi-step reaction update', async () => {
  await testEnv.withSecurityRulesDisabled(async (ctx) => {
    await ctx.firestore().collection('vitrin').doc('share_4').set({
      id: 'share_4',
      tip: 'tekli',
      tekliRoast: { metin: 'x' },
      fotograf1Url: 'https://example.com/f1.jpg',
      thumbnail1Url: 'https://example.com/t1.jpg',
      paylasanId: 'uid_owner',
      paylasanAdi: 'owner',
      tepkiler: { rip: 0, boom: 0, fire: 0 },
      tarih: '2026-01-01T00:00:00.000Z',
    });
  });

  const userCtx = testEnv.authenticatedContext('uid_any');
  const doc = userCtx.firestore().collection('vitrin').doc('share_4');

  await assertFails(doc.update({ tepkiler: { rip: 1, boom: 1, fire: 0 } }));
  await assertFails(doc.update({ tepkiler: { rip: 2, boom: 0, fire: 0 } }));
});

test('storage: owner can upload to own uid path', async () => {
  const ownerCtx = testEnv.authenticatedContext('uid_owner');
  const storage = ownerCtx.storage();
  const ref = storage.ref('vitrin_medya/uid_owner/share_1/foto.jpg');

  await assertSucceeds(ref.putString('jpeg-data', 'raw', { contentType: 'image/jpeg' }));
});

test('storage: rejects upload to another uid path', async () => {
  const attackerCtx = testEnv.authenticatedContext('uid_attacker');
  const storage = attackerCtx.storage();
  const ref = storage.ref('vitrin_medya/uid_owner/share_1/foto.jpg');

  await assertFails(ref.putString('jpeg-data', 'raw', { contentType: 'image/jpeg' }));
});

test('storage: rejects invalid file name', async () => {
  const ownerCtx = testEnv.authenticatedContext('uid_owner');
  const storage = ownerCtx.storage();
  const ref = storage.ref('vitrin_medya/uid_owner/share_1/random.png');

  await assertFails(ref.putString('png-data', 'raw', { contentType: 'image/png' }));
});

test('sanity: rules text loaded', async () => {
  assert.ok(firestoreRules.includes('match /vitrin/{shareId}'));
  assert.ok(storageRules.includes('match /vitrin_medya/{userId}/{shareId}/{fileName}'));
});
