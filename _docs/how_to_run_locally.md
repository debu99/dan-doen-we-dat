# How To Run Locally
Running the application consist out of roughly 3 sections.

1. Setting up docker with docker swarm and docker hub
2. Seeding the database
3. Editing your local host file

## 1. Docker, Docker Swarm and Docker Hub
Firstly, you need to have docker desktop installed. Install it from Dockerhub: 

* [https://hub.docker.com/editions/community/docker-ce-desktop-windows] windows
* [https://hub.docker.com/editions/community/docker-ce-desktop-mac] mac

Clone the repo to your system. If you are running windows, clone your project in WSL (Windows subsystem for Linux). Otherwise running the project becomes very slow, because docker has to translate the unix filesystem to the windows filessytem constantly. Now, enable docker swarm with `docker swarm init`. You can run this command from anywhere.

Now you can run `docker stack deploy -c docker/dev/docker-compose.yml ddwd` from the root directory of your project. Wait until all the services have started up. Inspect the services by running `docker service list`. At least 2 of them will have failed. You'll see something like this: ![services status](./_docs/status_services.png). A 0/1 indicates that the service is offline. Let's inspect why. Run `docker service logs ddwd_dandoenwedat`. It tells us that the image of the core application is missing. Pull it in by using `docker pull dandoenwedat/apache-php-se:dev-V1.11`. Make sure you are logged in to the correct dockerhub registery: `docker login dandoenwedat`. The password should have been provided to your separately. Consider using the docker desktop application to login. The image should remain in a private repository, because it's the core social engine code. This product is licensed and hosting it on a public repository might expose us to legal claims. Logging via the cli is flaky.

## 2. Editing your local host file
You need to edit your local host file and add the following line: `127.0.0.1 dandoenwedat.com www.dandoenwedat.com`. If you go to localhost directly, the application will crash on most pages, because it notices it it's not on the domain the social engine licence is registered on. If you want to see the real live version, you need to reverse these actions again or use a different computer.

### Mac
On mac you can do this with `sudo nano /etc/hosts`. Clear your local dns with `sudo killall -HUP mDNSResponder` after.

### Windows
On windows you need to edit the `:\Windows\System32\Drivers\etc\hosts` file with admin privileges and run `ipconfig /flushdns` in powershell afterwards. 

Consider checking if your local dns config has changed by pinging dandoenwedat: `ping dandoenwedat.com` and ping  `ping www.dandoenwedat.com`. 

Now open ** Chrome ** and go to www.dandoenwedat.com. You'll get an warning about the TSL. Ignore this by typing in `thisisunsafe` while in the warning screen of chrome. Yes, you read that correctly. Chrome is a little bit peculair in this. 

Now you'll see an error screen of the application itself. This is because the database isn't set up yet. Up to step 3!

## 3. Seeding the Local Database

You need the mysql cli client in order to complete this step. You do not necessarily need mysql server locally, but if you already have the full mysql installation, the required mysql client is included. Installation guides:

* [mysql for macos] (https://dev.mysql.com/doc/refman/8.0/en/osx-installation-pkg.html)
* [mysql for windows] (https://dev.mysql.com/doc/refman/8.0/en/windows-installation.html)
* Although not required, it will also not hurt to have have some Mysql GUI client installed, like mysql workbench.

This repo contains a copy of production database of 13 March 2021. You can use this copy to seed the database, but you might need a newer clone for recent code changes. In case you do, you need the credentials to the production database. These are not provided normally. 

In case you DO have the production credentials nad you DO need a newer clone run the following command: 
`mysqldump --column-statistics=0 -h ddwd-prod-restore-3.cf0o1nyizsus.eu-central-1.rds.amazonaws.com -u DANDOE_ROOT -p dandoe_se > ddwd_currentDay_currentMonth_currentYear.sql`

If you do have the credentials, be very careful. Faulty usage might result in destructive operations. It's advisable to make a backup first via AWS RDS. 

To seed the database run: `mysql -u root -P 3306 -h 127.0.0.1 -p dandoe_se5 < ddwd_13_march_21.sql`. The password is `root`.

Make sure the mysql service is up (`docker service list`) and that only the docker instance of MYSQL is running. If you already have a regular MySql installation installed it interferes with the Docker instance. Make sure your regular MySql installation doesn't boot on startup, restart your computer and try again.

## Final
Now you can make live changes to the code, which is in the `application` directory. You should only have to refresh the page in order for the changes to take effect. You probably one to use one of the [test acounts](./test_acounts.md)