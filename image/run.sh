if ! [ -f /var/www/html/w/LocalSettings.php ]; then
    bash /app/setup.sh
fi
. /etc/apache2/envvars
exec apache2 -DFOREGROUND
