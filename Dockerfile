FROM ubuntu

RUN apt-get update && apt-get install -y \
    git python3-pip python-passlib && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip
RUN pip3 install ansible

#RUN sed -e '/host_key_checking: False/ s/^#*/#/' -i /etc/ansible/ansible.cfg