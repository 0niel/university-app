import { createRelayServer } from './server.mjs';

const port = Number(process.env.PORT ?? process.env.RELAY_PORT ?? 8787);
const host = process.env.RELAY_HOST ?? '127.0.0.1';
const server = createRelayServer({ authorization: process.env.RELAY_AUTHORIZATION });

server.listen(port, host, () => {
  console.log(`schedule relay listening on ${host}:${port}`);
});

for (const signal of ['SIGTERM', 'SIGINT']) {
  process.once(signal, () => {
    server.close(() => process.exit(0));
    setTimeout(() => server.closeAllConnections(), 25_000).unref();
  });
}
