cluster_name="aks-apimdemo-app1"
cluster_name_subnet="aks-apimdemo-app1-subnet"
admin_resource_group="dev-australiaeast-2-apimdemo-mgmt-resources"
aks_vnet_name="vuggie-aks-demo-vnet"


# Needed for managed ID to create network resources on aks subnet
function assignContribRoleToManagedIdentity(){
   appId=$(az ad sp list --all --filter "displayname eq '"$cluster_name"'" --query [].appId -o tsv)
   subnetId=$(az network vnet subnet show -n $cluster_name_subnet -g $admin_resource_group --vnet-name $aks_vnet_name --query id -o tsv)
   az role assignment create --assignee $appId --role "Contributor" --scope $subnetId
}

#assignContribRoleToManagedIdentity

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
