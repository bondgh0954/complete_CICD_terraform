# CI/CD Pipeline Project with Jenkins

## Project Overview
This project demonstrates a complete CI/CD (Continuous Integration and Continuous Deployment) pipeline using Jenkins. It integrates various tools and processes to automate the application lifecycle, from versioning and building to deployment on a dynamically provisioned EC2 instance.

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
   - Git
   - Docker Pipeline
   - Terraform
2. Create a new Jenkins pipeline.
3. Use the pipeline script provided in the `Jenkinsfile` from this repository.

### Step 2: Set Up DockerHub
1. Create a DockerHub account if you don’t have one.
2. Generate an access token in DockerHub.
3. Configure Jenkins with the DockerHub credentials.

### Step 3: Prepare AWS and Terraform
1. Install the AWS CLI and configure it with your AWS credentials.
   ```bash
   aws configure
   ```
2. Write Terraform configuration files to define the EC2 instance:
   - Instance type, AMI, and security groups.
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
├── Dockerfile                   # Docker image definition
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

## Example Commands

### Build Application Locally
```bash
mvn clean package
```

### Run Docker Container Locally
```bash
docker build -t my-app .
docker run -p 8080:8080 my-app
```

### Apply Terraform Configuration
```bash
cd terraform
terraform init
terraform apply
```

## License
This project is licensed under the MIT License. See the LICENSE file for details.

## Contributing
Contributions are welcome! Feel free to submit issues or pull requests.

## Contact
For any inquiries, reach out via [your_email@example.com].
