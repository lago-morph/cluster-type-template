#!/bin/bash

export CLUSTER_TYPE_CONFIG_FILE=../cluster-type.json
export PRIVATE_KEY_FILE=../$(cat $CLUSTER_TYPE_CONFIG_FILE | jq -r .private_key_file)
export PRIVATE_KEY=$(tr '\n' ' ' < $PRIVATE_KEY_FILE )
export CLUSTER_TYPE=$(cat $CLUSTER_TYPE_CONFIG_FILE | jq -r .cluster_type)
export BRANCH=$(git rev-parse --abbrev-ref HEAD)
export CLUSTER_NAME="$CLUSTER_TYPE-$BRANCH"
export SSM_KEY="/$CLUSTER_NAME/private_key"

aws ssm put-parameter \
    --overwrite \
    --name $SSM_KEY \
    --value "$PRIVATE_KEY" \
    --type SecureString 
