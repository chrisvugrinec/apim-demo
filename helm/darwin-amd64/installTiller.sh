echo "make sure you are connected to the proper kube cluster"
echo "did you do the az aks get-credentials command???"

kubectl apply -f service-account.yaml

export TILLER_TAG=v2.13.0
kubectl --namespace=kube-system set image deployments/tiller-deploy tiller=gcr.io/kubernetes-helm/tiller:$TILLER_TAG

#./helm init --service-account tiller --override spec.selector.matchLabels.'name'='tiller',spec.selector.matchLabels.'app'='helm' --output yaml | sed 's@apiVersion: extensions/v1beta1@apiVersion: apps/v1@' | kubectl apply -f -

kubectl apply -f tiller-deploy.yaml
