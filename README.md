
# DISCS Collaboration: Naming System Module

Description: A web-based system to manage naming convention of a particle accelerator facility.

### Contents:
   - data: sample data
   - design: design artifacts (SQL, MWB, Enterprise Architect files)
   - docs: documentation
   - src: source code
   - sbin: support scripts and binaries 
   - etc: configuration

## Deployment 

### Pre-requisistes

- mariadb
- conda

### Structure 

- NAMES_INSTALL_DIR
  - NAMES_DIST: Names distribution
  - etc: Configuration
  - support-`hostname -s`: support binaries such as java and payara.
  - backup: db snapshots 

### Instructions

The deployment can be driven by creating a well defined configuration file. This is done in the `make configuration` step below. 

```sh
# Create a installation directory
mkdir $NAMES_INSTALL_DIR
cd $NAMES_INSTALL_DIR

## Download the names release/repo
# git clone ...
# wget names-release.tar.gz && unzip names-release.tar.gz
cd $NAMES_DIST
source setup.sh

# Create a configuration file for the deployment. 
make configuration

# Install necessary support
make support

# Deploy schema 
make schema

# Configure payara server
make payara-configure

# Deploy naming app
make deploy
```

### Update SSL certificate on payara

```sh
cd $NAMES_DIST

# Provide path to key and cert 
./sbin/names_update_ssl.sh ../etc/ssl.key ../etc/ssl.cer
```