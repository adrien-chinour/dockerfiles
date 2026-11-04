ARG VERSION
ARG OS


# @description base image: official php cli image with git, composer and install-php-extensions.
FROM php:$VERSION-cli-$OS AS base

RUN set -eux; \
    if command -v apk >/dev/null; then \
        apk add --no-cache git; \
    else \
        if grep -qs bullseye /etc/apt/sources.list; then \
            # Debian 11 is end-of-life: its packages moved to archive.debian.org
            sed -i 's|deb.debian.org|archive.debian.org|g' /etc/apt/sources.list; \
            echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99archive; \
        fi; \
        apt-get update; \
        apt-get install -y --no-install-recommends git; \
        rm -rf /var/lib/apt/lists/*; \
    fi

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

WORKDIR /opt


# @image ghcr.io/adrien-chinour/php-cli-xdebug
# @author Adrien Chinour <github@chinour.fr>
FROM base AS php-cli-xdebug
ARG VERSION
ARG OS
ARG BUILD_DATE

LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.source="https://github.com/adrien-chinour/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/adrien-chinour/dockerfiles"
LABEL org.opencontainers.image.url="https://github.com/adrien-chinour"

LABEL org.opencontainers.image.authors="Adrien Chinour <github@chinour.fr>"
LABEL org.opencontainers.image.title="php-cli-xdebug"
LABEL org.opencontainers.image.description="PHP CLI image with xdebug."
LABEL org.opencontainers.image.base.name="docker.io/library/php:$VERSION-cli-$OS"
LABEL org.opencontainers.image.version=$VERSION-$OS

RUN install-php-extensions zip xdebug


# @image ghcr.io/adrien-chinour/php-cli-allinclusive
# @author Adrien Chinour <github@chinour.fr>
FROM base AS php-cli-allinclusive
ARG VERSION
ARG OS
ARG BUILD_DATE

LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.source="https://github.com/adrien-chinour/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/adrien-chinour/dockerfiles"
LABEL org.opencontainers.image.url="https://github.com/adrien-chinour"

LABEL org.opencontainers.image.authors="Adrien Chinour <github@chinour.fr>"
LABEL org.opencontainers.image.title="php-cli-allinclusive"
LABEL org.opencontainers.image.description="PHP CLI image with commonly used extensions."
LABEL org.opencontainers.image.base.name="docker.io/library/php:$VERSION-cli-$OS"
LABEL org.opencontainers.image.version=$VERSION-$OS

RUN install-php-extensions gd intl yaml redis apcu opcache mcrypt mysqli pgsql pdo_mysql pdo_pgsql xdebug zip


# @image ghcr.io/adrien-chinour/phpstan
# @author Adrien Chinour <github@chinour.fr>
FROM php-cli-xdebug AS phpstan
ARG VERSION
ARG OS
ARG BUILD_DATE

LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.title="phpstan"
LABEL org.opencontainers.image.description="PHP CLI image with phpstan available."
LABEL org.opencontainers.image.base.name="ghcr.io/adrien-chinour/php-cli-xdebug:$VERSION-$OS"
LABEL org.opencontainers.image.version=$VERSION-$OS

ENV COMPOSER_HOME=/root/.composer
RUN composer global require phpstan/phpstan

ENTRYPOINT ["/root/.composer/vendor/bin/phpstan", "analyse", "src", "tests", "--memory-limit=-1"]
