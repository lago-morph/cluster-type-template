define DOCS
Convenience helpers for aws-salt

Run corresponding Terraform commands with additional error checking

- init		
- plan
- taint-hosts		(taints the hosts EC2 instances to recreate them w/apply)
- taint-master		(taints the salt-master EC2 instance to recreate it w/apply)
- apply
- apply-auto-approve

Connect to the bastion host (if defined)
* not yet *- ssh-cluster

Connect to the salt master (if it has a public IP)
- ssh-master

endef

MAKEFLAGS += --jobs

CLUSTER_TYPE_CONFIG = ../cluster-type.json
CLUSTER_CONFIG = ../cluster.json
VAR_BRANCH = -var branch=$(shell git rev-parse --abbrev-ref HEAD)
KEY_FILE = $(shell cat $(CLUSTER_TYPE_CONFIG) | jq -r .private_key_file)
VAR_KEY = -var private_key='$(shell cat $(KEY_FILE))'
TF_VARS = $(VAR_BRANCH) $(VAR_KEY)
TF_VAR_FILES = -var-file=$(CLUSTER_TYPE_CONFIG) -var-file=$(CLUSTER_CONFIG)
TF_ARGS = $(TF_VARS) $(TF_VAR_FILES)

.ONESHELL:

# dummy target does nothing when make without arguments
export DOCS
show-usage: 
	@echo "$$DOCS"

check-config: CLI_REGION = $(shell aws configure get region)
check-config: CONF_REGION = $(shell cat $(CLUSTER_TYPE_CONFIG) | jq -r .region)
check-config:
	@if [ "$(CLI_REGION)" = "$(CONF_REGION)" ]; \
	then true; \
	else \
	    echo "region config mismatch AWS CLI uses $(CLI_REGION), cluster-type config file uses $(CONF_REGION)"; \
	    false; \
	fi

init: check-config
	terraform init $(TF_ARGS)
plan: check-config
	terraform plan $(TF_ARGS) 
apply: check-config
	terraform apply $(TF_ARGS)
apply-auto-approve: check-config
	terraform apply $(TF_ARGS) --auto-approve

taint-host:
	terraform taint 'aws_instance.host[*]'

taint-master:
	terraform taint 'aws_instance.salt-master'


ssh:
	ssh  -A -o "StrictHostKeyChecking no" ubuntu@$(HOST_IP)

ssh-master: HOST_IP = $(SM)
ssh-master: ssh
