# Node.js CI/CD Pipeline

This repository contains a containerized Node.js application integrated with a robust **GitHub Actions** CI/CD pipeline. The workflow enforces high code quality via SonarQube, security through ECR container scanning, and automated deployment to AWS ECS.

## Architecture Overview

The system follows a modern cloud-native deployment pattern:

1.  **Continuous Integration:** GitHub Actions executes unit tests and static analysis.
2.  **Security Layer:** Multi-stage scanning (Dependency audit + ECR Image scanning).
3.  **Continuous Deployment:** Validated Docker images are pushed to Amazon ECR and deployed to an ECS Cluster using a rolling update strategy.



---

## Prerequisites

Before running the pipeline, ensure you have the following configured:

### 1. Infrastructure
* **AWS Account:** An active account with an **ECS Cluster** and **ECR Repository** created.
* **SonarQube:** An instance (Cloud or Self-hosted) to receive scan results.
* **Gmail/SMTP:** An account with an "App Password" generated for email notifications.

### 2. GitHub Secrets
Navigate to `Settings > Secrets and variables > Actions` and add:
* `AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY`: IAM user with ECR/ECS permissions.
* `SONAR_TOKEN`: Your SonarQube analysis token.
* `SONAR_HOST_URL`: The URL of your Sonar instance.
* `MAIL_USERNAME`: Your email address.
* `MAIL_PASSWORD`: Your SMTP app password.

---

## Setup & Local Development

### 1. Clone the repository
```bash
git clone <repository-url>
cd <repository-folder>
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Run Locally
```bash
# Start the application
npm start

# Run unit tests
npm test
```

---

## Running the Pipeline End-to-End

The pipeline is fully automated and follows a strictly gated flow:

### Step 1: Feature Development
Create a new branch for your changes.
```bash
git checkout -b feature/your-update
```

### Step 2: Trigger Quality Checks
Push your branch or open a **Pull Request** to `main`. This triggers the **Quality & Security** job.
* If `npm test` or `npm audit` fails, the pipeline stops.
* Check the SonarQube dashboard for deep code analysis.

### Step 3: Deployment (The Main Merge)
Once the PR is merged into `main`:
1.  **Build:** A Docker image is built using the GitHub SHA as a unique tag.
2.  **ECR Scan:** The image is pushed to AWS. The pipeline **waits** for the AWS Inspector scan results.
3.  **Security Gate:** If any **CRITICAL** or **HIGH** vulnerabilities are found, the deployment is aborted to protect production.
4.  **Deploy:** If clear, the ECS service is updated with the new image.

### Step 4: Verification
* Check the **Actions** tab in GitHub to see the real-time progress.
* Once complete, you will receive an **Email Notification** detailing the status of every stage (Quality, Build, and Deploy).

---

## Security Policy
* **Fail-Fast:** We do not build images if unit tests fail.
* **Zero-Vulnerability Policy:** Deployment is automatically blocked if the container image contains high-risk vulnerabilities.
* **Environment Isolation:** Production credentials are never hardcoded and are managed exclusively via GitHub Secrets.
