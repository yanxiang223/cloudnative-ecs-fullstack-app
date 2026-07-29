# Cloud Native Fullstack App - CCE Container Deployment & DevOps Practices

[![License: MIT-0](https://img.shields.io/badge/License-MIT--0-green.svg)](https://github.com/hsahbi/nolicense-mit-0)
[![Huawei Cloud](https://img.shields.io/badge/HuaweiCloud-Solutions-blue.svg)](https://github.com/huaweicloud-samples)
[![Incubating](https://img.shields.io/badge/status-incubating-orange.svg)](https://github.com/huaweicloud-samples)

---

## Introduction

Deploy a fullstack application using Huawei Cloud CCE (Cloud Container Engine) with CodeArts DevOps pipeline. Demonstrates infrastructure management with Terraform, CI/CD with CodeArts Pipeline, and containerized deployment with auto-scaling on CCE.

---

## Table of Contents

- [Introduction](#introduction)
- [Architecture](#architecture)
- [Highlights](#highlights)
- [Cloud Services & Costs](#cloud-services--costs)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Step-by-Step Deployment](#step-by-step-deployment)
- [Usage / Verification](#usage--verification)
- [Cleanup](#cleanup)
- [Details](#details)
- [FAQ / Troubleshooting](#faq--troubleshooting)
- [Contributing](#contributing)
- [License](#license)
- [Contact / Maintainers](#contact--maintainers)

---

## Architecture


**Infrastructure:**
- VPC network (HA design, multi-AZ)
- CCE cluster + 2 workloads (frontend/backend)
- ELB (public application load balancer)
- OBS buckets (static assets + pipeline artifacts)
- GaussDB NoSQL (application data store)
- SMN topic (deployment notifications)

**CI/CD:**
- CodeArts Repo (source code hosting)
- CodeArts Build (build)
- CodeArts Deploy (deployment, blue-green release)

---

## Highlights

- **Infrastructure as Code**: Terraform manages all Huawei Cloud resources, one-click deploy/destroy
- **Blue-Green Deployment**: CodeArts Deploy enables zero-downtime releases
- **Auto Scaling**: CCE workloads auto-scale based on CPU/memory metrics
- **Full-Stack DevOps**: Automated pipeline from code to build to deploy
- **Multi-Language App**: Vue.js frontend + Node.js backend

---

## Cloud Services & Costs

| Huawei Cloud Service | Purpose | Billing |
|----------------------|---------|---------|
| CCE | Container cluster & workloads | On-demand / Monthly |
| ELB | Application load balancing | On-demand |
| VPC | Network isolation | Free (NAT gateway on-demand) |
| EVS | Cloud disks (CCE node storage) | On-demand |
| OBS | Static assets & artifact storage | On-demand |
| GaussDB NoSQL | Application data store | On-demand / Monthly |
| SMN | Deployment notifications | On-demand |
| CodeArts | CI/CD pipeline | Free tier + On-demand |
| IAM | Permission management | Free |
| CES | Cloud monitoring & alarms | Free |

> **Cost Notice:** This sample will incur Huawei Cloud resource charges. Please clean up resources after use to avoid ongoing costs.
>
> **Cleanup Notice:** See the [Cleanup](#cleanup) section.

---

## Prerequisites

| Item | Requirement |
|------|-------------|
| Huawei Cloud Account | Registered with real-name authentication |
| AK/SK | Access keys obtained: [My Credentials](https://console.huaweicloud.com/iam/#/myCredential) |
| Terraform | >= 1.0 |
| Huawei Cloud CLI | hcloud latest version |
| kubectl | Matching CCE cluster version |
| Docker | Docker Desktop |
| Node.js | >= 18.x |
| Git | >= 2.x |

---

## Quick Start

```bash
git clone https://github.com/huaweicloud-samples/cloudnative-ecs-fullstack-app.git
cd cloudnative-ecs-fullstack-app/deploy/terraform
terraform init && terraform apply -auto-approve
```

---

## Step-by-Step Deployment

### Step 1: Configure Authentication

```bash
export HUAWEICLOUD_SDK_AK="your_access_key"
export HUAWEICLOUD_SDK_SK="your_secret_key"
export HUAWEICLOUD_SDK_PROJECT_ID="your_project_id"
```

### Step 2: Initialize Terraform

```bash
cd deploy/terraform
terraform init
```

### Step 3: Plan and Deploy

```bash
terraform plan -var="region=cn-north-4" -var="environment_name=dev"
terraform apply -var="region=cn-north-4" -var="environment_name=dev"
```

### Step 4: Configure kubectl

```bash
hcloud cce get-kubeconfig --cluster-name <cluster-name> --region cn-north-4
```

### Step 5: Verify Deployment

```bash
terraform output application_url
# Open the URL in a browser
```

---

## Usage / Verification

### Access the Application

After deployment, get the frontend URL via `terraform output application_url`.

### API Endpoints

| Endpoint | Description |
|----------|-------------|
| `/status` | Health check |
| `/api/getAllProducts` | Get product list |
| `/api/docs` | Swagger API documentation |

### Stress Testing

```bash
artillery run app/client/src/tests/stresstests/stress_client.yml
artillery run app/server/src/tests/stresstests/stress_server.yml
```

---

## Cleanup

> **Important:** To avoid ongoing charges, clean up all Huawei Cloud resources after use.

```bash
cd deploy/terraform
terraform destroy -var="region=cn-north-4" -var="environment_name=dev"
```

---

## Details

### Terraform Resources

| Resource | Count | Description |
|----------|-------|-------------|
| VPC + Subnets | 1 set | HA multi-AZ network |
| CCE Cluster | 1 | Container orchestration |
| CCE Workloads | 2 | Frontend + Backend |
| ELB | 2 | Public load balancers |
| OBS Buckets | 2 | Artifacts + Static assets |
| GaussDB NoSQL | 1 | Application data table |
| SMN Topic | 1 | Deployment notifications |
| IAM Roles | Multiple | CCE/CodeArts permissions |
| CES Alarms | 4 | Auto-scaling alarms |

### Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `region` | Deployment region | `cn-north-4` |
| `environment_name` | Environment name (resource prefix) | `dev` |
| `cce_node_count` | CCE node count | `2` |
| `cce_node_flavor` | Node flavor | `s6.large.2` |

---

## FAQ / Troubleshooting

| Issue | Solution |
|-------|----------|
| CCE cluster creation failed | Check if CCE service is enabled and quota is sufficient |
| Terraform init failed | Ensure Terraform >= 1.0 and network access to Huawei Cloud API |
| Image pull failed | Verify SWR image repository permissions |
| ELB health check failed | Check security group allows health check port |

> For more issues, please submit an [Issue](https://github.com/huaweicloud-samples/cloudnative-ecs-fullstack-app/issues)

---

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](./CONTRIBUTING.md) for the contribution process.

- All commits must include DCO signature: `git commit -s`
- PRs require at least one CODEOWNERS approval
- First response SLA: 5 business days

---

## License

This project is licensed under the [MIT-0 (MIT No Attribution)](https://github.com/hsahbi/nolicense-mit-0) License.

---

## Contact / Maintainers

| Role | Contact |
|------|---------|
| Maintainer | Huawei Cloud Cloud Native Solutions Team |
| Email | huaweiclouddeveloper-solution@huawei.com |

- GitHub: [huaweicloud-samples](https://github.com/huaweicloud-samples)
- Developer Community: [Huawei Cloud Developer](https://developer.huaweicloud.com)
