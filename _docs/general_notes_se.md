# General Notes Social Engine

## Database setup
in DocumentRoot/application/settings/database.php
host: database
username: root
password: root
msyqldatabase: tobecreatedbyyou

## Dev login info
admin email: j.tonneyck@gmail.com
admin password: DanDoenWeDat!1

# #Admin
Go to http://www.dandoenwedat.com/install/manage manually to lookup plugins

## Permissions
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

## Social Engine Info
https://kb.scripttechs.com/creating-a-socialengine-widget/


## Create Event
/application/web/DocumentRoot/application/modules/Sesevent/controllers/IndexController.php => createAction
Form = /application/web/DocumentRoot/application/modules/Sesevent/Form/Create.php

## User auth en login status related
/application/web/DocumentRoot/application/modules/User/Api/Core.php

## Internationalization
/application/web/DocumentRoot/application/languages/en/en.php
/application/web/DocumentRoot/application/languages/nl/nl.php

## Joining Leaving Controllers
/application/web/DocumentRoot/application/modules/Sesevent/controllers/MemberController.php
/application/web/DocumentRoot/application/modules/Sesevent/controllers/WidgetController.php

## Activating Controller through get/post requests
url pattern: /modules/controller/action/params
example: 
/application/web/DocumentRoot/application/modules/Sesevent/widgets/profile-join-leave/index.tpl

## Create Event Flow
/application/web/DocumentRoot/application/modules/Sesevent/Form/Create.php

### For API related actions

Doesn't seems to be usedf
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
### For Regular form related actions (Edit seems to be failing)

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

#### Templates
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

## Adding Translations
If a fully new translation is added through the language manager, it's first added to custom.csv. Only after regenerating the php arrays it's added in the respective en.php en nl.php. You can do this by going to https://www.dandoenwedat.com/admin/core/settings/performance, ticket the translation performance box and save.

## Privacy Lastname

The first and last name do not exist separately in the database. Only the full name exists, which is called displayname. Whether the displayname, username or only the lastname is shown, is calculated by 'userModelInstance'->getTitle(). The first and lastname do exist as fields. All direct references to display name should be replaced by getTitle. 

It would be more performant to have the first and lastname as separate columns in the database. The same goes for the privacy setting regarding the last name. 

usefull function: `$fieldValues = Engine_Api::_()->fields()->getFieldsValuesByAlias($this);`

The privacy is set by admin page=>settings=>profile questions=>edit Last Name=>setting everything on hide.
## Social Engine Plugin Installation Process
1. Install the core libraries via the free Core Plugin
2. Don't install the plugin yet, but go to the SocialApps.tech Core Plugin admin page=>Login with your SEAO credentials=>Upgrade
3. Now install the plugin. The link in the second last screen doesnt work. Fish out the url with dev tools and open in a new tab. Keep the other tab open.
4. The continue button will fail too. Go back to the previous tab and refresh.

# Payment implementation strategies:
Figure out the plugin checkout flow through subscription and tickets with paypal
Implement stripe

Use an existing plugin and customize it.

## Stripe checkout flows
https://stripe.com/docs/legacy-checkout
https://stripe.com/docs/payments/accept-a-payment?integration=elements
https://support.stripe.com/questions/using-metadata-with-checkout-sessions

stripe listen --skip-verify --forward-to https://dandoenwedat.com/sesadvpmnt/payment/newstripefulfill/route/default/type/sesevent_order/order_id/dummy/gateway_id/dummy
## Payment Gateways
https://www.dandoenwedat.com/events/order/success/some-test-event-no-101/state/active/order_id/65
