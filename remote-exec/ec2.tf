resource "aws_instance" "app" {
  ami = "ami-0f3c7d07486cad139"
  vpc_security_group_ids = [aws_security_group.practicetf.id]
  instance_type = "t2.micro"
  tags = {
    Name = "my_instance"
  }
  connection {
    type     = "ssh"
    user     = "centos"
    password = ""
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "echo 'this is text file' > /tmp/sample.txt",
      "ls -l /tmp/",
      "sudo yum install nginx -y",
      "sudo systemctl start nginx"
    ]
    }
}


resource "aws_security_group" "practicetf" {
  name        = "practice_sg"
  tags = {
    Name = "practice_sg"
  }

  ingress {
    description = "Allow ssh port"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }
  
  ingress {
    description = "Allow nginx port"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }
}
