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

                echo "⚠️ NOT using minikube docker-env (fixing TLS issue)"

                unset DOCKER_TLS_VERIFY
                unset DOCKER_HOST
                unset DOCKER_CERT_PATH

                echo "Building Docker image..."
                docker build -t flask-app:latest .

                echo "Images:"
                docker images | grep flask-app || true
                '''
            }
        }

        stage('Deploy to K8s') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh '''
                    set -e

                    echo "Checking cluster..."
                    kubectl get nodes

                    echo "Deploying..."
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml

                    echo "Status:"
                    kubectl get pods
                    kubectl get svc
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline SUCCESS ✅"
        }

        failure {
            echo "Pipeline FAILED ❌"
        }

        always {
            cleanWs()
        }
    }
}
