# Frigate NVR Ansible Playbook

Automates Frigate NVR Docker deployment on Raspberry Pi 4B with interactive setup.

## Features

- **Pi Setup**: System updates, security hardening, Docker installation
- **Cloudflare Tunnel**: Optional tunnel setup with interactive prompts
- **Frigate NVR**: Ready for camera system deployment
- **Interactive**: Prompts for passwords and configuration choices

## Quick Start

1. Update `inventory.yml` with your Pi's IP address
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

### Default (Pi Setup Only)
```bash
ansible-playbook playbook.yml --ask-pass --ask-become-pass
```

**Note**: Sensitive data (Cloudflare token, camera password) will be prompted securely during execution.

## Known Issues

### Long String Input Limitation
**Issue**: Ansible may skip entire playbooks when you're trying to use vars_prompt to accept anything other than passwords.

**When identified**: October 2025 - Cloudflare tunnel tokens (~120 characters) caused all tasks to skip silently.

**Root cause**: `vars_prompt` is designed only for passwords and sensitive data, not for general user choices or long tokens.

**Solution**: 
- Use extra vars (`-e`) for deployment choices (recommended Ansible best practice)
- Use `vars_prompt` only for passwords with `private: yes`
- Long tokens are handled via file-based workaround automatically

**Symptoms**: If you see all tasks "skipping" after entering a long token, this workaround should resolve it automatically.

## Playbook Structure

- `playbook.yml` - Master playbook with interactive prompts
- `pi-setup.yml` - Basic Pi configuration and Docker setup
- `cloudflare-setup.yml` - Optional Cloudflare Tunnel installation
- `frigate-deploy.yml` - Frigate NVR deployment (placeholder)

## Individual Playbook Usage

```bash
# Pi setup only
ansible-playbook pi-setup.yml --ask-pass --ask-become-pass

# Cloudflare only (after pi-setup)
ansible-playbook cloudflare-setup.yml --ask-pass --ask-become-pass

# Frigate only (after pi-setup)
ansible-playbook frigate/frigate-deploy.yml --ask-pass --ask-become-pass
```

## Requirements

- Ansible installed on control machine
- SSH access to Raspberry Pi 4B
- Raspberry Pi OS (Debian-based)

## What Gets Installed

- System updates + automatic security updates
- Docker + Docker Compose
- htop, vim (utilities)
- Cloudflare Tunnel (optional)
- Frigate NVR setup (ready for configuration)