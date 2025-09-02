#!/bin/bash

# Fix ArgoCD Issues Script
# This script fixes the OutOfSync and Missing status issues

set -e

echo "🔧 Fixing ArgoCD Issues..."
echo "=========================="

# Step 1: Create namespaces first
echo "📁 Creating namespaces..."
kubectl apply -f namespaces/spam2000-namespace.yml
kubectl apply -f namespaces/monitoring-namespace.yml

# Step 2: Wait for namespaces to be ready
echo "⏳ Waiting for namespaces to be ready..."
kubectl wait --for=condition=Active namespace/spam2000 --timeout=60s
kubectl wait --for=condition=Active namespace/monitoring --timeout=60s

# Step 3: Apply network policies
echo "🔒 Applying network policies..."
kubectl apply -f namespaces/spam2000-network-policy.yml
kubectl apply -f namespaces/monitoring-network-policy.yml

# Step 4: Sync ArgoCD applications
echo "🔄 Syncing ArgoCD applications..."
argocd app sync grafana
argocd app sync victoria-metrics

# Step 5: Check status
echo "📊 Checking application status..."
kubectl get applications -n argocd

echo "✅ Fix completed! Check ArgoCD UI for final status."
