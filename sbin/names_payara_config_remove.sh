#!/bin/bash

no_asadmin=true
which asadmin && no_asadmin=false

if $no_asadmin; then
    echo "No asadmin found in \$PATH"
    exit 1
fi

ASADMIN=`which asadmin` 

MY_DIR=`dirname $0` && cd $MY_DIR && MY_DIR=`pwd`
source $MY_DIR/_names_load_configuration

# TODO support production domain 

${ASADMIN} start-domain domain1
echo "Delete auth realm org.openepics.discs"
${ASADMIN} delete-auth-realm org.openepics.discs
echo "Delete JDBC resource org.openepics.names.data"
${ASADMIN} delete-jdbc-resource org.openepics.names.data
echo "Delete JDBC connection Pool org.openepics.names.dbpool"
${ASADMIN} delete-jdbc-connection-pool org.openepics.names.dbpool
echo "Stopping glassfish server domain1"
${ASADMIN} stop-domain domain1
