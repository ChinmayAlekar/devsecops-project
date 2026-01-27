DevSecOps Terraform Security Scanning with Trivy
A comprehensive DevSecOps project demonstrating Infrastructure as Code (IaC) security scanning using Jenkins, Terraform, Trivy, and AWS EC2 deployment.

📋 Project Overview
This project implements a secure CI/CD pipeline for infrastructure deployment with automated security scanning. It provisions AWS infrastructure using Terraform while ensuring zero critical vulnerabilities through Trivy security scans.

🏗️ Architecture
text
Developer → GitHub → Jenkins Pipeline → Trivy Scan → Terraform Plan → Manual Approval → AWS EC2 Deployment
Components:

Jenkins: CI/CD automation server

Terraform: Infrastructure as Code (IaC) provisioning

Trivy: Security vulnerability scanner

AWS EC2: Cloud infrastructure

Docker: Containerization platform

Node.js: Sample application

🚀 Features
✅ Automated Trivy security scanning for Terraform configurations

✅ Zero-trust security with IP-restricted access

✅ Manual approval gate before infrastructure deployment

✅ Jenkins declarative pipeline with 5 stages

✅ Secure AWS EC2 instance provisioning

📁 Project Structure
text
devsecops-assignment/
├── app/
│   ├── server.js           # Node.js application
│   ├── package.json        # Node.js dependencies
│   └── Dockerfile          # Container image definition
├── terraform/
│   ├── main.tf            # AWS infrastructure configuration
│   ├── variables.tf       # Terraform variables
│   ├── outputs.tf         # Output values
│   └── .terraform/        # Terraform state files
├── jenkins/
│   └── Jenkinsfile        # CI/CD pipeline definition
├── docker-compose.yml     # Jenkins container setup
└── README.md              # This file
🛠️ Prerequisites
Docker & Docker Compose

AWS Account with credentials configured

GitHub account

SSH key pair for EC2 access

⚙️ Installation & Setup
1. Clone Repository

bash
git clone https://github.com/alekarchinmay/devsecops-assignment.git
cd devsecops-assignment
2. Launch Jenkins with Trivy

bash
# Start Jenkins container
docker-compose up -d

# Get initial admin password
docker exec jenkins-devsecops cat /var/jenkins_home/secrets/initialAdminPassword
Access Jenkins: http://localhost:8080

3. Configure Jenkins

Install required plugins:

Pipeline

Git

Docker Pipeline

AWS Credentials

Add AWS credentials:

Manage Jenkins → Credentials → Global

Add AWS Access Key ID and Secret Access Key

ID: aws-credentials

Create Pipeline:

New Item → Pipeline

Name: devsecops-terraform-scan

Pipeline from SCM → Git

Repository: https://github.com/alekarchinmay/devsecops-assignment.git

Script Path: jenkins/Jenkinsfile

4. AWS Infrastructure Setup

Create EC2 SSH key pair:

bash
aws ec2 create-key-pair \
  --key-name devsecops-app-key \
  --region ap-south-1 \
  --query 'KeyMaterial' \
  --output text > ~/devsecops-app-key.pem

chmod 400 ~/devsecops-app-key.pem
🔄 Pipeline Stages
Stage 1: Checkout

Validates workspace

Lists Terraform files

Displays repository structure

Stage 2: Trivy Security Scan

Scans Terraform configurations for HIGH/CRITICAL vulnerabilities

Fails pipeline if critical issues found

Generates security report

Stage 3: Terraform Plan

Initializes Terraform

Validates configuration

Creates execution plan

Outputs planned infrastructure changes

Stage 4: Manual Approval

Waits for user confirmation

Reviews plan before deployment

Approval required to proceed

Stage 5: Terraform Apply

Deploys AWS infrastructure:

EC2 instance (t3.micro)

🔒 Security Best Practices
Infrastructure Security:

✅ Zero-Trust Network: SSH/App access restricted to specific IP

✅ Security Groups: Minimal port exposure (22, 3000)

✅ No Hardcoded Secrets: AWS credentials via Jenkins

Terraform Configuration:

Encrypted root block device

Metadata hop limit = 1

Instance metadata tags enabled

Security group with IP whitelisting

Trivy Scanning:

bash
trivy config --severity HIGH,CRITICAL --exit-code 1 terraform/
📊 Deployed Infrastructure
EC2 Instance Specifications:

Type: t3.micro (2 vCPU, 1GB RAM)

OS: Amazon Linux 2023

Region: ap-south-1 (Mumbai)

Storage: 30GB gp3 encrypted

Security: Zero-trust IP restrictions

Deployment Outputs:

text
instance_id         = "i-046a36443cc9c0f2c"
instance_public_ip  = "13.234.31.165"
instance_public_dns = "ec2-13-234-31-165.ap-south-1.compute.amazonaws.com"
security_group_id   = "sg-0f0e8f2cd0247d5bf"
🖥️ Verifying Deployment
Access EC2 Instance via AWS Console:

Login to AWS Console

Navigate to EC2 → Instances

Region: Asia Pacific (Mumbai) ap-south-1

Verify instance "devsecops-assignment-server" is Running

Check Security Group:

EC2 → Security Groups

Find: "devsecops-assignment-sg"

Verify inbound rules:

Port 22 (SSH) from your IP

Port 3000 (App) from your IP

SSH to Instance (Optional):

bash
ssh -i ~/devsecops-app-key.pem ec2-user@13.234.31.165
📸 Project Deliverables
Jenkins Pipeline

✅ All 5 stages successfully completed

✅ Trivy scan showing zero critical vulnerabilities

✅ Manual approval gate implemented

✅ Infrastructure deployed successfully

AWS Resources

✅ EC2 instance provisioned and running

✅ Security group configured with IP restrictions

✅ Encrypted EBS volume attached

✅ IMDSv2 enforced for metadata access

🧪 Testing & Verification
Verify Trivy Installation:

bash
docker exec jenkins-devsecops trivy --version
Test Terraform Configuration:

bash
cd terraform
terraform init
terraform validate
terraform plan
Check Pipeline Execution:

Navigate to Jenkins Dashboard

Click on "devsecops-terraform-scan"

Verify all stages show green checkmarks

🔧 Troubleshooting
Issue: Trivy scan fails

bash
# Reinstall Trivy in Jenkins container
docker exec -it jenkins-devsecops bash
wget https://github.com/aquasecurity/trivy/releases/download/v0.48.0/trivy_0.48.0_Linux-64bit.tar.gz
tar -xzf trivy_0.48.0_Linux-64bit.tar.gz
mv trivy /usr/local/bin/
Issue: EC2 Instance Connect fails

Use local terminal SSH instead

Verify security group allows your IP

Check key permissions: chmod 400 key.pem

Issue: Terraform volume size error

AMI requires minimum 30GB

Update main.tf: volume_size = 30

Issue: Free tier instance type error

Change to t3.micro in variables.tf

Or use us-east-1 region for t2.micro

📝 Pipeline Execution Logs
text
✅ Stage 1: Checkout (311ms)
✅ Stage 2: Trivy Security Scan (1s)
   └─ No critical vulnerabilities found!
✅ Stage 3: Terraform Plan (7s)
   └─ Plan: 1 to add, 0 to change, 0 to destroy
✅ Stage 4: Approval (Manual - 94s)
✅ Stage 5: Terraform Apply (15s)
   └─ Infrastructure deployed successfully!
   └─ Instance ID: i-046a36443cc9c0f2c
   └─ Public IP: 13.234.31.165
🌟 Key Achievements
✅ Zero critical vulnerabilities in infrastructure code

✅ Automated security scanning integrated in CI/CD pipeline

✅ Secure infrastructure deployment with full encryption

✅ Manual approval gate for production changes

✅ Complete automation from code to cloud

✅ Infrastructure as Code best practices implemented

📚 Technologies Used
Technology	Version	Purpose
Jenkins	2.528.3	CI/CD Automation
Trivy	0.48.0	Security Scanning
Terraform	Latest	IaC Provisioning
Docker	Latest	Containerization
AWS EC2	t3.micro	Cloud Infrastructure
Node.js	18	Sample Application
🎯 Project Workflow
Code Commit: Push Terraform changes to GitHub

Jenkins Trigger: Webhook triggers pipeline execution

Security Scan: Trivy scans for vulnerabilities

Infrastructure Plan: Terraform generates execution plan

Manual Review: DevOps team reviews and approves

Deployment: Infrastructure provisioned on AWS

Verification: Instance validated on AWS Console

🤝 Contributing
Fork the repository

Create feature branch (git checkout -b feature/improvement)

Commit changes (git commit -am 'Add feature')

Push to branch (git push origin feature/improvement)

Create Pull Request

📄 License
This project is licensed under the MIT License.

👤 Author
Alekarchinmay

GitHub: @alekarchinmay

🙏 Acknowledgments
Aqua Security for Trivy

HashiCorp for Terraform

AWS for cloud infrastructure

Jenkins community
