TOP = .

default:

support: 
	$(TOP)/sbin/names_install_support.sh

configuration:
	$(TOP)/sbin/names_create_configuration.sh

schema:
	$(TOP)/sbin/names_create_db_schema.sh

backup:
	$(TOP)/sbin/names_backup.sh

restore:
	$(TOP)/sbin/names_restore.sh

payara-configure:
	$(TOP)/sbin/names_payara_config_create.sh

payara-unconfigure:
	$(TOP)/sbin/names_payara_config_remove.sh

deploy:
	$(TOP)/sbin/names_deploy.sh