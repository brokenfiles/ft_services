#!/bin/bash

tar -xf /www/wordpress.tar.gz --strip-components=1 -C /www
rm /www/wordpress.tar.gz
rm /www/wp-config.php
mv /tmp/wp-config.php /www

php -S 0.0.0.0:5050 -t /www