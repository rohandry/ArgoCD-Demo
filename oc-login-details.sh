export RESOURCEGROUP=ocp-rg
export CLUSTER=testcluster
export LOCATION=australiacentral
echo "Here are your kubeadmin details"
az aro list-credentials --name $CLUSTER --resource-group $RESOURCEGROUP

echo "Here is your OpenShift console link"
az aro show --name $CLUSTER --resource-group $RESOURCEGROUP --query "consoleProfile.url" -o tsv

