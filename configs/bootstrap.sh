#!/bin/bash
docker load -i ../edge-bundles/containers.tar
kubectl apply -f ../k3s-manifests/
