#!/bin/bash

# Copyright (c) UChicago Argonne, LLC. All rights reserved.
# See LICENSE file.


#
# Script used for creation of configuration file used for CDB.
#
# Usage:
#
# $0 [NAMES_DB_NAME]
#

MY_DIR=`dirname $0` && cd $MY_DIR && MY_DIR=`pwd`

if [ -z "${NAMES_ROOT_DIR}" ]; then
    NAMES_ROOT_DIR=$MY_DIR/..
fi
NAMES_ENV_FILE=${NAMES_ROOT_DIR}/setup.sh
if [ ! -f ${NAMES_ENV_FILE} ]; then
    echo "Environment file ${NAMES_ENV_FILE} does not exist."
    exit 2
fi
. ${NAMES_ENV_FILE} > /dev/null

# Use first argument as db name, if provided
NAMES_DB_NAME=${NAMES_DB_NAME:=naming}
if [ ! -z "$1" ]; then
    NAMES_DB_NAME=$1
fi

echo "Using DB name: $NAMES_DB_NAME"

NAMES_ETC_DIR=$NAMES_INSTALL_DIR/etc

# Look for deployment file in etc directory.
deployConfigFile=$NAMES_ETC_DIR/${NAMES_DB_NAME}.deploy.conf
if [ -f $deployConfigFile ]; then
    echo "Using deployment config file: $deployConfigFile"
    . $deployConfigFile    
else
    echo "Deployment config file $deployConfigFile not found, creating new file."
    TEMPLATE_CONFIGURATION=$NAMES_ROOT_DIR/etc/names.config.template
    . $TEMPLATE_CONFIGURATION
    mkdir -p $NAMES_ETC_DIR
fi

read -p "DB Name [$NAMES_DB_NAME]: " userDbName
read -p "DB User [$NAMES_DB_USER]: " userDbUser
read -p "DB Host [$NAMES_DB_HOST]: " userDbHost
read -p "DB Port [$NAMES_DB_PORT]: " userDbPort
read -p "DB Admin User [$NAMES_DB_ADMIN_USER]: " userDbAdminUser
read -p "DB Admin Hosts [$NAMES_DB_ADMIN_HOSTS]: " userDbAdminHosts
read -p "DB Character Set [$NAMES_DB_CHARACTER_SET]: " userDbCharset
read -p "Context Root [$NAMES_CONTEXT_ROOT]: " userContextRoot

read -p "Auth LDAP server [$NAMES_LDAP_AUTH_SERVER_URL]: " userLdapServerUrl
read -p "LDAP dn root for lookup [$NAMES_LDAP_AUTH_DN_FORMAT]: " userLdapServerDnFormat
read -p "LDAP user lookup filter (use %s for username placeholder) [$NAMES_LDAP_LOOKUP_FILTER]: " userLdapLookupFilter
read -p "Auth LDAP service account dn [$NAMES_LDAP_SERVICE_DN]: " ldapServiceDn
echo "Auth LDAP service account password: " && read -s ldapServicePass

if [ ! -z $userDbName ]; then
	NAMES_DB_NAME=$userDbName
fi
if [ ! -z $userDbUser ]; then
	NAMES_DB_USER=$userDbUser
fi
if [ ! -z $userDbHost ]; then
	NAMES_DB_HOST=$userDbHost
fi
if [ ! -z $userDbPort ]; then
	NAMES_DB_PORT=$userDbPort
fi
if [ ! -z $userDbAdminUser ]; then
	NAMES_DB_ADMIN_USER=$userDbAdminUser
fi
if [ ! -z $userDbAdminHosts ]; then
	NAMES_DB_ADMIN_HOSTS=$userDbAdminHosts
fi
if [ ! -z $userDbCharset ]; then
	NAMES_DB_CHARACTER_SET=$userDbCharset
fi
if [ ! -z $userDbScriptsDir ]; then
	NAMES_DB_SCRIPTS_DIR=$userDbScriptsDir
fi
if [ ! -z $userDataDir ]; then
	NAMES_DATA_DIR=$userDataDir
fi
if [ ! -z $userContextRoot ]; then
	NAMES_CONTEXT_ROOT=$userContextRoot
fi
if [ ! -z $userLdapServerUrl ]; then
	NAMES_LDAP_AUTH_SERVER_URL=$userLdapServerUrl
fi
if [ ! -z $userLdapServerDnFormat ]; then
	NAMES_LDAP_AUTH_DN_FORMAT=$userLdapServerDnFormat
fi
if [ ! -z $userLdapLookupFilter ]; then
    NAMES_LDAP_LOOKUP_FILTER="'$userLdapLookupFilter'"
elif [ ! -z $NAMES_LDAP_LOOKUP_FILTER ]; then
    NAMES_LDAP_LOOKUP_FILTER="'$NAMES_LDAP_LOOKUP_FILTER'"
fi
if [ ! -z $ldapServiceDn ]; then
    NAMES_LDAP_SERVICE_DN=$ldapServiceDn
fi

configContents="NAMES_DB_NAME=$NAMES_DB_NAME"
configContents="$configContents\nNAMES_DB_USER=$NAMES_DB_USER"
configContents="$configContents\nNAMES_DB_HOST=$NAMES_DB_HOST"
configContents="$configContents\nNAMES_DB_PORT=$NAMES_DB_PORT"
configContents="$configContents\nNAMES_DB_ADMIN_USER=$NAMES_DB_ADMIN_USER"
configContents="$configContents\nNAMES_DB_ADMIN_HOSTS=$NAMES_DB_ADMIN_HOSTS"
configContents="$configContents\nNAMES_DB_CHARACTER_SET=$NAMES_DB_CHARACTER_SET"
configContents="$configContents\nNAMES_CONTEXT_ROOT=$NAMES_CONTEXT_ROOT"
configContents="$configContents\nNAMES_LDAP_AUTH_SERVER_URL=$NAMES_LDAP_AUTH_SERVER_URL"
configContents="$configContents\nNAMES_LDAP_AUTH_DN_FORMAT=$NAMES_LDAP_AUTH_DN_FORMAT"
configContents="$configContents\nNAMES_LDAP_LOOKUP_FILTER=$NAMES_LDAP_LOOKUP_FILTER"
configContents="$configContents\nNAMES_LDAP_SERVICE_DN=$NAMES_LDAP_SERVICE_DN"
configContents="$configContents\nNAMES_LDAP_SERVICE_PASS=$ldapServicePass"


echo '**************** RESULTING CONFIGURATION ****************'
echo -e $configContents
echo '*********************************************************'

echo "Saving configuration to: $deployConfigFile"
echo -e $configContents > $deployConfigFile