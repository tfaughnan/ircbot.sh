#!/bin/awk -f

function handle_msg(conn, chan, sender_nick, msg) {
    if (match(msg, /&[Hh]elp/)) {
        print "PRIVMSG " chan " :COMMANDS" |& conn
        print "PRIVMSG " chan " :&help: display this message" |& conn
        print "PRIVMSG " chan " :&b <phrase>: no explanation necessary" |& conn
    }
    else if (match(msg, /^&[Bb] .*/)) {
        response = substr(msg, 3)
        gsub(/ [a-zA-Z]/, " B", response)
        print "PRIVMSG " chan " :" substr(response, 2) |& conn
    }
}

BEGIN {
    NICK="d3ck4rd"
    CHAN="#bots"
    #SERVER=""
    #PORT="6697"

    # will use socat as proxy
    SERVER="localhost"
    PORT="6668"

    connection = "/inet/tcp/0/" SERVER "/" PORT
    
    print "USER " NICK " 8 * :" NICK |& connection
    print "NICK " NICK |& connection
    print "JOIN " CHAN |& connection
    print "PRIVMSG " CHAN " :i'm back, but this time i'm written in ~AWK~" |& connection

    quit = 0
    while (!quit) {
        connection |& getline
        if (match($0, "PRIVMSG " CHAN)) {
            split($0, a, "!")
            split($0, b, ":")
            handle_msg(connection, CHAN, substr(a[1], 2), b[3])
        }
        else if (match($0, "PING")) {
            sub("PING", "PONG", $0)
            print $0 |& connection
            print "just ponged a mf"
        }
    }
    close(connection)
}
