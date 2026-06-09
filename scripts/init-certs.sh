#!/bin/sh
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

CERT_DIR=/certs
mkdir -p "$CERT_DIR"

if [ ! -f "$CERT_DIR/nginx.crt" ]; then
  echo "${YELLOW}Gerando certificado autoassinado...${NC}"
  openssl req -x509 \
    -nodes \
    -days 365 \
    -newkey rsa:4096 \
    -keyout "$CERT_DIR/nginx.key" \
    -out "$CERT_DIR/nginx.crt" \
    -subj "/C=BR/ST=Pernambuco/L=Recife/O=BSAtech/CN=localhost" \
    2>/dev/null
  echo "${GREEN}Certificado gerado com sucesso!${NC}"
  ls -lh "$CERT_DIR/"
else
  echo "${GREEN}Certificados já existem. Pulando geração.${NC}"
fi

echo "${GREEN}Certificados prontos.${NC}"