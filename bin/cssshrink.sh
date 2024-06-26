#!/bin/sh

PWD=`dirname "$0"`
BIN=`which csso`

set -e

if [ -e "$PWD/../node_modules/.bin/csso" ]; then
    BIN="$PWD/../node_modules/.bin/csso"
fi

do_shrink() {
    rm -f "$2"
    $BIN $1 -o $2 --no-restructure
}

if [ -z "$BIN" ]; then
    echo "csso not found. Please run 'npm install'."
    exit 1
fi

# compress single file from argument
if [ $# -gt 0 ]; then
    CSS_FILE="$1"

    echo "Shrinking $CSS_FILE"
    minfile=`echo $CSS_FILE | sed -e 's/\.css$/\.min\.css/'`
    do_shrink "$CSS_FILE" "$minfile"
    exit
fi

DIRS="$PWD/../skins/* $PWD/../plugins/* $PWD/../plugins/*/skins/*  $PWD/../plugins/*/themes/*"
# default: compress application scripts
for dir in $DIRS; do
    for file in $dir/*.css; do
        if echo "$file" | grep -q -e '.min.css$'; then
            continue
        fi
        if [ ! -f "$file" ]; then
            continue
        fi

        echo "Shrinking $file"
        minfile=`echo $file | sed -e 's/\.css$/\.min\.css/'`
        do_shrink "$file" "$minfile"
    done
done
