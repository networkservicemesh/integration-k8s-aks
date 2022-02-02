#!/bin/bash

readonly AZURE_RESOURCE_GROUP=$1
readonly AZURE_CLUSTER_NAME=$2
readonly AZURE_CREDENTIALS_PATH=$3
readonly AZURE_SERVICE_PRINCIPAL=$4
readonly AZURE_SERVICE_PRINCIPAL_SECRET=$5
if [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]]; then
    echo "Usage: aks-start.sh <resource-group> <cluster-name> <kube-config-path> [<service-principal> <password>]"
    exit 1
fi
function nsg_polling {
    ((end_time=SECONDS+1200))
    REQUEST="az network nsg list -g $1 --query [].name -o tsv"
    while ((SECONDS < end_time)); do
      RESULT=$(az network nsg list -g "$1" --query [].name -o tsv)
      if [ -z "$RESULT" ]
      then
        sleep 60
      else
        echo "$RESULT"
        return 0
      fi
    done
    exit 5
}

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
echo "Creating Inbound traffic rule"
NODE_RESOURCE_GROUP=$(az aks show -g "$AZURE_RESOURCE_GROUP" -n "$AZURE_CLUSTER_NAME" --query nodeResourceGroup -o tsv)
echo NODE_RESOURCE_GROUP=$NODE_RESOURCE_GROUP
NSG_NAME=$(nsg_polling "$NODE_RESOURCE_GROUP")
echo NSG_NAME=$NSG_NAME
az network nsg rule create --name "${NSG_NAME}-rule" \
    --nsg-name "$NSG_NAME" \
    --priority 100 \
    --resource-group "$NODE_RESOURCE_GROUP" \
    --access Allow \
    --description "Allow All Inbound Internet traffic" \
    --destination-address-prefixes '*' \
    --destination-port-ranges '*' \
    --direction Inbound \
    --protocol '*' \
    --source-address-prefixes Internet \
    --source-port-ranges '*' && \
    echo "done" || exit 6
mkdir -p "$(dirname "$AZURE_CREDENTIALS_PATH")"
az aks get-credentials \
    --name "$AZURE_CLUSTER_NAME" \
    --resource-group "$AZURE_RESOURCE_GROUP" \
    --file "$AZURE_CREDENTIALS_PATH" \
    --overwrite-existing || exit 7
