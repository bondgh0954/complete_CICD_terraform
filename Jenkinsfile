pipeline {

    agent any

    tools {
        maven 'maven'
    }
    environment{
        IMAGE = "nanaot/java-app:$IMAGE_VERSION"
    }

    stages{

        stage('version increment'){
            steps{
                script{
                    echo 'incrementing application version dynamically.....'
                    sh 'mvn build-helper:parse-version versions:set \
                       -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                       versions:commit'
                    def getversion = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def newversion = getversion[0][1]
                    env.IMAGE_VERSION = "$newversion-$BUILD_NUMBER"
                }
            }
        }
        stage('build jar'){
            steps{
                script{
                    echo 'packaging application into a jar file.....'
                    sh 'mvn clean package'
                }
            }
        }

        stage('build image'){
            steps{
                script{
                    echo 'building application into docker image....'
                    sh "docker build -t nanaot/java-app:${IMAGE_VERSION} ."
                }
            }
        }

        stage('pushing image'){
            steps{
                script{
                    echo 'pushing image into private docker registry...'
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'USER', passwordVariable: 'PASS')]){
                        sh "echo ${PASS} | docker login -u ${USER} --password-stdin"
                        sh "docker push nanaot/java-app:${IMAGE_VERSION}"
                    }
                }
            }
        }

        stage("provision ec2 instance") {
            environment {
                AWS_ACCESS_KEY_ID = credentials("aws_access_key_id")
                AWS_SECRET_ACCESS_KEY = credentials("aws_secret_access_key")
            }
            steps{
                script{
                    echo 'provision instance with terraform dynamically'
                    dir('terraform'){
                        sh 'terraform init'
                        sh 'terraform apply --auto-approve'
                        EC2_PUBLIC_IP = sh(
                            script: "terraform output instance_id",
                            returnStdout: true   
                        ).trim()

                    }
                    
                    
                    
                }
            }
        }
        stage('deploy App'){
            environment {
                DOCKER_CRED = credentials("dockerhub-credentials")
            }
            steps{
                script{
                    echo "waiting for ec2 instance to initialize......"
                    sleep(time: 90, unit: "SECONDS")
                    echo "${EC2_PUBLIC_IP}"

                    echo 'deploying application into AWS server.....'
                    def dockerCmd = "bash ./my_script.sh ${IMAGE} ${DOCKER_CRED_USR} ${DOCKER_CRED_PSW}"
                    sshagent(['sshkey']) {
                        sh "scp -o StrictHostKeyChecking=no docker-compose.yaml ec2-user@${EC2_PUBLIC_IP}:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no my_script.sh ec2-user@${EC2_PUBLIC_IP}:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${EC2_PUBLIC_IP} ${dockerCmd}"
    
                    }

                }
            }
        }

        stage('commit version changes'){
            steps{
                script{
                    echo 'pushing updated app version into git repo.....'
                    withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'USER', passwordVariable: 'PASS')]){

                        sh "git remote set-url origin https://${USER}:${PASS}@github.com/bondgh0954/complete_CICD_terraform.git "
                        sh 'git config --global user.name "jenkins"'
                        sh 'git config --global user.email "jenkins@example.com"'

                        sh 'git add .'
                        sh 'git commit -m "commit changes"'
                        sh 'git push origin HEAD:main'
                    }
                }
            }
        }
    }
}