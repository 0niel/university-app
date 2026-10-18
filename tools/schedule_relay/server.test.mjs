import assert from 'node:assert/strict';
import { once } from 'node:events';
import { test } from 'node:test';
import { createRelayServer } from './server.mjs';

async function start(t, options = {}) {
  const server = createRelayServer({ authorization: 'Bearer test-token', ...options });
  server.listen(0, '127.0.0.1');
  await once(server, 'listening');
  t.after(() => new Promise(resolve => {
    server.close(resolve);
    server.closeAllConnections();
  }));
  return `http://127.0.0.1:${server.address().port}`;
}

const headers = { authorization: 'Bearer test-token' };

test('requires a nonempty authorization value', () => {
  assert.throws(() => createRelayServer({ authorization: ' ' }), /required/);
});

test('health, rejected paths, methods and credentials never contact upstream', async t => {
  const origin = await start(t, { fetchImpl: () => assert.fail('unexpected upstream request') });
  const cases = [
    ['/healthz', {}, 200],
    ['/healthz', { method: 'HEAD' }, 200],
    ['/healthz', { method: 'POST' }, 405],
    ['/other', { headers }, 404],
    ['/schedule/api/../../admin', { headers }, 404],
    ['/schedule/api/search', {}, 401],
    ['/schedule/api/search', { headers: { authorization: 'wrong' } }, 401],
    ['/schedule/api/search', { headers, method: 'POST' }, 405],
  ];
  for (const [path, options, expected] of cases) {
    const response = await fetch(origin + path, options);
    assert.equal(response.status, expected, path);
    await response.text();
  }
});

test('forwards calendars to the fixed origin without forwarding credentials', async t => {
  const requests = [];
  const origin = await start(t, {
    fetchImpl: async (url, options) => {
      requests.push({ url: url.href, ...options });
      return new Response('calendar content', {
        headers: {
          'content-type': 'text/calendar',
          'content-length': '9999',
          'content-encoding': 'gzip',
          'set-cookie': 'private=value',
          etag: 'version1',
        },
      });
    },
  });
  const response = await fetch(origin + '/schedule/api/ical/group?id=12', {
    headers: { ...headers, accept: 'text/calendar', cookie: 'private=value' },
  });
  assert.equal(response.status, 200);
  assert.equal(await response.text(), 'calendar content');
  assert.equal(response.headers.get('content-type'), 'text/calendar');
  assert.equal(response.headers.get('content-length'), null);
  assert.equal(response.headers.get('content-encoding'), null);
  assert.equal(response.headers.get('set-cookie'), null);
  assert.equal(response.headers.get('etag'), 'version1');
  assert.equal(requests[0].url, 'https://schedule-of.mirea.ru/schedule/api/ical/group?id=12');
  assert.equal(requests[0].redirect, 'manual');
  assert.deepEqual(Object.keys(requests[0].headers).sort(), ['accept', 'user-agent']);
});

test('never redirects the client to another host', async t => {
  const origin = await start(t, {
    fetchImpl: async () => new Response(null, {
      status: 302,
      headers: { location: 'https://other.example/private' },
    }),
  });
  const response = await fetch(origin + '/schedule/api/search', { headers, redirect: 'manual' });
  assert.equal(response.status, 302);
  assert.equal(response.headers.get('location'), null);
});

test('maps network failures to 502 and aborts timed-out upstream requests', async t => {
  const failed = await start(t, { fetchImpl: async () => { throw new Error('private detail'); } });
  assert.equal((await fetch(failed + '/schedule/api/search', { headers })).status, 502);

  let aborted = false;
  const timedOut = await start(t, {
    timeoutMs: 20,
    fetchImpl: async (_url, { signal }) => new Promise((_resolve, reject) => {
      signal.addEventListener('abort', () => {
        aborted = true;
        reject(new Error('timeout'));
      }, { once: true });
    }),
  });
  const response = await fetch(timedOut + '/schedule/api/search', { headers });
  assert.equal(response.status, 504);
  assert.equal(await response.text(), '');
  assert.equal(aborted, true);
});
