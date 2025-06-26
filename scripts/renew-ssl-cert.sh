#!/usr/bin/bash

CERT_DIR="$(dirname "$(dirname "$0")")/../cert"
CERT_FILE="$CERT_DIR/cert.pem"
KEY_FILE="$CERT_DIR/key.pem"

NGINX_CONTAINER_NAME="nginx-devops-container"


if [ ! -d "$CERT_DIR" ]; then
  echo "Директория $CERT_DIR не найдена. Создаю..."
  mkdir -p "$CERT_DIR"
fi

echo "Обновление самоподписанного сертификата..."

openssl req -x509 -newkey rsa:4096 \
  -keyout "$KEY_FILE" \
  -out "$CERT_FILE" \
  -sha256 -days 30 -nodes \
  -subj "/C=XX/ST=PermskiyKrai/L=Perm/O=DevOpsCompany/OU=AAA/CN=nginx-devops"

if [ $? -eq 0 ]; then
  echo "Сертификат успешно обновлён в $CERT_DIR"
else
  echo "Ошибка при обновлении сертификата"
  exit 1
fi

echo "Перезапуск nginx в контейнере ..."

docker exec "$NGINX_CONTAINER_NAME" nginx -s reload

if [ $? -eq 0 ]; then
  echo "nginx успешно перезагружен"
else
  echo "Ошибка при перезагрузке nginx. Лог контейнера:"
  echo "docker logs $NGINX_CONTAINER"
  exit 1
fi








