# Backup Azure MSQL to Azure Storage
_This process can take up to 30min_
1. Go to SQL database in Azure
1. Click the Export button
1. Select the Storage Location/Azure Blob Container

Once the backup is completed, you can browse to the Azure Blob Container and dowload the backup

Example:  **mc2_dctd-2023-5-17-3-51.bacpac**

![image](https://github.com/RaviRamDhali/programming-procedure/assets/1455413/d1f5f488-57c4-48e8-b2db-fc9e53abbcbb)


# Restore BACPAC File using SSMS
1. Open SSMS and right click on Database
1. Select Import Data-tier Application
1. Follow the steps
 
![image](https://github.com/RaviRamDhali/programming-procedure/assets/1455413/897a66a1-6091-45eb-8677-69ee7d29a82e)

