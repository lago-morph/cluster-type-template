define DOCS
Convenience helpers for aws-salt

backend-init    Create S3 bucket, DynamoDB table, and output to backend.tf

Run corresponding Terraform commands with additional error checking
- init		
- plan
- taint-hosts     (taints the hosts EC2 instances to recreate them w/apply)
- taint-master    (taints the salt-master EC2 instance to recreate it w/apply)
- apply
- apply-auto-approve
- destroy

Connect to the salt master (if it has a public IP)
- ssh-master

endef

MAKEFLAGS += --jobs

CLUSTER_TYPE_CONFIG = ../cluster-type.json
CLUSTER_CONFIG = ../cluster.json
VAR_BRANCH = -var branch=$(shell git rev-parse --abbrev-ref HEAD)
TF_VARS = $(VAR_BRANCH)
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
destroy: check-config
	terraform destroy $(TF_ARGS)

taint-host:
	terraform taint 'module.cluster.host[*]'

taint-master:
	terraform taint module.cluster.aws_instance.salt_master

ssh:
	ssh  -A -o "StrictHostKeyChecking no" ubuntu@$(HOST_IP)

ssh-master: HOST_IP = $(shell terraform output -raw salt_master_public_ip)
ssh-master: ssh

create-resources:
	aws s3 mb s3://$(S3B)
	aws dynamodb create-table \
		  --table-name $(DDBNAME) \
		  --key-schema AttributeName=$(DDBKEY),KeyType=HASH \
		  --attribute-definitions AttributeName=$(DDBKEY),AttributeType=S \
		  --billing-mode PAY_PER_REQUEST \
		  --no-cli-pager

output-file:
	cat <<EOF > $(TFBACKENDFILE)
	terraform {
	  backend "s3" {
	    bucket                 = "$(S3B)"
	    region                 = "$(REGION)"
	    key                    = "backend.tfstate"
	    dynamodb_table         = "$(DDBNAME)"
	  }
	}
	EOF

backend-init: S3B := chiller-state-bucket-$(shell openssl rand -hex 10)
backend-init: DDBNAME = terraformstatelock
backend-init: DDBKEY = LockID
backend-init: REGION = $(shell aws configure get region)
backend-init: TFBACKENDFILE := backend.tf

backend-init: create-resources output-file
	terraform fmt
	terraform init

