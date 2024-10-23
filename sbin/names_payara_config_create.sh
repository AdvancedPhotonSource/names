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

CLASSNAME="com.sun.enterprise.security.auth.realm.ldap.LDAPRealm"
JAAS_CONTEXT="ldapRealm"
DIRECTORY=$NAMES_LDAP_AUTH_SERVER_URL
BASE_DN=$NAMES_LDAP_AUTH_DN_FORMAT
SEARCH_FILTER=$NAMES_LDAP_LOOKUP_FILTER
SEARCH_BIND_PASSWORD=$NAMES_LDAP_SERVICE_PASS
SEARCH_BIND_DN=$NAMES_LDAP_SERVICE_DN

JDBC_CLASSNAME="org.mariadb.jdbc.MariaDbDataSource"
JDBC_USER=$NAMES_DB_USER

NAMES_DB_PASSWD_FILE="$NAMES_INSTALL_DIR/etc/$NAMES_DB_NAME.db.passwd"
if [ ! -f $NAMES_DB_PASSWD_FILE ]; then
    echo "No password file for $NAMES_DB_USER: $NAMES_DB_PASSWD_FILE"
    exit 1
fi 
JDBC_PASS=`cat $NAMES_DB_PASSWD_FILE`
JDBC_URL="jdbc\:mariadb\://$NAMES_DB_HOST\:$NAMES_DB_PORT/$NAMES_DB_NAME?zeroDateTimeBehavior\=convertToNull&useMysqlMetadata\=true"
JDBC_DATABASE=$NAMES_DB_NAME
JDBC_SERVER=$NAMES_DB_HOST

# TODO support production domain 

echo "Starting glassfish server domain1."
${ASADMIN} start-domain domain1

echo "Creating Auth-realm org.openepics.discs"
${ASADMIN} create-auth-realm --classname ${CLASSNAME} --property "assign-groups=Authenticated:jaas-context=${JAAS_CONTEXT}:directory=${DIRECTORY}:base-dn=${BASE_DN}:search-filter=${SEARCH_FILTER}:search-bind-password=${SEARCH_BIND_PASSWORD}:search-bind-dn=${SEARCH_BIND_DN}" org.openepics.discs

echo "Creating JDBC connection pool org.openepics.names.dbpool"
${ASADMIN} create-jdbc-connection-pool --restype javax.sql.ConnectionPoolDataSource --datasourceclassname ${JDBC_CLASSNAME} --property "User=${JDBC_USER}:Password=${JDBC_PASS}:URL=${JDBC_URL}:Url=${JDBC_URL}:DatabaseName=${JDBC_DATABASE}:ServerName=${JDBC_SERVER}" org.openepics.names.dbpool

echo "Creating JDBC respurce org.openepics.names.data"
${ASADMIN} create-jdbc-resource --connectionpoolid org.openepics.names.dbpool org.openepics.names.data

echo "Ping JDBC connection pool org.openepics.names.dbpool"
${ASADMIN} ping-connection-pool org.openepics.names.dbpool

echo "Restarting glassfish server domain1."
${ASADMIN} restart-domain domain1