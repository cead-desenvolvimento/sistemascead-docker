FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl gcc libjpeg-dev zlib1g-dev libpq-dev ghostscript \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/

RUN pip install --upgrade pip && \
    pip install -r requirements.txt

COPY . /app/
COPY config/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 8000
ENV PYTHONPATH=/app
ENTRYPOINT ["/app/entrypoint.sh"]
