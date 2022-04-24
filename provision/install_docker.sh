if [ "$1" = "yes" ]; then
  export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
  apt update > /dev/null 2>&1  && echo "[OK] APT source list updated"
  apt install -y ca-certificates curl gnupg-agent software-properties-common > /dev/null 2>&1 && echo "[OK] Prereq for Docker"
  curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - >/dev/null 2>&1 && echo "[OK] Repository key added"
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /dev/null 2>&1  && echo "[OK] Repository added"
  apt update > /dev/null 2>&1  && echo "[OK] APT source list updated"
  apt install -y docker-ce docker-ce-cli containerd.io docker-compose > /dev/null 2>&1  && echo "[OK] Docker installed"
else
  dnf install -y yum-utils device-mapper-persistent-data lvm2 
  dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  dnf  install --nobest -y docker-ce docker-ce-cli containerd.io docker-compose
fi

tee /etc/docker/daemon.json <<EOF > /dev/null 2>&1  && echo "[OK] Insecure Docker registries added"
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
    ]
}
{
  "insecure-registries": [
    "172.31.56.20:8082", "172.31.56.20:8083"
    ]  
}

EOF

systemctl start docker > /dev/null 2>&1  && echo "[OK] Docker started"
systemctl enable docker > /dev/null 2>&1  && echo "[OK] Docker enabled"
systemctl restart docker > /dev/null 2>&1  && echo "[OK] Docker restarted"