export function evaluateRelayRequest(request, authorization) {
  if (request.method !== 'GET' && request.method !== 'HEAD') {
    return { status: 405, headers: { allow: 'GET, HEAD' } };
  }
  let url;
  try {
    url = new URL(request.url ?? '/', 'http://localhost');
  } catch {
    return { status: 400 };
  }
  if (url.pathname === '/healthz') {
    return { status: 200, headers: { 'content-type': 'text/plain' }, body: 'ok' };
  }
  if (!url.pathname.startsWith('/schedule/api/')) {
    return { status: 404 };
  }
  if (request.headers.authorization !== authorization) {
    return { status: 401, headers: { 'cache-control': 'no-store' } };
  }
  return { url };
}
