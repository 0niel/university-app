export function pushBatchBudget(now = () => performance.now()): () => boolean {
  const deadline = now() + 60_000;
  return () => now() < deadline;
}

export const pushRpcFetch: typeof fetch = (input, init) => {
  const signal = init && "signal" in init ? init.signal : undefined;
  return fetch(input, {
    ...init,
    signal: signal
      ? AbortSignal.any([signal, AbortSignal.timeout(5_000)])
      : AbortSignal.timeout(5_000),
  });
};
