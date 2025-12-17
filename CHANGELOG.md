# Changelog

All notable changes to the Global Food Book K3S deployment manifests will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
