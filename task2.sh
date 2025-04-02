#!/bin/bash

N=0
minsize=1
h=false
dirs=()
fl=true



while [[ $# -gt 0 ]]; do
	if $fl; then
		if [[ "$1" == "--usage" ]]; then
			echo "$0 [--help] [-h] [-N] [-s minsize] [--] [dir...]"
			exit 0
		elif [[ "$1" == "--help" ]]; then 
			echo "version: 1.1, author: Me"
			exit 0
		elif [[ "$1" == "-h" ]]; then
			h=true
			shift
		elif [[ "$1" =~ ^-[0-9]+$ ]]; then
			str="$1"
			N=${str:1}
			shift
		elif [[ "$1" == "-s" ]]; then
			minsize=$2
			shift 2
		elif [[ "$1" == "--" ]]; then
			fl=false
			shift
		else
			echo "Error: option not supported" >&2
			exit 1
		fi
	else
		if [[ "$1" == -* ]]; then
            dirs+=("./$1")
        else
            dirs+=("$1")
        fi
		shift
	fi
done



if [[ ${#dirs[@]} -eq 0 ]]; then
    dirs=(.)
fi



find "${dirs[@]}" -type f -size +"${minsize}c" -printf "%s %p\n" | sort -nr | {
    if $h; then
        while read -r size path; do
            h_size=$(numfmt --to=iec-i --suffix=B "$size")
            echo "$h_size $path"
        done
    else
        cat
    fi
} | {
    if [[ $N -gt 0 ]]; then
        head -n "$N"
    else
        cat
    fi
}



exit 0







