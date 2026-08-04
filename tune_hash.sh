#!/bin/bash

LISTA="/install/params"
CONF="/var/lib/pgsql/16/data/postgresql.conf"

awk '
NR==FNR {
    wanted[$0]
    next
}
{
    if ($0 in wanted && $0 !~ /^#/)
        print "#" $0
    else
        print
}
' "$LISTA" "$CONF" > "${CONF}.new" && mv "${CONF}.new" "$CONF"