echo "make sure you are connected to the proper kube cluster"

AKS_CLUSTER=$1
AKS_RG=$2

if [ "$#" -ne 2 ] ;
then
  echo "Usage: $0 AKS_CLUSTER AKS_RG"
  echo ""
  echo "AKS Clusters:"
  az aks list -o table
  exit 1
fi

az aks get-credentials -n $AKS_CLUSTER -g $AKS_RG

kubectl apply -f service-account.yaml

export TILLER_TAG=v2.13.0
kubectl --namespace=kube-system set image deployments/tiller-deploy tiller=gcr.io/kubernetes-helm/tiller:$TILLER_TAG

#./helm init --service-account tiller --override spec.selector.matchLabels.'name'='tiller',spec.selector.matchLabels.'app'='helm' --output yaml | sed 's@apiVersion: extensions/v1beta1@apiVersion: apps/v1@' | kubectl apply -f -

kubectl apply -f tiller-deploy.yaml
