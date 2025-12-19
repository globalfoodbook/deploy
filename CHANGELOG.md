# Changelog

All notable changes to the Global Food Book K3S deployment manifests will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.3] - 2025-12-19

### Overview
Updates the default `gfb-api` image tag to `v1.10.4`, which removes remaining nil-pointer panic
paths in the authors DAO when `Queryx()` fails.

### Changed
- API Deployment (`02-gfb-api-deployment.yaml`)
  - Default image tag: `gfb-api:v1.10.3` → `gfb-api:v1.10.4`

## [1.0.2] - 2025-12-19

### Overview
Updates the default `gfb-api` image tag to `v1.10.3`, which prevents a known crash loop (nil-pointer
panic in `models.Author.Scan`) under database connection pressure.

### Changed
- API Deployment (`02-gfb-api-deployment.yaml`)
  - Default image tag: `gfb-api:v1.10.2` → `gfb-api:v1.10.3`

## [1.0.1] - 2025-12-19

### Overview
Aligns runtime health checks and admin authentication plumbing with the latest service hardening:
API probes now verify dependencies via `/v1/health`, and WordPress can read Basic Auth credentials
from a Kubernetes Secret.

### Changed
- API Deployment (`02-gfb-api-deployment.yaml`)
  - Liveness/readiness probes: `/v1/status` → `/v1/health` (dependency-aware check)
  - Default image tag: `gfb-api:v1.10.2`
- Web Deployment (`05-gfb-web-deployment.yaml`)
  - Default image tag: `gfb-web:v1.7.2`
- WordPress Deployment (`04-gfb-wp-deployment.yaml`)
  - Default image tag: `gfb-wp:v1.2.0`
  - Adds `envFrom` Secret `gfb-wp-http-auth` for the `http-auth` plugin
  - Fixes YAML indentation so manifests apply cleanly

### Documentation
- `README.md` documents the new `gfb-wp-http-auth` Secret and behavior.

### Security
- Credentials for admin Basic Auth can be rotated via Kubernetes Secret without modifying the
  WordPress DB options table.

### Deployment Notes
- Apply manifests: `kubectl apply -f . -n gfb`
- Verify rollouts: `kubectl -n gfb rollout status deploy/gfb-api deploy/gfb-web deploy/gfb-wp`

## [1.0.0] - 2025-12-17

### Added
- **K3S Manifests** for the `gfb` namespace:
  - Database bootstrap job: `01-database-init-job.yaml`
  - API Deployment/Service: `02-gfb-api-deployment.yaml`
  - WordPress PVC: `03-gfb-wp-pvc.yaml`
  - WordPress Deployment/Service: `04-gfb-wp-deployment.yaml`
  - Web frontend Deployment/Service: `05-gfb-web-deployment.yaml`
  - WordPress auth keys Secret template: `06-gfb-wp-auth-secrets.yaml`
  - Ingress rules: `07-gfb-ingress.yaml`
  - Pod Disruption Budget: `08-pod-disruption-budget.yaml`

- **Default Image Tags**:
  - `gfb-api:v1.10.1`
  - `gfb-web:v1.7.1`
  - `gfb-wp:v1.1.4`

- **Deployment Scripts**:
  - `scripts/generate-wp-auth-keys.sh`: generate WordPress salts and create `gfb-wp-auth-keys`.
  - `scripts/deploy-and-restart.sh`: apply manifests, restart deployments, and print verification commands.

### Security
- `06-gfb-wp-auth-secrets.yaml` ships placeholder values (`CHANGE_ME_*`) and must be replaced
  (or generated via script) before production deployment.
