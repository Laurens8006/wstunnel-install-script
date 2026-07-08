#!/usr/bin/env bash
set -euo pipefail

VERSION="10.6.1"
DOWNLOAD_URL="https://github.com/erebe/wstunnel/releases/download/v${VERSION}/wstunnel_${VERSION}_linux_amd64.tar.gz"

INSTALL_DIR="/usr/local/bin"
SERVICE_USER="wstunnel"
SERVICE_FILE="/etc/systemd/system/wstunnel.service"

read -rp "Server IP or domain: " SERVER_HOST
read -rp "Listening port [8898]: " LISTEN_PORT
LISTEN_PORT=${LISTEN_PORT:-8898}

read -rp "WireGuard server IP [127.0.0.1/localhost]: " WG_IP
WG_IP=${WG_IP:-127.0.0.1}

read -rp "WireGuard port [51820]: " WG_PORT
WG_PORT=${WG_PORT:-51820}

PATH_PREFIX=$(openssl rand -hex 8)

echo
echo "Generated path prefix: $PATH_PREFIX"
echo

TMPDIR=$(mktemp -d)
cd "$TMPDIR"

curl -L -o wstunnel.tar.gz "$DOWNLOAD_URL"
tar -xzf wstunnel.tar.gz
install -m755 wstunnel "$INSTALL_DIR/wstunnel"

if ! id "$SERVICE_USER" >/dev/null 2>&1; then
    useradd --system --no-create-home --shell /usr/sbin/nologin "$SERVICE_USER"
fi

cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=wstunnel Server
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$SERVICE_USER
Group=$SERVICE_USER
ExecStart=$INSTALL_DIR/wstunnel server \
  --restrict-http-upgrade-path-prefix ${PATH_PREFIX} \
  wss://0.0.0.0:${LISTEN_PORT}

Restart=always
RestartSec=5

NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=full
ProtectHome=true

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now wstunnel

echo
echo "=============================================================="
echo "Server installed successfully!"
echo
echo "Windows client command:"
echo
echo "wstunnel.exe client --http-upgrade-path-prefix \"${PATH_PREFIX}\" -L udp://${WG_PORT}:127.0.0.1:${WG_PORT} wss://${SERVER_HOST}:${LISTEN_PORT}"
echo
echo "Linux/macOS client command:"
echo
echo "wstunnel client --http-upgrade-path-prefix \"${PATH_PREFIX}\" -L udp://${WG_PORT}:127.0.0.1:${WG_PORT} wss://${SERVER_HOST}:${LISTEN_PORT}"
echo
echo "=============================================================="
