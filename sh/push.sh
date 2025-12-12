#!/bin/bash
set -e  # Остановить скрипт при любой ошибке

GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

echo -e "${YELLOW}=> Проверяю локальные изменения...${RESET}"

if ! git diff --quiet || ! git diff --cached --quiet; then
    echo -e "${YELLOW}→ Есть несохранённые изменения, делаю stash...${RESET}"
    git stash push -m "auto-stash-before-pull"
    STASHED=1
else
    STASHED=0
fi

echo -e "${YELLOW}=> Выполняю git pull...${RESET}"
if ! git pull --rebase; then
    echo -e "${RED}❌ Ошибка при git pull. Реши конфликты вручную.${RESET}"
    exit 1
fi

if [ $STASHED -eq 1 ]; then
    echo -e "${YELLOW}→ Возвращаю stash...${RESET}"
    if ! git stash pop; then
        echo -e "${RED}❌ Конфликт при применении stash! Реши вручную.${RESET}"
        exit 1
    fi
fi

echo -e "${YELLOW}=> Добавляю изменения...${RESET}"
git add .

read -p "Введите коммит (по умолчанию: Update): " commit
commit=${commit:-Update}

echo -e "${YELLOW}=> Делаю коммит...${RESET}"
git commit -m "$commit"

echo -e "${YELLOW}=> Отправляю на сервер...${RESET}"
git push

echo -e "${GREEN}Готово!${RESET}"

