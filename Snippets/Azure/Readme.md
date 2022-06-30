Azure Dev Ops Notes:

Dev Ops > Create Pipeline Notes:

New pipeline > Where is your code?
> Use the classic editor to create a pipeline without YAML
> Select a source (GitHub, etc.. ) 
> Select a template
> Select Azure Web App for ASP.NET [Build, package, test, and deploy an ASP.NET Azure Web App]

[%project%] / Settings / Service connections
To find Project Settings, 
> Click on project > at the very bottom of the left nav is the SETTINGS link
> Connect to Azure Service > web-app service ie sb1.domain.com

Azure Notes:

Home > Subscriptions > Microsoft Azure (xxxxxxxx) | Access control (IAM)
Make sure you have ROLE in the Subscription so you can attach it to Azure
All Service > Azure Active Directory > Users > New user

Select the Azure Active Directory service from Azure Portal
At the left sidebar, under the Manage section, choose Properties. 
Then in Directory Properties choose a new name

Azure Projects > Add User to Organization
Organization setting -> Policy to check if the Security policies >
Turn on "External Guest Access"

Azure DevOps Parallelism Request

https://forms.office.com/pages/responsepage.aspx?id=v4j5cvGGr0GRqy180BHbR63mUWPlq7NEsFZhkyH8jChUMlM3QzdDMFZOMkVBWU5BWFM3SDI2QlRBSC4u


Pipeline
**Package or folder**
$(System.DefaultWorkingDirectory)/**/**/*.zip
