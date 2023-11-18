ARG ESP_IDF_VERSION=release-v5.1
FROM espressif/idf:${ESP_IDF_VERSION}
LABEL maintainer="Björn Busse <bj.rn@baerlin.eu>"
LABEL org.opencontainers.image.source https://github.com/bbusse/esphome-build

ENV ARCH="x86_64" \
    USER="build" \
    PACKAGES="python3-pip" \
    PYTHON_PACKAGES="esphome>=2023.11.1"

RUN ls -al && \
    adduser $USER && \
    apt update && \
    apt install -y ${PACKAGES} && \
    # To add custom repository
    apt install -y software-properties-common && \
    # We want a more recent python from the ppa we added
    add-apt-repository ppa:deadsnakes/ppa && \
    apt install -y python3.11 python3.11-venv && \
    python3.11 -m ensurepip

USER $USER

RUN cd && ls -al && \
    python3.11 -m venv esphome && \
    . esphome/bin/activate && \
    pip3 install ${PYTHON_PACKAGES}

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
