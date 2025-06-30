from pathlib import Path

# Define contents of the bootstrap.sh file
bootstrap_script = """#!/bin/bash
# bootstrap.sh - Set up a K3s node and deploy workloads in a disconnected environment

set -e

echo "[*] Loading pre-packaged container images..."
docker load -i ../edge-bundles/containers.tar

echo "[*] Installing K3s lightweight Kubernetes..."
curl -sfL https://get.k3s.io | sh -

echo "[*] Waiting for K3s to become ready..."
sleep 10  # Optionally check k3s status before continuing

echo "[*] Applying Kubernetes manifests..."
kubectl apply -f ../k3s-manifests/

echo "[*] Done. Your edge runtime should now be running."
"""

# Set the output path
output_path = "/mnt/data/bootstrap.sh"

# Write the file
with open(output_path, "w") as f:
    f.write(bootstrap_script)

# Set executable permissions (for reference; not executable in sandbox)
Path(output_path).chmod(0o755)

output_path
