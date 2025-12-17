#!/bin/bash
# Generate WordPress authentication keys and create Kubernetes secret
# Usage: ./generate-wp-auth-keys.sh [namespace]

set -e

NAMESPACE="${1:-gfb}"
SECRET_NAME="gfb-wp-auth-keys"

echo "Generating WordPress authentication keys..."

# Generate random keys (64 characters each, alphanumeric + special chars)
generate_key() {
    openssl rand -base64 48 | tr -d '\n' | head -c 64
}

WP_AUTH_KEY=$(generate_key)
WP_SECURE_AUTH_KEY=$(generate_key)
WP_LOGGED_IN_KEY=$(generate_key)
WP_NONCE_KEY=$(generate_key)
WP_AUTH_SALT=$(generate_key)
WP_SECURE_AUTH_SALT=$(generate_key)
WP_LOGGED_IN_SALT=$(generate_key)
WP_NONCE_SALT=$(generate_key)

echo "Creating Kubernetes secret in namespace: $NAMESPACE"

# Delete existing secret if it exists
kubectl delete secret "$SECRET_NAME" --namespace="$NAMESPACE" 2>/dev/null || true

# Create new secret
kubectl create secret generic "$SECRET_NAME" \
    --namespace="$NAMESPACE" \
    --from-literal=WP_AUTH_KEY="$WP_AUTH_KEY" \
    --from-literal=WP_SECURE_AUTH_KEY="$WP_SECURE_AUTH_KEY" \
    --from-literal=WP_LOGGED_IN_KEY="$WP_LOGGED_IN_KEY" \
    --from-literal=WP_NONCE_KEY="$WP_NONCE_KEY" \
    --from-literal=WP_AUTH_SALT="$WP_AUTH_SALT" \
    --from-literal=WP_SECURE_AUTH_SALT="$WP_SECURE_AUTH_SALT" \
    --from-literal=WP_LOGGED_IN_SALT="$WP_LOGGED_IN_SALT" \
    --from-literal=WP_NONCE_SALT="$WP_NONCE_SALT"

echo "Secret '$SECRET_NAME' created successfully in namespace '$NAMESPACE'"
echo ""
echo "To verify:"
echo "  kubectl get secret $SECRET_NAME -n $NAMESPACE -o yaml"
echo ""
echo "To restart WordPress pods with new keys:"
echo "  kubectl rollout restart deployment/gfb-wp -n $NAMESPACE"
