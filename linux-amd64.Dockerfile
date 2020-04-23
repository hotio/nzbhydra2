FROM hotio/base@sha256:e6394cccaed4697611ed6ea31900aa3383f45fea45fba21a9b927966a7fb43d9

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 5076

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        openjdk-11-jre-headless && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG NZBHYDRA2_VERSION

# install app
RUN zipfile="/tmp/app.zip" && curl -fsSL -o "${zipfile}" "https://github.com/theotherp/nzbhydra2/releases/download/v${NZBHYDRA2_VERSION}/nzbhydra2-${NZBHYDRA2_VERSION}-linux.zip" && unzip -q "${zipfile}" -d "${APP_DIR}" && rm "${zipfile}" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
