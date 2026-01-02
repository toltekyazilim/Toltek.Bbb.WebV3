#!/bin/bash
set -e

# ------------------------------------------------------------------------------
# Toltek BBB WebV3 - UPDATE Script (ROOT)
# Sadece UPDATE yapar, INSTALL yapmaz
# ------------------------------------------------------------------------------

if [ "$EUID" -ne 0 ]; then
  echo "❌ Root olarak çalıştırılmalıdır"
  exit 1
fi

INSTANCE_NAME=${1:-"default-instance"}

echo "📌 Update başlatılıyor... (Instance: $INSTANCE_NAME)"

BASE_DIR="/var/toltek"
INSTANCE_DIR="$BASE_DIR/$INSTANCE_NAME"
APPS_DIR="$INSTANCE_DIR/apps"
SETTINGS_DIR="$INSTANCE_DIR/settings"

APP_DIR="$APPS_DIR/Toltek.Bbb.WebV3"
SERVICE_NAME="$INSTANCE_NAME.bbb.webv3.service"
NGINX_TARGET="/usr/share/bigbluebutton/nginx/$INSTANCE_NAME.bbb.webv3.nginx"
NGINX_SOURCE="$SETTINGS_DIR/nginx/$INSTANCE_NAME.bbb.webv3.nginx"

# ------------------------------------------------------------------------------
# 1️⃣ Repo Update
# ------------------------------------------------------------------------------
echo "🔄 Repository güncelleniyor..."

cd "$APP_DIR"
git fetch origin
git reset --hard origin/main

echo "✅ Repository güncellendi."

# ------------------------------------------------------------------------------
# 2️⃣ Nginx config (idempotent)
# ------------------------------------------------------------------------------
echo "🌐 Nginx konfigürasyonu kontrol ediliyor..."

if [ ! -f "$NGINX_SOURCE" ]; then
  echo "❌ Nginx config bulunamadı: $NGINX_SOURCE"
  exit 1
fi

ln -sfn "$NGINX_SOURCE" "$NGINX_TARGET"
service nginx reload

echo "✅ Nginx reload tamamlandı."

# ------------------------------------------------------------------------------
# 3️⃣ Runtime Restart
# ------------------------------------------------------------------------------
echo "🚀 Runtime servis restart ediliyor..."

systemctl stop "$SERVICE_NAME"
systemctl start "$SERVICE_NAME"

echo "✅ Servis yeniden başlatıldı."

# ------------------------------------------------------------------------------
# 4️⃣ Status
# ------------------------------------------------------------------------------
systemctl --no-pager --lines=10 status "$SERVICE_NAME"

echo "🎉 Update başarıyla tamamlandı."
