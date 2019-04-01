FROM hotio/base

ARG DEBIAN_FRONTEND="noninteractive"

ENV APP="NZBHydra2"
EXPOSE 5076
HEALTHCHECK --interval=60s CMD curl -fsSL http://localhost:5076 || exit 1

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        openjdk-8-jre-headless && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# install app
# https://github.com/theotherp/nzbhydra2/releases
RUN zipfile="/tmp/app.zip" && curl -fsSL -o "${zipfile}" "https://github.com/theotherp/nzbhydra2/releases/download/v2.3.21/nzbhydra2-2.3.21-linux.zip" && unzip -q "${zipfile}" -d "${APP_DIR}" && rm "${zipfile}" && \
    chmod +x "${APP_DIR}/nzbhydra2" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
