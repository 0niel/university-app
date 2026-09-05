self.addEventListener('notificationclick', (event) => {
  event.stopImmediatePropagation();
  event.notification.close();
  const data = event.notification.data?.FCM_MSG?.data ?? event.notification.data;
  const postId = data?.discourse_post_id;
  const parsedPostId = typeof postId === 'number'
    ? postId
    : typeof postId === 'string' && /^\d+$/.test(postId.trim()) ? Number(postId) : 0;
  const fallbackRoute = Number.isSafeInteger(parsedPostId) && parsedPostId > 0
    ? `/services/discourse-post-overview/${parsedPostId}`
    : '/';
  const route = typeof data?.route === 'string' ? data.route : fallbackRoute;
  let target = new URL(fallbackRoute, self.location.origin);
  if (route.startsWith('/') && !route.startsWith('//') && !route.includes('\\')) {
    const candidate = new URL(route, self.location.origin);
    if (candidate.origin === self.location.origin) target = candidate;
  }
  event.waitUntil((async () => {
    const windows = await self.clients.matchAll({
      type: 'window',
      includeUncontrolled: true,
    });
    const existing = windows.find((client) => client.url === target.href) ??
      windows.find((client) => new URL(client.url).origin === target.origin);
    if (existing) {
      try {
        const client = existing.url === target.href
          ? existing
          : await existing.navigate(target.href);
        if (client) return await client.focus();
      } catch (_) {}
    }
    return self.clients.openWindow(target.href);
  })());
});

importScripts('./firebase-messaging-config.js');

if (self.firebaseMessagingConfig?.enabled) {
  const { firebase: config, sdkVersion } = self.firebaseMessagingConfig;
  importScripts(
    `https://www.gstatic.com/firebasejs/${sdkVersion}/firebase-app-compat.js`,
    `https://www.gstatic.com/firebasejs/${sdkVersion}/firebase-messaging-compat.js`,
  );
  firebase.initializeApp(config);
  firebase.messaging().onBackgroundMessage((payload) => {
    if (payload.notification) return;
    const data = payload.data ?? {};
    if (typeof data.title !== 'string' || !data.title.trim()) return;
    return self.registration.showNotification(data.title, {
      body: typeof data.body === 'string' ? data.body : '',
      icon: '/icons/Icon-192.png',
      tag: data.notification_id || payload.messageId,
      data,
    });
  });
}
