#!/bin/bash


backup_dir=/migracjapg
pgdump=/usr/pgsql-16/bin/pg_dump
pgdumpall=/usr/pgsql-16/bin/pg_dumpall
psql=/usr/pgsql-16/bin/psql



loop=yes
while [ "$loop" = yes ]; do





echo -e "\nWybierz opcję: [y - rozpocznij restore baz] [e - update pg_extension] [x - wyjście]"

read -s -n 1 key


case $key in
    y|Y)

        $psql -f /"$backup_dir"/backupy/globals.sql
        echo -e "\nOdtworzono użytkowników\n"
        read -p "Naciśnij enter aby rozpocząć odtwarzanie baz"


        while read p; do

        backupwana_baza=$p
        if [ "$p" != "postgres" ]
        then

        echo "\n \n Odtwarzam bazę" $p
        createdb $p

        $psql -d "$p" -f /"$backup_dir"/backupy/"$p".sql
        fi


        done </"$backup_dir"/bazy.txt



        ;;
    e|E)
        echo "Rozpoczynam update"


                while read p; do

                backupwana_baza=$p
                  echo "Baza: " $p
                        psql -d "$p" -t -c "SELECT format('ALTER EXTENSION %I UPDATE;',extname) FROM pg_extension"

                done </"$backup_dir"/bazy.txt



    ;;


    x|X)
        echo -e "\n***** Zakończono skrypt *****"
        loop=no
        exit 1
        ;;
    *)
        echo "Nieprawidłowy output"
        ;;


esac

   done
done




















