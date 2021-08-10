pipeline {
    
    agent any
    
    environment {
        dockerImage =''
        registry = 'abhilashnarayan/springboot-web-dockerimage'
        registryCredential = 'dockerhub-id'
    }
    
    stages {
        stage ('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Abhilash-1201/spring-boot-dockerize.git']]])
            }
        }
        
        stage ('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build registry
                }
            }
        }
        
        stage ('Uploading Image') {
            steps {
                script {
                    docker.withRegistry( '', registryCredential ) {
                    dockerImage.push()
                    }
                }
            }
        }
        
         // Stopping Docker containers for cleaner Docker run
        stage('docker stop container') {
            steps {
              sh 'docker ps -f name=spring-boot-docker -q | xargs --no-run-if-empty docker container stop'
              sh 'docker container ls -a -fname=springboot-web-dockerimage -q | xargs -r docker container rm'
            }
       } 
       
       // Running Docker container, make sure port 8096 is opened in 
        stage('Docker Run') {
            steps{
                script {
                    dockerImage.run("-p 9000:8080 --rm --name springboot-web-dockerimage")
                }
            }
        }
        stage ('Deploy to k8s') {
            steps {
                sshagent(['kops-machine']) {
                 sh 'scp -o StrictHostKeyChecking=no spring-kube-deploy.yml ubuntu@54.183.61.19:/home/ubuntu/'
                 script {
                     try{
                         sh 'ssh ubuntu@54.183.61.19 kubectl apply -f .'
                     }catch(error){
                         sh 'ssh ubuntu@54.183.61.19 kubectl create -f .'
                     }
                 }
                }
            }
        }
        
    }
}