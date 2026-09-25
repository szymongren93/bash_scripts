#!/bin/bash

LISTA="/install/params"
CONF="/var/lib/pgsql/16/data/postgresql.conf"
awk '
NR==FNR {
    # Zapamiętaj nazwę parametru i całą linię z params
    if ($0 !~ /^[[:space:]]*#/ && $0 ~ /=/) {
        line=$0
        sub(/^[[:space:]]*/, "", line)
        param=line
        sub(/[[:space:]]*=.*/, "", param)
        gsub(/[[:space:]]+$/, "", param)

        wanted[param]=$0
        order[++count]=param
    }
    next
}
{
    # Sprawdź, czy linia jest aktywną konfiguracją
    line=$0

    if (line !~ /^[[:space:]]*#/ && line ~ /^[[:space:]]*[^[:space:]=]+[[:space:]]*=/) {
        param=line
        sub(/^[[:space:]]*/, "", param)
        sub(/[[:space:]]*=.*/, "", param)
        gsub(/[[:space:]]+$/, "", param)

        if (param in wanted) {
            print "#" $0
            found[param]=1
            next
        }
    }

    print
}
END {
    print ""
    print "# Parameters from /install/params"

    for (i=1; i<=count; i++) {
        param=order[i]
        print wanted[param]
    }
}
' "$LISTA" "$CONF" > "${CONF}.new" && mv "${CONF}.new" "$CONF"

