#Specify a base image
FROM ubuntu:18.04
WORKDIR /var/www/html/
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install apache2 -y
RUN apt-get install apache2-utils -y
RUN apt-get install -y php php-pdo php-mysqlnd php-opcache php-xml php-gd php-mysql php-intl php-mbstring php-bcmath php-json php-iconv php-soap php-zip php-curl
RUN apt-get install curl -y
RUN apt-get clean
RUN a2enmod rewrite
RUN service apache2 restart
EXPOSE 80
CMD ["apache2ctl","-D","FOREGROUND"]
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN apt-get install vim -y
COPY apache2.conf /etc/apache2/apache2.conf
RUN   sed -i "s|DocumentRoot /var/www/html|DocumentRoot /var/www/html/pub|g" /etc/apache2/sites-available/000-default.conf

COPY --chown=www-data:www-data Magento232.zip /var/www/html/
RUN apt-get update && apt-get install -y unzip
RUN unzip /var/www/html/Magento232.zip -d /var/www/html/
COPY --chown=www-data:www-data env.php /var/www/html/app/etc/
COPY --chown=www-data:www-data config.php /var/www/html/app/etc/
RUN chmod -R 777 /var/www/html/var/ /var/www/html/generated/ /var/www/html/pub/ /var/www/html/app/etc/
RUN chown -R www-data:www-data /var/www/html/app/etc/
RUN chmod -R 777 /var/www/html/app/etc/
#CMD [ "./script.sh" ]
