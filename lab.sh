#!/usr/bin/env bash
# Лабораторна: дерево каталогів, файли, копіювання, перевірка email, пошук 404
set -euo pipefail
cd "$(dirname "$0")"
source ./config.env

ROOT="$SURNAME"

# 9. Дерево: AAA -> DEE/GR1, SEE, SSS/GR2
mkdir -p "$ROOT/ZDD"
mkdir -p "$ROOT/ZEE/GR1"
mkdir -p "$ROOT/ZFF/GR2"

echo "Структуру папок успішно створено:"
ls -R "$ROOT"
echo ""

DATE_NOW=$(date +"%Y-%m-%d %H:%M:%S")

FILE_NAME_PATH="$ROOT/ZEE/GR1/${FIRST_NAME}.txt"
echo "Група: $GROUP" > "$FILE_NAME_PATH"
echo "Дата створення: $DATE_NOW" >> "$FILE_NAME_PATH"
echo "Створено файл: $FILE_NAME_PATH"

FILE_SURNAME_PATH="$ROOT/ZFF/GR2/${LAST_NAME}.txt"
echo "Email: $EMAIL" > "$FILE_SURNAME_PATH"
echo "Створено файл: $FILE_SURNAME_PATH"
echo ""

# 10. Копіювання файлів у кореневий каталог (AAA)
cp "$ROOT/ZEE/GR1/${FIRST_NAME}.txt" "$ROOT/"
cp "$ROOT/ZFF/GR2/${LAST_NAME}.txt" "$ROOT/"

echo "Вміст кореневої папки $ROOT після копіювання:"
ls -la "$ROOT"
echo ""

# 11. Перевірка email регулярним виразом
EMAIL_REGEX="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"

if [[ "$EMAIL" =~ $EMAIL_REGEX ]]; then
    echo "[УСПІХ] Email '$EMAIL' є коректним!"
else
    echo "[ПОМИЛКА] Некоректний формат email: '$EMAIL'"
    exit 1
fi
echo ""

# 13. Помилки 404 в Apache-логах
LOG_FILE="access.log"

if [ -f "$LOG_FILE" ]; then
    echo "Аналіз файлу $LOG_FILE..."
    COUNT_404=$(grep -c " 404 " "$LOG_FILE")
    echo "Загальна кількість помилок 404: $COUNT_404"
    echo "Усі записи з помилкою 404:"
    grep " 404 " "$LOG_FILE"
else
    echo "Примітка: Файл '$LOG_FILE' не знайдено в поточній директорії."
    echo "Створіть тестовий файл access.log або вкажіть шлях до реального логу."
fi

echo ""
echo "=== Скрипт успішно завершив роботу ==="
