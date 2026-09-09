#!/bin/bash
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
echo "<html><head><style>body{font-family:Verdana,Geneva,Tahoma,sans-serif;background:#1d4ed8;color:white;text-align:center;padding-top:1%;}</style></head><body><h1>Web:<br>$(hostname)</h1></body></html>" > /var/www/html/index.html
