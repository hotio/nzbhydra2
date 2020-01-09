FROM hotio/base@sha256:a97ec69084f2db5bc2603e79e905c34595ea1fe78e1143d0beaf2b1c7b4a9087

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 5076

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        python openjdk-11-jre-headless && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# https://github.com/theotherp/nzbhydra2/releases
ARG NZBHYDRA2_VERSION=2.10.8

# install app
RUN zipfile="/tmp/app.zip" && curl -fsSL -o "${zipfile}" "https://github.com/theotherp/nzbhydra2/releases/download/v${NZBHYDRA2_VERSION}/nzbhydra2-${NZBHYDRA2_VERSION}-linux.zip" && unzip -q "${zipfile}" -d "${APP_DIR}" && rm "${zipfile}" && \
    curl -fsSL -o "${APP_DIR}/nzbhydra2wrapper.py" "https://raw.githubusercontent.com/theotherp/nzbhydra2/master/other/wrapper/nzbhydra2wrapper.py" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
