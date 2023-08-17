pipeline {
    agent any
    environment {
        //be sure to replace "bhavukm" with your own Docker Hub username
        DOCKER_IMAGE_NAME = "balacse530/train-schedule"
		DOCKERHUB_CREDENTIALS = credentials('Balacse530')
  
    }
    stages {
        stage('Build') {
            steps {
                echo 'Running build automation'
                sh './gradlew build --no-daemon'
                //archiveArtifacts artifacts: 'dist/*.*'
            }
        }
        stage('Build Docker Image') {
            
            steps {
                script {
                    app = docker.build(DOCKER_IMAGE_NAME)
                    app.inside {
                        sh 'echo Hello, World!'
                    }
                }
            }
        }
		stage('Login') {
		  steps {
		   sh 'docker login -u balacse530 -p dckr_pat_vUlIRdWsxJRK0N_BYYBOebVAZ9Y'
		  }
		}
        stage('Push Docker Image') {
            
            steps {
                script {
                    //docker.withRegistry('https://registry.hub.docker.com', 'Balacse530') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    //}
                }
            }
        }
        stage('CanaryDeploy') {
            
            environment { 
                CANARY_REPLICAS = 1
            }
            steps {
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    configs: 'train-schedule-kube-canary.yml',
                    enableConfigSubstitution: true
                )
            }
        }
        stage('DeployToProduction') {
            
            environment { 
                CANARY_REPLICAS = 0
            }
           steps {
                input 'Deploy to Production?'
                milestone(1)
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    configs: 'train-schedule-kube.yml',
                    enableConfigSubstitution: true
                )
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    configs: 'train-schedule-kube-canary.yml',
                    enableConfigSubstitution: true
                )
            }
      }
        }
    }
}
