#!/bin/bash

sudo hostnamectl set-hostname web-01-host
sudo dnf update -y
sudo dnf install -y nginx
sudo systemctl enable --now nginx
sudo echo "Hello From DEPI 206 Terraform Trial" > /usr/share/nginx/html/index.html