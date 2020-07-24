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


![Config APIM service](https://raw.githubusercontent.com/chrisvugrinec/apim-demo/master/images/apim-svc-config.png)

Please note thate the current Internal loadbalancer is based on the following configured IP address:   
```
  loadBalancerIP: 15.1.0.100
```
If you like to change this, make sure that it is in the range of your configured AKS subnet. You can change the ip of the ingress loadbalancer by editing this file: ```ingress/nginx/service/loadbalancer.yaml```