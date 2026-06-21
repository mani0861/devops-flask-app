pipeline {
    agent any

    environment {
        IMAGE_NAME = "flask-app"
        IMAGE_TAG = "latest"
        FULL_IMAGE = "flask-app:latest"
    }

    stages {

        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Verify Workspace') {
            steps {
                sh '''
                echo "Workspace Details:"
                pwd
                ls -la
                '''
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

                echo "Running basic import test..."
                ./venv/bin/python -c "import flask; print('Flask OK')"
                '''
            }
        }

        stage('Validate Dockerfile') {
            steps {
                sh '''
                set -e

                echo "Checking Dockerfile for merge conflicts..."

                if grep -q "<<<<<<<" Dockerfile; then
                    echo "ERROR: Merge conflict found in Dockerfile"
                    exit 1
                fi

                echo "Dockerfile is clean"
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                set -e

                echo "Fixing Docker env (avoid minikube TLS issue)"
                unset DOCKER_TLS_VERIFY || true
                unset DOCKER_HOST || true
                unset DOCKER_CERT_PATH || true

                echo "Building Docker image..."
                docker build -t flask-app:latest .

                echo "Docker images:"
                docker images | grep flask-app || true
                '''
            }
        }

        stage('Deploy to K8s') {
            steps {
                sh '''
                set -e

                echo "Deploying to Kubernetes using local kubeconfig..."

                export KUBECONFIG=/home/manish/.kube/config

                kubectl version --client
                kubectl get nodes

                kubectl apply -f deployment.yaml -n default
                kubectl apply -f service.yaml -n default

                echo "Deployment status:"
                kubectl get pods -n default
                kubectl get svc -n default
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline SUCCESS ✅"
        }

        failure {
            echo "Pipeline FAILED ❌ - check logs"
        }

        always {
            cleanWs()
        }
    }
}
