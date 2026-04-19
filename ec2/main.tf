provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "my_instance" {
  ami           = "ami-05d2d839d4f73aafb"
  instance_type = "t2.micro"
  
  associate_public_ip_address = true
  availability_zone = "ap-south-1a"

  tags = {
    Name = "ExampleInstance"
  }

  
}


output "instance_name" {
  value = aws_instance.my_instance.tags["Name"]
}

output "instance_id" {
  value = aws_instance.my_instance.id
}

output "instance_public_ip" {
  value = aws_instance.my_instance.public_ip
}