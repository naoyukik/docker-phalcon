#!/usr/bin/env bash

# Exit the script if any statement returns a non-true return value
set -e

if [ "x${XDEBUG_REMOTE_PORT}" != "x" ]; then
    sed -i -e "s/xdebug.remote_port[ \t]*=[ \t]*\(.*\)$/xdebug.remote_port = ${XDEBUG_REMOTE_PORT}/g" \
        /usr/local/etc/php/conf.d/xdebug.ini
fi

if [ "x${XDEBUG_REMOTE_AUTO_START}" != "x" ]; then
    sed -i -e "s/xdebug.remote_autostart[ \t]*=[ \t]*\(.*\)$/xdebug.remote_autostart = ${XDEBUG_REMOTE_AUTO_START}/g" \
        /usr/local/etc/php/conf.d/xdebug.ini
fi

if [ "x${XDEBUG_REMOTE_ENABLE}" != "x" ]; then
    sed -i -e "s/xdebug.remote_enable[ \t]*=[ \t]*\(.*\)$/xdebug.remote_enable = ${XDEBUG_REMOTE_ENABLE}/g" \
        /usr/local/etc/php/conf.d/xdebug.ini

    # Setting XDEBUG_REMOTE_ENABLE=1 will enable xdebug
    case $XDEBUG_REMOTE_ENABLE in
        "1"|"on"|"On"|"ON"|"true"|"True"|"TRUE")
            sed -i -e "s/^;zend_extension=xdebug.so$/zend_extension=xdebug.so/g" \
                /usr/local/etc/php/conf.d/xdebug.ini
            ;;
        "0"|"off"|"Off"|"OFF"|"false"|"False"|"FALSE")
            sed -i -e "s/^zend_extension=xdebug.so$/;zend_extension=xdebug.so/g" \
                /usr/local/etc/php/conf.d/xdebug.ini
            ;;
    esac
fi

# Enable xdebug if XDEBUG_REMOTE_HOST is defined
if [ "x${XDEBUG_REMOTE_HOST}" != "x" ]; then
    if [ ${XDEBUG_REMOTE_HOST} == "auto" ]; then
    export XDEBUG_REMOTE_HOST=$(/sbin/ip route|awk '/default/ { print $3 }')
    fi

    sed -i -e "s/xdebug.remote_host[ \t]*=[ \t]*\(.*\)$/xdebug.remote_host = ${XDEBUG_REMOTE_HOST}/g" \
        /usr/local/etc/php/conf.d/xdebug.ini
fi
