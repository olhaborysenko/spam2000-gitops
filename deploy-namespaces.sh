#!/bin/bash

# Spam2000 Platform Namespace Deployment Script
# This script creates namespaces and deploys applications with proper isolation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if kubectl is available
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed or not in PATH"
        exit 1
    fi
    
    if ! kubectl cluster-info &> /dev/null; then
        print_error "Cannot connect to Kubernetes cluster"
        exit 1
    fi
    
    print_success "Prerequisites check passed"
}

# Function to create namespaces
create_namespaces() {
    print_status "Creating namespaces..."
    
    # Create spam2000 namespace
    kubectl apply -f namespaces/spam2000-namespace.yml
    print_success "Created spam2000 namespace"
    
    # Create monitoring namespace
    kubectl apply -f namespaces/monitoring-namespace.yml
    print_success "Created monitoring namespace"
    
    # Wait for namespaces to be ready
    print_status "Waiting for namespaces to be ready..."
    kubectl wait --for=condition=Active namespace/spam2000 --timeout=60s
    kubectl wait --for=condition=Active namespace/monitoring --timeout=60s
    
    print_success "All namespaces are ready"
}

# Function to apply network policies
apply_network_policies() {
    print_status "Applying network policies..."
    
    kubectl apply -f namespaces/spam2000-network-policy.yml
    kubectl apply -f namespaces/monitoring-network-policy.yml
    
    print_success "Network policies applied"
}

# Function to deploy applications
deploy_applications() {
    print_status "Deploying ArgoCD applications..."
    
    # Deploy spam2000 application
    kubectl apply -f apps/spam2000-app.yml
    print_success "Deployed spam2000 application"
    
    # Deploy monitoring applications
    kubectl apply -f apps/grafana-app.yml
    kubectl apply -f apps/victoria-metrics-app.yml
    print_success "Deployed monitoring applications"
}

# Function to wait for applications to sync
wait_for_sync() {
    print_status "Waiting for applications to sync..."
    
    local timeout=300  # 5 minutes timeout
    local elapsed=0
    
    while [ $elapsed -lt $timeout ]; do
        local all_synced=true
        
        for app in spam2000 grafana victoria-metrics; do
            local status=$(kubectl get application $app -n argocd -o jsonpath='{.status.sync.status}' 2>/dev/null || echo "Unknown")
            if [ "$status" != "Synced" ]; then
                all_synced=false
                break
            fi
        done
        
        if [ "$all_synced" = true ]; then
            print_success "All applications synced successfully!"
            return 0
        fi
        
        print_status "Waiting for applications to sync... (${elapsed}s elapsed)"
        sleep 10
        elapsed=$((elapsed + 10))
    done
    
    print_warning "Timeout waiting for applications to sync"
    return 1
}

# Function to display namespace information
show_namespace_info() {
    print_status "Namespace Information:"
    echo
    
    echo "📁 spam2000 namespace:"
    kubectl get all -n spam2000
    echo
    
    echo "📁 monitoring namespace:"
    kubectl get all -n monitoring
    echo
    
    echo "📁 argocd namespace:"
    kubectl get applications -n argocd
    echo
}

# Function to provide access information
show_access_info() {
    print_status "Access Information:"
    echo
    
    echo "🔍 Grafana Dashboard (monitoring namespace):"
    echo "   kubectl port-forward -n monitoring svc/grafana 3000:80"
    echo "   URL: http://localhost:3000"
    echo "   Username: admin"
    echo "   Password: admin"
    echo
    
    echo "📊 Victoria Metrics (monitoring namespace):"
    echo "   kubectl port-forward -n monitoring svc/victoria-metrics 8428:8428"
    echo "   URL: http://localhost:8428"
    echo
    
    echo "🚀 Spam2000 App (spam2000 namespace):"
    echo "   kubectl port-forward -n spam2000 svc/spam2000 8081:8080"
    echo "   URL: http://localhost:8081"
    echo
    
    echo "🎛️ ArgoCD (argocd namespace):"
    echo "   kubectl port-forward -n argocd svc/argocd-server 8080:443"
    echo "   URL: https://localhost:8080"
    echo
}

# Function to show resource usage
show_resource_usage() {
    print_status "Resource Usage by Namespace:"
    echo
    
    echo "📊 spam2000 namespace:"
    kubectl top pods -n spam2000 2>/dev/null || echo "Metrics not available"
    echo
    
    echo "📊 monitoring namespace:"
    kubectl top pods -n monitoring 2>/dev/null || echo "Metrics not available"
    echo
}

# Main execution
main() {
    echo "🚀 Spam2000 Platform Namespace Deployment Script"
    echo "================================================"
    echo
    
    check_prerequisites
    create_namespaces
    apply_network_policies
    deploy_applications
    
    echo
    print_status "Waiting for applications to sync..."
    if wait_for_sync; then
        print_success "Deployment completed successfully!"
    else
        print_warning "Deployment completed with warnings"
    fi
    
    echo
    show_namespace_info
    echo
    show_access_info
    echo
    show_resource_usage
    
    print_success "Namespace deployment script completed!"
}

# Run main function
main "$@"
