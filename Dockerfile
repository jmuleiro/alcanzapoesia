#* --- Helper container
#? This container is meant to run as a sidecar to the Wordpress container.
#? With a shared volume, this sidecar shall install all plugins and themes.
#? After installing all required packages, the container can exit w/ exit code 0.
FROM wordpress:6.2-php8.2-apache AS helper

#* --- Configuration
ENV WORDPRESS_PLUGINS="jquery-manager slide-anything the-events-calendar widget-options wp-optimize"
ENV WORDPRESS_THEME="maxwell"
ENV WORDPRESS_LANGUAGE="es_AR"
ENV WORDPRESS_EXTENSION_LINKS=""
ENV HOME=/var/www/html
WORKDIR ${HOME}

#* --- Dependencies
RUN apt-get -qq update&& \
    apt-get -qq install curl wget && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    php wp-cli.phar --info && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    wp --info

#* --- Entrypoint script
COPY scripts/helper.sh /usr/local/bin/helper.sh
RUN chmod +x /usr/local/bin/helper.sh && \
    sed -i 's/^exec.*$//g' $(which docker-entrypoint.sh) && \
    docker-entrypoint.sh apache2-foreground
ENTRYPOINT [ "/bin/bash", "-c" ]
CMD [ "helper.sh" ]