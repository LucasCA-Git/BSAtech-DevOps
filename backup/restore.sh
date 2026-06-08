#!/bin/bash

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$PROJECT_ROOT/.env"

if [ -z "$1" ]; then
    echo "Uso:"
    echo "./backups/restore.sh arquivo.sql"
    exit 1
fi

cat "$1" | docker compose exec -T mysql \
  mysql \
  -u"${MYSQL_USER}" \
  -p"${MYSQL_PASSWORD}" \
  "${MYSQL_DATABASE}"

echo "Restore concluído."