if ! [ -f /var/www/html/LocalSettings.php ]; then
    bash /setup.sh
fi
. /etc/apache2/envvars
exec apache2 -DFOREGROUND
