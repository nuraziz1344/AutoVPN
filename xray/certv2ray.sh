#!/bin/bash
# ==========================================
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# ==========================================
# Getting
clear
echo -e "${GREEN}Start${NC}"
sleep 0.5
source /var/lib/crot/ipvps.conf
domain=$(cat /etc/xray/domain)
echo -e "${CYAN}Stopping service on port 80...${NC}"
sudo lsof -t -i tcp:80 -s tcp:listen | sudo xargs kill
echo -e "${CYAN}Updating packages...${NC}"
sudo apt-get update
echo -e "${CYAN}Installing Certbot...${NC}"
sudo apt-get install certbot python3-certbot-nginx
echo -e "${CYAN}Obtaining SSL certificate...${NC}"
sudo certbot certonly --standalone -d $domain --pre-hook "systemctl stop xray" --post-hook "systemctl start xray" --register-unsafely-without-email
echo -e "${CYAN}Creating symbolic links...${NC}"
sudo ln -sf /etc/letsencrypt/live/$domain/fullchain.pem /etc/xray/xray.crt
sudo ln -sf /etc/letsencrypt/live/$domain/privkey.pem /etc/xray/xray.key
echo -e "${GREEN}SSL certificate obtained and configured successfully.${NC}"
