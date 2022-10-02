# integration-k8s-aks

Integration K8s AKS runs NSM system tests on AKS.


## Requirements

1. Install [az](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) 

2. Set envs

```bash
AZURE_CLUSTER_NAME
AZURE_RESOURCE_GROUP
AZURE_SERVICE_PRINCIPAL
AZURE_SERVICE_PRINCIPAL_SECRET
AZURE_TENANT
```

## Setup

Run this command to create `AKS` cluster.

```bash
az aks create \
    --resource-group "$AZURE_RESOURCE_GROUP" \
    --name "$AZURE_CLUSTER_NAME" \
    --node-count 2 \
    --node-vm-size Standard_B2s \
    --generate-ssh-keys \
    --debug
az aks wait  \
    --name "$AZURE_CLUSTER_NAME" \
    --resource-group "$AZURE_RESOURCE_GROUP" \
    --created > /dev/null
```

## Cleanup

Run this command to delete `AKS` cluster.

```bash
az aks delete \
    --name "$AZURE_CLUSTER_NAME" \
    --resource-group "$AZURE_RESOURCE_GROUP" \
    --yes
```