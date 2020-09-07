#!/usr/bin/env bash

_DIR=$(dirname $(realpath "$0"))
cd $_DIR

yarn prepare
tape test/**/*.coffee|npx colortape
