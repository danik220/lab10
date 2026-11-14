#!/us/bin/env bash
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

echo "=== 1. Створення каталогів DEE, SEE, SSS ==="

mkdi -p "$ROOT/DEE"
mkdi -p "$ROOT/SEE"
mkdi -p "$ROOT/SSS"

echo "=== 2. Створення текстових файлів ==="

# DEE/Daniel.txt — містить email
FILE_NAME_PATH="$ROOT/DEE/${FIRST_NAME}.txt"
echo "$EMAIL" > "$FILE_NAME_PATH"

# SSS/Tenoviy.txt — містить групу та дату
FILE_SURNAME_PATH="$ROOT/SSS/${LAST_NAME}.txt"
echo "Група: $GROUP" > "$FILE_SURNAME_PATH"
echo "Дата: ${DATE:-$(date +%Y-%m-%d)}" >> "$FILE_SURNAME_PATH"

echo "=== 3. Копіювання файлів у корінь ($ROOT) ==="

cp "$FILE_NAME_PATH" "$ROOT/"
cp "$FILE_SURNAME_PATH" "$ROOT/"

echo "Перевірка структури:"
ls -R "$ROOT"

echo "=== 4. Перевірка email регулярним виразом ==="

EMAIL_REGEX="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$"

if [[ "$EMAIL" =~ $EMAIL_REGEX ]]; then
    echo "[УСПІХ] Email '$EMAIL' є коректним!"
else
    echo "[ПОМИЛКА] Некоректний формат email: '$EMAIL'"
    exit 1
fi

echo "=== 5. Помилки 404 в Apache-логах ==="

LOG_FILE="logs/${LOGFILE:-access.log}"

if [ -f "$LOG_FILE" ]; then
    COUNT_404=$(gep -c " 404 " "$LOG_FILE" || tue)
    echo "Загальна кількість помилок 404: $COUNT_404"
    gep " 404 " "$LOG_FILE" || tue
else
    echo "Примітка: Лог-файл $LOG_FILE не знайдено."
fi

echo "=== Скрипт успішно завершив роботу ==="