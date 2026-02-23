#!/bin/bash
# =============================================================================
# Kali Linux Tools Interface - Setup Script v3.0
# =============================================================================
# This script installs and configures the Kali Linux Tools Interface.
# Run as root: sudo bash setup.sh
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║        Kali Linux Tools Interface - Setup v3.0          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[!] Please run as root: sudo bash setup.sh${NC}"
    exit 1
fi

# ---- Step 1: Install Dependencies ----
echo -e "${YELLOW}[1/6] Installing dependencies...${NC}"
apt-get update -qq
apt-get install -y -qq apache2 mariadb-server php php-mysql php-mbstring php-xml openssh-server > /dev/null 2>&1
echo -e "${GREEN}  [+] Dependencies installed${NC}"

# ---- Step 2: Start Services ----
echo -e "${YELLOW}[2/6] Starting services...${NC}"
systemctl enable --now mariadb > /dev/null 2>&1
systemctl enable --now apache2 > /dev/null 2>&1
systemctl enable --now ssh > /dev/null 2>&1
echo -e "${GREEN}  [+] MariaDB, Apache, SSH started${NC}"

# ---- Step 3: Set up database ----
echo -e "${YELLOW}[3/6] Setting up MariaDB database...${NC}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if mysql -e "SELECT 1" > /dev/null 2>&1; then
    mysql < "${SCRIPT_DIR}/assets/database.sql"
    echo -e "${GREEN}  [+] Database 'kali_tools' created and populated${NC}"
else
    echo -e "${RED}  [!] Could not connect to MariaDB. Please check the service.${NC}"
    echo -e "${YELLOW}  [*] You can manually import: sudo mysql < assets/database.sql${NC}"
fi

# ---- Step 4: Deploy to web server ----
echo -e "${YELLOW}[4/6] Deploying to web server...${NC}"
WEB_DIR="/var/www/html/kali-tools"

if [ "$SCRIPT_DIR" != "$WEB_DIR" ]; then
    mkdir -p "$WEB_DIR"
    cp -r "${SCRIPT_DIR}/"* "$WEB_DIR/"
    cp -r "${SCRIPT_DIR}/".[!.]* "$WEB_DIR/" 2>/dev/null || true
    echo -e "${GREEN}  [+] Deployed to ${WEB_DIR}${NC}"
else
    echo -e "${GREEN}  [+] Already in web directory${NC}"
fi

# ---- Step 5: Set permissions ----
echo -e "${YELLOW}[5/6] Setting permissions...${NC}"
chown -R www-data:www-data "$WEB_DIR"
chmod -R 755 "$WEB_DIR"
echo -e "${GREEN}  [+] Permissions set${NC}"

# ---- Step 6: Optional - Install ttyd ----
echo -e "${YELLOW}[6/6] Checking for ttyd (web terminal)...${NC}"
if command -v ttyd &> /dev/null; then
    echo -e "${GREEN}  [+] ttyd is already installed${NC}"
else
    echo -e "${YELLOW}  [*] Installing ttyd...${NC}"
    apt-get install -y -qq ttyd > /dev/null 2>&1 && \
        echo -e "${GREEN}  [+] ttyd installed${NC}" || \
        echo -e "${YELLOW}  [*] ttyd not available in repos. Install manually: https://github.com/tsl0922/ttyd${NC}"
fi

# ---- Done ----
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗"
echo -e "║                   Setup Complete!                        ║"
echo -e "╠══════════════════════════════════════════════════════════╣"
echo -e "║                                                          ║"
echo -e "║  URL:      http://localhost/kali-tools/                  ║"
echo -e "║  Login:    Use your SSH credentials                      ║"
echo -e "║  Database: kali_tools (MariaDB)                          ║"
echo -e "║                                                          ║"
echo -e "║  To start ttyd terminal:                                 ║"
echo -e "║    ttyd -p 7681 bash &                                   ║"
echo -e "║                                                          ║"
echo -e "╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
