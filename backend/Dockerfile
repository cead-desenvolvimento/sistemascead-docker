FROM python:3.12-slim

ENV PYTHONPATH=/app \
    TZ=America/Sao_Paulo
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    tzdata \
    ghostscript \
    libjpeg-dev \
    zlib1g-dev \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && rm -rf /var/lib/apt/lists/*

COPY sistemascead-backend/backend/requirements.txt /tmp/requirements.txt

RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r /tmp/requirements.txt

COPY sistemascead-backend/backend/ /app/

RUN chmod +x /app/config/entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/app/config/entrypoint.sh"]
