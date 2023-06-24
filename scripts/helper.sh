#!/bin/bash
set -euo pipefail

#* Check if wp CLI is installed
if ! which wp 2>&1 > /dev/null; then
  echo "ERROR: Wordpress CLI is not installed or not found"
  exit 127
fi

#* Install plugins
echo "Installing plugins..."
declare -a PLUGINS_ARRAY=($WORDPRESS_PLUGINS)
for i in "${PLUGINS_ARRAY[@]}"
do
  echo "Installing Wordpress '$i' plugin..."
  wp plugin install $i --activate --allow-root
  echo "Successfully installed Wordpress '$i' plugin"
done
echo "Successfully installed all plugins"

#* Install theme
#? Only one theme is allowed
declare THEME=$WORDPRESS_THEME
echo "Installing '$THEME' theme..."
wp theme install $THEME --activate --allow-root
echo "Successfully installed Wordpress '$THEME' theme"

#* Language
#? Only one language is allowed
declare LANG=$WORDPRESS_LANGUAGE
echo "Installing '$LANG' language package..."
wp language core install $LANG --allow-root
wp site switch-language $LANG --allow-root
echo "\$wp_local_package = '$LANG';" >> wp-includes/version.php
echo "Successfully installed '$LANG' language"

#* Misc. extensions
#? i.e. non-catalogued plugin extenisions
declare EXTENSIONS=($WORDPRESS_EXTENSION_LINKS)
for i in "${!EXTENSIONS[@]}"
do
  echo "Installing extension n°$i from link: '${EXTENSIONS[$i]}'"
  declare extname=ext_$i.zip
  wget -O $extname "${EXTENSIONS[$i]}"
  wp plugin install ./$extname --activate --allow-root
  rm -f $extname
  echo "Successfully installed extension n°$i"
done

#* Change permissions
chown -R www-data:www-data /var/www/html

#* Start server
exec apache2-foreground