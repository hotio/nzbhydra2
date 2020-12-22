FROM hotio/base@sha256:63541494a6b6e37e2913c1ebc0ee45a4d046965fb453bba5e8d2c688ba18463a

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

ARG VERSION
ARG PACKAGE_VERSION=${VERSION}

# install app
RUN mkdir "${APP_DIR}/bin" && \
    zipfile="/tmp/app.zip" && curl -fsSL -o "${zipfile}" "https://github.com/theotherp/nzbhydra2/releases/download/v${VERSION}/nzbhydra2-${VERSION}-linux.zip" && unzip -q "${zipfile}" -d "${APP_DIR}/bin" && rm "${zipfile}" && \
    echo "ReleaseType=Pre-Release\nPackageVersion=${PACKAGE_VERSION}\nPackageAuthor=hotio" > "${APP_DIR}/package_info" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
