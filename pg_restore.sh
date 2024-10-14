#!/bin/bash


backup_dir=/migracjapg
pgdump=/usr/pgsql-16/bin/pg_dump
pgdumpall=/usr/pgsql-16/bin/pg_dumpall
psql=/usr/pgsql-16/bin/psql


echo "Odtwarzam użytkowników"
$psql -f /"$backup_dir"/backupy/globals.sql

read -p "Naciśnij enter aby rozpocząć odtwarzanie baz"


while read p; do

backupwana_baza=$p
if [ "$p" != "postgres" ]
then

echo "\n \n Odtwarzam bazę" $p
createdb $p

$psql -d "$p" -f /"$backup_dir"/backupy/"$p".sql



fi


done </"$backup_dir"/"$baza"/bazy.txt

echo -e "\n     *******\nZAKOŃCZONO RESTORE BAZ \n     ******* \n"








