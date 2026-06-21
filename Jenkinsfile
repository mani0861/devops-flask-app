pipeline {
    agent any

    environment {
        IMAGE_NAME = "flask-app:latest"
        KUBECONFIG = "${WORKSPACE}/kubeconfig"
    }

    stages {

        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Test') {
            steps {
                sh '''
                set -e

                echo "Creating virtual environment..."
                python3 -m venv venv

                echo "Installing dependencies..."
                ./venv/bin/pip install --upgrade pip
                ./venv/bin/pip install -r requirements.txt

                echo "Running test..."
                ./venv/bin/python -c "import flask; print('Flask OK')"
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                set -e

                echo "Fixing docker environment..."
                unset DOCKER_TLS_VERIFY || true
                unset DOCKER_HOST || true
                unset DOCKER_CERT_PATH || true

                echo "Building Docker image..."
                docker build -t $IMAGE_NAME .

                docker images | grep flask-app || true
                '''
            }
        }

        stage('Deploy to K8s') {
            steps {
                sh '''
                set -e

                echo "Using kubeconfig from workspace..."

                export KUBECONFIG=$KUBECONFIG

                kubectl version --client
                kubectl get nodes

                echo "Deploying to Kubernetes..."
                kubectl apply -f deployment.yaml
                kubectl apply -f service.yaml
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline SUCCESS ✅"
        }
        failure {
            echo "Pipeline FAILED ❌ (check logs)"
        }
        always {
            cleanWs()
        }
    }
}
