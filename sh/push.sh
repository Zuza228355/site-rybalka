#!/bin/bash
echo "=== Автоматический пуш ==="

# Переход в корень
cd "$(dirname "$0")/.." || exit

# Добавить все
git add .

# Коммит
read -p "Сообщение коммита (Update): " msg
msg=${msg:-Update}
git commit -m "$msg"

# Пуш
git push

echo "✅ Готово!"
