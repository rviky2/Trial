# Azure Deployment Guide

This is a step-by-step guide to deploy your Django Question Paper Management System to Azure App Service with PostgreSQL and Azure Storage.

## Step 1: Create Azure Resources

### Create Resources in Azure Portal

1. **Resource Group**:
   - Create a new resource group (e.g., `qp-resource-group`)

2. **PostgreSQL Flexible Server**:
   - Create a new PostgreSQL Flexible Server
   - Name: `qp-postgres` (your choice)
   - Admin username: (your choice, e.g., `dbadmin`)
   - Password: (create a strong password)
   - Save these credentials

3. **Create a Database**:
   - Go to your PostgreSQL server
   - Create a new database (e.g., `qpdb`)

4. **Storage Account**:
   - Create a new Storage Account (must be globally unique)
   - Name: (your choice, e.g., `qpstorage`)
   - Performance: Standard
   - Redundancy: Locally redundant (LRS)

5. **Storage Container**:
   - Go to your Storage Account
   - Create a new container named `media`
   - Set public access level to "Blob"

6. **App Service Plan**:
   - Create a new App Service Plan
   - Name: (your choice, e.g., `qp-appplan`)
   - OS: Linux
   - Pricing plan: Basic B1 (minimum recommended)

7. **Web App**:
   - Create a new Web App
   - Name: (your choice, e.g., `sit-qp-management`)
   - Runtime stack: Python 3.9
   - Link to your App Service Plan

## Step 2: Configure App Settings

1. Go to your Web App
2. Navigate to "Settings" > "Configuration"
3. Add the following "Application settings":

```
SECRET_KEY=<your-secret-key>
DEBUG=False
ALLOWED_HOSTS=.azurewebsites.net
DB_NAME=qpdb
DB_USER=dbadmin@<server-name>
DB_PASSWORD=<your-db-password>
DB_HOST=<your-postgres-server>.postgres.database.azure.com
DB_PORT=5432
AZURE_STORAGE_CONNECTION_STRING=<your-connection-string>
AZURE_STORAGE_CONTAINER=media
AZURE_STORAGE_ACCOUNT_NAME=<your-storage-account-name>
DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_EMAIL=admin@example.com
DJANGO_SUPERUSER_PASSWORD=<admin-password>
```

4. In "General settings", set "Startup Command" to: `sh startup.sh`

## Step 3: Configure GitHub Repository

1. Push your code to GitHub
2. Set up GitHub Actions:
   - Go to your GitHub repository
   - Go to "Settings" > "Secrets and variables" > "Actions"
   - Add these secrets:
     - `SECRET_KEY`: Your Django secret key
     - `AZURE_WEBAPP_NAME`: Your Azure Web App name
     - `AZURE_WEBAPP_PUBLISH_PROFILE`: (paste your publish profile from Azure)

## Step 4: Get Publish Profile from Azure

1. Go to your Web App
2. Click "Get publish profile" button
3. Save the downloaded file
4. Open the file and copy the entire XML content
5. Paste it as the value for `AZURE_WEBAPP_PUBLISH_PROFILE` in GitHub secrets

## Step 5: Deploy

1. Commit and push your code to GitHub
2. Go to the "Actions" tab in your GitHub repository
3. Watch the deployment process
4. Once completed, your site will be available at `https://<your-app-name>.azurewebsites.net/qp/`

## Troubleshooting

- **Database Connection Issues**:
  - Make sure the firewall rules allow Azure services to access the database
  - Verify your connection string and format (especially username should be `username@servername`)

- **Static Files Not Appearing**:
  - Check that `collectstatic` ran successfully in GitHub Actions
  - Verify that whitenoise is properly configured

- **Media Files Upload Issues**:
  - Ensure the storage container exists and has proper permissions
  - Verify connection string and container name
  - Check that the storage account has proper CORS settings if needed

## Maintenance

To view logs, go to your Web App in Azure Portal:
- Navigate to "Monitoring" > "Log stream"

To connect to SSH console:
- Navigate to "Development Tools" > "SSH" 