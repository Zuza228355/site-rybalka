#!/bin/bash

echo "=> Проверяю локальные изменения..."
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "→ Есть несохранённые изменения, делаю stash..."
    git stash push -m "auto-stash-before-pull"
    STASHED=1
else
    STASHED=0
fi

echo "=> Выполняю git pull..."
git pull --rebase
if [ $? -ne 0 ]; then
    echo "❌ Ошибка при git pull. Реши конфликты вручную."
    exit 1
fi

if [ $STASHED -eq 1 ]; then
    echo "→ Возвращаю stash..."
    git stash pop
fi

echo "=> Добавляю изменения..."
git add .

read -p "Введите коммит (по умолчанию: Update): " commit
commit=${commit:-Update}

echo "=> Делаю коммит..."
git commit -m "$commit"

echo "=> Отправляю на сервер..."
git push

echo "Готово!"

