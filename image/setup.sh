set -e

cd /var/www/html/w

LANG=ko_KR.UTF-8
export LANG

if ! mysqlshow -h db -u root --password=$MEDIAWIKI_DB_PASSWORD galkwiki >/dev/null; then
    INIT_DB=yes
else
    INIT_DB=no
fi

if ! [ -e LocalSettings.php ] || ! [ -e conf/LocalSettings.php ]; then
    INIT_CONF=yes
else
    INIT_CONF=no
fi

if [ $INIT_DB = yes ]; then
    php maintenance/install.php \
        --dbserver db --dbtype mysql --dbname galkwiki \
        --dbuser root --dbpass $MEDIAWIKI_DB_PASSWORD \
        --scriptpath "/w" \
        --installdbpass $MEDIAWIKI_DB_PASSWORD --installdbuser root \
        --lang ko --pass $MEDIAWIKI_ADMIN_PASSWORD \
        "갈퀴" Admin
    mv LocalSettings.php conf/LocalSettings.php.install
fi

if [ $INIT_CONF = yes ]; then
    SECRET_KEY=`grep 'wgSecretKey =' conf/LocalSettings.php.install | cut -c17-80`
    UPGRADE_KEY=`grep 'wgUpgradeKey =' conf/LocalSettings.php.install |cut -c18-33`
    sed -e s%@MEDIAWIKI_URL@%$MEDIAWIKI_URL%';'s%@MEDIAWIKI_DB_PASSWORD@%$MEDIAWIKI_DB_PASSWORD%';'s%@SECRET_KEY@%$SECRET_KEY%';'s%@UPGRADE_KEY@%$UPGRADE_KEY% \
        LocalSettings.php.dist > conf/LocalSettings.php
    ln -s conf/LocalSettings.php LocalSettings.php
fi

if [ $INIT_DB = yes ]; then
    php maintenance/update.php
    php extensions/FlaggedRevs/maintenance/updateAutoPromote.php
    php extensions/SemanticMediaWiki/maintenance/SMW_setup.php
fi
