#!/bin/bash

# adjust PHP settings
sed -i -e "s/post_max_size = 8M/post_max_size = ${POST_MAX_SIZE}/g" \
       -e "s/upload_max_filesize = 2M/upload_max_filesize = ${UPLOAD_MAX_FILESIZE}/g" \
       -e "s/max_execution_time = 30/max_execution_time = ${MAX_EXECUTION_TIME}/g" \
       /etc/php/7.2/apache2/php.ini

echo "placeholder" > /var/moodledata/placeholder
chown -R www-data:www-data /var/moodledata
chmod 777 /var/moodledata

read pid cmd state ppid pgrp session tty_nr tpgid rest < /proc/self/stat
trap "kill -TERM -$pgrp; exit" EXIT TERM KILL SIGKILL SIGTERM SIGQUIT

#start up cron
/usr/sbin/cron


source /etc/apache2/envvars
tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND
