#!/bin/bash

# Проверка на права root (необходимы для изменения системных файлов)
if [[ $EUID -ne 0 ]]; then
   echo "Ошибка: Запустите скрипт через sudo."
   exit 1
fi

MODE=$1

# Проверка ввода
if [[ "$MODE" != "performance" && "$MODE" != "powersave" ]]; then
    echo "Использование: sudo $0 [performance|powersave]"
    exit 1
fi

echo "Устанавливаю режим: $MODE..."

# Применяем режим к каждому ядру
for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
    GOVERNOR_FILE="$cpu/cpufreq/scaling_governor"
    if [ -f "$GOVERNOR_FILE" ]; then
        echo "$MODE" > "$GOVERNOR_FILE"
    fi
done

echo "Готово! Текущее состояние:"
grep . /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor | head -n 5
echo "... (и так далее для всех ядер)"
