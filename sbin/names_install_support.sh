#!/bin/bash

MY_DIR=`dirname $0` && cd $MY_DIR && MY_DIR=`pwd`
source $MY_DIR/_names_load_configuration

mkdir -p $NAMES_SUPPORT_DIR
cd $NAMES_SUPPORT_DIR

mkdir -p src

rm -rf bin
mkdir -p bin

cd src

# Install payara
PAYARA_FILENAME=payara-5.2022.5.zip
if [ ! -f $PAYARA_FILENAME ]; then 
    wget https://repo1.maven.org/maven2/fish/payara/distributions/payara/5.2022.5/$PAYARA_FILENAME
fi

cd ../
unzip src/$PAYARA_FILENAME

# Install Java maven
CONDA_ENV_DIR=./names-env
conda create --prefix $CONDA_ENV_DIR openjdk==11.0.9.1 maven -y

# Add links 
cd bin 
ln -s `realpath ../names-env/bin/java`
ln -s `realpath ../names-env/bin/javac`
ln -s `realpath ../names-env/bin/mvn`

cd $NAMES_SUPPORT_DIR
ln -s payara5 payara

# Install maradb client. 
cp $MY_DIR/mariadb-java-client-3.1.0.jar payara/glassfish/domains/domain1/lib/

# Set up new admin and master passwords 
echo "Update default payara credentials" 
echo "Change master password. Default one is 'changeit'"
asadmin change-master-password --savemasterpassword
echo "Change admin password. Default one is blank"
asadmin change-admin-password

asadmin start-domain domain1
echo "set up auto log in to payara server."
asadmin login

asadmin stop-domain domain1