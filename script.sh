#!/bin/bash

usage() {
    echo "Использование: $0 [опции] файл1 файл2 ..."
    echo "Опции:"
    echo "  -s         Выводит суммарный размер файлов в конце"
    echo "  -S         Выводит только суммарный размер файлов"
    echo "  --help     Показать это сообщение"
    echo "  --usage    Показать краткое использование"
}

sum_size=0
is_sum=false
is_file_info=true
options=true
files=()

for arg in "$@"; do
    if [[ "$arg" == "--" && $options ]]; then
        options=false
        continue
    fi

    if [[ "$arg" == "-s" && $options ]]; then
        is_sum=true
        continue
    fi

    if [[ "$arg" == "-S" && $options ]]; then
        is_sum=true
        is_file_info=false
        continue
    fi

    if [[ "$arg" == "--help" && $options ]]; then
        usage
        exit 0
    fi

    if [[ "$arg" == "--usage" && $options ]]; then
        echo "Использование: $0 [опции] файл1 файл2 ..."
        exit 0
    fi

    if [[ -n "$arg" ]]; then
        files+=("$arg")
    fi
done

for file in "${files[@]}"; do
    if [[ ! -e "$file" ]]; then
        echo "Ошибка: файл '$file' не существует."
        exit 1
        continue
    fi

    size=$(stat -c%s "$file" 2>/dev/null)
    if [[ $? -ne 0 ]]; then
        echo "Ошибка: не удалось получить размер файла '$file'."
        exit 1
    fi

    if $is_file_info; then
        echo "$size $file"
    fi
    
    sum_size=$((sum_size + size))
done

if [[ $is_sum ]]; then
    echo "$sum_size"
fi

if [[ $? -eq 0 ]]; then
    exit 0
else
    exit 1
fi
