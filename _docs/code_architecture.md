
# Code Architecture WIP
Dandoenwedat is build on [social engine php platform](https://www.socialengine.com). Social engine is itself based on the Zend Framework 1.12, which is a php MVC framework. Social engine works with a plugin architecture, of which we have several. The most important ones are of [social apps](https://socialapps.tech/). Starting from august 2020 a lot of custom features have been implemented. This makes updating and the installation of new plugins non trivial. Most changes have been made to the SES Events plugin and the Payment Gateway plugin.

There are lot's of .tpl files. This is a php templating language, but it's functionalities are hardly used. If you tell VSCode that it's php you get proper syntax highlighting.

## New Php packages

### Php settings
## MCV Pattern in SE WIP

## Plugin Installation
New plugins can still be installed, but not on production directly (contrary to the descriptions in installation guides of the plugins). You have to install the plugins locally first and push the changes just like regular feature changes. Plugins often heavily changes the Mysql schema. **Make a backup of the database before you push to production**. This can be done the easiest via AWS RDS. Contact Ahmed or the main developer  Updates are less likely to go well, because of the custom changes on many different areas, but it could be tried controlled by first trying them out locally as well.