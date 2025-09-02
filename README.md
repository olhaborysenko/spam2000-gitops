# 🚀 Spam2000 - Kubernetes Application Platform

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.25+-blue.svg)](https://kubernetes.io/)
[![ArgoCD](https://img.shields.io/badge/ArgoCD-2.0+-green.svg)](https://argoproj.github.io/argo-cd/)
[![Helm](https://img.shields.io/badge/Helm-3.0+-orange.svg)](https://helm.sh/)

A modern, cloud-native application platform built with Kubernetes, ArgoCD, and comprehensive monitoring stack. This project demonstrates GitOps practices for deploying and managing applications in a Kubernetes cluster with automated monitoring and observability.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Components](#components)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Monitoring](#monitoring)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

Spam2000 is a comprehensive Kubernetes application platform that implements GitOps principles using ArgoCD for continuous deployment. The platform includes:

- **Main Application**: Custom spam2000 application with Helm charts
- **Monitoring Stack**: Grafana for visualization and Victoria Metrics for time-series data
- **GitOps Workflow**: Automated deployment and synchronization via ArgoCD
- **Infrastructure as Code**: Declarative Kubernetes manifests and Helm charts

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   GitOps Repo   │    │     ArgoCD      │    │   Kubernetes    │
│                 │    │                 │    │     Cluster     │
│ ┌─────────────┐ │    │ ┌─────────────┐ │    │ ┌─────────────┐ │
│ │ Application │ │───▶│ │  Controller │ │───▶│ │  Spam2000   │ │
│ │  Manifests  │ │    │ │             │ │    │ │  Application│ │
│ └─────────────┘ │    │ └─────────────┘ │    │ └─────────────┘ │
│                 │    │                 │    │                 │
│ ┌─────────────┐ │    │ ┌─────────────┐ │    │ ┌─────────────┐ │
│ │   Grafana   │ │───▶│ │  Controller │ │───▶│ │   Grafana   │ │
│ │   Config    │ │    │ │             │ │    │ │   Dashboard │ │
│ └─────────────┘ │    │ └─────────────┘ │    │ └─────────────┘ │
│                 │    │                 │    │                 │
│ ┌─────────────┐ │    │ ┌─────────────┐ │    │ ┌─────────────┐ │
│ │VictoriaMetrics│ │───▶│ │  Controller │ │───▶│ │VictoriaMetrics│ │
│ │   Config    │ │    │ │             │ │    │ │   Service   │ │
│ └─────────────┘ │    │ └─────────────┘ │    │ └─────────────┘ │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## ✅ Prerequisites

Before deploying this platform, ensure you have:

- **Kubernetes Cluster** (v1.25+)
  - Access to cluster with admin privileges
  - `kubectl` configured and accessible
  
- **ArgoCD** (v2.0+)
  - Installed and running in your cluster
  - Access to ArgoCD UI or CLI
  
- **Helm** (v3.0+)
  - For managing Helm charts and releases
  
- **Git Repository**
  - Repository with your application manifests
  - ArgoCD access to the repository

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/<your-username>/spam2000-gitops.git
cd spam2000-gitops
```

### 2. Configure ArgoCD Applications

Update the repository URLs in your application manifests:

```bash
# Update repository URLs in app manifests
sed -i 's/<your-username>/your-actual-username/g' apps/*.yml
```

### 3. Deploy Applications

```bash
# Apply ArgoCD applications
kubectl apply -f apps/

# Or use ArgoCD CLI
argocd app sync spam2000
argocd app sync grafana
argocd app sync victoria-metrics
```

### 4. Verify Deployment

```bash
# Check application status
argocd app list

# Check pod status
kubectl get pods -A
```

## 📁 Project Structure

```
spam2000/
├── 📁 apps/                          # ArgoCD Application manifests
│   ├── spam2000-app.yml             # Main application deployment
│   ├── grafana=app.yml              # Grafana monitoring stack
│   └── victoria-metrics-app.yml     # Victoria Metrics deployment
├── 📁 charts/                        # Helm charts
│   └── spam2000/                    # Custom application chart
│       ├── Chart.yml                 # Chart metadata
│       ├── templates/                # Kubernetes templates
│       │   ├── deployment.yml        # Deployment manifest
│       │   └── service.yml           # Service manifest
│       └── values.yml                # Default values
├── 📁 monitoring/                    # Monitoring configurations
│   ├── grafana/                      # Grafana configuration
│   │   └── values.yaml               # Grafana Helm values
│   └── victoria-metrics/             # Victoria Metrics config
│       └── values.yaml               # Victoria Metrics values
└── 📄 README.md                      # This file
```

## 🔧 Components

### Main Application (Spam2000)

The core application deployed via Helm chart with:
- **Deployment**: Scalable application deployment
- **Service**: Network access configuration
- **ConfigMaps/Secrets**: Application configuration
- **Ingress**: External access configuration

### Monitoring Stack

#### Grafana
- **Version**: 6.60.6
- **Purpose**: Metrics visualization and dashboards
- **Namespace**: `monitoring`
- **Features**: Automated deployment, self-healing

#### Victoria Metrics
- **Purpose**: High-performance time-series database
- **Namespace**: `monitoring`
- **Features**: Single-node deployment, metrics storage

### ArgoCD Integration

- **Automated Sync**: Continuous deployment from Git
- **Self-Healing**: Automatic recovery from drift
- **Pruning**: Clean removal of deleted resources
- **Project**: Default project with full access

## ⚙️ Configuration

### Environment Variables

```bash
# Required environment variables
export KUBECONFIG=/path/to/your/kubeconfig
export ARGOCD_SERVER=argocd.your-domain.com
export ARGOCD_AUTH_TOKEN=your-auth-token
```

### Customizing Values

#### Spam2000 Application

Edit `charts/spam2000/values.yml`:

```yaml
# Application configuration
app:
  name: spam2000
  version: "1.0.0"
  replicas: 3
  
# Resource limits
resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi
```

#### Monitoring Configuration

Edit monitoring values files in `monitoring/` directory:

```yaml
# Grafana configuration
grafana:
  adminPassword: "your-secure-password"
  persistence:
    enabled: true
    size: 10Gi
```

## 🚀 Deployment

### Manual Deployment

```bash
# 1. Deploy ArgoCD applications
kubectl apply -f apps/

# 2. Monitor deployment status
argocd app sync --all
argocd app list

# 3. Check application health
kubectl get applications -n argocd
```

### Automated Deployment

The platform supports automated deployment through:

- **GitOps Workflow**: Changes in Git automatically trigger deployments
- **ArgoCD Sync**: Continuous synchronization with repository
- **Health Checks**: Automatic health monitoring and alerts

### Rollback Strategy

```bash
# Rollback to previous version
argocd app rollback spam2000

# Check rollback status
argocd app history spam2000
```

## 📊 Monitoring

### Accessing Dashboards

#### Grafana
```bash
# Port forward to access Grafana
kubectl port-forward -n monitoring svc/grafana 3000:80

# Access at: http://localhost:3000
# Default credentials: admin/admin
```

#### Victoria Metrics
```bash
# Port forward to access Victoria Metrics
kubectl port-forward -n monitoring svc/victoria-metrics 8428:8428

# Access at: http://localhost:8428
```

### Metrics Collection

The platform automatically collects:
- **Application Metrics**: Custom business metrics
- **Infrastructure Metrics**: CPU, memory, network usage
- **Kubernetes Metrics**: Pod, service, and cluster health

## 🛠️ Development

### Local Development

```bash
# 1. Set up local Kubernetes (e.g., minikube)
minikube start

# 2. Install ArgoCD locally
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 3. Deploy applications
kubectl apply -f apps/
```

### Testing

```bash
# Validate Helm charts
helm lint charts/spam2000/

# Test deployment
helm install test-release charts/spam2000/ --dry-run

# Run integration tests
kubectl apply -f tests/
```

### Debugging

```bash
# Check application logs
kubectl logs -f deployment/spam2000

# Check ArgoCD application status
argocd app get spam2000

# Verify resource creation
kubectl get all -l app=spam2000
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines

- Follow Kubernetes and Helm best practices
- Ensure all manifests are valid and linted
- Test changes in a development environment
- Update documentation for new features
- Follow GitOps principles

## 📚 Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [ArgoCD User Guide](https://argoproj.github.io/argo-cd/user-guide/)
- [Helm Documentation](https://helm.sh/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Victoria Metrics Documentation](https://docs.victoriametrics.com/)

## 🐛 Troubleshooting

### Common Issues

#### Application Not Syncing
```bash
# Check ArgoCD application status
argocd app get <app-name>

# Verify repository access
argocd repo list

# Check application logs
kubectl logs -n argocd deployment/argocd-application-controller
```

#### Pod Not Starting
```bash
# Check pod events
kubectl describe pod <pod-name>

# Check pod logs
kubectl logs <pod-name>

# Verify resource quotas
kubectl describe resourcequota
```

#### Monitoring Not Working
```bash
# Check monitoring namespace
kubectl get all -n monitoring

# Verify service endpoints
kubectl get endpoints -n monitoring

# Check persistent volumes
kubectl get pv,pvc -n monitoring
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [ArgoCD](https://argoproj.github.io/) for GitOps capabilities
- [Helm](https://helm.sh/) for Kubernetes package management
- [Grafana](https://grafana.com/) for monitoring and visualization
- [Victoria Metrics](https://victoriametrics.com/) for time-series database

---

**Made with ❤️ by the Spam2000 Team**

For support and questions, please [open an issue](https://github.com/<your-username>/spam2000-gitops/issues) or contact the team.
