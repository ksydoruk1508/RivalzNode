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
██████  ██ ██    ██  █████  ██      ███████     ███    ██  ██████  ██████  ███████ 
██   ██ ██ ██    ██ ██   ██ ██         ███      ████   ██ ██    ██ ██   ██ ██      
██████  ██ ██    ██ ███████ ██        ███       ██ ██  ██ ██    ██ ██   ██ █████   
██   ██ ██  ██  ██  ██   ██ ██       ███        ██  ██ ██ ██    ██ ██   ██ ██      
██   ██ ██   ████   ██   ██ ███████ ███████     ██   ████  ██████  ██████  ███████ 
                                                                                  
________________________________________________________________________________________________________________________________________


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

# Файл для сохранения EVM адреса
EVM_ADDRESS_FILE="evm_address.txt"

function install_node {
    echo -e "${BLUE}Обновляем сервер...${NC}"
    sudo apt update && sudo apt upgrade -y && sudo apt install -y tmux

    echo -e "${BLUE}Устанавливаем NPM...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -

    echo -e "${BLUE}Устанавливаем Node.js и Rivalz CLI...${NC}"
    sudo apt install -y nodejs
    npm i -g rivalz-node-cli

    if [ ! -f "$EVM_ADDRESS_FILE" ]; then
        echo -e "${YELLOW}Введите ваш EVM адрес:${NC}"
        read evm_address
        echo "$evm_address" > "$EVM_ADDRESS_FILE"
    else
        evm_address=$(cat "$EVM_ADDRESS_FILE")
        echo -e "${GREEN}Используем сохраненный EVM адрес: $evm_address${NC}"
    fi

    echo -e "${BLUE}Запускаем ноду в фоновом режиме...${NC}"
    nohup rivalz run > rivalz_node.log 2>&1 &
    echo -e "${GREEN}Нода Rivalz успешно установлена и запущена в фоновом режиме.${NC}"

    echo -e "${BLUE}Возвращаемся в главное меню...${NC}"
    main_menu
}

function view_logs {
    echo -e "${YELLOW}Просмотр логов ноды (последние 50 строк, выход из режима просмотра: Ctrl+C)...${NC}"
    tail -n 50 rivalz_node.log
    echo -e "${BLUE}Возвращаемся в главное меню...${NC}"
}

function remove_node {
    echo -e "${BLUE}Удаляем ноду Rivalz...${NC}"
    pkill -f "rivalz run"
    npm uninstall -g rivalz-node-cli
    rm -f "$EVM_ADDRESS_FILE"
    echo -e "${GREEN}Нода Rivalz успешно удалена.${NC}"
}

function restart_node {
    echo -e "${BLUE}Перезапускаем ноду Rivalz...${NC}"
    pkill -f "rivalz run"
    evm_address=$(cat "$EVM_ADDRESS_FILE")
    echo -e "${BLUE}Запускаем ноду в фоновом режиме...${NC}"
    nohup rivalz run > rivalz_node.log 2>&1 &
    echo -e "${GREEN}Нода Rivalz успешно перезапущена.${NC}"
}

function main_menu {
    while true; do
        echo -e "${YELLOW}Выберите действие:${NC}"
        echo -e "${CYAN}1. Установка ноды${NC}"
        echo -e "${CYAN}2. Просмотр логов${NC}"
        echo -e "${CYAN}3. Удаление ноды${NC}"
        echo -e "${CYAN}4. Перезапуск ноды${NC}"
        echo -e "${CYAN}5. Перейти к другим нодам${NC}"
        echo -e "${CYAN}6. Выход${NC}"
       
        echo -e "${YELLOW}Введите номер действия:${NC} "
        read choice
        case $choice in
            1) install_node ;;
            2) view_logs ;;
            3) remove_node ;;
            4) restart_node ;;
            5) wget -q -O Ultimative_Node_Installer.sh https://raw.githubusercontent.com/ksydoruk1508/Ultimative_Node_Installer/main/Ultimative_Node_Installer.sh && sudo chmod +x Ultimative_Node_Installer.sh && ./Ultimative_Node_Installer.sh ;;
            6) break ;;
            *) echo -e "${RED}Неверный выбор, попробуйте снова.${NC}" ;;
        esac
    done
}

main_menu
