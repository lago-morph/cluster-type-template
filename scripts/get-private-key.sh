#!/bin/bash

export CLUSTER_TYPE_CONFIG_FILE=../cluster-type.json
export CLUSTER_TYPE=$(cat $CLUSTER_TYPE_CONFIG_FILE | jq -r .cluster_type)
export BRANCH=$(git rev-parse --abbrev-ref HEAD)
export CLUSTER_NAME="$CLUSTER_TYPE-$BRANCH"
export SSM_KEY="/$CLUSTER_NAME/private_key"

aws ssm get-parameter \
    --name $SSM_KEY \
    --with-decryption \
| jq -r .Parameter.Value
