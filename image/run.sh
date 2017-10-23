# wait for db
cd /var/www/html/w

while ! mysqladmin ping -h db --silent; do
    sleep 1
done

if ! mysqlshow -h db -u root --password=$MEDIAWIKI_DB_PASSWORD galkwikiki >/dev/null; then
    bash /app/setup.sh
elif ! [ -e LocalSettings.php ]; then
    if [ -e conf/LocalSettings.php ]; then
        ln -s conf/LocalSettings.php LocalSettings.php
    else
        bash /app/setup.sh
    fi
fi

. /etc/apache2/envvars
exec apache2 -DFOREGROUND
