provider "aws" {
  profile = "default"
  region  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
}

resource "aws_key_pair" "ddwd" {
  key_name   = "terraform"
  public_key = file("~/.ssh/terraform.pub")
}

resource "aws_db_instance" "ddwd" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "dandoe_se"
  username             =  var.DB_USER # use the same user as in .db.env
  password             =  var.DB_PASSWORD # use the same password as in .db.env
  parameter_group_name = "default.mysql5.7"
  publicly_accessible  = true
  vpc_security_group_ids  = ["sg-0d12b65d9d5f6dc21"]
  
  tags = {
    Name = "ddwd-prod"
  }

  provisioner "local-exec" {
    command = "echo '\ndb_host=${aws_db_instance.ddwd.address}' >> .db.env"
  }
}

resource "aws_instance" "ddwd" {
  key_name      = aws_key_pair.ddwd.key_name
  ami           = "ami-0ac80df6eff0e70b5"
  instance_type = "t2.micro"
  security_groups = ["ddwd-web-prod-environment"]
  depends_on = [aws_db_instance.ddwd]
  tags = {
    Name = "ddwd-prod-web-node"
  }

  iam_instance_profile  = "my-role"

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/terraform")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = ".db.env"
    destination = "~/.env"
  }

  provisioner "file" {
    source      = ".s3.env"
    destination = "~/.s3.env"
  }

  provisioner "file" {
    source      = "~/.ssh/ec2-github-access"
    destination = "~/.ssh/id_rsa"
  }

  provisioner "file" {
    source      = "./terraform_resources/known_hosts"
    destination = "~/.ssh/known_hosts"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "chmod 400 ~/.ssh/id_rsa",
      "sudo apt-get install git -y",
      "git clone -b production git@github.com:Piepongwong/dev-dan-doen-we-dat.git ddwd",
      "mv ~/.db.env ~/dev-dan-doen-we-dat/.db.env",
      "mv ~/.s3.env ~/dev-dan-doen-we-dat/.s3.env",
      "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable'",
      "sudo apt-get update",
      "sudo apt-get install docker-ce docker-ce-cli containerd.io -y",
      "sudo apt-get install docker -y", 
      "sudo docker swarm init",
      "curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'",
      "sudo apt install unzip -y",
      "unzip awscliv2.zip",
      "sudo ./aws/install",
      "rm awscliv2.zip",
      "cd ~/dev-dan-doen-we-dat",
      "echo '*/10 * * * * root aws s3 sync /home/ubuntu/ddwd/DocumentRoot/public s3://dandoenwedat-prod/public' >> /etc/cron.d/s3_aws_public_sync",
      "sudo docker stack deploy -c docker-compose-prod.yml ddwd"
    ]
  }
}


