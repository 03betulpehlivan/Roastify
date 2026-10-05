const test = require('node:test');
const assert = require('node:assert/strict');

const { _internal } = require('./index');

test('parseBearerToken returns token for valid header', () => {
  const token = _internal.parseBearerToken('Bearer abc123');
  assert.equal(token, 'abc123');
});

test('parseBearerToken returns null for invalid header', () => {
  const token = _internal.parseBearerToken('Basic abc123');
  assert.equal(token, null);
});

test('validatePayload returns true for Gemini style payload', () => {
  const validPayload = {
    contents: [
      {
        parts: [{ text: 'hello' }],
      },
    ],
  };
  assert.equal(_internal.validatePayload(validPayload), true);
});

test('validatePayload returns false when contents are missing', () => {
  assert.equal(_internal.validatePayload({}), false);
});

test('resolveRateLimitState limits after threshold', () => {
  const now = Date.now();
  let state = { windowStartMs: now, count: 0 };

  for (let i = 0; i < 21; i += 1) {
    const next = _internal.resolveRateLimitState({
      windowStartMs: state.windowStartMs,
      count: state.count,
      now,
    });
    state = { windowStartMs: next.windowStartMs, count: next.count };
    if (i < 20) {
      assert.equal(next.limited, false);
    } else {
      assert.equal(next.limited, true);
    }
  }
});
