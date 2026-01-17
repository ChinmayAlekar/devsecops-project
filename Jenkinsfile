pipeline {
    agent any
    
    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
        TF_IN_AUTOMATION = 'true'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo "========== Stage 1: Checking Workspace =========="
                sh '''
                    echo "Workspace: ${WORKSPACE}"
                    pwd
                    echo "Current directory: $(pwd)"
                    echo ""
                    echo "Files in workspace:"
                    ls -la
                    echo ""
                    echo "Files in terraform directory:"
                    ls -la terraform/
                '''
            }
        }
        
        stage('Trivy Security Scan') {
            steps {
                echo "========== Stage 2: Running Trivy Security Scan =========="
                script {
                    sh '''
                        echo "Running Trivy scan on terraform/"
                        trivy config --severity HIGH,CRITICAL --exit-code 1 --format table terraform/
                    '''
                    echo "✅ No critical vulnerabilities found!"
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                echo "========== Stage 3: Running Terraform Plan =========="
                dir('terraform') {
                    sh '''
                        echo "Initializing Terraform..."
                        terraform init -input=false
                        
                        echo "Validating Terraform configuration..."
                        terraform validate
                        
                        echo "Running Terraform plan..."
                        terraform plan -out=tfplan
                        
                        echo "✅ Terraform plan completed successfully!"
                    '''
                }
            }
        }
        
        stage('Approval') {
            steps {
                echo "========== Stage 4: Waiting for Approval =========="
                script {
                    def userInput = input(
                        id: 'Proceed',
                        message: 'Deploy infrastructure to AWS?',
                        parameters: [
                            choice(
                                choices: ['Deploy', 'Abort'],
                                description: 'Proceed with Terraform Apply?',
                                name: 'action'
                            )
                        ]
                    )
                    if (userInput == 'Abort') {
                        error('Deployment aborted by user')
                    }
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                echo "========== Stage 5: Deploying Infrastructure =========="
                dir('terraform') {
                    sh '''
                        echo "Applying Terraform plan..."
                        terraform apply -auto-approve tfplan
                        
                        echo ""
                        echo "=========================================="
                        echo "✅ Infrastructure Deployed Successfully!"
                        echo "=========================================="
                        echo ""
                        
                        terraform output
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo "========== Pipeline Execution Complete =========="
            echo "✅ BUILD SUCCESSFUL: All stages passed!"
        }
        failure {
            echo "========== Pipeline Execution Failed =========="
            echo "❌ BUILD FAILED: Check logs above"
        }
    }
}

