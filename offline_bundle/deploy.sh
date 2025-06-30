#!/bin/bash
# offline-deploy.sh - Automates disconnected edge setup

set -e

echo "🛠 Starting offline edge deployment..."

echo "[1/5] Installing Docker (if not present)..."
if ! command -v docker &> /dev/null; then
  sudo apt update && sudo apt install -y docker.io
  sudo systemctl start docker
  sudo systemctl enable docker
fi

echo "[2/5] Loading pre-built Docker images..."
docker load -i edge-bundles/inference-image.tar

echo "[3/5] Installing K3s..."
curl -sfL https://get.k3s.io | sh -

echo "[4/5] Waiting for K3s to stabilize..."
sleep 15

echo "[5/5] Applying manifests from k3s-manifests/..."
kubectl apply -f k3s-manifests/

echo "✅ Edge app deployed! Run 'kubectl get pods -A' and 'curl http://localhost:8080' to test."
