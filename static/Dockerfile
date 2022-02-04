FROM nginx:1.21

COPY --chown=nginx:nginx ./ /usr/share/nginx/html

EXPOSE 80

CMD nginx -g "daemon off;"