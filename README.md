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

Feel free to fork and adapt this for disconnected or hybrid edge environment. j
