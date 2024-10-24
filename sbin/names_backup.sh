#!/bin/bash

MY_DIR=`dirname $0` && cd $MY_DIR && MY_DIR=`pwd`
source $MY_DIR/_names_load_configuration

DATE=`date +'%Y-%m-%d'`
TIME=`date +'%H-%m'`
SNAPSHOT_NAME=snapshot-$TIME
BACKUP_DIR=$NAMES_INSTALL_DIR/backup/$NAMES_DB_NAME/$DATE
SNAPSHOT_PATH=$BACKUP_DIR/$SNAPSHOT_NAME

mkdir -p $BACKUP_DIR

DB_PASSWD=`cat $NAMES_DB_PASSWD_FILE`
mariadb-dump $NAMES_DB_NAME -h $NAMES_DB_HOST -u $NAMES_DB_USER -p$DB_PASSWD > $SNAPSHOT_PATH

echo "Created Backup: $SNAPSHOT_PATH"