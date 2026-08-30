FROM python:3.12-slim-bookworm AS builder

WORKDIR /app
ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_CACHE_DIR=1

COPY requirements.txt .
RUN python -m pip install --upgrade pip setuptools wheel && \
    pip install --no-cache-dir --user -r requirements.txt

FROM python:3.12-slim-bookworm

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/* && \
    groupadd -g 1000 appuser && \
    useradd -u 1000 -g appuser -m -s /bin/bash appuser

COPY --from=builder /root/.local /home/appuser/.local
COPY --chown=appuser:appuser . .

RUN mkdir -p /app/data /app/sessions /app/logs && \
    chown -R appuser:appuser /app /home/appuser/.local && \
    chmod -R 755 /app && \
    chmod 700 /app/data /app/sessions /app/logs

USER appuser

ENV PATH=/home/appuser/.local/bin:$PATH

CMD ["python", "worker.py"]
