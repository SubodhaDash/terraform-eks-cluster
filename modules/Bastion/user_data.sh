#!/bin/bash
exec > /var/log/user-data.log 2>&1

# Update system
yum update -y

# Install required packages
yum install -y git unzip curl tar

# ----------------------------
# Install kubectl (Official)
# ----------------------------
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl
mv kubectl /usr/local/bin/

# ----------------------------
# Install eksctl (Official)
# ----------------------------
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz"

tar -xzf eksctl_Linux_amd64.tar.gz -C /tmp
rm -f eksctl_Linux_amd64.tar.gz

mv /tmp/eksctl /usr/local/bin/

# ----------------------------
# Install AWS CLI v2 (Official)
# ----------------------------
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip
./aws/install

# ----------------------------
# Clone Git Repo
# ----------------------------
cd /home/ec2-user
git clone ${repo_url}

chown -R ec2-user:ec2-user /home/ec2-user

# ----------------------------
# Verification Logs
# ----------------------------
aws --version
kubectl version --client
eksctl version
git --version