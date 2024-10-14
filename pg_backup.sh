#!/bin/bash


backup_dir=/migracjapg
pgdump=/usr/pgsql-12/bin/pg_dump
pgdumpall=/usr/pgsql-12/bin/pg_dumpall
psql=/usr/pgsql-12/bin/psql


/usr/pgsql-12/bin/psql -d postgres -c "SELECT datname FROM pg_catalog.pg_database WHERE datistemplate = false;"  > /"$backup_dir"/bazy.txt

#Liczba baz
#batabase_count=$(wc -l < /migracjapg/bazy.txt)
#echo $batabase_count
#batabase_count=$(( $batabase_count - 2 ))
#echo $batabase_count


sed -i '$d' /"$backup_dir"/bazy.txt
sed -i '$d' /"$backup_dir"/bazy.txt
sed -i '1d;2d' /"$backup_dir"/bazy.txt

mkdir -p /"$backup_dir"/backupy


echo "Backupuję użytkowników"
$pgdumpall --globals-only -f /"$backup_dir"/backupy/globals.sql

while read p; do

backupwana_baza=$p

echo "Backupuję " $backupwana_baza

$pgdump -d "$backupwana_baza" -f "$backup_dir"/backupy/"$backupwana_baza".sql


done </"$backup_dir"/bazy.txt

echo -e "\n     *******\nZAKOŃCZONO BACKUP \n     ******* \n"









