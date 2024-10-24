#!/bin/bash
#
# Script used for updating the SSL certificates the application runs on
#
# Usage:
#
# $0 KEY_FILE CRT_FILE
#
CALLER_DIR=`pwd`
MY_DIR=`dirname $0` && cd $MY_DIR && MY_DIR=`pwd`
source $MY_DIR/_names_load_configuration

NAMING_DOMAIN_NAME=domain1
ASADMIN=`which asadmin`
NAMING_GLASSFISH_DIR=`dirname $ASADMIN`/..
NAMING_GLASSFISH_DIR=`realpath $NAMING_GLASSFISH_DIR`

if [ ! -z "$1" ]; then
    KEY_FILE=`realpath $1`
else
    echo "Please provide a key file input."
    exit 2
fi

if [ ! -z "$2" ]; then
    CRT_FILE=`realpath $2`
else
    >&2 echo "Please provide a crt file input."
    exit 2
fi

echo -n "Please enter the master password for glassfish: "
read -s masterPassword
echo ""; 

if [ -z $masterPassword ]; then
    >&2 echo "A master password must be provided"
    exit 2
fi

echo "Stopping glassfish server."
$ASADMIN stop-domain $NAMING_DOMAIN_NAME

GLASSFISH_KEYSTORE_PATH=$NAMING_GLASSFISH_DIR/domains/$NAMING_DOMAIN_NAME/config/keystore.jks

# Test entered password
failed=0
keytool -list -v -keystore $GLASSFISH_KEYSTORE_PATH --storepass $masterPassword > /dev/null || failed=1

if [ $failed == 1 ]; then
    >&2 echo "The password entered was incorrect"
    exit 2
fi

PKCS12_CERT_STORE="/tmp/${RANDOM}cert.pkcs12"
SSL_ALIAS="namingcert"

echo "Creating keystore: $PKCS12_CERT_STORE"
openssl pkcs12 -export -in $CRT_FILE -inkey $KEY_FILE -out $PKCS12_CERT_STORE -name $SSL_ALIAS -passout pass:$masterPassword

keytool -keystore $GLASSFISH_KEYSTORE_PATH -delete -alias $SSL_ALIAS -storepass $masterPassword

keytool -importkeystore \
-srckeystore $PKCS12_CERT_STORE \
-srcstoretype pkcs12 \
-srcstorepass $masterPassword \
-deststoretype jks \
-destkeystore $GLASSFISH_KEYSTORE_PATH \
-deststorepass $masterPassword


$ASADMIN start-domain $NAMING_DOMAIN_NAME

$ASADMIN set configs.config.server-config.network-config.protocols.protocol.http-listener-2.ssl.cert-nickname=$SSL_ALIAS

# Restart
$ASADMIN stop-domain $NAMING_DOMAIN_NAME
$ASADMIN start-domain $NAMING_DOMAIN_NAME

echo "Removing keystore: $PKCS12_CERT_STORE"
rm $PKCS12_CERT_STORE 
