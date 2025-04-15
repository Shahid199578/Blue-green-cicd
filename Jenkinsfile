pipeline {
    agent any
    tools {
        maven 'Maven-Tool'
    }
    environment {
        IMAGE = "shahid199578/demoapp"
        VERSION = "v1"
        AWS_REGION = "ap-south-1"
        CLUSTER_NAME = "demoapp-cluster"
    }

    stages {
        stage('Checkout'){
            steps {
                git 'https://github.com/Shahid199578/Blue-green-cicd.git'
            }
        }
        stage('Compile'){
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Run Test'){
            steps {
                sh 'mvn test'
            }
        }
        stage('Code Scan with SonarQube'){
            steps {
                script {
                    withSonarQubeEnv('SonarQube') {
                        sh "mvn sonar:sonar -Dsonar.projectKey=demoapp"
                    }
                }
            }
        }
        stage('Trivy File Scan'){
            steps {
                sh 'trivy fs . > trivy-report.txt || true'
            }
        }
        stage('Build Docker Image'){
            steps {
                sh "docker build -t ${IMAGE}:${VERSION} ."
            }

        }
        stage('Trivy image Scan'){
            steps {
                sh 'trivy image $IMAGE:$VERSION > trivy-image.txt || true'
            }
        }
        stage('Push Docker Image'){
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh """
                    echo $PASS | docker login -u $USER --password-stdin"
                    docker push $IMAGE:$VERSION
                    """
                }
            }
        }
        stage('Deploy to EKS'){
            steps {
                sh """
                aws eks --region $AWS_REGION update-kubeconfig --name $CLUSTER_NAME
                sed 's|dockerimage|${IMAGE}:${VERSION}|' k8s/green-deployment.yaml | kubectl apply -f -
                """
            }
        }
        stage('Swithc Traffic to Green') {
            steps {
                sh "kubcectl patch svc demoapp-service -p '{\"spec\":{\"selector\":{\"app\":\"demoapp\",\"version\":\"green\"}}}'"
            }
        }


    }

}