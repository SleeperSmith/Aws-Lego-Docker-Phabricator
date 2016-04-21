#!/bin/bash
openssl req -nodes -x509 -newkey rsa:4096 -days 35600 -sha256 -keyout private.key -out certificate.crt -subj "/C=AU/ST=NSW/L=Sydney/O=BitClouded/CN=phabricator.digitalent.link"
pip install pygments
ln -s /usr/lib/git-core/git-http-backend /usr/local/phabricator/support/bin/git-http-backend
./bin/storage upgrade -f
echo "www-data ALL=(daemon-user) SETENV: NOPASSWD: /usr/lib/git-core/git-http-backend, /usr/bin/hg" >> /etc/sudoers
echo "opcache.validate_timestamps=0" >> /etc/php5/apache2/php.ini
sed -i 's/post_max_size = .*/post_max_size = 50M/' /etc/php5/apache2/php.ini
a2enmod rewrite
a2enmod ssl
a2dissite 000-default
a2ensite phabricator
service apache2 restart
