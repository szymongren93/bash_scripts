#!/bin/bash


backup_dir=/migracjapg
pgdump=/usr/pgsql-12/bin/pg_dump
pgdumpall=/usr/pgsql-12/bin/pg_dumpall
psql=/usr/pgsql-12/bin/psql


sudo -u postgres $psql -d postgres -t -c "SELECT datname FROM pg_catalog.pg_database WHERE datistemplate = false;"  > /"$backup_dir"/bazy.txt
sed -i "s/ //g" /"$backup_dir"/bazy.txt
sed -i '$ d' /"$backup_dir"/bazy.txt


mkdir -p /"$backup_dir"/backupy


echo "Backupuję użytkowników"
sudo -u postgres $pgdumpall --globals-only -f /"$backup_dir"/backupy/globals.sql

while read p; do

backupwana_baza=$p

echo "Backupuję bazę: " $backupwana_baza

sudo -u postgres $pgdump -d "$backupwana_baza" -f "$backup_dir"/backupy/"$backupwana_baza".sql


done </"$backup_dir"/bazy.txt

echo -e "\n     *******\nZAKOŃCZONO BACKUP \n     ******* \n"
