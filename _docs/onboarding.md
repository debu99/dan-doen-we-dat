## Access
There are different kinds of users who can be onboarded. A prospect developer needs the least amount of access, followed by a fully regular developer. Only an admin user has full access to github, AWS and other tools. Ahmd Tarsi is the owner of the project and always should have admin privileges. As of current writing, ... ....is the main developer and has admin privileges too. If you needs extra permissions, first contact the main developer and if not available, ask Ahmed. Store all the password you receive in a decent password manager.
## Prospect Developer
A prospect developer should only have read access to Github and Docker hub. The current free version of docker hub only always 1 admin user. It's advisable to go for the payed plan if budget allows it.

* Read acces to Github (Github => Manage Access => Invite teams or people => Select Read => Send Invite) This increases billing with $4/month
* Dockerhub 
     *  Login credentials: dandoenwedataws@gmail.com / password provided separately

## Regular Developer
New developers need access to the following:


* Jira 
* Write access to Github (Github => Manage Access => Invite teams or people => Select Write => Send Invite) This increases billing with $4/month
* Push access to the production branch (Github => Branches => Production (edit) => Add developer to 'Restrict who can push to matching branches')
* Dockerhub
* Live test accounts credentials 
     * admin account to be newly created in the dandoenwedat live site settings
     * test accounts like radi.schaefers@gmail.com / password provided separately
## Admin Developer
* admin access on github
* root access to aws
* root access to production mysqldb
     * whitelist ip address
* mijnhosting net
* Simple Email Service credentials
