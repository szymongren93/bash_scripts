#!/bin/bash


backup_dir=/migracjapg
pgdump=/usr/pgsql-16/bin/pg_dump
pgdumpall=/usr/pgsql-16/bin/pg_dumpall
psql=/usr/pgsql-16/bin/psql



loop=yes
while [ "$loop" = yes ]; do





echo -e "\nWybierz opcję: \n [u] - odtworzenie użytkowników \n [r] - restore baz \n [e] - update pg_extension \n [x] - wyjście"

read -s -n 1 key


case $key in
    u|U)
        sed -i 's/CREATE ROLE postgres/-- CREATE ROLE postgres/g' /"$backup_dir"/backupy/globals.sql
        sudo -u postgres $psql -f /"$backup_dir"/backupy/globals.sql -a
        echo -e "\n***** Odtworzono użytkowników *****\n"



    ;;


    r|R)
        while read p; do

        backupwana_baza=$p
        if [ "$p" != "postgres" ]
        then

        echo -e "\n \n***** Odtwarzam bazę" $p " *****"
        sleep 2
        sudo -u postgres createdb $p

        sudo -u postgres $psql -d "$p" -v ON_ERROR_STOP=on -f /"$backup_dir"/backupy/"$p".sql
        fi


        done </"$backup_dir"/bazy.txt

        echo -e "\n \n***** Zakończono odtwarzanie baz *****\n"

        ;;
    e|E)
        echo -e "\n***** Rozpoczynam update *****\n"


                while read p; do

                backupwana_baza=$p
                  echo "Baza: " $p
                        sudo -u postgres $psql -d "$p" -t -c "SELECT format('ALTER EXTENSION %I UPDATE;',extname) FROM pg_extension"

                done </"$backup_dir"/bazy.txt
        echo -e "\n \n***** Zakończono extension update *****\n"


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
