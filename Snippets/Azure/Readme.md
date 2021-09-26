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


Pipeline
**Package or folder**
$(System.DefaultWorkingDirectory)/**/**/*.zip
