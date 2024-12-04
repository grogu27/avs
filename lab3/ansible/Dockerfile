FROM ubuntu:latest
RUN apt-get update && apt-get install -y openssh-server sshpass python3 python3-pip python3-six && apt-get clean
RUN groupadd docker
RUN useradd -m -s /bin/bash ansible_user && \
    echo 'ansible_user:qwerty' | chpasswd && \
    usermod -aG sudo ansible_user && \
    usermod -aG docker ansible_user

RUN mkdir /var/run/sshd

RUN echo 'PermitRootLogin no' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]