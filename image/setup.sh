set -e

cd /var/www/html/w

# wait for db
while ! mysqladmin ping -h db --silent; do
    sleep 1
done

LANG=ko_KR.UTF-8
export LANG

php maintenance/install.php \
    --dbserver db --dbtype mysql --dbname galkwiki \
    --dbuser root --dbpass $MEDIAWIKI_DB_PASSWORD \
    --scriptpath "/w" \
    --installdbpass $MEDIAWIKI_DB_PASSWORD --installdbuser root \
    --lang ko --pass $MEDIAWIKI_ADMIN_PASSWORD \
    "갈퀴" Admin

mv LocalSettings.php conf/LocalSettings.php.install
sed -e s%@MEDIAWIKI_URL@%$MEDIAWIKI_URL%';'s%@MEDIAWIKI_DB_PASSWORD@%$MEDIAWIKI_DB_PASSWORD% \
    LocalSettings.php.dist > conf/LocalSettings.php
ln -s conf/LocalSettings.php LocalSettings.php

php maintenance/update.php
php extensions/FlaggedRevs/maintenance/updateAutoPromote.php
php extensions/SemanticMediaWiki/maintenance/SMW_setup.php
