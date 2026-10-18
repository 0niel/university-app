import http from 'node:http';
import { evaluateRelayRequest } from './request_policy.mjs';
import { createUpstreamProxy } from './upstream_proxy.mjs';

export function createRelayServer({ authorization, fetchImpl, timeoutMs }) {
  authorization = authorization?.trim();
  if (!authorization) throw new Error('RELAY_AUTHORIZATION is required');
  const forward = createUpstreamProxy({ fetchImpl, timeoutMs });

  return http.createServer(async (request, response) => {
    const result = evaluateRelayRequest(request, authorization);
    if ('status' in result) {
      response.writeHead(result.status, result.headers).end(result.body);
      return;
    }
    await forward(request, response, result.url);
  });
}
