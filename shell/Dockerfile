FROM fedora:latest

WORKDIR /workdir

# Install the necessary packages.
RUN curl https://rpm.releases.hashicorp.com/fedora/hashicorp.repo | tee /etc/yum.repos.d/hashicorp.repo
RUN yum install -y curl jq vault terraform python3 python3-pip
RUN setcap cap_ipc_lock= /usr/bin/vault

# No python yet
# COPY python/requirements.txt .

# RUN pip install -r requirements.txt
# RUN rm requirements.txt

# COPY python/* /usr/local/bin

# Copy shell scripts to setup.
COPY scripts/* /usr/local/bin
# COPY terraform /workdir
# RUN mkdir .terraformrc
# RUN terraform providers mirror [options] <target-dir>


# Set command line to wait for login.
CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"

