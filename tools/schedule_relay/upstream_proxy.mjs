import { Readable } from 'node:stream';
import { pipeline } from 'node:stream/promises';

const UPSTREAM = 'https://schedule-of.mirea.ru';
const FORWARDED_HEADERS = ['content-type', 'cache-control', 'last-modified', 'etag', 'retry-after'];

export function createUpstreamProxy({ fetchImpl = fetch, timeoutMs = 60_000 } = {}) {
  return async (request, response, url) => {
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
    } catch (error) {
      const code = error?.cause?.code ?? error?.code;
      const category = typeof code === 'string' && /^[A-Z_]{1,40}$/.test(code)
        ? code
        : controller.signal.aborted ? 'TIMEOUT' : 'NETWORK';
      console.error(`Schedule upstream request failed: ${category}`);
      if (!response.headersSent) {
        response.writeHead(controller.signal.aborted ? 504 : 502);
      }
      response.end();
    } finally {
      clearTimeout(timer);
      response.off('close', abort);
    }
  };
}
