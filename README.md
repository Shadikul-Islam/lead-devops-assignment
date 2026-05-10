# <p align=center>Gitops Fluxcd Project  <br> <br> </p> 

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