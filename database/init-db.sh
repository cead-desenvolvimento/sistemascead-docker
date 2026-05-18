#!/bin/sh
set -eu

: "${POSTGRES_USER:?POSTGRES_USER não definido}"
: "${POSTGRES_DB:?POSTGRES_DB não definido}"

if psql -tA \
    --username "$POSTGRES_USER" \
    --dbname "$POSTGRES_DB" \
    -c "SELECT 1
        FROM pg_tables
        WHERE schemaname = 'sistemascead'
          AND tablename = 'cm_pessoa'
        LIMIT 1" | grep -q 1; then
    echo "Tabela sistemascead.cm_pessoa já existe; restore abortado."
    exit 0
fi

echo "Restaurando dump em '${POSTGRES_DB}'..."

pg_restore --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
  /docker-entrypoint-initdb.d/sistemascead.dump
