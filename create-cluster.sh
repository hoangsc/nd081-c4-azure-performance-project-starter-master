#!/bin/bash

# Variables
resourceGroup="acdnd-c4-project"
clusterName="udacity-cluster"

# Install aks cli
echo "Installing AKS CLI"

sudo az aks install-cli

echo "AKS CLI installed"

# Create AKS cluster
echo "Step 1 - Creating AKS cluster udacity-cluster"
# Use either one of the "az aks create" commands below
# For users working in their personal Azure account
# This commmand will not work for the Cloud Lab users, because you are not allowed to create Log Analytics workspace for monitoring
az aks create \
--resource-group acdnd-c4-project \
--name udacity-cluster \
--node-count 1 \
--enable-addons monitoring \
--generate-ssh-keys

# For Cloud Lab users
az aks create \
--resource-group acdnd-c4-project \
--name udacity-cluster \
--node-count 1 \
--generate-ssh-keys

# For Cloud Lab users
# This command will is a substitute for "--enable-addons monitoring" option in the "az aks create"
# Use the log analytics workspace - Resource ID
# For Cloud Lab users, go to the existing Log Analytics workspace --> Properties --> Resource ID. Copy it and use in the command below.
#az aks enable-addons -a monitoring -n udacity-cluster -g acdnd-c4-project --workspace-resource-id "/subscriptions/6c39f60b-2bb1-4e37-ad64-faaf30beaca4/resourcegroups/cloud-demo-153430/providers/microsoft.operationalinsights/workspaces/loganalytics-153430"
az aks enable-addons -a monitoring -n udacity-cluster -g acdnd-c4-project --workspace-resource-id "/subscriptions/d681f4bb-8cf6-4784-af46-d2dc7c063e48/resourcegroups/acdnd-c4-project/providers/microsoft.operationalinsights/workspaces/cloud-demo-153430"

echo "AKS cluster created: udacity-cluster"

# Connect to AKS cluster

echo "Step 2 - Getting AKS credentials"

az aks get-credentials \
--resource-group acdnd-c4-project \
--name udacity-cluster \
--verbose

echo "Verifying connection to udacity-cluster"

kubectl get nodes

# echo "Deploying to AKS cluster"
# The command below will deploy a standard application to your AKS cluster. 
kubectl apply -f azure-vote.yaml

#updates an existing AKS cluster to enable the 
#cluster autoscaler on the node pool for the cluster 
#and sets a minimum of 1 and maximum of 3 nodes:
az aks update \
  --resource-group acdnd-c4-project \
  --name udacity-cluster \
  --enable-cluster-autoscaler \
  --min-count 1 \
  --max-count 3