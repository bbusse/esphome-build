ARG ESPHOME_VERSION=2025.2.2
FROM bitnami/minideb:latest
LABEL maintainer="Björn Busse <bj.rn@baerlin.eu>"
LABEL org.opencontainers.image.source https://github.com/bbusse/esphome-build

ARG ESPHOME_VERSION
ENV ARCH="x86_64" \
    USER="build" \
    PACKAGES="curl git python3-pip python3-launchpadlib" \
    PYTHON_PACKAGES="esphome>=${ESPHOME_VERSION}"

RUN ls -al && \
    adduser $USER && \
    apt update && \
    apt install -y ${PACKAGES} && \
    # To add custom repository
    apt install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    # We want a more recent python from the ppa we added
    apt install -y python3.11 python3.11-venv

USER $USER

RUN cd && ls -al && \
    python3.11 -m venv esphome && \
    . esphome/bin/activate && \
    pip3 install ${PYTHON_PACKAGES}

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
