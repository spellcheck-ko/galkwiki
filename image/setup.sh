set -e

cd /var/www/html

# wait for db
while ! mysqladmin ping -h db --silent; do
    sleep 1
done

LANG=ko_KR.UTF-8
export LANG

echo language is $LANG

php maintenance/install.php \
    --dbname galkwiki --dbpass password --dbserver db --dbtype mysql \
    --dbuser root \
    --scriptpath "" \
    --installdbpass password --installdbuser root \
    --lang ko --pass adminpass \
    "갈퀴" Admin

mv LocalSettings.php LocalSettings.php.install
cp LocalSettings.php.dist LocalSettings.php

php extensions/SemanticMediaWiki/maintenance/SMW_setup.php
