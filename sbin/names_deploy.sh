#!/bin/bash

MY_DIR=`dirname $0` && cd $MY_DIR && MY_DIR=`pwd`
source $MY_DIR/_names_load_configuration

# Build 
mvn clean package

# Start 
asadmin start-domain domain1

# Undeploy last version 
LAST_DEPLOYMENT=`asadmin list-applications -t | awk '{print $1;}' | grep 'names-'`

if [ ! -z $LAST_DEPLOYMENT ]; then
    asadmin undeploy $LAST_DEPLOYMENT
fi

# Deploy
asadmin deploy $NAMES_ROOT_DIR/target/names-*.war

# Ensure disallow remote console 4848 for production use. 

