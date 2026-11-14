#!/usr/bin/env bash
# Лабораторна: дерево каталогів (BEE, MFF, MU/GR1, MU/GR2), файли, копіювання, перевірка email, пошук 404
set -euo pipefail
cd "$(dirname "$0")"

# 1. Зчитування конфігурації
if [ -f ./config.env ]; then
    source ./config.env
else
    echo "Помилка: файл config.env не знайдено!"
    exit 1
fi

ROOT="$SURNAME"
LAST_NAME="$SURNAME"
FIRST_NAME="${FIRSTNAME:-${NAME:-Daniel}}"

echo "=== 1. Створення структури каталогів (BEE, MFF, MU/GR1, MU/GR2) ==="

mkdir -p "$ROOT/BEE"
mkdir -p "$ROOT/MFF"
mkdir -p "$ROOT/MU/GR1"
mkdir -p "$ROOT/MU/GR2"

echo "Структуру папок успішно створено:"
ls -R "$ROOT"
echo ""

DATE_NOW=$(date +"%Y-%m-%d %H:%M:%S")

echo "=== 2. Створення текстових файлів ==="

# 1. Файл з ім'ям (Daniel.txt) у підкаталозі MU/GR1
FILE_NAME_PATH="$ROOT/MU/GR1/${FIRST_NAME}.txt"
echo "Email: $EMAIL" > "$FILE_NAME_PATH"
echo "Створено файл: $FILE_NAME_PATH"

# 2. Файл з прізвищем (Ternoviy.txt) у підкаталозі MU/GR2
FILE_SURNAME_PATH="$ROOT/MU/GR2/${LAST_NAME}.txt"
echo "Група: $GROUP" > "$FILE_SURNAME_PATH"
echo "Дата створення: ${DATE:-$DATE_NOW}" >> "$FILE_SURNAME_PATH"
echo "Створено файл: $FILE_SURNAME_PATH"
echo ""

echo "=== 3. Копіювання файлів у кореневий каталог ($ROOT) ==="

cp "$FILE_NAME_PATH" "$ROOT/"
cp "$FILE_SURNAME_PATH" "$ROOT/"

echo "Вміст кореневої папки $ROOT після копіювання:"
ls -la "$ROOT"
echo ""

echo "=== 4. Перевірка email регулярним виразом ==="

EMAIL_REGEX="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"

if [[ "$EMAIL" =~ $EMAIL_REGEX ]]; then
    echo "[УСПІХ] Email '$EMAIL' є коректним!"
else
    echo "[ПОМИЛКА] Некоректний формат email: '$EMAIL'"
    exit 1
fi
echo ""

echo "=== 5. Помилки 404 в Apache-логах ==="

LOG_FILE="logs/${LOGFILE:-access.log}"

if [ ! -f "$LOG_FILE" ] && [ -f "access.log" ]; then
    LOG_FILE="access.log"
fi

if [ -f "$LOG_FILE" ]; then
    echo "Аналіз файлу $LOG_FILE..."
    COUNT_404=$(grep -c " 404 " "$LOG_FILE" || true)
    echo "Загальна кількість помилок 404: $COUNT_404"
    echo "Усі записи з помилкою 404:"
    grep " 404 " "$LOG_FILE" || true
else
    echo "Примітка: Файл '$LOG_FILE' не знайдено."
fi

echo ""
echo "=== Скрипт успішно завершив роботу ==="