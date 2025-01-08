# CI/CD Pipeline Project with Jenkins

## Project Overview
This project demonstrates a complete CI/CD (Continuous Integration and Continuous Deployment) pipeline using Jenkins. It integrates various tools and processes to automate the application lifecycle, from versioning and building to deployment on a dynamically provisioned EC2 instance using docker-compose

## Features
- **Dynamic Application Versioning**: Automatically increment the application version.
- **Build and Package**: Compile and package the Java Maven application into a JAR file.
- **Docker Image Creation**: Build a Docker image for the application.
- **DockerHub Integration**: Push the Docker image to DockerHub.
- **Dynamic Infrastructure Provisioning**: Use Terraform to provision an EC2 instance dynamically.
- **Application Deployment**: Deploy the application on the EC2 instance using Docker Compose.
- **Git Integration**: Commit changes back to the Git repository.

## Pipeline Stages
1. **Increment Application Version**
   - Automatically update the application's version based on the current build.
2. **Build JAR File**
   - Compile the Java Maven application into a deployable JAR file.
3. **Build Docker Image**
   - Use the JAR file to create a Docker image of the application.
4. **Push Docker Image to DockerHub**
   - Authenticate with DockerHub and push the Docker image.
5. **Provision EC2 Instance with Terraform**
   - Dynamically create an EC2 instance using Terraform configuration files.
   - Retrieve the EC2 instance ID for deployment.
6. **Deploy Application on EC2 Instance**
   - Use Docker Compose to deploy the application on the provisioned EC2 instance.
7. **Commit Changes to Git**
   - Commit any configuration or versioning updates back to the Git repository.

## Prerequisites
- Jenkins installed and configured.
- A Java Maven application.
- Docker and DockerHub account.
- Terraform installed.
- AWS credentials for provisioning EC2 instances.
- Git installed and configured.

## Tools and Technologies
- **Jenkins**: Orchestrates the CI/CD pipeline.
- **Java (Maven)**: Used to build the application.
- **Docker**: Builds and runs containerized applications.
- **DockerHub**: Stores Docker images.
- **Terraform**: Manages infrastructure as code.
- **AWS EC2**: Hosts the deployed application.
- **Git**: Manages version control.

## Setup Instructions

### Step 1: Configure Jenkins
1. Install necessary Jenkins plugins:
   - Docker 
   - Terraform
2. Create a new Jenkins mutibranch pipeline job.
3. Credentials in Jenkins:
   - Create credentials in jenkins with aws credentials
   - Create credentials with the .pem key associated with the ec2 instance
   - create credentials for git registry
   - create credentials for dockerhub registry
   - 


### Step 3: Prepare AWS and Terraform
1. Install the AWS CLI and configure it with your AWS credentials.
   ```bash
   aws configure
   ```
2. Write Terraform configuration files to create the EC2 instance:
   - Create all infrastructure from scratch.
   - Create VPC, Subnet, internet gateway, route table , security group and ec2 instance
3. Store the Terraform files in the `terraform/` directory.

### Step 4: Configure Git Repository
1. Push the application code and `Jenkinsfile` to your Git repository.
2. Set up a webhook to trigger the Jenkins pipeline on code changes (optional).

### Step 5: Run the Pipeline
1. Trigger the Jenkins pipeline manually or through a webhook.
2. Monitor the execution of each stage:
   - Version increment.
   - Application build.
   - Docker image creation and push.
   - EC2 provisioning and deployment.
3. Verify the application is running on the provisioned EC2 instance.

## Repository Structure
```
├── Jenkinsfile                  # CI/CD pipeline definition
├── src/                         # Java Maven application source code
├── Dockerfile                   # build docker image from the application
├── docker-compose.yml           # Docker Compose file for deployment
├── terraform/                   # Terraform configuration files
├── README.md                    # Project documentation
```

## Detailed Steps

### 1. Increment Application Version
- A script in the pipeline updates the `pom.xml` file to increment the application version.
- The updated `pom.xml` is committed back to the Git repository.

### 2. Build JAR File
- The `mvn clean package` command compiles the source code and creates a JAR file.
- The generated JAR file is stored in the `target/` directory.

### 3. Build Docker Image
- The Dockerfile is used to create a Docker image.
- The image is tagged with the updated application version.

### 4. Push Docker Image to DockerHub
- Jenkins authenticates with DockerHub using stored credentials.
- The tagged Docker image is pushed to the DockerHub repository.

### 5. Provision EC2 Instance with Terraform
- Jenkins runs Terraform commands to provision an EC2 instance:
   ```bash
   terraform init
   terraform apply -auto-approve
   ```
- The instance ID and public IP are captured for deployment.

### 6. Deploy Application on EC2 Instance
- The Docker Compose file is used to deploy the Docker container on the EC2 instance.
- SSH is used to connect to the EC2 instance and execute Docker Compose commands.

### 7. Commit Changes to Git
- Any changes, such as the updated `pom.xml` file, are committed back to the repository.



