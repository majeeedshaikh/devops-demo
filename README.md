# DevOps Demo

## Overview

This repo bootstraps a fully-automated local Kubernetes environment:

1. **k3d** “devops” cluster  
2. **Terraform** provisions nginx-ingress  
3. **Helm**/CRDs install Prometheus & Grafana  
4. **Ansible** orchestrates:
   - Docker image pull & import  
   - Kubernetes manifests (app, ServiceMonitor, etc.)  
   - Smoke-tests via Ingress & direct service calls  
5. **GitHub Actions** CI pipeline:
   - Build & push multi-arch image to GHCR  
   - Run Ansible playbook  
   - Verify `/health` and `/metrics` endpoints  

## Prerequisites

- Docker & k3d  
- Terraform v1.x  
- Ansible 2.9+  
- kubectl  

## Getting Started

1. **Clone & enter**  
   ```bash
   git clone https://github.com/<you>/devops-demo.git
   cd devops-demo
