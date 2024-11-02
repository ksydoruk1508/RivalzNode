#!/bin/bash

# Цвета текста
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # Нет цвета (сброс цвета)

# Проверка наличия curl и установка, если не установлен
if ! command -v curl &> /dev/null; then
    sudo apt update
    sudo apt install curl -y
fi
sleep 1

echo -e "${GREEN}"
cat << "EOF"
███████  ██████  ██████      ██   ██ ███████ ███████ ██████      ██ ████████     ████████ ██████   █████  ██████  ██ ███    ██  ██████  
██      ██    ██ ██   ██     ██  ██  ██      ██      ██   ██     ██    ██           ██    ██   ██ ██   ██ ██   ██ ██ ████   ██ ██       
█████   ██    ██ ██████      █████   █████   █████   ██████      ██    ██           ██    ██████  ███████ ██   ██ ██ ██ ██  ██ ██   ███ 
██      ██    ██ ██   ██     ██  ██  ██      ██      ██          ██    ██           ██    ██   ██ ██   ██ ██   ██ ██ ██  ██ ██ ██    ██ 
██       ██████  ██   ██     ██   ██ ███████ ███████ ██          ██    ██           ██    ██   ██ ██   ██ ██████  ██ ██   ████  ██████  
                                                                                                                                         
                                                                                                                                         
 ██  ██████  ██       █████  ███    ██ ██████   █████  ███    ██ ████████ ███████                                                         
██  ██        ██     ██   ██ ████   ██ ██   ██ ██   ██ ████   ██    ██    ██                                                             
██  ██        ██     ███████ ██ ██  ██ ██   ██ ███████ ██ ██  ██    ██    █████                                                          
██  ██        ██     ██   ██ ██  ██ ██ ██   ██ ██   ██ ██  ██ ██    ██    ██                                                             
 ██  ██████  ██      ██   ██ ██   ████ ██████  ██   ██ ██   ████    ██    ███████

Donate: 0x0004230c13c3890F34Bb9C9683b91f539E809000
EOF
echo -e "${NC}"

function install_node {
    echo -e "${BLUE}Обновляем сервер...${NC}"
    sudo apt update && sudo apt upgrade -y && sudo apt install -y tmux

    echo -e "${BLUE}Устанавливаем NPM...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -

    echo -e "${BLUE}Устанавливаем Node.js и Rivalz CLI...${NC}"
    sudo apt install -y nodejs
    npm i -g rivalz-node-cli

    echo -e "${BLUE}Запускаем ноду в новой сессии tmux...${NC}"
    tmux new-session -d -s rivalz "rivalz run"
    echo -e "${GREEN}Нода Rivalz успешно установлена и запущена в сессии tmux с именем 'rivalz'.${NC}"
}

function run_node_tmux {
    echo -e "${BLUE}Запускаем ноду в новой сессии tmux...${NC}"
    tmux new-session -d -s rivalz "rivalz run"
    echo -e "${GREEN}Нода Rivalz запущена в сессии tmux с именем 'rivalz'.${NC}"
}

function view_logs {
    echo -e "${YELLOW}Просмотр логов tmux сессии...${NC}"
    echo -e "${YELLOW}Для входа в сессию используйте команду: tmux attach -t rivalz${NC}"
    echo -e "${YELLOW}Для выхода из сессии без остановки ноды нажмите Ctrl+B, затем D.${NC}"
}

function remove_node {
    echo -e "${BLUE}Удаляем ноду Rivalz...${NC}"
    npm uninstall -g rivalz-node-cli
    echo -e "${GREEN}Нода Rivalz успешно удалена.${NC}"
}

function main_menu {
    while true; do
        echo -e "${YELLOW}Выберите действие:${NC}"
        echo -e "${CYAN}1. Установка ноды${NC}"
        echo -e "${CYAN}2. Запуск ноды в tmux${NC}"
        echo -e "${CYAN}3. Просмотр логов${NC}"
        echo -e "${CYAN}4. Удаление ноды${NC}"
        echo -e "${CYAN}5. Выход${NC}"
       
        echo -e "${YELLOW}Введите номер:${NC} "
        read choice
        case $choice in
            1) install_node ;;
            2) run_node_tmux ;;
            3) view_logs ;;
            4) remove_node ;;
            5) break ;;
            *) echo -e "${RED}Неверный выбор, попробуйте снова.${NC}" ;;
        esac
    done
}

main_menu
