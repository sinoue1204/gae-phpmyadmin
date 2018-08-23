#!/bin/bash
sudo apt install bzip2

if [ -d phpMyAdmin ]; then
  rm -rf phpMyAdmin
fi
mkdir -p deploy/phpMyAdmin

wget https://files.phpmyadmin.net/phpMyAdmin/4.6.3/phpMyAdmin-4.6.3-all-languages.tar.bz2
tar -xvf phpMyAdmin-4.6.3-all-languages.tar.bz2 -C deploy/phpMyAdmin --strip-components=1
rm -f phpMyAdmin-4.6.3-all-languages.tar.bz2

#templateの各種設定ファイルの中身のコマンドライン入力しphpMyAdminにコピー
#touch app.yaml
cp template/app.yaml deploy

#touch config.inc.php
echo "(1) Create your secret -> http://www.question-defense.com/tools/phpmyadmin-blowfish-secret-generator"
echo -n "Then input your secret : "
read secret
echo -n "(2) Prease Input Cloud SQL instance connect name : "
read connectionstr
cat template/config.inc.php | sed "s/{{your_secret}}/$secret/" | sed "s/{{your_connection_string}}/$connectionstr/" > deploy/config.inc.php

#touch php.ini
cp template/php.ini deploy

cd deploy

gcloud components update
gcloud app deploy

cd ../