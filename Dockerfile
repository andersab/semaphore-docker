FROM ubuntu

ENV SEMAPHORE_VERSION="2.4.1" SEMAPHORE_ARCH="linux_amd64"

RUN apt-get update && apt-get install -y \
    git python3-pip python-passlib \
    software-properties-common curl

RUN apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y ansible && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip

RUN sed -i 's|#\(host_key_checking.*\)|\1|' /etc/ansible/ansible.cfg

RUN mkdir /var/semaphore

RUN curl -sSfL "https://github.com/ansible-semaphore/semaphore/releases/download/v$SEMAPHORE_VERSION/semaphore_$SEMAPHORE_ARCH" > /usr/bin/semaphore && \
    chmod +x /usr/bin/semaphore && mkdir -p /etc/semaphore/playbooks

EXPOSE 3000

ADD ./docker-startup.sh /usr/bin/semaphore-startup.sh
RUN chmod +x /usr/bin/semaphore-startup.sh

ENTRYPOINT ["/sbin/tini", "--"]

VOLUME /etc/ansible
VOLUME /etc/semaphore/playbooks

CMD ["/usr/bin/semaphore-startup.sh", "/usr/bin/semaphore", "--config", "/etc/semaphore/semaphore_config.json"]