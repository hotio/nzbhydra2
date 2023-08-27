ARG UPSTREAM_IMAGE
ARG UPSTREAM_DIGEST_ARM64

FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST_ARM64}
EXPOSE 5076
ARG DEBIAN_FRONTEND="noninteractive"

VOLUME ["${CONFIG_DIR}"]

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        libfreetype6 \
        openjdk-17-jre-headless && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG VERSION
ARG PACKAGE_VERSION=${VERSION}

# install app
RUN mkdir "${APP_DIR}/bin" && \
    zipfile="/tmp/app.zip" && curl -fsSL -o "${zipfile}" "https://github.com/theotherp/nzbhydra2/releases/download/v${VERSION}/nzbhydra2-${VERSION}-arm64-linux.zip" && unzip -q "${zipfile}" -d "${APP_DIR}/bin" && rm "${zipfile}" && \
    echo "ReleaseType=Pre-Release\nPackageVersion=${PACKAGE_VERSION}\nPackageAuthor=hotio" > "${APP_DIR}/package_info" && \
    chmod -R u=rwX,go=rX "${APP_DIR}" && \
    chmod +x "${APP_DIR}/bin/core"

COPY root/ /
