pipeline {
    agent any
    
    environment {
        PROJECT_NAME = 'devsecops-assignment'
        TERRAFORM_DIR = 'terraform'
        TRIVY_SEVERITY = 'HIGH,CRITICAL'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '========== Stage 1: Checking out code from Git =========='
                checkout scm
                echo 'Code checkout successful!'
                
                sh '''
                    echo "Current directory: $(pwd)"
                    echo "Files in root:"
                    ls -la
                    echo "Files in terraform directory:"
                    ls -la ${TERRAFORM_DIR}/
                '''
            }
        }
        
        stage('Trivy Security Scan') {
            steps {
                echo '========== Stage 2: Running Trivy security scan =========='
                script {
                    def trivyExitCode = sh(
                        script: """
                            trivy config \
                                --severity ${TRIVY_SEVERITY} \
                                --exit-code 1 \
                                --format table \
                                ${TERRAFORM_DIR}/
                        """,
                        returnStatus: true
                    )
                    
                    if (trivyExitCode != 0) {
                        echo "⚠️  Trivy found security vulnerabilities!"
                        echo "Exit code: ${trivyExitCode}"
                        error("Security vulnerabilities detected. Build failed.")
                    } else {
                        echo "✅ No critical vulnerabilities found!"
                    }
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                echo '========== Stage 3: Running Terraform Plan =========='
                dir("${TERRAFORM_DIR}") {
                    sh '''
                        echo "Initializing Terraform..."
                        terraform init -input=false
                        
                        echo "Validating Terraform configuration..."
                        terraform validate
                        
                        echo "Formatting Terraform files..."
                        terraform fmt -check
                        
                        echo "Running Terraform plan..."
                        terraform plan -out=tfplan
                        
                        echo "✅ Terraform plan completed successfully!"
                    '''
                }
            }
        }
    }
    
    post {
        always {
            echo '========== Pipeline Execution Complete =========='
            cleanWs()
        }
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed! Check logs above for details.'
        }
    }
}

