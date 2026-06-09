#!/bin/bash

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$PROJECT_ROOT/.env"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p "$PROJECT_ROOT/backup"

docker compose exec -T mysql \
  mysqldump \
  --no-tablespaces \
  -u"${MYSQL_USER}" \
  -p"${MYSQL_PASSWORD}" \
  "${MYSQL_DATABASE}" \
  > "$PROJECT_ROOT/backup/ghost_${TIMESTAMP}.sql"

echo ""
echo "Backup criado:"
ls -lh "$PROJECT_ROOT/backup" | tail -n 1