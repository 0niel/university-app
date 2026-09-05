const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const { test } = require('node:test');

const source = fs.readFileSync(
  path.join(__dirname, '../../web/firebase-messaging-sw.js'), 'utf8');

function worker({ enabled = true, windows = [] } = {}) {
  const handlers = {};
  const imported = [];
  const notifications = [];
  const opened = [];
  let background;
  const self = {
    location: { origin: 'https://app.example' },
    addEventListener: (name, callback) => { handlers[name] = callback; },
    clients: {
      matchAll: async () => windows,
      openWindow: async (url) => { opened.push(url); },
    },
    registration: {
      showNotification: async (title, options) => { notifications.push({ title, options }); },
    },
  };
  const context = {
    self,
    URL,
    importScripts: (...urls) => {
      imported.push(...urls);
      if (urls[0] === './firebase-messaging-config.js') {
        self.firebaseMessagingConfig = {
          enabled,
          sdkVersion: '12.14.0',
          firebase: { projectId: 'test-project' },
        };
      } else {
        assert.ok(handlers.notificationclick);
      }
    },
    firebase: {
      initializeApp: (config) => { assert.equal(config.projectId, 'test-project'); },
      messaging: () => ({ onBackgroundMessage: (callback) => { background = callback; } }),
    },
  };
  vm.runInNewContext(source, context);
  return {
    imported, notifications, opened,
    message: (payload) => background(payload),
    click: async (data) => {
      let pending;
      let closed = false;
      let stopped = false;
      handlers.notificationclick({
        notification: { data, close: () => { closed = true; } },
        stopImmediatePropagation: () => { stopped = true; },
        waitUntil: (promise) => { pending = promise; },
      });
      await pending;
      assert.equal(closed, true);
      assert.equal(stopped, true);
    },
  };
}

test('loads matching Firebase SDK only when enabled', () => {
  assert.deepEqual(worker({ enabled: false }).imported, ['./firebase-messaging-config.js']);
  assert.deepEqual(worker().imported, [
    './firebase-messaging-config.js',
    'https://www.gstatic.com/firebasejs/12.14.0/firebase-app-compat.js',
    'https://www.gstatic.com/firebasejs/12.14.0/firebase-messaging-compat.js',
  ]);
});

test('does not duplicate notifications already displayed by Firebase', async () => {
  const app = worker();
  await app.message({ notification: { title: 'Title' }, data: { title: 'Title' } });
  await app.message({ data: { route: '/services/people' } });
  assert.equal(app.notifications.length, 0);
});

test('data messages use stable notification identity and preserve route', async () => {
  const app = worker();
  await app.message({
    data: { title: 'Friend request', body: 'Body', route: '/services/people?tab=friends', notification_id: 'id' },
  });
  assert.equal(app.notifications.length, 1);
  assert.equal(app.notifications[0].options.tag, 'id');
  assert.equal(app.notifications[0].options.data.route, '/services/people?tab=friends');
});

test('cold click opens the route from a Firebase notification', async () => {
  const app = worker();
  await app.click({ FCM_MSG: { data: { route: '/services/people?tab=friends' } } });
  assert.deepEqual(app.opened, ['https://app.example/services/people?tab=friends']);
});

test('legacy Discourse click opens a positive post ID without an explicit route', async () => {
  const app = worker();
  await app.click({ FCM_MSG: { data: { discourse_post_id: '42' } } });
  assert.deepEqual(app.opened, ['https://app.example/services/discourse-post-overview/42']);
});

test('invalid Discourse IDs do not become click routes', async () => {
  for (const discourse_post_id of ['0', '-42', '1.5', '1e2', '42/../profile', true, 1.5, '9007199254740992']) {
    const app = worker();
    await app.click({ FCM_MSG: { data: { discourse_post_id } } });
    assert.deepEqual(app.opened, ['https://app.example/']);
  }
});

test('safe explicit routes win and unsafe routes fall back to the Discourse post', async () => {
  const explicit = worker();
  await explicit.click({ route: '/profile', discourse_post_id: '42' });
  assert.deepEqual(explicit.opened, ['https://app.example/profile']);
  const unsafe = worker();
  await unsafe.click({ route: '//evil.example', discourse_post_id: '42' });
  assert.deepEqual(unsafe.opened, ['https://app.example/services/discourse-post-overview/42']);
});

test('warm click navigates and focuses an existing app window', async () => {
  const navigated = [];
  let focused = false;
  const app = worker({ windows: [{
    url: 'https://app.example/',
    navigate: async (url) => {
      navigated.push(url);
      return { focus: async () => { focused = true; } };
    },
  }] });
  await app.click({ route: '/services/people?tab=group' });
  assert.deepEqual(navigated, ['https://app.example/services/people?tab=group']);
  assert.equal(focused, true);
  assert.equal(app.opened.length, 0);
});

test('rejects external and protocol-relative click destinations', async () => {
  for (const route of ['https://evil.example', '//evil.example', '/\\evil.example', '/\n/evil.example']) {
    const app = worker();
    await app.click({ route });
    assert.deepEqual(app.opened, ['https://app.example/']);
  }
});

test('a window closing during navigation falls back to opening the route', async () => {
  const app = worker({ windows: [{
    url: 'https://app.example/',
    navigate: async () => { throw new Error('Window closed'); },
  }] });
  await app.click({ route: '/profile' });
  assert.deepEqual(app.opened, ['https://app.example/profile']);
});
