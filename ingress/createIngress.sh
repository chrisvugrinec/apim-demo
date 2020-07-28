
if [ "$#" -ne 2 ] ;
then
  echo "Usage: $0 AKS_CLUSTER AKS_RG"
  echo ""
  echo "AKS Clusters:"
  az aks list -o table
  exit 1
fi

AKS_CLUSTER=$1
AKS_RG=$2

# Needed for managed ID to create network resources on aks subnet
function assignContribRoleToManagedIdentity(){
   appId=$(az ad sp list --all --filter "displayname eq '"$AKS_CLUSTER"'" --query [].appId -o tsv)
   subnetId=$(az aks show -n $AKS_CLUSTER -g $AKS_RG --query agentPoolProfiles[].vnetSubnetId -o tsv )
   az role assignment create --assignee $appId --role "Contributor" --scope $subnetId
}

assignContribRoleToManagedIdentity

kubectl apply -f ./rbac/dev-namespace.yaml
kubectl apply -f ./rbac/role-aks-user.yaml
kubectl apply -f ./rbac/rolebinding-aks-user.yaml
kubectl apply -f ./nginx/common/ns-and-sa.yaml
kubectl apply -f ./nginx/rbac/rbac.yaml
kubectl apply -f ./nginx/common/default-server-secret.yaml
kubectl apply -f ./nginx/common/nginx-config.yaml
kubectl apply -f ./nginx/common/vs-definition.yaml
kubectl apply -f ./nginx/common/vsr-definition.yaml
kubectl apply -f ./nginx/common/ts-definition.yaml
kubectl apply -f ./nginx/deployment/nginx-ingress.yaml
kubectl apply -f ./nginx/service/loadbalancer.yaml
kubectl apply -f ./rbac/role-aks-user-ingress.yaml
kubectl apply -f ./rbac/rolebinding-aks-user-ingress.yaml
