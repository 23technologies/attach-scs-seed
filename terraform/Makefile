# Makefile

# set the env we used 
#ENVIRONMENT = gx-bc
#ENVIRONMENT = gx-citycloud
#ENVIRONMENT = gx-scs
ENVIRONMENT = gx-citycloud
OPENSTACK = openstack
USERNAME = ubuntu
CONSOLE = capi-mgmtcluster

# check for openstack credentials
NEED_OSCLOUD := $(shell test -z "$$OS_PASSWORD" -a -z "$$OS_CLOUD" && echo 1 || echo 0)
ifeq ($(NEED_OSCLOUD),1)
  export OS_CLOUD=$(ENVIRONMENT)
endif

create: init
	@touch .deploy.$(ENVIRONMENT)
	@terraform apply -auto-approve -var-file="environments/environment-$(ENVIRONMENT).tfvars"

purge:
	@echo "Warning, going to delete ALL resources in $(ENVIRONMENT), even those that have not been created by the testbed. The SSH-Key capi-keypair will be removed for all projects."
	@read -p "Continue? (y/n) " -r; \
        if [[ ! $$REPLY =~ ^[Yy] ]]; \
        then \
			exit 1; \
        fi
	@ospurge --purge-own-project --os-cloud $(ENVIRONMENT) --verbose || true
	@rm -f .deploy.$(ENVIRONMENT) .MGMT_ADDRESS.$(ENVIRONMENT)
	@rm -f .id_rsa.$(ENVIRONMENT)
	@terraform workspace select default || true
	@terraform workspace delete -force $(ENVIRONMENT) || true
	@openstack keypair delete capi-keypair || true
	@ospurge --purge-own-project --os-cloud $(ENVIRONMENT) --verbose || true

ssh:    .deploy.MGMTCLUSTER_ADDRESS.$(ENVIRONMENT) .deploy.id_rsa.$(ENVIRONMENT)
	@source ./.deploy.MGMTCLUSTER_ADDRESS.$(ENVIRONMENT); \
	ssh -o StrictHostKeyChecking=no -i .deploy.id_rsa.$(ENVIRONMENT) $(USERNAME)@$$MGMTCLUSTER_ADDRESS

openstack: init
	@$(OPENSTACK)

PHONY: clean console attach detach ssh dry-run list deploy watch openstack create log console login k9s 
