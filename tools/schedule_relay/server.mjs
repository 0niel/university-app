import http from 'node:http';
import { Readable } from 'node:stream';
import { pipeline } from 'node:stream/promises';

const UPSTREAM = 'https://schedule-of.mirea.ru';
const FORWARDED_HEADERS = ['content-type', 'cache-control', 'last-modified', 'etag'];

export function createRelayServer({ authorization, fetchImpl = fetch, timeoutMs = 60_000 }) {
  authorization = authorization?.trim();
  if (!authorization) throw new Error('RELAY_AUTHORIZATION is required');

  return http.createServer(async (request, response) => {
    if (request.method !== 'GET' && request.method !== 'HEAD') {
      response.writeHead(405, { allow: 'GET, HEAD' }).end();
      return;
    }
    let url;
    try {
      url = new URL(request.url ?? '/', 'http://localhost');
    } catch {
      response.writeHead(400).end();
      return;
    }
    if (url.pathname === '/healthz') {
      response.writeHead(200, { 'content-type': 'text/plain' }).end('ok');
      return;
    }
    if (!url.pathname.startsWith('/schedule/api/')) {
      response.writeHead(404).end();
      return;
    }
    if (request.headers.authorization !== authorization) {
      response.writeHead(401, { 'cache-control': 'no-store' }).end();
      return;
    }

    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), timeoutMs);
    const abort = () => {
      if (!response.writableFinished) controller.abort();
    };
    response.once('close', abort);
    try {
      const upstream = await fetchImpl(new URL(url.pathname + url.search, UPSTREAM), {
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
        await upstream.body?.cancel();
        response.end();
        return;
      }
      await pipeline(Readable.fromWeb(upstream.body), response);
    } catch {
      if (!response.headersSent) {
        response.writeHead(controller.signal.aborted ? 504 : 502);
      }
      response.end();
    } finally {
      clearTimeout(timer);
      response.off('close', abort);
    }
  });
}
