pipeline {
    environment {
    imagename = "pskaletskyy/jenkins-docker"
    registryCredential = 'DockerHub'
    dockerImage = "pskaletskyy/jenkins-docker:latest"
    }
    
    agent any
    
    stages {
        stage('Cloning Git') {
            steps {
                git (branch: 'main', 
                url: 'git@github.com:petroskaletskyy/jenkins-doker.git',
                credentialsId: 'petroskaletskyy-GitHub-key')
            }
        }
        stage ('Build Docker image') {
            steps {
                script {
                    dockerImage = docker.build imagename
                }
            }
        }
        stage ('Push Docker image to DockerHub') {
            steps {
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                    }    
                }
            }
        }
        stage ('Deploy to remote host') {
            steps {
                script {
                    sshPublisher(publishers: [sshPublisherDesc(configName: 'web-srv', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '''if [ "$(docker ps -q -f name=jenkins-docker)" ]; then
                    # cleanup
                    docker rm -f $(docker ps -aq -f name=jenkins-docker)
                    # run your container
                    docker run -d --name jenkins-docker -p 8081:80 pskaletskyy/jenkins-docker
                    fi''', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
                }    
            }
        }
    }
}    
