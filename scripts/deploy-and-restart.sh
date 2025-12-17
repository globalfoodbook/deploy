#!/bin/bash
# Deploy GFB changes and restart pods
# Run this script on the K3S server after syncing the repository

set -e

NAMESPACE="gfb"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
K8S_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== GFB Deployment Script ==="
echo "Namespace: $NAMESPACE"
echo "Kubernetes dir: $K8S_DIR"
echo ""

# Step 1: Generate WordPress auth keys if secret doesn't exist
echo "Step 1: Checking WordPress auth keys secret..."
if ! kubectl get secret gfb-wp-auth-keys -n "$NAMESPACE" &>/dev/null; then
    echo "Creating WordPress auth keys secret..."
    "$SCRIPT_DIR/generate-wp-auth-keys.sh" "$NAMESPACE"
else
    echo "Secret gfb-wp-auth-keys already exists"
fi

# Step 2: Apply Kubernetes manifests
echo ""
echo "Step 2: Applying Kubernetes manifests..."
kubectl apply -f "$K8S_DIR/06-gfb-wp-auth-secrets.yaml" 2>/dev/null || true
kubectl apply -f "$K8S_DIR/07-gfb-ingress.yaml"
kubectl apply -f "$K8S_DIR/08-pod-disruption-budget.yaml"
kubectl apply -f "$K8S_DIR/02-gfb-api-deployment.yaml"
kubectl apply -f "$K8S_DIR/04-gfb-wp-deployment.yaml"
kubectl apply -f "$K8S_DIR/05-gfb-web-deployment.yaml"

# Step 3: Restart deployments
echo ""
echo "Step 3: Restarting deployments..."
kubectl rollout restart deployment/gfb-api -n "$NAMESPACE"
kubectl rollout restart deployment/gfb-web -n "$NAMESPACE"
kubectl rollout restart deployment/gfb-wp -n "$NAMESPACE"

# Step 4: Wait for rollouts
echo ""
echo "Step 4: Waiting for rollouts to complete..."
kubectl rollout status deployment/gfb-api -n "$NAMESPACE" --timeout=120s
kubectl rollout status deployment/gfb-web -n "$NAMESPACE" --timeout=120s
kubectl rollout status deployment/gfb-wp -n "$NAMESPACE" --timeout=120s

# Step 5: Verify health
echo ""
echo "Step 5: Verifying pod health..."
kubectl get pods -n "$NAMESPACE" -o wide

echo ""
echo "=== Deployment Complete ==="
echo ""
echo "Verify health endpoints:"
echo "  kubectl exec -n $NAMESPACE deploy/gfb-wp -- curl -s http://localhost/health.php"
echo "  kubectl exec -n $NAMESPACE deploy/gfb-api -- curl -s http://localhost:5000/v1/status"
echo ""
echo "Check logs if issues:"
echo "  kubectl logs -n $NAMESPACE -l app=gfb-wp --tail=50"
echo "  kubectl logs -n $NAMESPACE -l app=gfb-api --tail=50"
