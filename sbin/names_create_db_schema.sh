#!/bin/bash

MY_DIR=`dirname $0` && cd $MY_DIR && MY_DIR=`pwd`
source $MY_DIR/_names_load_configuration

SCHEMA_FILE=$NAMES_ROOT_DIR/design/names_schema_v2.4.sql

echo "Using $SCHEMA_FILE to create db." 

# Get db admin password
if [ -z "$DB_ADMIN_PASSWORD" ]; then
    sttyOrig=`stty -g`
    stty -echo
    read -p "Enter DB root password: " DB_ADMIN_PASSWORD
    stty $sttyOrig
    echo
fi

# Get user db password and create passwd file for user. 
NAMES_DB_PASSWORD=$NAMES_DB_USER_PASSWORD
if [ -z "$NAMES_DB_USER_PASSWORD" ]; then
    if [ -f $NAMES_DB_PASSWD_FILE ]; then
	    NAMES_DB_PASSWORD=`cat $NAMES_DB_PASSWD_FILE`
    else
        sttyOrig=`stty -g`
        stty -echo
        read -p "Enter DB password for the $NAMES_DB_USER user: " NAMES_DB_PASSWORD
        stty $sttyOrig
        echo
        echo "Creating user db passwd file $NAMES_DB_PASSWD_FILE"
        touch $NAMES_DB_PASSWD_FILE
        chmod 600 $NAMES_DB_PASSWD_FILE
        echo $NAMES_DB_PASSWORD > $NAMES_DB_PASSWD_FILE
    fi
fi

execute() {
    msg="$@"
    if [ ! -z "$DB_ADMIN_PASSWORD" ]; then
        sedCmd="s?$DB_ADMIN_PASSWORD?\\*\\*\\*\\*\\*\\*?g"
        echo "Executing: $@" | sed -e $sedCmd
    else
        echo "Executing: $@"
    fi
    if eval "$@"; then
	echo 'Success'
    else
	exit 1
    fi
}

mysqlCmd="mariadb --port=$NAMES_DB_PORT --host=$NAMES_DB_HOST -u $NAMES_DB_ADMIN_USER"
mysqlCmd="$mysqlCmd -p$DB_ADMIN_PASSWORD"

mysqlUserCmd="mariadb $NAMES_DB_NAME --port=$NAMES_DB_PORT --host=$NAMES_DB_HOST -u $NAMES_DB_USER -p$NAMES_DB_PASSWORD"

# Create Database and User

sqlFile=/tmp/create_names_db.`id -u`.sql
rm -f $sqlFile
echo "DROP DATABASE IF EXISTS $NAMES_DB_NAME;" >> $sqlFile
echo "CREATE DATABASE $NAMES_DB_NAME CHARACTER SET $NAMES_DB_CHARACTER_SET;" >> $sqlFile
for host in $NAMES_DB_ADMIN_HOSTS; do
    echo "GRANT ALL PRIVILEGES ON $NAMES_DB_NAME.* TO '$NAMES_DB_USER'@'$host'
    IDENTIFIED BY '$NAMES_DB_PASSWORD';" >> $sqlFile
done
execute "$mysqlCmd < $sqlFile"

# Create Schema.

execute "$mysqlUserCmd < $SCHEMA_FILE"
