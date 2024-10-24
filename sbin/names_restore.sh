#!/bin/bash

MY_DIR=`dirname $0` && cd $MY_DIR && MY_DIR=`pwd`
source $MY_DIR/_names_load_configuration

DB_PASSWD=`cat $NAMES_DB_PASSWD_FILE`
mysqlUserCmd="mariadb $NAMES_DB_NAME --port=$NAMES_DB_PORT --host=$NAMES_DB_HOST -u $NAMES_DB_USER -p$DB_PASSWD"
BACKUP_DIR=$NAMES_INSTALL_DIR/backup
LASTEST_BACKUP=`ls -t $BACKUP_DIR/$NAMES_DB_NAME/ | head -1`
LATEST_SNAPSHOT=`ls -t $BACKUP_DIR/$NAMES_DB_NAME/$LASTEST_BACKUP | head -1`

BACKUP_SNAPSHOT_PATH=$LASTEST_BACKUP/$LATEST_SNAPSHOT
BACKUP_PATH=$BACKUP_DIR/$NAMES_DB_NAME/$BACKUP_SNAPSHOT_PATH
echo $BACKUP_PATH

read -p "Proceed to restore backup $BACKUP_SNAPSHOT_PATH (Y/n) " proceed

if [[ -z $proceed ]]; then
  proceed="y"
fi

if [ $proceed == "y" -o $proceed == "Y" ]; then
    echo "Restoring snapshot..."
    RESTORE_CMD="$mysqlUserCmd < $BACKUP_PATH" 

    if eval "$RESTORE_CMD"; then
	    echo 'Success'
    else
        echo 'Error occurred restoring snapshot'
	    exit 1
    fi
fi
