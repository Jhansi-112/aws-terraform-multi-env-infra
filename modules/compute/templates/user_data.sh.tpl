#!/bin/bash
# Start-up script: starts a small web server so the load balancer health check passes.
echo "APP_ENV=${environment}" >> /etc/environment
mkdir -p /opt/app
echo "ok" > /opt/app/health
echo "Hello from ${environment} - $(hostname)" > /opt/app/index.html

cat > /etc/systemd/system/app.service <<'UNIT'
[Unit]
Description=Simple demo web app
After=network.target

[Service]
WorkingDirectory=/opt/app
ExecStart=/usr/bin/python3 -m http.server ${app_port}
Restart=always

[Install]
WantedBy=multi-user.target
UNIT

systemctl daemon-reload
systemctl enable --now app.service
