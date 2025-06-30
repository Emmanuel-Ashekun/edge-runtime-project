# EdgeOps: Portable Runtime Platform for Edge and Cloud Environments

This project delivers a portable, containerized runtime platform capable of deploying containerized applications across:
- **Tactical edge environments** (e.g., Intel NUC, Raspberry Pi, Klas Voyager)
- **Disconnected or air-gapped systems**
- **Cloud environments** (e.g., AWS EC2, Azure Stack Edge)

Built using **Docker**, **K3s**, **Helm**, **Terraform**, and **Argo CD**, this project supports GitOps workflows, offline bundles, and CI automation.

---

## 🔧 Project Structure
```
edge-runtime-project/
├── helm-charts/
│   └── edge-inference/             # Helm chart for the Flask inference app
├── docker/
│   ├── Dockerfile.inference        # Dockerfile for the Flask app
│   ├── inference.py                # Hello World Flask API
│   └── requirements.txt            # Flask dependency
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── dev.tfvars
├── argocd/
│   └── edge-inference-app.yaml     # Argo CD GitOps Application manifest
├── configs/
│   ├── install-k3s.sh
│   ├── bootstrap.sh
│   └── secrets.env
├── scripts/
│   ├── sync-logs.sh                # Sync logs to AWS S3
│   ├── gitops-pull.sh              # Pull latest Helm chart updates
│   └── test-deployment.sh          # End-to-end simulation
├── edge-bundles/                  # Contains packaged tarballs for offline deployments
├── .github/workflows/
│   └── docker-ci.yml
└── README.md
```

---

## 🚀 Deployment Overview

### Step 1: Build Docker Image
```bash
cd docker
docker build -t edge-inference:latest -f Dockerfile.inference .
```

### Step 2: Create Offline Bundle
```bash
docker save -o edge-bundles/containers.tar edge-inference:latest
cp -r configs edge-bundles/
tar -czvf edge-bundles/edge-deploy-bundle.tar.gz -C edge-bundles containers.tar configs/
```

### Step 3: Provision Infrastructure (Cloud)
```bash
cd terraform
terraform init
terraform apply -var-file="dev.tfvars"
```

### Step 4: Deploy with Helm (Online or Offline)
```bash
# Online
helm upgrade --install edge-inference helm-charts/edge-inference \
  --set image.repository=edge-inference \
  --set image.tag=latest \
  --set service.type=NodePort

# Offline (K3s air-gapped)
kubectl load -i edge-bundles/containers.tar
helm install edge-inference ./helm-charts/edge-inference
```

### Step 5: GitOps with Argo CD
```bash
kubectl apply -f helm-charts/argocd/edge-inference.yml
```
ArgoCD will watch your repo and sync Helm chart changes to the cluster.

### Step 6: Test Inference App
```bash
kubectl port-forward svc/edge-inference 8080:8080 &
curl http://localhost:8080
```
Expected output:
```
Hello from the edge inference container!
```

---

## 📦 Scripts Summary
| Script | Description |
|--------|-------------|
| `install-k3s.sh` | Installs K3s lightweight Kubernetes |
| `bootstrap.sh` | Loads container image and applies Helm chart |
| `sync-logs.sh` | Pushes logs to AWS S3 bucket |
| `gitops-pull.sh` | Pulls latest Git repo updates and upgrades Helm |
| `test-deployment.sh` | Runs full simulated end-to-end deployment locally |

---

## 🔐 Security Considerations
- TLS certs and tokens can be added to `configs/`
- Secrets managed via `secrets.env` or AWS SSM/Vault

---

## ✅ Requirements
- Docker
- Terraform + AWS CLI
- Helm
- kubectl
- K3s (for edge) or any Kubernetes cluster

---

## 🧩 TODO
- Add Prometheus/Grafana observability stack
- Add Vault auto-unseal
- Add OTA update check from Git

---

## 📄 License
MIT License

---

Clone this project, adapt to your stack, and deploy anywhere – from air-gapped edge compute to the cloud ☁️

**Repo:** https://github.com/Emmanuel-Ashekun/edge-runtime-project.git
