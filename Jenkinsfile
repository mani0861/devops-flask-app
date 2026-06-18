pipeline {
    agent any

    stages {

        stage('Git Checkout') {
            steps {
                git 'https://github.com/YOUR-REPO.git'
            }
        }

        stage('Test') {
            steps {
                sh '''
                python3 -m venv venv
                . venv/bin/activate
                pip install -r requirements.txt
                echo "Testing done"
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                eval $(minikube docker-env)
                docker build -t flask-app:latest .
                '''
            }
        }

        stage('Deploy to K8s') {
            steps {
                sh '''
                kubectl apply -f deployment.yaml
                kubectl apply -f service.yaml
                '''
            }
        }
    }
}
