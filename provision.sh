#!/bin/bash
set -e

# Update and install base packages
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
usermod -aG docker vagrant

# Docker Compose (standalone)
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# k3s
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode 644 --node-ip 192.168.56.10" sh -
mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Allow insecure registry for k3s (containerd)
cat >> /etc/rancher/k3s/registries.yaml <<EOF
mirrors:
  "localhost:5000":
    endpoint:
      - "http://localhost:5000"
EOF
systemctl restart k3s

Start services using docker-compose
cd /home/vagrant/gridsensor-simulator
# docker-compose up -d

# echo "Waiting for Jenkins to start..."
# sleep 120
# JENKINS_PASSWORD=$(docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword)
# echo "Jenkins initial admin password: $JENKINS_PASSWORD"
# echo "Access Jenkins at http://192.168.56.10:8080"