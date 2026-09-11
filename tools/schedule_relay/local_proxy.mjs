import http from 'node:http';

const UPSTREAM = 'https://schedule-of.mirea.ru';
const ALLOWED_PREFIX = '/schedule/api/';
const PORT = Number(process.env.RELAY_PORT ?? 8787);
const AUTHORIZATION = process.env.RELAY_AUTHORIZATION?.trim();
const FORWARDED_HEADERS = ['content-type', 'content-length', 'cache-control', 'last-modified', 'etag'];

if (!AUTHORIZATION) {
  console.error('RELAY_AUTHORIZATION is required');
  process.exit(1);
}

const server = http.createServer(async (request, response) => {
  const url = new URL(request.url ?? '/', 'http://localhost');
  if (url.pathname === '/healthz') {
    response.writeHead(200).end('ok');
    return;
  }
  if (request.method !== 'GET' && request.method !== 'HEAD') {
    response.writeHead(405).end();
    return;
  }
  if (!url.pathname.startsWith(ALLOWED_PREFIX)) {
    response.writeHead(404).end();
    return;
  }
  if (request.headers.authorization !== AUTHORIZATION) {
    response.writeHead(401).end();
    return;
  }

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), 60_000);
  try {
    const upstream = await fetch(new URL(url.pathname + url.search, UPSTREAM), {
      method: request.method,
      headers: {
        accept: request.headers.accept ?? '*/*',
        'user-agent': 'university-app-schedule-relay/1.0',
      },
      redirect: 'manual',
      signal: controller.signal,
    });
    const headers = {};
    for (const name of FORWARDED_HEADERS) {
      const value = upstream.headers.get(name);
      if (value) headers[name] = value;
    }
    response.writeHead(upstream.status, headers);
    if (request.method === 'HEAD' || !upstream.body) {
      response.end();
      return;
    }
    for await (const chunk of upstream.body) {
      response.write(chunk);
    }
    response.end();
  } catch (error) {
    console.error(`${new Date().toISOString()} ${url.pathname} failed: ${error.message}`);
    if (!response.headersSent) response.writeHead(502);
    response.end();
  } finally {
    clearTimeout(timer);
  }
});

server.listen(PORT, '127.0.0.1', () => {
  console.log(`schedule relay listening on 127.0.0.1:${PORT}`);
});
