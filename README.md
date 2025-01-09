# CI/CD Pipeline Project with Jenkins

## Project Overview
This project demonstrates a complete CI/CD (Continuous Integration and Continuous Deployment) pipeline using Jenkins. It integrates various tools and processes to automate the application lifecycle, from versioning and building to deployment on a dynamically provisioned EC2 instance using docker-compose

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
   - Create credentials with the key pair associated with the ec2 instance
   - create credentials for git registry
   - create credentials for dockerhub registry
   - 


### Step 2:Create Terraform configuration files

1. Write Terraform configuration files to create the EC2 instance:
   - Create all infrastructure from scratch.
   - Create VPC, Subnet, internet gateway, route table , security group and ec2 instance
3. Store the Terraform files in the `terraform/` directory.

### Step 3: Configure Git Repository
1. Push the application code and `Jenkinsfile` to your Git repository.
2. Set up a webhook to trigger the Jenkins pipeline on code changes (optional).

### Step 4: Run the Pipeline
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



