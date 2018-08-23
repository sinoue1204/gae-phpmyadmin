#!/bin/bash
sudo apt install bzip2

if [ -d phpMyAdmin ]; then
  rm -rf phpMyAdmin
fi
mkdir phpMyAdmin

wget https://files.phpmyadmin.net/phpMyAdmin/4.6.3/phpMyAdmin-4.6.3-all-languages.tar.bz2
tar -xvf phpMyAdmin-4.6.3-all-languages.tar.bz2 -C phpMyAdmin --strip-components=1
rm -f phpMyAdmin-4.6.3-all-languages.tar.bz2

#templateの各種設定ファイルの中身のコマンドライン入力しphpMyAdminにコピー
#touch app.yaml
cp template/app.yaml phpMyAdmin

#touch config.inc.php
echo "(1) Create your secret -> http://www.question-defense.com/tools/phpmyadmin-blowfish-secret-generator"
echo -n "Then input your secret : "
read secret
echo -n "(2) Prease Input Cloud SQL instance connect name : "
read connectionstr
cat template/config.inc.php | sed "s/{{your_secret}}/$secret/" | sed "s/{{your_connection_string}}/$connectionstr/" > phpMyAdmin/config.inc.php

#touch php.ini
cp template/php.ini phpMyAdmin

cd phpMyAdmin

gcloud init

#sudo apt-get update && sudo apt-get --only-upgrade install kubectl google-cloud-sdk google-cloud-sdk-app-engine-grpc google-cloud-sdk-pubsub-emulator google-cloud-sdk-app-engine-go google-cloud-sdk-cloud-build-local google-cloud-sdk-datastore-emulator google-cloud-sdk-app-engine-python google-cloud-sdk-cbt google-cloud-sdk-bigtable-emulator google-cloud-sdk-app-engine-python-extras google-cloud-sdk-datalab google-cloud-sdk-app-engine-java

gcloud components update
gcloud app deploy

cd ../