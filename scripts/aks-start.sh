#!/bin/bash

readonly AZURE_RESOURCE_GROUP=$1
readonly AZURE_CLUSTER_NAME=$2
readonly AZURE_CREDENTIALS_PATH=$3

if [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]]; then
    echo "Usage: aks-start.sh <resource-group> <cluster-name> <kube-config-path> [<service-principal> <password>]"
    exit 1
fi

echo -n "Creating AKS cluster '$AZURE_CLUSTER_NAME'..."
az aks create \
    --resource-group "$AZURE_RESOURCE_GROUP" \
    --name "$AZURE_CLUSTER_NAME" \
    --node-count 2 \
    --node-vm-size Standard_B2s \
    --generate-ssh-keys \
    --debug && \
    echo "az aks create done" || exit 3
echo "Waiting for deploy to complete..."
az aks wait  \
	--name "$AZURE_CLUSTER_NAME" \
	--resource-group "$AZURE_RESOURCE_GROUP" \
	--created > /dev/null && \
echo "az aks wait done" || exit 4
mkdir -p "$(dirname "$AZURE_CREDENTIALS_PATH")"
az aks get-credentials \
    --name "$AZURE_CLUSTER_NAME" \
    --resource-group "$AZURE_RESOURCE_GROUP" \
    --file "$AZURE_CREDENTIALS_PATH" \
    --overwrite-existing || exit 7
