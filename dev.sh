#!/usr/bin/env bash
set -e
DIR=$( dirname $(realpath "$0") )
cd $DIR
if [ ! -n "$1" ] ;then
exe=src/index.coffee
else
exe="npx coffee --compile --output lib src/ && .direnv/bin/coffee ${@:1}"
fi
echo $exe
exec nodemon --watch 'test/**/*' --watch 'src/**/*' -e coffee,js,mjs,json,wasm,txt,yaml --exec $exe

