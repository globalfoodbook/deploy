# GFB Kubernetes Manifests

Kubernetes manifests and helper scripts for deploying the Global Food Book (GFB) stack to a K3S cluster.

This repo focuses on deploying:

- `gfb-api` (Go backend API)
- `gfb-web` (Node/Express frontend)
- `gfb-wp` (WordPress CMS)
- Ingress + supporting resources (PDB, init job, secrets templates)

## Prerequisites

- Access to the target cluster via `kubectl`
- Namespace `gfb` created
- Required secrets created (see manifests below)
- Images loaded into the cluster runtime (many manifests use `imagePullPolicy: Never`)

## What’s in this repo

- `01-database-init-job.yaml` — DB initialization job (schema/setup)
- `02-gfb-api-deployment.yaml` — API Deployment + Service
- `03-gfb-wp-pvc.yaml` — PVC for WordPress uploads
- `04-gfb-wp-deployment.yaml` — WordPress Deployment + Service
- `05-gfb-web-deployment.yaml` — Web Deployment + Service
- `06-gfb-wp-auth-secrets.yaml` — WordPress auth keys secret template
- `07-gfb-ingress.yaml` — Ingress rules (Traefik/K3S)
- `08-pod-disruption-budget.yaml` — PDBs for higher availability
- `scripts/` — helper scripts for deploying and managing secrets

## Secrets

At minimum, deployments expect:

- `gfb-api-secret` (e.g. `GFB_API_KEYS`, `SQL_MARIADB_DSN`)
- `gfb-web-secret` (e.g. `GFB_API_BACKEND_URL`, `GFB_API_KEYS`, `GFB_CDN_URL`, `PUBLIC_GFB_DOMAINS`, etc.)
- `gfb-wp-secret` (e.g. DB settings and WP Stateless settings)
- `gfb-redis-secret` (`REDIS_PASSWORD`, if Redis auth is enabled)
- `gfb-wp-auth-keys` (WordPress auth keys/salts)

## Deploy

### Option A: Apply manifests manually

Apply in a sensible order (secrets/namespace first):

```bash
kubectl apply -f 01-database-init-job.yaml
kubectl apply -f 03-gfb-wp-pvc.yaml
kubectl apply -f 02-gfb-api-deployment.yaml
kubectl apply -f 04-gfb-wp-deployment.yaml
kubectl apply -f 05-gfb-web-deployment.yaml
kubectl apply -f 07-gfb-ingress.yaml
kubectl apply -f 08-pod-disruption-budget.yaml
```

### Option B: Use the helper script

`scripts/deploy-and-restart.sh` applies key manifests and restarts workloads:

```bash
./scripts/deploy-and-restart.sh
```

If WordPress auth keys are missing, the script will generate and create the `gfb-wp-auth-keys` secret.
