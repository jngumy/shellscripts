    #!/bin/bash

    #Ask user to enter database name and save input to dbname variable
    read -p "Please Enter Database Name:" dbname

    #ask user about username
    read -p "Please enter the username you wish to create : " username

    #ask user about allowed hostname
    read -p "Please Enter Host To Allow Access Eg: %,ip or hostname : " host

    #ask user about password
    read -p "Please Enter the Password for New User ($username) : " password

    #mysql query that will create new user, grant privileges on database with entered password
    query="CREATE DATABASE IF NOT EXISTS $dbname; GRANT ALL PRIVILEGES ON $dbname.* TO $username@`$host` IDENTIFIED BY `$password`";

    #ask user to confirm all entered data
    read -p "Executing Query : $query , Please Confirm (y/n) : " confirm

    #if user confims then
    if [ "$confirm" == 'y' ]; then

    #run query
    mysql -uroot -p -e "$query"

    #update privileges, without this new user will be created but not active
    mysql -uroot -p -e "flush privileges"

    else

    #if user didn't confirm entered data
    read -p "Aborted, Press any key to continue.."

    #just exit
    fi


   
