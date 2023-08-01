resource "aws_vpc" "new_vpc" {
    cidr_block = var.vpc_cidr
    
    tags = {
        Name = "new_vpc"
    }
}

resource "aws_subnet" "public_subnet" {
    cidr_block = var.subnet_cidr
    vpc_id = aws_vpc.new_vpc.id
    tags = {
        Name = "public_subnet"
    }
    depends_on = [
        aws_vpc.new_vpc
    ]
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.new_vpc.id
    tags = {
        Name = "igw1"
    }

    depends_on = [
        aws_subnet.public_subnet
    ]
}

resource "aws_route_table" "public_route" {
    vpc_id = aws_vpc.new_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "Public_route"
    }
    depends_on = [
        aws_internet_gateway.igw
    ]

}

resource "aws_route_table_association" "association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route.id
    depends_on = [ 
        aws_route_table.public_route
    ]
}

resource "aws_security_group" "opensshandtomcatport" {
    vpc_id = aws_vpc.new_vpc.id
    ingress {
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
    }
    ingress {
        from_port = 8080
        to_port = 8080
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
    }
    egress {
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "-1"
    }

    tags = {
        Name = "sshandtomcat"
    }
    depends_on = [
        aws_route_table_association.association
    ]
   
}