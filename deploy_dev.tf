resource "aws_instance" "web1_dev" {
    ami = "ami-0500f74cc2b89fb6b"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.sg1_dev]
    subnet_id     = aws_subnet.public-subnet.id
    associate_public_ip_address = true

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello World"
                EOF
    user_data_replace_on_change = true
}

resource "aws_instance" "web2_dev" {
    ami = "ami-0500f74cc2b89fb6b"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.sg1_dev]
    subnet_id     = aws_subnet.public-subnet.id
    associate_public_ip_address = true

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello World"
                EOF
    user_data_replace_on_change = true
}

resource "aws_instance" "web3_dev" {
    ami = "ami-0500f74cc2b89fb6b"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.sg1_dev]
    subnet_id     = aws_subnet.public-subnet.id
    associate_public_ip_address = true

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello World"
                EOF
    user_data_replace_on_change = true
}

resource "aws_security_group" "sg1_dev" {
    name = "sg1dev"
    vpc_id = aws_vpc.public-vpc.id
    ingress {
        from_port = 8080
        to_port   = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
