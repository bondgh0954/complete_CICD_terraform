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
        stage('deploy App'){
            steps{
                script{
                    echo 'deploying application into AWS server.....'
                    def dockerCmd = "bash ./my_script.sh ${IMAGE}"
                    sshagent(['key']) {
                        sh 'scp docker-compose.yaml ec2-user@3.120.132.115:/home/ec2-user'
                        sh 'scp my_script.sh ec2-user@3.120.132.115:/home/ec2-user'
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@3.120.132.115 ${dockerCmd}"
    
                    }

                }
            }
        }

        stage('commit version changes'){
            steps{
                script{
                    echo 'pushing updated app version into git repo.....'
                    withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'USER', passwordVariable: 'PASS')]){

                        sh "git remote set-url origin https://${USER}:${PASS}@github.com/bondgh0954/CI-CD_jenkins.git "
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