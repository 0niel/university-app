FROM python:3.11-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y gcc g++ && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt 

FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/* && \
    groupadd -g 1000 appuser && \
    useradd -u 1000 -g appuser -m -s /bin/bash appuser

COPY --from=builder /root/.local /home/appuser/.local
COPY --chown=appuser:appuser . .

RUN mkdir -p /app/data /app/sessions /app/logs && \
    chown -R appuser:appuser /app /home/appuser/.local && \
    chmod -R 755 /app && \
    chmod -R 777 /app/data /app/sessions /app/logs && \
    find /app -name "*.session*" -exec chmod 666 {} \; 2>/dev/null || true

USER appuser

ENV PATH=/home/appuser/.local/bin:$PATH

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 CMD python -c "import requests; requests.get('http://localhost:8000/api/health')" || exit 1

CMD ["python", "main.py"]
