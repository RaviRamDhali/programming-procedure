# Adding Identity Service Connection
When a pipleline failed to connect to Azure Resource 

## Azure DevOps 
1. Select Project Settings
1. Select Pipelines > Service connections
1. Delete all old Service connections
1. Select identity type App registration or Managed identity (manual) the Workload identity federation credential.
1. Connection name, enter "uamanagedidentity".
1. Select Next.
1. App registration details



![image](https://github.com/user-attachments/assets/37db1c26-d270-492d-9832-e61d91487baf)

1. Select the Resouce Group
1. Select Access control (IAM)
1. Select Grant access to this resource btn "Add role assignment"
1. Select tab "Privileged administrator roles"
1. Select "Contributor"
1. Select Next
1. For "Assign access to" > "Managed identity"
1. Click on "Select members"
1. Click on the Select member you added before

![image](https://github.com/user-attachments/assets/bb3cbe46-05bc-43b2-87b4-f83525c37ab2)


Grant permissions to the managed identity in Azure portal
In Azure portal, go to the Azure resource that you want to grant permissions for (for example, a resource group).

1. Select Access control (IAM).
1. Screenshot that shows selecting Access control in the resource menu.
1. Select Add role assignment. Assign the required role to your managed identity (for example, Contributor).
.1 Select Review and assign.

![image](https://github.com/user-attachments/assets/ffe4f454-d0c5-45f6-87f2-00acf8414b2a)

## Back to Azure Devops
Finish up adding the Service Connection (which should have been left if Draft Mode)

1. Select Project Settings
1. Select Pipelines > Service connections
![image](https://github.com/user-attachments/assets/6f8cf19c-bddc-43be-be56-a91224812c9c)
1. 

