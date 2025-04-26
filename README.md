# Terraform Monorepo Example

This repository serves as an example of a **monorepo** structure built with **Terraform**. The goal is to demonstrate how to organize infrastructure and reusable code in a scalable and maintainable way using Terraform.

## Project Structure

The project is organized into the following main directories:

- `services/`: This directory contains all the services such as APIs, cron jobs, queues, etc. Each service is isolated and can be independently managed.
- `packages/`: This directory holds reusable code that can be shared across services, such as logging, authentication, utilities, etc.

## Setup and Running Locally

To run this project locally, follow these steps:

### Prerequisites

1. **Terraform** - Install Terraform on your machine: [Terraform Installation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
2. **Node.js** - Ensure you have Node.js installed (version 22 or higher recommended).
3. **AWS Credentials** - You need valid AWS credentials with sufficient permissions to manage the infrastructure.

### Steps to Run Locally

1. **Clone the repository**:

```sh
git clone https://github.com/syllomex/terraform-monorepo.git
cd terraform-monorepo
```

2. **Configure AWS credentials**:

- Create `.aws` directory in the root of your project and a `credentials` file inside it.

```sh
mkdir -p .aws
touch .aws/credentials
```

- In the credentials file, add the following content, replacing `[AWS_ACCESS_KEY_ID]` and `[AWS_SECRET_ACCESS_KEY]` with your actual AWS credentials

```ini
[default]
aws_access_key_id = [AWS_ACCESS_KEY_ID]
aws_secret_access_key = [AWS_SECRET_ACCESS_KEY]
```

3. **Install dependencies**: This project uses Yarn for dependency management. Run the following command to install the necessary dependencies:

```sh
yarn install
```

3. **Set up environment variables**: Copy the `.env.example` file to `.env` and update it with your own AWS credentials and Terraform backend configuration:

```sh
cp .env.example .env
```

4. **Run Terraform commands locally**:

- **Initialize Terraform**:

```sh
yarn tf:init
```

- **Apply Terraform plan**:

```sh
yarn tf:apply
```

## Configuring GitHub Actions

This repository includes a pre-configured GitHub Actions workflow for deploying your infrastructure using Terraform. The workflow is located in `.github/workflows/deploy.yml`.

### GitHub Secrets

For the deployment workflow to work, make sure to set the following GitHub secrets in your repository:

- `AWS_ACCESS_KEY_ID`: Your AWS access key ID.

- `AWS_SECRET_ACCESS_KEY`: Your AWS secret access key.

The following environment variables are used for configuring the Terraform backend:

- `TF_BACKEND_BUCKET`: The name of the S3 bucket for Terraform state storage.

- `TF_BACKEND_KEY`: The path to the Terraform state file within the S3 bucket.

- `TF_BACKEND_REGION`: The region of the S3 bucket.

### Sample .env configuration

```properties
AWS_SHARED_CREDENTIALS_FILE="./.aws/credentials"
TF_BACKEND_BUCKET="your-bucket"
TF_BACKEND_KEY="state/terraform.tfstate"
TF_BACKEND_REGION="sa-east-1"
```

Make sure to configure these variables correctly for your environment.

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE.md) file for details.
