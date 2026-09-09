#!/bin/bash
yum update -y
yum install -y httpd.x86_64
systemctl enable httpd.service

cat << 'EOF' > /usr/local/bin/generate-index.sh
#!/bin/bash
echo "<html><head><style>body{font-family: Verdana, Geneva, Tahoma, sans-serif;background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);background-attachment: fixed;color: white; text-align: center; padding-top: 1%; min-height: 100vh; margin: 0;}</style></head><body><h1>Web:<br>$(hostname)</h1></body></html>" > /var/www/html/index.html
EOF
chmod +x /usr/local/bin/generate-index.sh

cat << 'EOF' > /etc/systemd/system/generate-index.service
[Unit]
Description=Generate index.html with current hostname
Before=httpd.service
[Service]
Type=oneshot
ExecStart=/usr/local/bin/generate-index.sh
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF

systemctl enable generate-index.service
systemctl start generate-index.service
systemctl start httpd.service