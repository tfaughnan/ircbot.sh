#!/bin/sh

trap cleanup INT

cleanup() {
    echo exiting...
    echo QUIT :see ya l8r
    exit
}

usage() {
    send_msg << EOF
hello there! i'm $NICK, a simple irc bot written in POSIX shell by $ADMIN_NICK
my code is here: $REPO
COMMANDS:
    ${PREFIX}help or ${PREFIX}usage: display this message
EOF
}

# dummy function for testing
testfunc() {
    echo 'test successful!' | send_msg
}

handle_msg() {
    msg="$(echo "$1" | cut -d : -f 3)"
    sender_nick="$(echo "$1" | cut -d : -f 2 | cut -d ! -f 1)"
    echo "$msg" | grep -qE "${PREFIX}([Hh]elp|[Uu]sage)" && usage && return
    
    echo "$msg" | grep -qE "${PREFIX}[Tt]est" && testfunc && return

    echo "$msg" | grep -qE "${PREFIX}([Dd]ie)" && [ "$sender_nick" = "$ADMIN_NICK" ] && echo "wait no pls dont kil--" | send_msg && cleanup
    echo "$msg" | grep -qi 'who are you[?]*' && [ "$sender_nick" = "$ADMIN_NICK" ] && echo "$ADMIN_NICK: i'm you, but stronger" | send_msg && return


}

# allows for sending [pseudo]multiline messages (e.g. for usage function)
send_msg() {
    while read -r line
    do
        echo "PRIVMSG $CHAN :$line"
    done
}

cat << EOF
USER $USER 8 * :$REALNAME
NICK $NICK
JOIN $CHAN
PRIVMSG $CHAN :hello there! i'm $NICK!
PRIVMSG $CHAN :(note: my commands are prefixed with '$PREFIX')
EOF

while true; do
    read -r response
    #echo "$response"
    echo "$response" | grep -q '^PING' && echo "$response" | sed 's/PING/PONG/' && continue
    echo "$response" | grep -q "PRIVMSG $CHAN" && handle_msg "$response" && continue
done

