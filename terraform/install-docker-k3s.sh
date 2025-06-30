#!/bin/bash
# Update and install dependencies
apt-get update -y
apt-get install -y curl docker.io

# Enable and start Docker
systemctl enable docker
systemctl start docker

# Install K3s (lightweight Kubernetes)
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable=traefik" sh -

# Allow kubectl for ec2-user
cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/kubeconfig
chown ubuntu:ubuntu /home/ubuntu/kubeconfig
