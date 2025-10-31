FROM python:3.11-slim

WORKDIR /app

RUN cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && echo "America/Sao_Paulo" > /etc/timezone
ENV TZ=America/Sao_Paulo

RUN apt-get update && apt-get install -y \
    curl gcc libjpeg-dev zlib1g-dev libpq-dev ghostscript \
    && rm -rf /var/lib/apt/lists/*

COPY sistemascead-backend/backend/requirements.txt /app/

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

COPY sistemascead-backend/backend/ /app/
COPY sistemascead-backend/backend/config/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 8000
ENV PYTHONPATH=/app
ENTRYPOINT ["/app/entrypoint.sh"]
