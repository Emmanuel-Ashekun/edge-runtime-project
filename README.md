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
│   └── docker-ci.yml
├── .gitignore
├── LICENSE
├── edge-bundles/
├── configs/
│   ├── install-k3s.sh
│   ├── bootstrap.sh
│   └── secrets.env
├── docker/
│   ├── Dockerfile.inference
│   ├── Dockerfile.logger
│   └── Dockerfile.dashboard
├── scripts/
│   ├── sync-logs.sh
│   └── gitops-pull.sh
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── dev.tfvars
├── ansible/
│   ├── playbook.yml
│   └── inventory.ini
├── k3s-manifests/
│   ├── inference-deployment.yaml
│   ├── logger-deployment.yaml
│   └── dashboard-service.yaml
└── README.md
```

---

## 🔧 Sample File Contents

### `.gitignore`
```
*.tar.gz
*.log
*.pem
.env
__pycache__/
.edge-cache/
.terraform/
```

### `LICENSE`
```
MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy...
```

### `.github/workflows/docker-ci.yml`
```yaml
name: Docker Build CI
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
      - name: Build Docker Images
        run: |
          docker build -t edge-inference docker/ -f docker/Dockerfile.inference
```

### `docker/Dockerfile.inference`
```Dockerfile
FROM python:3.9-slim
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
CMD ["python", "inference.py"]
```

### `terraform/main.tf`
```hcl
provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "edge_runtime" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = "EdgeRuntime"
  }
}
```

### `ansible/playbook.yml`
```yaml
- name: Setup Edge Device
  hosts: edge
  become: yes
  tasks:
    - name: Install K3s
      shell: curl -sfL https://get.k3s.io | sh -
    - name: Load images
      shell: docker load -i /opt/containers.tar
```

### `configs/install-k3s.sh`
```bash
#!/bin/bash
curl -sfL https://get.k3s.io | sh -
```

### `configs/bootstrap.sh`
```bash
#!/bin/bash
docker load -i ../edge-bundles/containers.tar
kubectl apply -f ../k3s-manifests/
```

---

## 📦 Requirements
- Docker
- Terraform + AWS CLI
- Ansible
- K3s or MicroK8s

---

## 🔄 To-Do
- Add Vault auto-unseal logic
- Add Azure Stack Edge deployment example

---

## License
MIT License

---

Feel free to fork and adapt this for disconnected or hybrid edge environments.
