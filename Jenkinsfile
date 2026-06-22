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
                echo "Creating venv..."
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
                echo "Building Docker image..."
                docker build -t flask-app:latest .
                docker images | grep flask-app
                '''
            }
        }

        stage('Deploy to K8s') {
            steps {
                sh '''
                set -e

                echo "Deploying to Kubernetes..."

                export KUBECONFIG=$WORKSPACE/kubeconfig

                kubectl version --client
                kubectl get nodes

                # optional deployment
                if [ -d "k8s" ]; then
                    kubectl apply -f k8s/
                else
                    echo "No k8s folder found, skipping deploy"
                fi
                '''
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
