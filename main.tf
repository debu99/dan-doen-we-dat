provider "aws" {
  profile = "default"
  region  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
}

resource "aws_key_pair" "ddwd" {
  key_name   = "terraform"
  public_key = file("~/.ssh/terraform.pub")
}

resource "aws_instance" "remote-desktop"  {
  key_name      = aws_key_pair.ddwd.key_name
  ami           = "ami-0ac80df6eff0e70b5"
  instance_type = "t2.micro"
  security_groups = ["remote-desktop-vnc-viewer"]
  
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/terraform")
    host        = self.public_ip
  }
  
  provisioner "file" {
      source      = "./terraform_resources/vncserver"
      destination = "~/vncserver"
    }

 provisioner "remote-exec" { 
    inline = [
      "sudo apt-get update && sudo apt-get install --no-install-recommends ubuntu-desktop gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal gnome-core -y",
      "sudo apt-get update && sudo apt-get install vnc4server -y",
      "sudo mv ~/vncserver /usr/bin/vncserver",
      "sudo yes 'supersecurepw' | sudo vnc4server"
    ]
  }
}

resource "aws_instance" "ddwd" {
  key_name      = aws_key_pair.ddwd.key_name
  ami           = "ami-0ac80df6eff0e70b5"
  instance_type = "t2.micro"
  security_groups = ["ddwd-test-environment"]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/terraform")
    host        = self.public_ip
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.ddwd.public_ip} > ip_address.txt"
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
      "git clone -b develop git@github.com:Piepongwong/dev-dan-doen-we-dat.git",
      "sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo apt-key fingerprint 0EBFCD88",
      "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable'",
      "sudo apt-get update",
      "sudo apt-get install docker-ce docker-ce-cli containerd.io -y",
      "sudo apt-get install docker -y", 
      "sudo docker swarm init",
      "cd dev-dan-doen-we-dat",
      "sudo docker stack deploy -c docker-compose.yml ddwd"
    ]
  }
}
