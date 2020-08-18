#!/bin/bash -v

sudo yum update -y
sudo yum install -y httpd

mkdir -p /var/www/html && touch /var/www/html/index.html
echo "<html><h1> Hello World </h1></html>" > /var/www/html/index.html
sudo service httpd start