# <p align=center>Cloud-Native DevOps Pipeline for Node.js on EKS using Terraform, Helm & GitHub Actions  <br> <br> </p> 

### Table of Contents

| **SL** | **Topic** |
| --- | --- |
| 01 | [Project Overview and Requirements](#01) |
| 02 | [Introduction](#02) |
| 03 | [Tools and Technologies Used](#03) |
| 04 | [Project Structure](#04) |
| 05 | [Setup and Deployment Process](#05)  |
| 06 | [Conclusion](#06)  |

<br>

### <a name="01">Project Overview and Requirements</a>

**Objective**

Design and implement a production-ready infrastructure and deployment pipeline for the provided Node.js application (with Dockerfile) on a managed Kubernetes platform. You can choose Amazon EKS, Azure AKS, or Google GKE.

**Codebase**

To begin this assignment, please download the minimal Node.js application. You will find the necessary files attached to the email containing these instructions. The application folder contains:
nodejs-app/
├──index.js
├──package.json
└──Dockerfile
This application exposes a simple REST API and can be containerized using the provided Dockerfile.

**Task Details**

- Provision the necessary cloud infrastructure using Terraform. This includes networking, the Kubernetes cluster, and IAM/role permissions.
- Create Kubernetes manifests or Helm charts to deploy the Node.js application on the chosen Kubernetes cluster.
- Apply Kubernetes best practices, such as readiness/liveness probes, resource requests/limits, and secure secret management.
- Write a `README.md` file detailing the architecture, assumptions, and setup instructions.

**Deliverables**
- Terraform code for provisioning the cloud infrastructure and the managed Kubernetes cluster, along with the Terraform plan output.
- Kubernetes manifests or Helm charts for deploying the Node.js application.
- CI/CD pipeline configuration (YAML/Jenkinsfile) to automate the build, test, and deployment process to the
Kubernetes cluster.
- A `README.md` file including an architecture overview, key assumptions, and step-by-step deployment
instructions.

### <a name="02">Introduction</a>

This project implements a production-ready cloud-native deployment pipeline for a Node.js application using Infrastructure as Code (IaC), Kubernetes, and CI/CD automation. The focus is on building a scalable, secure, and fully automated delivery workflow using modern DevOps practices.

The infrastructure is provisioned on AWS using Terraform in a modular approach. It includes VPC networking, an Amazon EKS managed Kubernetes cluster, Amazon ECR for container images, and IAM roles integrated with GitHub OIDC for secure authentication without static credentials.

The application is containerized using Docker and deployed to Kubernetes using Helm charts, following best practices such as health probes, resource limits, and scalable replicas for production readiness.

A CI/CD pipeline is implemented using GitHub Actions for both application and infrastructure workflows. Infrastructure changes follow a pull request-based model where Terraform runs a plan on PR creation, and apply is executed automatically after merge, ensuring controlled and auditable infrastructure changes. Application delivery is also automated through build, image push to ECR, and deployment to EKS.

Overall, this project demonstrates a real-world DevOps architecture focused on automation, security, and operational efficiency using industry-standard cloud-native tools.


### <a name="03">Tools & Technologies Used</a>

**Cloud Platform**
- Amazon Web Services (AWS)

**Infrastructure as Code**
- Terraform
- Terraform Modules (VPC, EKS, ECR, IAM, GitHub OIDC)
- Remote state management (S3 + DynamoDB)

**Containerization**
- Docker

**Container Registry**
- Amazon ECR (Elastic Container Registry)

**Container Orchestration**
- Amazon EKS (Elastic Kubernetes Service)

**Kubernetes Packaging**
- Helm

**CI/CD**
- GitHub Actions
- GitHub OIDC (for AWS authentication)
- Pull Request based Terraform workflow

**Version Control**
- Git
- GitHub

**Application Stack**
- Node.js
- npm

**Networking & Security**
- AWS VPC (Subnets, Route Tables, Internet Gateway, NAT Gateway)
- IAM Roles & Policies
- Kubernetes RBAC
- aws-auth ConfigMap (EKS access management)

### <a name="04">Project Structure</a>



### <a name="04">Setup and Deployment Process</a>

**AWS EC2 Bastion Server Setup**

A dedicated AWS EC2 instance is configured as a bastion host to securely access and manage resources within the private network. It provides controlled administrative access to the DevOps infrastructure while keeping internal components isolated from direct public exposure.

## EC2 Instance Configuration

| Setting        | Recommendation          |
|----------------|------------------------|
| AMI            | Ubuntu 24.04           |
| Instance Type  | t3.small               |
| Storage        | 30 GB gp3              |
| Elastic IP     | Enabled (recommended)  |
| Security Group | SSH only (port 22)     |
| SSH Access     | Restricted to My IP    |
| IAM Role       | AdministratorAccess    |


**System Update & Base Utilities**

```sudo apt update && sudo apt upgrade -y```

```sudo apt install -y git curl unzip zip jq```

**Docker Installation**

```sudo apt install -y docker.io```

```sudo systemctl enable docker```

```sudo systemctl start docker```

```sudo usermod -aG docker ubuntu```

**AWS CLI Installation**

```curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"```

```unzip awscliv2.zip```

```sudo ./aws/install```

```aws --version```

**kubectl Installation**

```curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"```

```chmod +x kubectl```

```sudo mv kubectl /usr/local/bin/```

```kubectl version --client```

**Helm Installation**

```curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash```

```helm version```

**Terraform Installation**

```wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg```

```echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list```

```sudo apt update && sudo apt install terraform```

```terraform version```

**Clone Application & Run Locally**

```git clone MY_GITHUB_REPO```

```cd project-name && cd app```

```docker build -t nodejs-app .```

```docker run -p 3000:3000 nodejs-app```

```curl localhost:3000```

```curl localhost:3000/health```

Image_1

**Assign IAM Role to EC2 (Administrator Access)**

To allow Terraform and AWS CLI operations, attach an IAM role with administrative access to the EC2 instance.

Steps:

- Go to EC2 → Instances → Select instance
- Click Actions → Security → Modify IAM role
- Attach role with AdministratorAccess

**Verify AWS Access**

``aws sts get-caller-identity```

```json
{
    "UserId": "AROA2WTZMQNUOOYEKLRPU:i-06862e6*****b3dc5",
    "Account": "7357*****904",
    "Arn": "arn:aws:sts::7357*****904:assumed-role/terraform-administrator-access/i-06862e6*****b3dc5"
}
```

**Create S3 Bucket for Terraform State**

```aws s3 mb s3://shadikul-terraform-state-001 --region ap-south-1```

**Create DynamoDB Table for State Locking**

```bash
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ap-south-1
```

**Verify DynamoDB Table Status**

```bash
aws dynamodb describe-table \
  --table-name terraform-state-lock \
  --region ap-south-1
```

Image_2

**Configure Terraform Backend**

Update the `backend.tf` file to enable:

- S3 bucket for remote Terraform state storage
- DynamoDB table for state locking and consistency

**Initialize Terraform**

```cd /home/ubuntu/dev/terraform/environments/prod```

```terraform init```

**Terraform Plan**

```terraform plan -out=tfplan```

**Terraform Apply**
```terraform apply tfplan```

**Verify EKS Worker Nodes**

```bash
aws ec2 describe-instances \
  --region ap-south-1 \
  --filters "Name=tag:eks:nodegroup-name,Values=nodejs-eks-workers" \
  --query "Reservations[*].Instances[*].[InstanceId,State.Name,PrivateIpAddress]" \
  --output table
```

**Check EKS Node Group Status**

```bash
aws eks describe-nodegroup \
  --cluster-name nodejs-eks-prod \
  --nodegroup-name nodejs-eks-workers \
  --region ap-south-1 \
  --query "nodegroup.status"
```

**Configure Kubernetes Access**

```bash
aws eks update-kubeconfig \
  --region ap-south-1 \
  --name nodejs-eks-prod
```

**Verify Kubernetes Nodes**

```kubectl get nodes```

**Login to Amazon ECR**

```bash
aws ecr get-login-password --region ap-south-1 \
| docker login --username AWS --password-stdin 735767724904.dkr.ecr.ap-south-1.amazonaws.com
```

**Build and Push Docker Image to ECR**

```bash
cd ~/dev/app

docker build --no-cache -t nodejs-app .

docker tag nodejs-app:latest \
735767724904.dkr.ecr.ap-south-1.amazonaws.com/nodejs-app:v1

docker push 735767724904.dkr.ecr.ap-south-1.amazonaws.com/nodejs-app:v1
```

**Deploy Application Using Helm**

```bash
cd ~/dev/helm/nodejs-app

helm upgrade --install nodejs-app .
```

Image_3


















