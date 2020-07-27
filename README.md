# DEBUGGER README (Windows)

To make use of xdebug in the docker container, you have to correctly set `xdebug.remote_host=dockershostip` in `./config/php/php.ini`. On windows this is not equal to the regular ip address on the local network. It's the DockerNat also referred to as Ethernet adapter vEthernet (WSL) in ipconfig. To determine the host ip in wsl, run hostname -I.

If you want to debug .tpl files in visual code, mark them as php in the bottom left.


# Database setup
in DocumentRoot/application/settings/database.php
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

If installing of plugs on live version directly enabled chmod 777 on  application/packages. In a sensible release cycle this should not be the case though.
# Social Engine Info
https://kb.scripttechs.com/creating-a-socialengine-widget/

# Release Procedure
In root dir of project:
```
sudo docker build -f ./docker/prod/dockerfile . --tag piepongwong/apache-php-se-prod:major.minor
docker push piepongwong/apache-php-se-prod:vmajor:minor
docker tag digestofnewbuild piepongwong/apache-php-se-prod:latest
docker push --tag piepongwong/apache-php-se-prod:latest
ssh ubuntu@managernode -i ~/.ssh/keyfile
cd ddwd
docker pull piepongwong/apache-php-se-prod:latest
docker stack -c docker-compose.yml ddwd
```


# Create Event
/application/web/DocumentRoot/application/modules/Sesevent/controllers/IndexController.php => createAction

Form = /application/web/DocumentRoot/application/modules/Sesevent/Form/Create.php