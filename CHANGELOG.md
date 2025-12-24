# Kubernetes Manifests Changelog

## [v1.3.0] - 2025-12-24

### 🚀 Features

- **Updated Deployment Images**: Updated gfb-api to v1.10.5 and gfb-web to v1.7.3
- **Latest Features**: Deployments now include the latest CORS and rate limiting enhancements

### 🔧 Configuration Changes

- **gfb-api**: Updated to v1.10.5 with fail-closed rate limiting support
- **gfb-web**: Updated to v1.7.3 with configurable CORS origin support

### 🐛 Bug Fixes

- **Image Version Alignment**: Ensured deployment manifests match current running versions
- **Feature Parity**: Aligned Kubernetes manifests with latest application features

### 🔒 Security Improvements

- **Fail-Closed Rate Limiting**: gfb-api now supports secure fail-closed mode for rate limiting
- **Configurable CORS**: gfb-web now supports environment-specific CORS configuration

### 📝 Deployment Changes

**Updated Files:**
- `02-gfb-api-deployment.yaml`: Updated image to v1.10.5
- `05-gfb-web-deployment.yaml`: Updated image to v1.7.3

### 🌐 Environment Variables

**gfb-api:**
- `RATE_LIMIT_FAIL_CLOSED`: Controls fail-closed behavior for rate limiting

**gfb-web:**
- `GFB_ALLOWED_ORIGIN`: Configures CORS allowed origin

## [v1.2.0] - 2025-12-23

### 🔧 Updates

- **WordPress Admin Protection**: Added Traefik Basic Auth for WordPress admin
- **WordPress Image Updates**: Bumped gfb-wp to v1.2.3
- **API Image Updates**: Bumped gfb-api to v1.10.4

### 📝 Previous Updates

- **gfb-wp**: Updated to v1.2.2
- **gfb-api**: Updated to v1.10.3

## Previous Versions

For earlier versions, please refer to the Git history or previous changelog entries.