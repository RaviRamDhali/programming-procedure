# GitHub Actions with React CI/CD



```
name: Development Pipeline REACT

on:
  push:
    branches: ["main"]
  workflow_dispatch:

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
  
env:
  ReactDir: ./WebApp/ClientApp/
  DotNetDir: ${{github.workspace}}/build/api/

jobs:
  build_react:
    name: Build React
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4
        
      - name: Make ENV file with variable substitution
        uses: SpicyPizza/create-envfile@v2.0
        with:
          envkey_REACT_APP_DEFAULTAUTH: fake
          envkey_REACT_APP_GENERATE_SOURCEMAP: false
          envkey_REACT_APP_APIURL: ${{ vars.APIURL_DEV }}
          envkey_REACT_APP_APPURL: ${{ vars.APPURL_DEV }}
          envkey_REACT_APP_APPENV: ${{ vars.APPENV_DEV }}
          envkey_REACT_APP_AZURE_WEBAPI_NAME: ${{ vars.AZURE_WEBAPI_NAME }}
          directory: ${{env.ReactDir}}
          file_name: .env

      - name: ENV file review
        run: cat ${{env.ReactDir}}/.env

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 22.x
          
      - name: Install Corepack and Yarn
        working-directory: ${{env.ReactDir}}
        run: | 
          corepack enable
          corepack use yarn@*
            
      - name: Build React Yarn Project
        working-directory: ${{env.ReactDir}}
        run: yarn build:prod

      - name: Upload artifact for deployment job
        uses: actions/upload-artifact@v4
        with:
          name: webreact
          path: ${{env.ReactDir}}/build/

  deployment_react:
    name: Deploy React
    runs-on: ubuntu-latest
    needs: build_react
    
    steps:
      - name: Download artifact from build job
        uses: actions/download-artifact@v4
        with:
          name: webreact
          path: ${{env.ReactDir}}/dist/

      - name: Deploy to Azure WebApp
        id: deploy-to-webapp
        uses: azure/webapps-deploy@v3
        with:
          app-name: ${{ env.AZURE_WEBAPP_NAME }}
          publish-profile: ${{ secrets.AZURE_WEBAPP_PUBLISH_PROFILE_SB2 }}

```
          package: ${{env.ReactDir}}/dist/
