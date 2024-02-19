FROM ubuntu

USER root

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

ARG GODOT_VERSION="4.1.2"
ARG RELEASE_NAME="stable"

RUN wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}${SUBDIR}/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64.zip \
    && wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}${SUBDIR}/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz \
    && mkdir ~/.cache \
    && mkdir -p ~/.local/share/godot/export_templates/${GODOT_VERSION}.${RELEASE_NAME} \
    && unzip Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64.zip \
    && mv Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64 /usr/local/bin/godot \
    && unzip Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz \
    && mv templates/* ~/.local/share/godot/export_templates/${GODOT_VERSION}.${RELEASE_NAME} \
    && rm -f Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64.zip

RUN mkdir -p /home/godot/project

CMD ["godot", "-v", "-e", "--quit", "--headless"]