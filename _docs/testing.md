# Testing WIP
There are no tests yet, but some attempts were made from which could be picked up.

## E2E
The prefered E2E solution is Cypress.

## TDD
In web container run, for example:
```
phpunit --bootstrap /var/www/html/index.php /var/www/html/application/modules/Sesevent/tests/IndexControllerTest.php
```