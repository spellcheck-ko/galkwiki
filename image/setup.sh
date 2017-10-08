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
    sed -e s%@MEDIAWIKI_URL@%$MEDIAWIKI_URL%';'s%@MEDIAWIKI_DB_PASSWORD@%$MEDIAWIKI_DB_PASSWORD% \
        LocalSettings.php.dist > conf/LocalSettings.php
    ln -s conf/LocalSettings.php LocalSettings.php
fi

if [ $INIT_DB = yes ]; then
    php maintenance/update.php
    php extensions/FlaggedRevs/maintenance/updateAutoPromote.php
    php extensions/SemanticMediaWiki/maintenance/SMW_setup.php
fi
