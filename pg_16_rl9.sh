#!/bin/bash


timedatectl set-timezone Europe/Warsaw
dnf install tar net-tools wget chrony mc telnet wget -y
dnf -y install epel-release
dnf config-manager --enable crb
dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm
dnf -qy module disable postgresql
dnf install -y postgresql16-server


/usr/pgsql-16/bin/postgresql-16-setup initdb
systemctl enable postgresql-16
systemctl start postgresql-16



firewall-cmd --permanent --add-service=postgresql
firewall-cmd --reload


sed -i 's/#listen_addresses = /listen_addresses/g' /var/lib/pgsql/16/data/postgresql.conf
sed -i -e '$ahost\tall\t\tall\t\tall\t\t\tmd5' /var/lib/pgsql/16/data/pg_hba.conf

dnf install postgis34_16 -y
