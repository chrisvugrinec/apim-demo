# apim-demo

## Intro

This repo contains a cookbook for you to get started with APIM.
It rolls out an AKS and MGMT vnet. Deploys an AKS cluster with Ingress controller (linked to internal loadbalancer) and creates and APIM gateway on the management VNET. In the last step you will deploy an HelloWorld restService and configure this with the APIM gateway.

![Image of APIM solution](https://raw.githubusercontent.com/chrisvugrinec/apim-demo/master/images/apim2.png)

for more complex scenario (using UDR/ Firewall/ AKS private cluster), please have a look at: https://github.com/chrisvugrinec/aks-sec-demo

## Cookbook

### Create Infra

For this demo you will need the following Azure Infra components: AKS cluster, APIM and a Private DNS zone. This demo uses a tiered setup into 2 layers. Terraform is used for the rollout and the State is stored on Azure Blob storage.

- get sources; ```git clone https://github.com/chrisvugrinec/apim-demo.git```
- prepare Azure storage (for terraform state); ```cd infra``` change the variables in the ```1_setupTFStorage.sh``` script.
- create the storage: ```./1_setupTFStorage.sh*```
- set the ARM_ACCESS_KEY variable; ```export ARM_ACCESS_KEY= [ the storage key found in the previous step] ```
- setup tier 2, the network structure; ```cd tier_2``` change the variables.tf, naming and storage account settings
- rollout the network structure; ```terraform init; terraform plan; terraform apply```
- setup tier 3, AKS; ```cd tier_3``` change the variables.tf, naming and storage account settings
- rollout the demo app structure; ```terraform init; terraform plan; terraform apply```

#### Setup HELM

Sometimes an old version of HELM is required, this demo is using version 2.13, tiller downloaded from the helm.sh site
- ```cd helm/darwin-amd64```
- ```./installTiller.sh AKS_CLUSTER AKS_RG```

This will get the credentials for your AKS cluster and initialise tiller on your AKS cluster.

#### Setup ingress controller

-  ```cd ingress/```
- ```./createIngress.sh AKS_CLUSTER AKS_RG```

This will give your managed identity of your AKS cluster the rights to create resources on the AKS subnet.
Next to this it will create an Nginx Ingress controller linked to an Internal Azure LoadBalancer.
Please note thate the current Internal loadbalancer is based on the following configured IP address:   
```
  loadBalancerIP: 15.1.2.100
```
If you like to change this, make sure that it is in the range of your configured AKS subnet. You can change the ip of the ingress loadbalancer by editing this file: ```ingress/nginx/service/loadbalancer.yaml```

### Deploy service

Deploy the sayHello service
- ```cd services/hello-python-service/helm```
- ```../../../helm/darwin-amd64/helm install -n sayhello sayhello/```

Deploy the poker service
- ```cd services/poker-springboot-service/helm```
- ```../../../helm/darwin-amd64/helm install -n poker-deal-test pokerservice/```

After this deployments you should be able to:
- check helm deployments; helm ls
- check if the pods are running; kubectl get pods 
- check if services are available: kubectl get svc
- check if ingresses are configured; kubectl get ing

### Config APIM

#### Setup services

In your Azure Poral go to the APIM and select the API tab:

![Config APIM service](https://raw.githubusercontent.com/chrisvugrinec/apim-demo/master/images/apim1.png)

Select the OpenAPI option and use the wizzard to configure the services. 
In the services folder you can find the api spec (swagger extraction):
```
services/hello-python-service/api.json
services/poker-springboot-service/api.json
```
In the `API URL suffix` you fill in the path you like your service to be accessible from the APIM.

Your service is now visible within the API portal, select your service and then select the `Design` tab. Within the design tab, select the policy for Inbound processing:

![Config APIM service](https://raw.githubusercontent.com/chrisvugrinec/apim-demo/master/images/apim3.png)

In this policy you should forward your backend request to the AKS backend service, by adding this code:
```
<policies>
...
    <backend>
        <forward-request />
    </backend>
...
</policies>
```
Please note that you can configure this policy on Operation level or more globally on API level. If you do not configure this, you backend service will never be reached, also have a look at the caching possibilities.
Of course you can configure other policies as well, for more information please read the [APIM documentation](https://docs.microsoft.com/en-us/azure/api-management/).

In the `Settings` tab you need to configure the URL of your backend service. If you used the scripts in this repo you should have 2 domains configured:

```
hello.apimdemo.service.local
poker.apimdemo.service.local
```

Both services are pointing to the internal loadbalancer, which is pre configured on this address: `15.1.2.100`. This address is used by the nginx ingress controller, which will make sure that you address the appropriate services which are deployed on the AKS cluster.

For the hello service you enter: `http://hello.apimdemo.service.local` in the `Web service URL` field. Make sure you select `HTTP`.

For the poker service your config should look like this:

![Config APIM service](https://raw.githubusercontent.com/chrisvugrinec/apim-demo/master/images/apim5.png)

If you have configured your `<forward-request />` and the proper `Web service URL` you should be able to test your service through the portal. Ps If testing using an external tool like *Postman* make sure you post the required headers as well, for eg `Ocp-Apim-Subscription-Key` with the key for the defined APIM product.

#### Configure Authentication

There are multiple ways to enforce authentication on your services using APIM.


## Links

- APIM documentation; https://docs.microsoft.com/en-us/azure/api-management/
- APIM AAD authentication; https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-protect-backend-with-aad
- oauth2; https://auth0.com/docs/integrations/azure-api-management
