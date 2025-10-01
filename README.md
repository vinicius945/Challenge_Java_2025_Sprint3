# Gestão de Frota - Challenge Java 2025 Sprint 

**Grupo:** LTAKN
* Enzo Prado Soddano — RM557937
* Lucas Resende Lima — RM556564
* Vinícius Prates Altafini — RM559183


---

## 📌 Descrição

Este projeto contém a terceira sprint do **Challenge 2025** da disciplina de Java Advanced. Consiste em uma aplicação de **Gestão de Frota** que permite gerenciar motos, pátios e usuários. A aplicação foi desenvolvida com foco em boas práticas, segurança e deploy automatizado na nuvem.

O projeto utiliza:
* Interface web com **Spring MVC + Thymeleaf**.
* CRUD completo para as principais entidades do sistema.
* Segurança com **Spring Security** para controle de acesso e autenticação.
* Persistência com **Spring Data JPA** conectado a um banco de dados **Azure SQL**.
* Migrations automatizadas com **Flyway** para controle de versão do schema do banco de dados.
* Deploy automatizado (CI/CD) com **GitHub Actions** para o **Azure App Service**.

----------


## 🛠️ Tecnologias

* **Java 21**
* **Spring Boot 3**
* Spring MVC + Thymeleaf
* Spring Data JPA
* Spring Security
* **Flyway**
* Maven
* **Azure SQL** (Banco de Dados em Nuvem)
* **Azure App Service** (Hospedagem em Nuvem)
* **GitHub Actions** (CI/CD)
* Bootstrap + CSS customizado
* Lombok

---

## ☁️ Deploy e Acesso em Nuvem

A aplicação está publicada no Azure e pode ser acessada através da seguinte URL:

**[webapp-challenge-945-sprint3.azurewebsites.net)**

O deploy é feito automaticamente a cada `push` para a branch `main` via GitHub Actions.

#### 👤 Usuários para Teste
* **Usuário:** `user`, **Senha:** `userpass` (Acesso padrão)
* **Usuário:** `admin`, **Senha:** `adminpass` (Acesso de administrador)

---

## ⚙️ Como Rodar Localmente

#### Pré-requisitos
* Java 21 (JDK)
* Maven 3.x
* IntelliJ IDEA ou outra IDE de sua preferência

#### Passos
1.  **Clone o repositório:**
    ```bash
    git clone [https://github.com/vinicius945/Challenge_Java_2025_Sprint3.git](https://github.com/vinicius945/Challenge_Java_2025_Sprint3.git)
    cd Challenge_Java_2025_Sprint3
    ```

2.  **Abra o projeto** na sua IDE e aguarde o Maven baixar as dependências.

3.  **Configure as Variáveis de Ambiente:**
    Esta aplicação é configurada para ler as credenciais do banco de dados a partir de variáveis de ambiente, para maior segurança. Configure as seguintes variáveis na sua "Run Configuration" do IntelliJ:

    * `SPRING_DATASOURCE_USERNAME`: `leticia@sqlserver-challenge-945-sprint3`
    * `SPRING_DATASOURCE_PASSWORD`: `AzureFest@2025`

4.  **Rode a Aplicação:**
    Execute a aplicação a partir da classe principal `com.fiap.gestaofrota.GestaoFrotaApplication`.

5.  **Acesse a Aplicação:**
    A aplicação ficará disponível localmente em: **http://localhost:8080**

---

## 🏗️ Infraestrutura como Código (IaC) e Deploy

A criação de todos os recursos no Azure e a configuração do deploy são feitas via linha de comando, conforme os requisitos da disciplina de DevOps.

#### Criação da Infraestrutura (Azure CLI)
O comando a seguir, executado no Cloud Shell, cria todos os recursos necessários (Grupo de Recursos, Servidor SQL, Banco, App Service, etc.):




```bash
RESOURCE_GROUP="rg-challenge-sprint3"; LOCATION="eastus2"; SQL_SERVER_NAME="sqlserver-challenge-945-sprint3"; SQL_DATABASE_NAME="sqlLTAKN"; ADMIN_USER="leticia"; ADMIN_PASSWORD="AzureFest@2025"; APPSERVICE_PLAN_NAME="plan-challenge-sprint3"; WEBAPP_NAME="webapp-challenge-945-sprint3"; JAVA_RUNTIME="JAVA:21-java21"; echo "Criando grupo de recursos..." && az group create --name $RESOURCE_GROUP --location $LOCATION && echo "Criando servidor SQL..." && az sql server create --name $SQL_SERVER_NAME --resource-group $RESOURCE_GROUP --location $LOCATION --admin-user $ADMIN_USER --admin-password $ADMIN_PASSWORD && echo "Configurando firewall do SQL..." && az sql server firewall-rule create --resource-group $RESOURCE_GROUP --server $SQL_SERVER_NAME --name AllowAzureServices --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0 && echo "Criando banco de dados..." && az sql db create --resource-group $RESOURCE_GROUP --server $SQL_SERVER_NAME --name $SQL_DATABASE_NAME --service-objective S0 && echo "Criando plano de serviço..." && az appservice plan create --name $APPSERVICE_PLAN_NAME --resource-group $RESOURCE_GROUP --sku B1 --is-linux && echo "Criando Web App..." && az webapp create --name $WEBAPP_NAME --resource-group $RESOURCE_GROUP --plan $APPSERVICE_PLAN_NAME --runtime $JAVA_RUNTIME && echo "🚀 Tudo pronto! Seus recursos foram criados em East US 2."

```

Crie as tabelas no banco de dados, a criação está no script.sql

Passo 2: Configuração das Variáveis de Ambiente no App Service
Após a criação da infraestrutura, execute este comando no Cloud Shell para injetar as credenciais do banco de dados de forma segura no App Service.

Bash

```bash

az webapp config appsettings set \
    --resource-group rg-challenge-sprint3 \
    --name webapp-challenge-945-sprint3 \
    --settings "SPRING_DATASOURCE_USERNAME=leticia@sqlserver-challenge-945-sprint3" "SPRING_DATASOURCE_PASSWORD=AzureFest@2025"

```    
Passo 3: Configuração e Ativação do Pipeline de CI/CD (Script Automatizado)
Este passo é executado a partir do terminal local, na pasta do projeto. Ele utiliza um script para automatizar a criação da identidade de serviço no Azure, a configuração do segredo no GitHub e a geração do arquivo de workflow para o deploy.

Pré-requisito: Você precisa ter o GitHub CLI instalado e autenticado (gh auth login).

Crie o script setup-deploy.sh:
Na raiz do seu projeto, crie um arquivo chamado setup-deploy.sh com o seguinte conteúdo:

```bash

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

```
Execute o script:

```bash

chmod +x setup-deploy.sh
./setup-deploy.sh

```

A partir deste ponto, o workflow de CI/CD estará configurado e o primeiro deploy será iniciado.


Depois teste o link:

### [Link do daaplicação em nuvem] webapp-challenge-945-sprint3.azurewebsites.net

A partir deste ponto, o workflow de CI/CD estará configurado e o primeiro deploy será iniciado.


###Arquitetura

# Arquitetura do Projeto

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/37aa7ebe-6ac2-4a7f-82a9-c2f0d8cb4c23" />


## 📸 Prints de tela

* Página inicial
  ![home](src/main/resources/static/prints/home.png)

* Formulário de Cadastro
  ![register](src/main/resources/static/prints/cadastro.png)

* Formulário de Login
![register](src/main/resources/static/prints/login.png)

* Listagem de Pátios
  ![patios-list](src/main/resources/static/prints/patios_list.png)

* Cadastro de Pátio
  ![patios-form](src/main/resources/static/prints/patios_form.png)

* Listagem de Motos
  ![patios-list](src/main/resources/static/prints/motos_list.png)

* Cadastro de Moto
  ![patios-form](src/main/resources/static/prints/motos_form.png)

---

## 📽️ Vídeo de demonstração

### [[[Link do vídeo](https://youtu.be/ckQmOTrJXrQ)](https://youtu.be/qjdKAtLK4q4)]

🔍 Solução de Problemas (Troubleshooting)
Caso o script setup-deploy.sh ou o deploy automático falhe por algum motivo (ex: GitHub CLI não instalado, problemas de permissão), a configuração de autenticação entre o GitHub e o Azure pode ser feita manualmente:

Gere as Credenciais no Cloud Shell:

Bash

```bash
az ad sp create-for-rbac --name "GitHub-Action-Deploy-Sprint3" --role "Contributor" --scopes "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/rg-challenge-sprint3/providers/Microsoft.Web/sites/webapp-challenge-945-sprint3" --sdk-auth

```
Configure o Segredo no GitHub:

Copie a saída JSON inteira do comando anterior.

No seu repositório GitHub, vá em Settings > Secrets and variables > Actions.

Crie um novo segredo com o nome AZURE_CREDENTIALS e cole o JSON como valor.

Remova segredos antigos (AZUREAPPSERVICE_...) para evitar conflitos.

Crie/Atualize o Arquivo de Workflow (.yml):

Garanta que seu arquivo .github/workflows/deploy.yml utilize este método de login, como mostrado no script setup-deploy.sh.
# Atualização forçada de deploy
# Atualização forçada de deploy
