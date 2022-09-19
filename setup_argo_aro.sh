#! /bin/bash

#Create some useful some env vars
export RESOURCEGROUP=ocp-rg
export CLUSTER=testcluster
export LOCATION=australiacentral

#Register our resource providers 
az provider register -n Microsoft.RedHatOpenShift --wait
az provider register -n Microsoft.compute --wait
az provider register -n Microsoft.Storage --wait
az provider register -n Microsoft.Authorization --wait

#Create the resource group for the cluster
az group create --name $RESOURCEGROUP --location $LOCATION

#Create a cluster vnet
az network vnet create --resource-group $RESOURCEGROUP --name aro-vnet --address-prefixes 10.0.0.0/22

#Create master subnet
az network vnet subnet create --resource-group $RESOURCEGROUP --vnet-name aro-vnet --name master-subnet --address-prefixes 10.0.0.0/23 --service-endpoints Microsoft.ContainerRegistry

#Create worker subnet 
az network vnet subnet create --resource-group $RESOURCEGROUP --vnet-name aro-vnet --name worker-subnet --address-prefixes 10.0.2.0/23 --service-endpoints Microsoft.ContainerRegistry 

#Not sure
az network vnet subnet update --name master-subnet --resource-group $RESOURCEGROUP  --vnet-name aro-vnet --disable-private-link-service-network-policies true

#Create the cluster; Requires pull secret in active directory
az aro create  --resource-group  $RESOURCEGROUP --name $CLUSTER --vnet aro-vnet --master-subnet master-subnet --worker-subnet worker-subnet --pull-secret @pull-secret.txt 

echo "Here are your kubeadmin details"
az aro list-credentials --name $CLUSTER --resource-group $RESOURCEGROUP

echo "Here is your OpenShift console link"
az aro show --name $CLUSTER --resource-group $RESOURCEGROUP --query "consoleProfile.url" -o tsv
