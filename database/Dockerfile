FROM postgres:17

RUN cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && echo "America/Sao_Paulo" > /etc/timezone

COPY sistemascead.sql /docker-entrypoint-initdb.d/
