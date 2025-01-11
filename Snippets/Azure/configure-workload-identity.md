# Adding Identity Service Connection
When a pipleline failed to connect to Azure Resource 

![image](https://github.com/user-attachments/assets/37db1c26-d270-492d-9832-e61d91487baf)

## Azure DevOps 
1. Select Project Settings
1. Select Pipelines > Service connections
1. Delete all old Service connections
1. Click "Create service connection"
1. Select Azure Resource Manager
1. Select Workload Identity federation (manual)
1. ~~type App registration or Managed identity (manual) the Workload identity federation credential.~~
1. Connection name, enter "{{client-name}}-managedidentity", and description
1. Enter Subscription Id and Subscription Name (from Azure Resource)
1. Click "Keep as Draft" (you will be getting the remaning data from 

## Azure Reource
### Create Managed identity
1. Go to Managed Identities
1. Create managed identity
1. Select Subscription, Resource group, and Region
1. Name: {{client-name}}-az-resource-conn
1. Click Review and Create 
1. Go to Managed Identity > {{client-name}}-az-resource-conn (might take a few minutes to appear)
### Add Federated Credential
1. Select Managed Identity > {{client-name}}-az-resource-conn
1. Select Settings > Federated credentials > Add Federated Credential
1. Federated credential scenario: Select Other
1. Go back to Azure DevOps > Project Settings > Service Connections > {{client-name}}-managedidentity
1. Copy and Paste both Issuer and Subject identifier into Add Federated Credential screen
1. Credential details > Name: {{client-name}}-federated-credential
1. Click Add

![image](https://github.com/user-attachments/assets/bfea2ce9-7e32-4e5f-ab4f-480a09628967)


### Add Role Contributor
1. Select the Resouce Group
1. Select Access control (IAM)
1. Select Grant access to this resource btn "Add role assignment"
1. Select tab "Privileged administrator roles"
1. Select "Contributor"
1. Select Next
1. For "Assign access to" > "Managed identity"
1. Click on "Select members"
1. Dropdown "User-assigned managed identity"
1. Click on the Select member you added {{client-name}}-az-resource-conn
1. Click "Select"
1. Click "Review + assign"

![image](https://github.com/user-attachments/assets/bb3cbe46-05bc-43b2-87b4-f83525c37ab2)


Grant permissions to the managed identity in Azure portal
In Azure portal, go to the Azure resource that you want to grant permissions for (for example, a resource group).

1. Select Access control (IAM).
1. Select Grant access to this resource btn "Add role assignment"
1. Select Tab "Privileged administrator roles"
1. Screenshot that shows selecting Access control in the resource menu.
1. Select Add role assignment. Assign the required role to your managed identity (for example, Contributor).
.1 Select Review and assign.

![image](https://github.com/user-attachments/assets/ffe4f454-d0c5-45f6-87f2-00acf8414b2a)

## Back to Azure Devops
Finish up adding the Service Connection (which should have been left if Draft Mode)

1. Select Project Settings
1. Select Pipelines > Service connections
1. Select "Finish Setup"
![image](https://github.com/user-attachments/assets/6f8cf19c-bddc-43be-be56-a91224812c9c)
1. Get the **Tenant Id** and **Client Id** from Managed Identities > {{client-name}}-managedidentity > Settings > Properties
1. The label _Service Principal Id_ is misleading, but if you read the description it does say 
```Client Id for connecting to the endpoint. Refer to Azure Service Principal link on how to create Azure Service Principal.```
![image](https://github.com/user-attachments/assets/4b8096ab-02dd-4afe-a2bd-5a6a90eca9de)

![image](https://github.com/user-attachments/assets/869a2db6-7268-4f54-9971-36e4ff372c33)


