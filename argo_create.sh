#! /bin/bash

#Create Namespaces and install operator 
oc create -f manifests/namespace-subscription.yaml

#Setup auth, rbac etc
oc create -f manifests/sso-authentication.yaml

#Get the argocd server
ARGOCD_ROUTE=$(oc -n argocd get route argocd-server -o jsonpath='{.spec.host}')

#login
argocd login --sso $ARGOCD_ROUTE

#Add the cluster
argo cluster add argocd/api-$(oc get cluster -o jsonpath='{.items[].spec.domain}{"\n"}'):6443/kube:admin 

#Launch the application 
oc create -f web-app.yaml
