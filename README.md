# apim-demo

This repo contains a cookbook for you to get started with APIM.
It rolls out an AKS and MGMT vnet. Deploys an AKS cluster with Ingress controller (linked to internal loadbalancer) and creates and APIM gateway on the management VNET.

![Image of APIM solution](https://raw.githubusercontent.com/chrisvugrinec/apim-demo/master/images/apim2.png)

for more complex scenario (using UDR/ Firewall/ AKS private cluster), please have a look at: https://github.com/chrisvugrinec/aks-sec-demo