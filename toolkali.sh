#!/bin/bash
# ToolKali v1.0 - by aqifmuqri-lab | Long Lama, Baram

# Colors
red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
blue='\033[1;34m'
cyan='\033[1;36m'
white='\033[1;37m'
reset='\033[0m'

banner() {
clear
echo -e "${cyan}"
echo "  _______          _  __     _ _ "
echo " |__   __|        | | |/ /    | | |"
echo "    | | ___   ___ | | ' / __ _| | |"
echo "    | |/ _ \ / _ \| |  < / _\` | | |"
echo "    | | (_) | (_) | | . \ (_| | | |"
echo "    |_|\___/ \___/|_|_|\_\__,_|_|_|"
echo -e "${reset}"
echo -e "${yellow}   ToolKali v1.0 | Long Lama, Baram | CelcomDigi Tested${reset}"
echo ""
}

ip_tracker() {
    echo -e "${blue}[*] Detecting IP...${reset}"
    IP=$(curl -s -4 ifconfig.me || curl -s ipinfo.io/ip || echo "No Connection")
    IPV6=$(curl -s -6 ifconfig.me 2>/dev/null || echo "No IPv6")
    
    echo -e "${green}[+] IPv4: $IP ${reset}"
    echo -e "${green}[+] IPv6: $IPV6 ${reset}"
    
    echo -e "${blue}[*] Getting location...${reset}"
    DATA=$(curl -s --connect-timeout 10 "https://ipapi.co/$IP/json/" || curl -s "https://ipinfo.io/$IP/json")
    
    # Simple parse without jq
    CITY=$(echo $DATA | grep -o '"city": *"[^"]*"' | cut -d'"' -f4)
    REGION=$(echo $DATA | grep -o '"region": *"[^"]*"' | cut -d'"' -f4)
    COUNTRY=$(echo $DATA | grep -o '"country_name": *"[^"]*"' | cut -d'"' -f4)
    if [ -z "$COUNTRY" ]; then
      COUNTRY=$(echo $DATA | grep -o '"country": *"[^"]*"' | cut -d'"' -f4)
    fi
    ISP=$(echo $DATA | grep -o '"org": *"[^"]*"' | cut -d'"' -f4)
    
    echo -e "${yellow}Location: $CITY, $REGION, $COUNTRY${reset}"
    echo -e "${yellow}ISP: $ISP${reset}"
    
    # Get lat long
    LAT=$(echo $DATA | grep -o '"latitude": [^,]*' | cut -d' ' -f2 | tr -d ',')
    LON=$(echo $DATA | grep -o '"longitude": [^,]*' | cut -d' ' -f2 | tr -d ',')
    if [ -z "$LAT" ]; then
      LAT=$(echo $DATA | grep -o '"loc": *"[^"]*"' | cut -d'"' -f4 | cut -d',' -f1)
      LON=$(echo $DATA | grep -o '"loc": *"[^"]*"' | cut -d'"' -f4 | cut -d',' -f2)
    fi
    
    if [ ! -z "$LAT" ]; then
        echo -e "${cyan}Maps: https://www.google.com/maps?q=$LAT,$LON${reset}"
    fi
    echo ""
    read -p "Tekan Enter untuk balik..."
}

install_tool() {
    echo -e "${blue}[*] Installing $1...${reset}"
    pkg install $1 -y || apt install $1 -y || sudo apt install $1 -y
    echo -e "${green}[+] $1 installed!${reset}"
    sleep 1
}

while true; do
banner
echo -e "${white}[1] IP Tracker (IPv4/IPv6) - WORKING"
echo -e "[2] Install Nmap"
echo -e "[3] Install SQLMap"
echo -e "[4] Install Whois & Traceroute"
echo -e "[5] About"
echo -e "[0] Exit${reset}"
echo ""
read -p "Pilih > " pilih

case $pilih in
    1) ip_tracker ;;
    2) install_tool nmap; nmap --version; read -p "Enter..." ;;
    3) install_tool sqlmap; read -p "Enter..." ;;
    4) install_tool whois; install_tool traceroute; read -p "Enter..." ;;
    5) echo -e "${cyan}Made by aqifmuqri-lab\nLong Lama, Baram, Sarawak\nTested on CelcomDigi 4G/5G\n2402:1980:8930:ebc7::1 Proof${reset}"; read -p "Enter..." ;;
    0) echo "Bye bro!"; exit ;;
    *) echo -e "${red}Salah pilih bro!${reset}"; sleep 1 ;;
esac
done
