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
sudo docker build -f ./docker/prod/dockerfile . --tag piepongwong/apache-php-se-prod:vmajor.minor --tag piepongwong/apache-php-se-prod:latest
docker push piepongwong/apache-php-se-prod:vmajor:minor
docker push piepongwong/apache-php-se-prod:latest
ssh ubuntu@managernode -i ~/.ssh/keyfile
sudo su
docker pull piepongwong/apache-php-se-prod:latest
docker stack deploy -c docker-compose.yml ddwd

run mysql migration scripts if there are any new ones
```

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

## TDD
In web container run, for example:
```
phpunit --bootstrap /var/www/html/index.php /var/www/html/application/modules/Sesevent/tests/IndexControllerTest.php
```

## Profile Fields
Most profile fields are dynamically set through 
/application/web/DocumentRoot/application/modules/Fields/views/helpers/AdminFieldMeta.php in 
`dandoe_se5`.`engine4_user_fields_meta` and `dandoe_se5`.`engine4_user_fields_values`

$db = Engine_Db_Table::getDefaultAdapter();

$birthDate = $db->select()
            ->from('engine4_user_fields_meta')
            ->where('type = ?', 'birthdate')
            ->query()
            ->fetch(); 
$birthDateFieldId = $birthDate['field_id'];

$birthDayUser = $db->select()
            ->from('engine4_user_fields_values')
            ->where('item_id = ?', 1) // user_id
             ->where('field_id = ?', 6) // field_id
            ->query()
            ->fetch();


## TODO
Clean up code duplication in Event.php and member/indexController ageCategories

## Upload Cover Photo
https://www.dandoenwedat.com/user/coverphoto/upload-cover-photo/user_id/14/photoType/profile
https://uifaces.co/

        $this->setCoverPhoto($form->Filedata, null, $level_id);
https://framework.zend.com/manual/1.12/en/zend.test.phpunit.html


_version3PasswordCrypt

/home/piepongwong/dev-dan-doen-we-dat/application/web/DocumentRoot/application/modules/User/Form/Signup/Account.php


/home/piepongwong/dev-dan-doen-we-dat/application/web/DocumentRoot/application/modules/User/controllers/SignupController.php
12345Abc@


 https://www.dandoenwedat.com/user/auth/reset/code/5wxmrohg61c80084so04kgckc/uid/17

Modules Permissions
drwxr-xr-x piepongwong piepongwong

## MYSQL Migration Scripts
mysqldump --column-statistics=0 -h prodhost -u DANDOE_ROOT -p dandoe_se > ddwd.sql
mysql -u root -P 3306 -h 127.0.0.1 -p dandoe_se5 < ddwd.sql