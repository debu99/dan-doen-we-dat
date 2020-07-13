# DEBUGGER README (Windows)

To make use of xdebug in the docker container, you have to correctly set `xdebug.remote_host=dockershostip` in `./config/php/php.ini`. On windows this is not equal to the regular ip address on the local network. It's the DockerNat also referred to as Ethernet adapter vEthernet (WSL) in ipconfig. To determine the host ip in wsl, run hostname -I.

# Database setup
host: database
username: root
password: root
msyqldatabase: tobecreatedbyyou

# Dev login info
admin email: j.tonneyck@gmail.com
admin password: DanDoenWeDat!1

# Admin
Go to http://www.dandoenwedat.com/install/manage manually to lookup plugins

# Permissions
You must set the permissions (CHMOD) of the following directories and files to 777:
/install/config/ (recursively; all directories and files contained within this must also be changed)
/temporary/ (recursively; all directories and files contained within this must also be changed)
/public/ (recursively; all directories and files contained within this must also be changed)
/application/themes/ (recursively; all directories and files contained within this should also be changed)
/application/packages/ (recursively; all directories and files contained within this should also be changed)
/application/languages/ (recursively; all directories and files contained within this must also be changed)
/application/settings/ (recursively; all files contained within this must also be changed)