## Release Procedure Summary
We are relying on docker, docker swarm, dockerhub, circleci, aws and Terraform. The code is deployed in a CI/CD fashion. Every push to production triggers a deployment pipeline in circle ci. You can find the configuration of this pipeline in the `.circleci` directory. Circle ci first builds a docker image and pushes it to the dockerhub image registery. Afterwards it logs in on the AWS EC2 instance, pulls in the new image and updates the docker swarm configuration to use it. The main advantages for this strategies are:

* Minimal downtime
* Versioned releases that are easy to roll back in case of bugs
* Predictable deployments
* Relatively easy extensability to a staging environment and scalability
 
Social Engine is by default installed on a single monolithic server on which code changes are file based using using something like Filezilla. This doesn't work well with short release cycles, isn't scalable and has very limited rollback functionalities. It also makes it very hard to set up different environments, like a local one. You might find some references to this old style deployment online, but this is not how it's used on this project.

## Docker Swarm
The application runs in a docker swarm cluster. It uses a mysql, php-apache-socialengine and a traefik image. The traefik image is a reverse proxy that's mainly utitlized for the SSL encryption. The mysql image is only used locally. In production a AWS Rds instance is used because it's easier to create automatic backups and more stable.

## MySQL Migration Scripts
Every change to the schema has to be made through migrations scripts. Include a rollback script as well. Give the migrations scripts a sequence number so that we know in which order to run them. As it is know, the sequence numbers are between parentheses. 

## Deployment Architecture Summary
The infrastructure is managed by Terraform in a infrastructure as code fashion. New resources should be added through the configuration and not through the AWS console directly. If changes to the infrastructure are made in AWS directly, new updates through Terraform may overwrite those. You can find the Terraform configuration the `terraform` directory. The dev sub directory isn't currently used, but could be used later to set up a staging environment. The configuration is self documenting, but a couple of pointers are given. The infrastructre uses a single EC2 micro instance, a Mysql micro RDS instance and a S3 Storage bucket. The domain is registered at http://mijn.hostnet.nl, but the nameservers of AWS are used through Route53. Dandoenwedat is also using the Simple Emadil Service (SES) for transaction emails, but SES is not provisioned by Terraform. It should have been though. The credentials to AWS and related solutions are provided on a on needed basis.

### Old Manual Release Procedure
This is legacy, but might be needed in case the pipeline breaks.

In root dir of project:
```
sudo docker build -f ./docker/prod/dockerfile . --tag piepongwong/apache-php-se-prod:vmajor.minor --tag piepongwong/apache-php-se-prod:latest
docker push piepongwong/apache-php-se-prod:vmajor:minor
docker push piepongwong/apache-php-se-prod:latest
ssh ubuntu@managernode -i ~/.ssh/keyfile //ssh ubuntu@54.93.127.176 -i ~/.ssh/terraform
sudo su
docker pull piepongwong/apache-php-se-prod:latest
docker stack deploy -c docker-compose.yml ddwd
run mysql migration scripts if there are any new ones

---

for circle ci setup
docker pull piepongwong/apache-php-se-prod:latest
docker service update ddwd_dandoenwedat
docker image prune
```