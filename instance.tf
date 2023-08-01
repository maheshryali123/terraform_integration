resource "aws_instance" "tomcat" {
    ami = "ami-053b0d53c279acc90"
    associate_public_ip_address = true
    key_name = "newkey"
    instance_type = "t2.micro"
    availability_zone = "us-east-1d"
    subnet_id = aws_subnet.public_subnet.id
    vpc_security_group_ids = [aws_security_group.opensshandtomcatport.id]
}

resource "null_resource" "scripttorun" {
    provisioner "remote-exec" {
        connection {
            type = "ssh"
            user = "ubuntu"
            private_key = file("/home/ubuntu/.ssh/authorized_keys")
            host = aws_instance.tomcat.public_ip
        }
        inline = [
            "sudo apt update",
            "sudo apt install tomcat9 -y"
        ]
    }
}