FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# 1. Installation des prérequis
RUN apt-get update && apt-get install -y openssh-server sudo python3 docker.io curl unzip python3-docker python3-requests gnupg software-properties-common

# 2. Installation de Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get install -y terraform

# 3. Configuration SSH
RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN useradd -m -s /bin/bash vagrant && echo 'vagrant:vagrant' | chpasswd
RUN echo 'vagrant ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/vagrant
RUN mkdir -p /home/vagrant/.ssh && \
    curl -sSLo /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub && \
    chown -R vagrant:vagrant /home/vagrant/.ssh && chmod 700 /home/vagrant/.ssh && chmod 600 /home/vagrant/.ssh/authorized_keys

# 4. Script de démarrage (Docker + SSH)
RUN echo '#!/bin/bash\ndockerd --iptables=false --storage-driver=vfs > /tmp/dockerd.log 2>&1 &\n/usr/sbin/sshd -D' > /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]
