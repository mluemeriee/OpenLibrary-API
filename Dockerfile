FROM php:8.3-apache

# Switch Apache to listen on port 10000 (required for platforms like Render)
RUN sed -i 's/Listen 80/Listen 10000/' /etc/apache2/ports.conf \
 && sed -i 's/<VirtualHost \*:80>/<VirtualHost *:10000>/' /etc/apache2/sites-enabled/000-default.conf

# Copy your PHP app as the default index page
COPY API.php /var/www/html/index.php

EXPOSE 10000