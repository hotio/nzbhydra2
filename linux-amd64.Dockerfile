ARG BRANCH
FROM hotio/base:${BRANCH}

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 5076
HEALTHCHECK --interval=60s CMD curl -fsSL http://localhost:5076 || exit 1

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        openjdk-11-jre-headless && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

COPY root/ /

# install app
RUN version=$(sed -n '1p' /versions/nzbhydra2) && \
    zipfile="/tmp/app.zip" && curl -fsSL -o "${zipfile}" "https://github.com/theotherp/nzbhydra2/releases/download/v${version}/nzbhydra2-${version}-linux.zip" && unzip -q "${zipfile}" -d "${APP_DIR}" && rm "${zipfile}" && \
    curl -fsSL -o "${APP_DIR}/nzbhydra2wrapper.py" "https://raw.githubusercontent.com/theotherp/nzbhydra2/master/other/wrapper/nzbhydra2wrapper.py" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"
