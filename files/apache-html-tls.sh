#!/bin/bash
# Update system and install required packages
yum update -y
yum install -y httpd mod_ssl openssl

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Ensure mod_ssl is installed and loaded
if ! apachectl -M | grep -q "ssl_module"; then
    echo "mod_ssl is not enabled. Installing mod_ssl..."
    yum install -y mod_ssl
fi

# Ensure Apache is listening on port 443
if ! grep -q "Listen 443" /etc/httpd/conf.d/ssl.conf; then
    echo "Listen 443" >> /etc/httpd/conf.d/ssl.conf
fi

# Create self-signed SSL certificate
mkdir -p /etc/httpd/ssl
openssl req -newkey rsa:2048 -nodes -keyout /etc/httpd/ssl/apache-selfsigned.key \
  -x509 -days 365 -out /etc/httpd/ssl/apache-selfsigned.crt \
  -subj "/C=US/ST=State/L=City/O=Organization/OU=IT Department/CN=$(hostname)"

# Configure Apache SSL settings properly
cat <<EOF > /etc/httpd/conf.d/ssl.conf
Listen 443
<VirtualHost *:443>
    DocumentRoot "/var/www/html"
    ServerName $(hostname)

    SSLEngine on
    SSLCertificateFile /etc/httpd/ssl/apache-selfsigned.crt
    SSLCertificateKeyFile /etc/httpd/ssl/apache-selfsigned.key

    <Directory "/var/www/html">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>

# Redirect HTTP to HTTPS
<VirtualHost *:80>
    ServerName $(hostname)
    Redirect permanent / https://$(hostname)/
</VirtualHost>
EOF

# Ensure correct permissions for SSL files
chmod 600 /etc/httpd/ssl/apache-selfsigned.key
chmod 644 /etc/httpd/ssl/apache-selfsigned.crt

# Create a simple HTML page
echo "<html><head><style>body{font-family: Verdana, Geneva, Tahoma, sans-serif;background-image: url('https://github.com/cloudsteak/azurestaticwebsite/blob/main/assets/images/wallpaper-2025-01.jpeg?raw=true');background-repeat: no-repeat;background-size: cover; background-position: center;color: white; text-align: center; padding-top: 1%;}</style></head><body><h1>Web:<br>$(hostname)</h1></body></html>" > /var/www/html/index.html

# Restart Apache to apply SSL changes
systemctl restart httpd

# Verify if Apache started successfully
if systemctl status httpd | grep -q "active (running)"; then
    echo "Apache started successfully with SSL on port 443."
else
    echo "Error: Apache failed to start. Check logs."
    journalctl -xeu httpd.service
fi
