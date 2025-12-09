# **Simple Time Service**

A minimalist microservice and infrastructure deployment challenge using **Docker**, **AWS ECS (Fargate)**, and **Terraform**.

---

## **Overview**
This repository contains two tasks:

- **Task 1:** Develop a simple web service that returns the current timestamp and client IP in JSON format, containerize it using Docker, and publish the image.
- **Task 2:** Provision AWS infrastructure using Terraform to host the containerized application behind a load balancer.

** You can refer to README.md files in app/ and terraform/ for each tasks
---

## **Repository Structure**
```
.
├── app/                # Application source code and Dockerfile
│   ├── Dockerfile
    |__ README.md
│   ├── requirements.txt
│   ├── .dockerignore
│   └── simple_time_service/
└── terraform/          # Terraform configuration for AWS ECS + ALB
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── provider.tf
    ├── terraform.tfvars
    └── README.md
```

---

## **Task 1: Minimalist Application Development & Docker**

### **Application Behavior**
- HTTP `GET /` returns:
```json
{
  "timestamp": "<current date and time>",
  "ip": "<client IP address>"
}
```

### **Build and Run Locally**
1. Navigate to the `app` directory:
   ```bash
   cd app
   ```
2. Build the Docker image:
   ```bash
   docker build -t simple-time-service:latest .
   ```
3. Run the container:
   ```bash
   docker run --rm -p 8080:8080 simple-time-service:latest
   ```
4. Test the service:
   ```bash
   curl -s http://localhost:8080/ | jq .
   ```
   Expected output:
   ```json
   {
     "timestamp": "2025-12-09T10:00:00Z",
     "ip": "172.17.0.1"
   }
   ```

### **Pull from Docker Hub**
```bash
docker pull harsha786docker/simple-time-service:1.0.1
```

---

## **Task 2: Terraform & AWS Infrastructure**

### **Infrastructure Components**
- **VPC** with 2 public and 2 private subnets.
- **Application Load Balancer (ALB)** in public subnets.
- **ECS Cluster (Fargate)** running the container in private subnets.
- **CloudWatch Logs** for ECS tasks.

### **Deploy Steps**
1. Navigate to the `terraform` directory:
   ```bash
   cd terraform
   ```
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Plan the deployment:
   ```bash
   terraform plan
   ```
4. Apply the deployment:
   ```bash
   terraform apply -auto-approve
   ```

### **Test the Service**
Retrieve the ALB URL:
```bash
terraform output -raw service_url
```
Example:
```
http://simple-time-alb-123456.ap-south-1.elb.amazonaws.com/
```

Test the endpoint:
```bash
curl -s $(terraform output -raw service_url) | jq .
```
Expected output:
```json
{
  "timestamp": "2025-12-09T10:05:00Z",
  "ip": "65.0.3.175"
}
```

---

## **Notes**
- The application runs as a **non-root user** inside the container.
- The Docker image is published on [Docker Hub](https://hub.docker.com/repository/docker/harsha786docker/simple-time-service).
- No credentials are committed to the repository. AWS authentication must be configured before running Terraform.
