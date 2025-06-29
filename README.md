# EdgeOps: Portable Container Runtime for Edge and Cloud

## Overview
This project demonstrates how to build and deploy a **lightweight, portable container runtime platform** that works across:
- Disconnected, tactical edge devices (e.g., Intel NUC, Raspberry Pi, Klas Voyager)
- Azure Stack Edge and AWS EC2

Built with **K3s**, **Docker**, **Terraform**, and **Ansible**.

---

## Project Structure
```
edgeops-runtime/
├── .github/workflows/         # GitHub Actions for CI
│   └── docker-ci.yml          # Lint and build containers
├── .gitignore                 # Standard Git ignore rules
├── LICENSE                    # MIT License
├── edge-bundles/              # Pre-packaged tarballs for edge deployment
├── configs/                   # TLS certs, .env files, YAML manifests
│   ├── install-k3s.sh
│   ├── bootstrap.sh
│   └── secrets.env
├── docker/                    # Dockerfiles for app components
│   ├── Dockerfile.inference
│   ├── Dockerfile.logger
│   └── Dockerfile.dashboard
├── scripts/                   # Sync and utility scripts
│   ├── sync-logs.sh
│   └── gitops-pull.sh
├── terraform/                 # AWS EC2 and network provisioning
│   ├── main.tf
│   ├── variables.tf
│   └── dev.tfvars
├── ansible/                   # Configuration management for edge nodes
│   ├── playbook.yml
│   └── inventory.ini
├── k3s-manifests/             # K3s deployment manifests (apps, services)
│   ├── inference-deployment.yaml
│   ├── logger-deployment.yaml
│   └── dashboard-service.yaml
└── README.md                  # Setup and usage guide
```

---

## 🛠️ Step-by-Step Setup Guide

### 1. Clone the Repository
```bash
git clone https://github.com/YOUR_USERNAME/edgeops-runtime.git
cd edgeops-runtime
```

### 2. Build Docker Images
```bash
cd docker/
docker build -t edge-inference:latest -f Dockerfile.inference .
docker build -t edge-logger:latest -f Dockerfile.logger .
docker build -t edge-dashboard:latest -f Dockerfile.dashboard .
```

### 3. Create an Edge Bundle for Offline Deployment
```bash
mkdir -p ../edge-bundles/
docker save edge-inference edge-logger edge-dashboard -o ../edge-bundles/containers.tar
cp -r ../configs ../edge-bundles/
cd ../edge-bundles/
tar -czvf edge-deploy-bundle.tar.gz containers.tar configs/
```

### 4. Provision Cloud Resources with Terraform (AWS Example)
```bash
cd terraform/
terraform init
terraform apply -var-file="dev.tfvars"
```

### 5. Deploy to Edge Device (Disconnected)
Transfer `edge-deploy-bundle.tar.gz` to the device (via USB or SSD), then run:
```bash
tar -xzvf edge-deploy-bundle.tar.gz
cd configs/
./install-k3s.sh  # Or use ansible playbook
./bootstrap.sh    # Load images, apply manifests, start services
```

### 6. Observe Locally
- Visit `http://localhost:3000` for the Grafana dashboard
- Log output: `/var/log/edge-apps/`

### 7. Sync to Cloud (When Online)
```bash
./scripts/sync-logs.sh  # Push to S3 or CloudWatch
./scripts/gitops-pull.sh  # Optional GitOps update if network is restored
```

---

## 🔐 Security Considerations
- TLS certs and tokens are pre-staged in `configs/`
- Secrets managed via Vault or AWS SSM snapshots

---

## 📦 Requirements
- Docker
- Terraform + AWS CLI
- Ansible
- K3s or MicroK8s

---

## 🔄 To-Do
- Add automated Vault unseal
- Add GPU inference demo for Jetson devices
- Add Azure Stack Edge deployment example

---

## License
MIT License

---

Feel free to fork and adapt this for other disconnected or hybrid environments.
