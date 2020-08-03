# DEBUGGER README (Windows)

To make use of xdebug in the docker container, you have to correctly set `xdebug.remote_host=dockershostip` in `./application/web/devconfig/php/php.ini`. On windows this is not equal to the regular ip address on the local network. It's the DockerNat also referred to as Ethernet adapter vEthernet (WSL) in ipconfig. To determine the host ip in wsl, run `hostname -I` from the terminal.

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
/application/languages (for emails)

# Social Engine Info
https://kb.scripttechs.com/creating-a-socialengine-widget/

# Release Procedure
In root dir of project:
```
sudo docker build -f ./docker/prod/dockerfile . --tag piepongwong/apache-php-se-prod:vmajor.minor
docker push piepongwong/apache-php-se-prod:vmajor:minor
docker tag digestofnewbuild piepongwong/apache-php-se-prod:latest
docker push --tag piepongwong/apache-php-se-prod:latest
ssh ubuntu@managernode -i ~/.ssh/keyfile
cd ddwd
docker pull piepongwong/apache-php-se-prod:latest
docker stack -c docker-compose.yml ddwd

run mysql migration scripts if there are any new ones
```
>>>>>>> f-specific-leave-waitinglist-form

# Create Event
/application/web/DocumentRoot/application/modules/Sesevent/controllers/IndexController.php => createAction

Form = /application/web/DocumentRoot/application/modules/Sesevent/Form/Create.php

# User auth en login status related
/application/web/DocumentRoot/application/modules/User/Api/Core.php

# Internationalization
/application/web/DocumentRoot/application/languages/en/en.php
/application/web/DocumentRoot/application/languages/nl/nl.php
s
# Joining Leaving Controllers
/application/web/DocumentRoot/application/modules/Sesevent/controllers/MemberController.php
/application/web/DocumentRoot/application/modules/Sesevent/controllers/WidgetController.php

# Activating Controller through get/post requests
url pattern: /modules/controller/action/params
example: 
/application/web/DocumentRoot/application/modules/Sesevent/widgets/profile-join-leave/index.tpl

# Create Event Flow
/application/web/DocumentRoot/application/modules/Sesevent/Form/Create.php

## For API related actions

Doesn't seems to be used
/application/modules/Sesapi/controllers/Sesevent/IndexController.php 
    createAction
    editAction

Mo `$this->view` props should be set with this style. Instead use something like 
```
  return $this->_forward('success', 'utility', 'core', array(
      'messages' => array(Zend_Registry::get('Zend_Translate')->_('Joined list')),
      'layout' => 'default-simple',
      'parentRefresh' => true,  
    ));
```
In the end.
## For Regular form related actions (Edit seems to be failing)

No distinction made between edit and create?!
/application/modules/Sesevent/controllers/IndexController.php

```
    2 => 'Attending',
    // 1 => 'Maybe Attending',
    0 => 'Not Attending',
    //3 => 'Awaiting Reply',
    5 => "Waiting List"
```

/application/web/DocumentRoot/application/modules/Sesevent/Model/Event.php

## How To Send Emails
Engine_Api::_()->getApi('mail', 'core')
Engine_Api::_()->getApi('mail', 'core')->sendSystem($user, 'nameoftemplateasindatabase', array('atemplatevariable' => "atemplatevalue, 'anothertemplatevariable' => 'anothertemplatevalue'));

### Templates
new templates are added through the database in table => `engine4_core_mailtemplates`.
For the template to take effect, you have to set it up in the admin dashboard. settings => email templates. After taking effect, Social Engine should have written entries in application/web/DocumentRoot/application/languages/en/custom.csv.

## Fetching users
    Engine_Api::_()->getDbtable('membership', 'sesevent')->getMembership(array('event_id'=>$subject->getIdentity(),'type'=>'maybeattending'));
    Engine_Api::_()->getDbtable('membership', 'sesevent')->getMembership(array('event_id'=>$event->getIdentity(),'type'=>'5'));
    Engine_Api::_()->getItem('user', $user_id);


## Form and Actions
    The same action is used for rendering AND processing the form by 
    ```
        if ($this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost())) 
    ```

## Models and Controllers
Incomplete. Methods of models seem to be callable by using $subject->nameofmethod

## Forms 
Forms have the following naming convention: ModuleName_Form_Controller_FormNameCamelCased. Example: `Sesevent_Form_Member_LeaveWaitingList`. They alos should have view.tpl in the view directory of the controller. The file should be kebab cased, for example? leave-waiting-list.tpl.