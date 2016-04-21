#!/bin/bash
useradd daemon-user
mkdir /home/daemon-user
chown daemon-user /home/daemon-user
chown daemon-user /mnt/xvdb/ -R
sudo -iu daemon-user /usr/local/phabricator/bin/phd start