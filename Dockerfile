# Pull base image
# ---------------
FROM alpine:latest

# Maintainer
# ----------
MAINTAINER Rafael Souza <contato@rafaelfcsouza.com.br>

# Install and configure CUrl
# -------------------------------------
RUN apk add --update curl && \
# Install and configure Oracle JDK 8u25
# -------------------------------------
    apk add openjdk8 && \
# Remove APK Cache
# -------------------------------------
    rm -rf /var/cache/apk/*

# Set JAVA_HOME
# -------------------------------------
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk

# Environment variables required for this build (do NOT change)
ENV WLS_PKG  wls1213_dev_update3.zip
ENV WLS_VERSION wls12130

# WLS Admin Password (you may change)
# This password is used for:
#  (a) 'weblogic' admin user of WebLogic
# -----------------------------------
ENV ADMIN_PASSWORD welcome1

# Config MW_HOME
# -------------------------------------
ENV MW_HOME /app/prd1bea/$WLS_VERSION
ENV CONFIG_JVM_ARGS -Djava.security.egd=file:/dev/./urandom

# Setup filesystem and oracle user
# ------------------------------------------------------------
# Enable this if behind proxy
RUN mkdir -p /app/prd1bea && chmod a+xr /app/prd1bea

# Installation of Weblogic
WORKDIR /app/prd1bea

# Add files required to build this image
RUN unzip -q /app/prd1bea/$WLS_PKG && \
    rm -f /app/prd1bea/$WLS_PKG

RUN ln -s /app/prd1bea/$WLS_VERSION /app/prd1bea/weblogic

WORKDIR /app/prd1bea/$WLS_VERSION

RUN chmod 777 configure.sh && \
    sh ./configure.sh -silent && \
    find /app/prd1bea/$WLS_VERSION -name "*.sh" -exec chmod a+x {} \;
