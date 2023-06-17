# --- Server
FROM wordpress:6.2-php8.2-apache AS server

# --- Dependencies
RUN apt-get -qq update && \
    apt-get -qq install curl && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    php wp-cli.phar --info && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    wp --info && \
    wp plugin install jquery-manager --activate && \ 
    wp plugin install slide-anything --activate && \
    wp plugin install the-events-calendar --activate && \
    wp plugin install https://s3.theeventscalendar.com/uploads/2020/05/tribe-ext-relabeler-1.1.0.zip?extension-sidebar-checkbox=on --activate && \
    wp plugin install widget-options --activate && \
    wp plugin install wp-optimize --activate