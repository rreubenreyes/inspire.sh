#!/bin/bash
declare -r INSPIRE_QUOTES_FILE="$HOME/.inspire/quotes.txt"
declare -r INSPIRE_ANGRY_MODE_FILE="$HOME/.inspire/angry_mode.txt" # ANGRY MODE!!!1!!!!!!!1
QUOTES_FILE=$INSPIRE_QUOTES_FILE

function print_quote() {
    awk 'BEGIN{ FS="|" } { print $1 " -" $2 }' $arg1
}

function fancify_quote() {
    tee $arg1 \
        1>/dev/null \
        >(cut -c 2- | awk 'BEGIN{ FS="|" } { print "-" $2 }' | figlet -f small -w $(tput cols)) \
        >(awk 'BEGIN{ FS="|" } { print $1 }')
}

function get_quote() {
    local numquotes=$(wc -l $QUOTES_FILE | awk '{ print $1 }')
    local linum=$(echo $[$RANDOM % $numquotes + 1])
    local quote=$(head -n $linum $QUOTES_FILE | tail -n 1 | awk 'BEGIN{ FS="|"; OFS="|" } { print "\"" $1 "\"", $2 }')

    echo -e "\033[3m${quote}\033"
}

mkdir -p $HOME/.inspire
decorate_output="print_quote"
while getopts 'af' flag; do
    case "${flag}" in
        a) QUOTES_FILE=$INSPIRE_ANGRY_MODE_FILE ;; # ANGRY MODE!!!!!!!!!!!!!!!!!!!1!
        f) decorate_output="fancify_quote" ;;
        *) exit 1
    esac
done

get_quote | ($decorate_output)
