
#!/bin/bash

APP_NAME="webapp-challenge-945-sprint3"
RESOURCE_GROUP="rg-challenge-sprint3"
REPO="vinicius945/Challenge_Java_2025_Sprint3"
WORKFLOW_PATH=".github/workflows/deploy.yml"

# 1. Criar Service Principal
echo "🔐 Criando Service Principal..."
az ad sp create-for-rbac \
  --name "GitHub-Action-Deploy-Sprint3" \
  --role "Contributor" \
  --scopes "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Web/sites/$APP_NAME" \
  --sdk-auth > azure-credentials.json

# 2. Criar segredo no GitHub
echo "🔑 Adicionando segredo AZURE_CREDENTIALS ao GitHub..."
gh secret set AZURE_CREDENTIALS --repo "$REPO" < azure-credentials.json

# 3. Apagar o JSON local
rm azure-credentials.json

# 4. Criar o arquivo de workflow
echo "🛠️ Gerando workflow de deploy em $WORKFLOW_PATH..."
mkdir -p .github/workflows

cat > "$WORKFLOW_PATH" << 'EOF'
name: Build and Deploy to Azure Web App

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Java version
      uses: actions/setup-java@v4
      with:
        java-version: '21'
        distribution: 'temurin'

    - name: Build with Maven
      run: mvn clean install

    - name: Login to Azure
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    - name: Deploy to Azure Web App
      uses: azure/webapps-deploy@v3
      with:
        app-name: 'webapp-challenge-945-sprint3'
        package: '${{ github.workspace }}/target/*.jar'
EOF

# 5. Commit e push do workflow
echo "🚀 Fazendo commit e push do workflow..."
git add "$WORKFLOW_PATH"
git commit -m "✨ Add GitHub Actions workflow for Azure deploy"
git push origin main

echo "✅ Tudo pronto! O deploy será disparado automaticamente via GitHub Actions."
