#!/bin/bash

file="/etc/passwd"
login="$USER"

# Обработка аргументов
while getopts ":f:" opt; do
    if [ $opt == f ]; then
        file="$OPTARG"
    fi
done

shift $((OPTIND -1))
if [ $# -gt 0 ]; then
  login="$1"
fi

if [ ! -f "$file" ]; then
  echo "Файл '$file' не найден." >&2
  exit 2
fi

home_dir=$(grep "^$login:" "$file" | cut -d':' -f6)

if [ -z "$home_dir" ]; then
  echo "Пользователь '$login' не найден." >&2
  exit 1
fi

echo "$home_dir"
exit 0