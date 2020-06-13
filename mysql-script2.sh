#!/bin/bash

echo "mysql root password:"
read rootpass

if [[ $rootpass ]]; then
    # create db
    # create user
    mysql -uroot -p$rootpass <<EOF
CREATE DATABASE \`${1}\`;
CREATE USER $2@localhost IDENTIFIED BY '$3';
GRANT ALL PRIVILEGES ON \`${1}\`.* TO \`${2}\`@'localhost';
EOF

fi
