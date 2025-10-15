# Frigate NVR Ansible Playbook

Automates Frigate NVR Docker deployment on Raspberry Pi with interactive setup and AWS S3 integration.

## Features

- **Pi Setup**: System updates, security hardening, Docker installation
- **Cloudflare Tunnel**: Optional tunnel setup with secure token prompts
- **Frigate NVR**: Camera system deployment with AWS S3 storage
- **Video Export**: Automated video export service with S3 upload

## Quick Start

1. Update `inventory.yml` with your Pi's IP address and username
2. Choose your deployment options:

### Full Deployment (Pi + Cloudflare + Frigate)
```bash
ansible-playbook playbook.yml --ask-pass --ask-become-pass -e "install_cloudflare=yes deploy_frigate=yes"
```

### Pi Setup + Frigate Only (Skip Cloudflare)
```bash
ansible-playbook playbook.yml --ask-pass --ask-become-pass -e "install_cloudflare=no deploy_frigate=yes"
```

### Pi Setup Only
```bash
ansible-playbook playbook.yml --ask-pass --ask-become-pass -e "install_cloudflare=no deploy_frigate=no"
```

### Default
```bash
ansible-playbook playbook.yml --ask-pass --ask-become-pass
```

**Note**: Frigate deployment will prompt for camera credentials and AWS S3 configuration during execution.

## Known Issues

### Long String Input Limitation
**Issue**:  
Ansible may skip entire playbooks when you're trying to use vars_prompt to accept very long string.

**Root cause**:  
This has been identified with Cloudflare tunnel tokens (~120 characters) which caused all tasks to skip silently.  
As per the Ansible forum discussion `vars_prompt` is designed only for passwords and sensitive data, not for general user choices or long tokens.

**Solution**: 
- Use extra vars (`-e`) for deployment choices (recommended Ansible best practice)
- Don't use `vars_prompt` for long strings or users decision prompt

**Symptoms**:  
If you see all tasks "skipping" after entering a long token, this workaround should resolve it automatically.

## Playbook Structure

- `playbook.yml` - Master playbook with deployment control
- `pi-setup.yml` - Pi configuration and Docker setup
- `cloudflare-setup.yml` - Optional Cloudflare Tunnel installation
- `frigate/frigate-deploy.yml` - Frigate NVR deployment with S3 integration
- `frigate/docker-compose.yml` - Container definitions
- `frigate/config.yml` - Frigate configuration template
- `frigate/scripts/main.py` - Video export automation
- `test-container.sh` - Docker test environment

## Requirements

- Ansible installed on control machine
- SSH access to Raspberry Pi
- Raspberry Pi OS (Debian-based)
- AWS S3 bucket (for Frigate video storage)

## What Gets Installed

- System updates + automatic security updates
- Docker + Docker Compose
- htop, vim
- Cloudflare Tunnel (optional)
- Frigate NVR with AWS S3 integration (optional)
- Video export automation service (with Frigate)