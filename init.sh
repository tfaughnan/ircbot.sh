#!/bin/sh

set -a
. ./config
set +a

socat EXEC:./ircbot.sh,sigint OPENSSL:"$SERVER":"$PORT"
