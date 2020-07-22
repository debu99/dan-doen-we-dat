provider "aws" {
  profile = "default"
  region  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
}

resource "aws_key_pair" "ddwd" {
  key_name   = "terraform"
  public_key = file("~/.ssh/terraform.pub")
}

# https://www.techrepublic.com/article/how-to-install-a-vnc-server-on-linux/
# install chromium
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
  
  depends_on = [aws_instance.ddwd]

  provisioner "remote-exec" { 
    inline = [
      "sudo apt-get update",
      "sudo apt-get install chromium-browser -y",
      "sudo apt-get update -y && sudo apt-get install xfce4 xfce4-goodies -y",
      "sudo apt-get install tightvncserver -y",
      "echo '#!/bin/bash\nxrdb $HOME/.Xresources\nstartxfce4 &' < ~/.vnc/xstartup",
      "mkdir /home/ubuntu/.vnc",
      "echo 'supersecurepw' | vncpasswd -f > /home/ubuntu/.vnc/passwd",
      "chmod 0600 /home/ubuntu/.vnc/passwd",
      "vncserver -y &",
      "sudo su",
      "sudo echo '${aws_instance.ddwd.public_ip} dandoenwedat.com' >> /etc/hosts",
      "sudo echo '${aws_instance.ddwd.public_ip} www.dandoenwedat.com' >> /etc/hosts",
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
      "sudo chmod -R 777 ~/dev-dan-doen-we-dat/DocumentRoot/temporary/{cache,log,scaffold}",
      "sudo docker stack deploy -c docker-compose.yml ddwd"
    ]
  }
}
