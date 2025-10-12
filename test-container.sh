#!/bin/bash

# Clean up existing container
docker rm -f frigate-test 2>/dev/null

# Run Debian Bookworm container for testing
docker run -d \
  --name frigate-test \
  --hostname frigate-test \
  -p 2222:22 \
  debian:bookworm \
  bash -c "
    apt-get update && 
    apt-get install -y openssh-server python3 sudo curl &&
    mkdir -p /var/run/sshd &&
    echo 'root:password' | chpasswd &&
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config &&
    /usr/sbin/sshd -D
  "

echo "Container started! Waiting for SSH to be ready..."
sleep 5
echo "SSH should be available at localhost:2222"
echo "Username: root, Password: password"
