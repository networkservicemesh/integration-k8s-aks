# integration-k8s-aks

Integration K8s AKS runs NSM system tests on AKS.

[cloudtest](https://github.com/networkservicemesh/cloudtest) is used to run the tests from [deployments-k8s](https://github.com/networkservicemesh/deployments-k8s/) in AKS.

You can see exactly what cloudtest does to setup a cluster in AKS [here](cloudtest/azure.yaml).

Effectively it just sets the indicated environment variables
```bash
AZURE_CLUSTER_NAME
AZURE_RESOURCE_GROUP=nsm-ci
KUBECONFIG
AZURE_CREDENTIALS_PATH
AZURE_SERVICE_PRINCIPAL
AZURE_SERVICE_PRINCIPAL_SECRET
AZURE_TENANT
GITHUB_RUN_NUMBER
```

and then runs the [aks-start.sh](scripts/aks-start.sh)
