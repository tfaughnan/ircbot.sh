# ircbot.sh

a simple irc bot written in POSIX shell

there's also a related `awk` implementation in this repo just for fun.
since [awk doesn't play well with SSL](https://www.gnu.org/software/gawk/manual/html_node/TCP_002fIP-Networking.html), the following command can be used as a proxy:

    socat TCP-LISTEN:$LOCALPORT OPENSSL:$SERVER:$PORT
