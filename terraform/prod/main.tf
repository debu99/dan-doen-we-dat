provider "aws" {
  profile = "default"
  region  = var.AWS_REGION
  shared_credentials_file = "~/.aws/credentials"
}

resource "aws_key_pair" "ddwd" {
  key_name   = "terraform-prod"
  public_key = file("~/.ssh/terraform.pub")
}

resource "aws_db_instance" "ddwd" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "dandoe_se5"
  username             =  var.DB_USER # use the same user as in .db.env
  password             =  var.DB_PASSWORD # use the same password as in .db.env
  parameter_group_name = "default.mysql5.7"
  publicly_accessible  = true
  skip_final_snapshot = true
  final_snapshot_identifier = "ddwd"
  tags = {
    Name = "ddwd-prod"
  }

  provisioner "local-exec" {
    command = "echo '\nMYSQL_HOST=${aws_db_instance.ddwd.address}' >> ../../environment/prod/.db.env"
  }
}

resource "random_id" "id" {
	  byte_length = 8
}

resource "aws_s3_bucket" "ddwd" {
  bucket = "ddwd-prod-${random_id.id.hex}"
  acl    = "public-read"

  tags = {
    Name        = "ddwd public dir"
    Environment = "prod"
  }
  
  provisioner "local-exec" {
    command = "echo '\ns3_public_bucket=${aws_s3_bucket.ddwd.bucket_domain_name}' >> ../../environment/${var.ENVIRONMENT}/.s3.env"
  }
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "BucketPolicy",
    "Statement": [
        {
            "Sid": "AllAccess",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": [
                "arn:aws:s3:::ddwd-prod-${random_id.id.hex}",
                "arn:aws:s3:::ddwd-prod-${random_id.id.hex}/*"
            ]
        }
    ]
}
POLICY

}

resource "aws_iam_role" "ec2_s3_access" {
  name = "ddwd_ec2_s3_access"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_role_policy" "s3_bucket_policy" {
  name = "ddwd_full_bucket_access"
  role = aws_iam_role.ec2_s3_access.id
  depends_on = [aws_s3_bucket.ddwd]

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.ddwd.arn}",
        "${aws_s3_bucket.ddwd.arn}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_s3_role" {
  name = "ec2-s3-access"
  role = aws_iam_role.ec2_s3_access.name
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "ec2" {
  name = "ddwd-ec2-sg"

  description = "EC2 security group (terraform-managed)"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    description = "MySQL"
    cidr_blocks = [aws_default_vpc.default.cidr_block]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Telnet"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "HTTPS"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ddwd" {
  key_name      = aws_key_pair.ddwd.key_name
  ami           = "ami-0668176b7d648cc1c"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2.id]
  
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_role.name
  depends_on = [aws_db_instance.ddwd , aws_s3_bucket.ddwd]
  tags = {
    Name = "ddwd-prod-web-node"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/terraform")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "../../environment/${var.ENVIRONMENT}"
    destination = "~/environment"
  }

  provisioner "file" {
    source      = "../../docker/${var.ENVIRONMENT}/docker-compose.yml"
    destination = "~/docker-compose.yml"
  }

  provisioner "file" {
    source      = "./terraform_resources/known_hosts"
    destination = "~/.ssh/known_hosts"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "chmod 400 ~/.ssh/id_rsa",
      "sudo echo 'local_ip=${self.public_ip}' >> ~/environment/prod/.env",
      "sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo apt-key fingerprint 0EBFCD88",
      "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable'",
      "sudo apt-get update -y",
      "sudo apt-get install docker-ce docker-ce-cli containerd.io -y",
      "curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'",
      "sudo apt install unzip -y",
      "unzip awscliv2.zip",
      "sudo ./aws/install",
      "sudo rm awscliv2.zip",
      "echo '*/15 * * * * root /usr/local/bin/aws s3 sync /home/ubuntu/public s3://${aws_s3_bucket.ddwd.id}/public' >> ~/s3awspublicsync",
      "sudo mv ~/s3awspublicsync /etc/cron.d/",
      "sudo chown root:root /etc/cron.d/s3awspublicsync",
      "sudo chmod 644 /etc/cron.d/s3awspublicsync",
      "mkdir public",
      "mkdir languages",
      "mkdir letsencrypt",
      "sudo chmod -R 777 public",
      "sudo chmod -R 777 languages",
      "sudo docker swarm init",
      "echo '${var.DOCKER_PASSWORD}' | sudo docker login --username piepongwong --password-stdin",
      "sudo docker pull piepongwong/apache-php-se-prod:latest",
      "sudo docker stack deploy -c docker-compose.yml ddwd"
    ]
  }
}

resource "aws_route53_zone" "ddwd" {
  name = "dandoenwedat.com.com"
}

resource "aws_route53_record" "ddwd-www" {
  zone_id = aws_route53_zone.ddwd.zone_id
  name    = "www.dandoenwedat.com"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.ddwd.public_ip]
}

resource "aws_route53_record" "ddwd" {
  zone_id = aws_route53_zone.ddwd.zone_id
  name    = "dandoenwedat.com"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.ddwd.public_ip]
}

resource "aws_route53_record" "ddwd-all" {
  zone_id = aws_route53_zone.ddwd.zone_id
  name    = "*.dandoenwedat.com"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.ddwd.public_ip]
}