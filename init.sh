#!/bin/bash

mkdir -p /home/local/storage/repos/
mkdir -p /home/local/storage/ssl/
REPO_DIR=/home/local/storage/repos/

cd /home/local/phabricator/bin/
./config set phd.user daemon-user
./config set phabricator.timezone Australia/Sydney
./config set diffusion.allow-http-auth true
./config set pygments.enabled true
./config set metamta.mail-adapter PhabricatorMailImplementationAmazonSESAdapter
./config set metamta.default-address noreply@digitalent.link
./config set amazon-ses.access-key AKIAJHWJG6VCUDAC2PVA
./config set amazon-ses.secret-key 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
./config set amazon-ses.endpoint email-smtp.us-east-1.amazonaws.com
./config set repository.default-local-path $REPO_DIR
./config set mysql.user sqladmin
./config set mysql.pass 3c148cb8-eb32-446a-a9cc-d5f55e0f22b1
./config set mysql.host ddlfjdtt695nc8.clhkkwzee0bn.ap-southeast-2.rds.amazonaws.com
./config set phabricator.base-uri "https://phabricator.digitalent.link/"
./storage upgrade -f

cd /home/local/storage/ssl/
openssl req -nodes -x509 -newkey rsa:4096 -days 35600 -sha256 -keyout private.key -out certificate.crt -subj "/C=AU/ST=NSW/L=Sydney/O=BitClouded/CN=phabricator.digitalent.link"
ln -s /usr/lib/git-core/git-http-backend /home/local/phabricator/support/bin/git-http-backend
echo "www-data ALL=(daemon-user) SETENV: NOPASSWD: /usr/lib/git-core/git-http-backend, /usr/bin/hg" >> /etc/sudoers
sed -i -e 's/;opcache.validate_timestamps=1/opcache.validate_timestamps=0/g' /etc/php5/fpm/php.ini
sed -i -e 's/post_max_size = 8M/post_max_size = 500M/g' /etc/php5/fpm/php.ini
sed -i -e 's/listen = \/var\/run\/php5-fpm.sock/listen = localhost:9000/g' /etc/php5/fpm/pool.d/www.conf
service php5-fpm restart

useradd daemon-user
mkdir /home/daemon-user
chown daemon-user /home/daemon-user
chown daemon-user $REPO_DIR -R
sudo -iu daemon-user /home/local/phabricator/bin/phd start

nginx -g "daemon off;"
