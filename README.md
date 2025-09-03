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
- **GitOps Workflow**: All applications managed from single Git repository with ArgoCD auto-sync
- **Infrastructure as Code**: Declarative Kubernetes manifests and Helm charts
- **Real-time Updates**: Changes in Git automatically trigger deployments without manual intervention

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

Namespace Isolation:
┌─────────────────────────────────────────────────────────────────┐
│                    Kubernetes Cluster                          │
├─────────────────────────────────────────────────────────────────┤
│  argocd namespace: ArgoCD control plane                       │
├─────────────────────────────────────────────────────────────────┤
│  spam2000 namespace: Main application with network policies   │
├─────────────────────────────────────────────────────────────────┤
│  monitoring namespace: Grafana + Victoria Metrics             │
└─────────────────────────────────────────────────────────────────┘
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

### 🎯 **GitOps Benefits - Why This Approach?**

The platform now uses **Option 1** - all applications managed from your Git repository:

- ✅ **Auto-Sync**: ArgoCD automatically detects changes in your Git repo
- ✅ **No Manual Intervention**: Changes push to Git → Auto-deploy to cluster
- ✅ **Version Control**: All configurations tracked in Git history
- ✅ **Rollback**: Easy rollback to previous Git commits
- ✅ **Collaboration**: Team can review changes via Pull Requests
- ✅ **Audit Trail**: Complete history of who changed what and when

### 1. Clone the Repository

```bash
git clone https://github.com/olhaborysenko/spam2000-gitops.git
cd spam2000-gitops
```

### 2. Update Helm Dependencies

```bash
# Update dependencies for Grafana and Victoria Metrics
cd charts/grafana && helm dependency update
cd ../victoria-metrics && helm dependency update
cd ..
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
│   ├── grafana-app.yml              # Grafana monitoring stack
│   └── victoria-metrics-app.yml     # Victoria Metrics deployment
├── 📁 charts/                        # Helm charts (all managed from Git repo)
│   ├── spam2000/                    # Custom application chart
│   │   ├── Chart.yaml               # Chart metadata
│   │   ├── templates/                # Kubernetes templates
│   │   │   ├── deployment.yaml      # Deployment manifest
│   │   │   ├── service.yaml         # Service manifest
│   │   │   ├── serviceaccount.yaml  # Service account
│   │   │   ├── _helpers.tpl         # Helm helper functions
│   │   │   └── NOTES.txt            # Post-installation notes
│   │   └── values.yaml              # Default values
│   ├── grafana/                     # Custom Grafana chart
│   │   ├── Chart.yaml               # References official Grafana chart
│   │   └── values.yaml              # Custom Grafana configuration
│   └── victoria-metrics/            # Custom Victoria Metrics chart
│       ├── Chart.yaml               # References official VM chart
│       └── values.yaml              # Custom VM configuration
├── 📁 namespaces/                    # Namespace and network policies
│   ├── spam2000-namespace.yml       # Spam2000 namespace with quotas
│   ├── monitoring-namespace.yml     # Monitoring namespace with quotas
│   ├── spam2000-network-policy.yml  # Network policy for spam2000
│   └── monitoring-network-policy.yml # Network policy for monitoring
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
- **Version**: 6.60.6 (via Helm dependency)
- **Purpose**: Metrics visualization and dashboards
- **Namespace**: `monitoring`
- **Features**: Automated deployment, self-healing, custom dashboards
- **Configuration**: Managed from Git repo with custom values

#### Victoria Metrics
- **Purpose**: High-performance time-series database
- **Namespace**: `monitoring`
- **Features**: Single-node deployment, metrics storage, Spam2000 scraping
- **Configuration**: Managed from Git repo with custom values

### ArgoCD Integration

- **Automated Sync**: Continuous deployment from Git with auto-sync enabled
- **Self-Healing**: Automatic recovery from drift
- **Pruning**: Clean removal of deleted resources
- **Project**: Default project with full access
- **GitOps Workflow**: All applications managed from single Git repository
- **Real-time Updates**: Changes in Git automatically trigger deployments

### Namespace Isolation & Security

- **spam2000 namespace**: Dedicated namespace for main application
  - Resource quotas: CPU 2/4, Memory 2Gi/4Gi
  - Network policies: Controlled ingress/egress traffic
  - Isolated from monitoring stack with specific allow rules
  
- **monitoring namespace**: Dedicated namespace for observability
  - Resource quotas: CPU 4/8, Memory 8Gi/16Gi
  - Network policies: Allows scraping from spam2000 namespace
  - Higher resource limits for monitoring workloads
  
- **Network Security**: 
  - Pod-to-pod communication controlled by network policies
  - DNS access allowed for service discovery
  - Cross-namespace communication explicitly defined

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

Edit `charts/spam2000/values.yaml`:

```yaml
# Application configuration
app:
  name: spam2000
  version: "1.0.0"
  replicas: 3
  
# Resource limits
resources:
  limits:
    cpu: 1000m
    memory: 1Gi
  requests:
    cpu: 500m
    memory: 512Mi
```

#### Grafana Configuration

Edit `charts/grafana/values.yaml`:

```yaml
# Grafana configuration
grafana:
  adminPassword: ${GRAFANA_ADMIN_PASSWORD:-admin}
  persistence:
    enabled: true
    size: 10Gi
  service:
    port: 3001
    targetPort: 3001
```

#### Victoria Metrics Configuration

Edit `charts/victoria-metrics/values.yaml`:

```yaml
# Victoria Metrics configuration
victoria-metrics-single:
  server:
    resources:
      limits:
        cpu: 1000m
        memory: 2Gi
  persistence:
    enabled: true
    size: 5Gi
```

## 🚀 Deployment

### Manual Deployment

```bash
# 1. Create namespaces and apply network policies
kubectl apply -f namespaces/

# 2. Deploy ArgoCD applications
kubectl apply -f apps/

# 3. Monitor deployment status
argocd app sync --all
argocd app list

# 4. Check application health
kubectl get applications -n argocd
```

### GitOps Deployment Workflow

The platform now uses a proper GitOps approach:

1. **All configurations are stored in your Git repository**
2. **ArgoCD watches your repo for changes**
3. **Changes automatically trigger deployments**
4. **No manual sync required after initial setup**

### Initial Setup on EC2

```bash
# 1. Clone your GitOps repository
git clone https://github.com/olhaborysenko/spam2000-gitops.git
cd spam2000-gitops

# 2. Update Helm dependencies
cd charts/grafana && helm dependency update
cd ../victoria-metrics && helm dependency update
cd ..

# 3. Deploy applications
kubectl apply -f apps/spam2000-app.yml -n argocd
kubectl apply -f apps/grafana-app.yml -n argocd
kubectl apply -f apps/victoria-metrics-app.yml -n argocd
```

### 🔄 **Making Changes - GitOps Workflow**

After initial setup, here's how to make changes:

```bash
# 1. Edit any configuration file (e.g., charts/grafana/values.yaml)
vim charts/grafana/values.yaml

# 2. Commit and push changes
git add .
git commit -m "Update Grafana configuration"
git push origin main

# 3. ArgoCD automatically detects changes and syncs!
# No manual kubectl apply needed!
```

**Example Changes You Can Make:**
- Modify Grafana dashboards in `charts/grafana/values.yaml`
- Update Victoria Metrics scraping config in `charts/victoria-metrics/values.yaml`
- Change Spam2000 resources in `charts/spam2000/values.yaml`
- Add new dashboards or data sources

### Automated Deployment

The platform supports automated deployment through:

- **GitOps Workflow**: All applications managed from single Git repository
- **ArgoCD Auto-Sync**: Changes in Git automatically trigger deployments
- **Continuous Synchronization**: Real-time updates without manual intervention
- **Health Checks**: Automatic health monitoring and alerts
- **Self-Healing**: Automatic recovery from configuration drift

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
kubectl port-forward -n monitoring svc/grafana 3001:3001

# Access at: http://localhost:3001
# Default credentials: admin/admin
```

#### Victoria Metrics
```bash
# Port forward to access Victoria Metrics
kubectl port-forward -n monitoring svc/victoria-metrics 8428:8428

# Access at: http://localhost:8428
```

#### Spam2000 Application
```bash
# Port forward to access Spam2000
kubectl port-forward -n spam2000 svc/spam2000 8081:8080

# Access at: http://localhost:8081
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

# 3. Update Helm dependencies
cd charts/grafana && helm dependency update
cd ../victoria-metrics && helm dependency update
cd ..

# 4. Deploy applications
kubectl apply -f apps/
```

### Testing

```bash
# Validate Helm charts
helm lint charts/spam2000/
helm lint charts/grafana/
helm lint charts/victoria-metrics/

# Test deployment
helm install test-release charts/spam2000/ --dry-run
helm install test-grafana charts/grafana/ --dry-run
helm install test-vm charts/victoria-metrics/ --dry-run

# Update dependencies
cd charts/grafana && helm dependency update
cd ../victoria-metrics && helm dependency update
cd ..
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

## 🔐 **Secret Management (Simple Local Approach)**

### **Current Implementation:**
- **✅ Local Secrets**: Create Kubernetes secrets locally on your machine
- **✅ No Git Storage**: Secrets never stored in Git repository
- **✅ ArgoCD Integration**: Grafana automatically uses the secret
- **✅ Simple & Secure**: Clean separation of concerns

### **How It Works:**

1. **🔐 Create Secret Locally**:
   ```bash
   kubectl create secret generic grafana-admin-secret -n monitoring --from-literal=admin-password=your_password
   ```

2. **📦 Deploy with ArgoCD**:
   - Secret exists in your cluster
   - Grafana automatically uses it via `secretName`
   - ArgoCD manages the application deployment

3. **🔄 Password Rotation**:
   - Update the secret locally: `kubectl patch secret grafana-admin-secret -n monitoring --type='json' -p='[{"op": "replace", "path": "/data/admin-password", "value":"<base64-encoded-password>"}]'`
   - Restart Grafana pod to pick up new password

### **Security Benefits:**
- **🔒 No Git Exposure**: Secrets never stored in Git
- **🎯 Local Control**: You control secrets on your machine
- **🔄 Simple Management**: Easy to create and update
- **🛡️ Production Ready**: Standard Kubernetes secret management

### **Workflow:**
```
1. Create secret locally → 2. Push app config to Git → 3. ArgoCD deploys → 4. Grafana uses secret
```

### **Verification:**
```bash
# Check if secret exists
kubectl get secret grafana-admin-secret -n monitoring

# Check secret details
kubectl describe secret grafana-admin-secret -n monitoring

# Verify Grafana is using the secret
kubectl get pods -n monitoring -l app.kubernetes.io/name=grafana
```

For support and questions, please [open an issue](https://github.com/olhaborysenko/spam2000-gitops/issues) or contact the team.


