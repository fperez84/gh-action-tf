# Might do a module later of the EC2 test code
# resource "aws_instance" "example" {
#   ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2
#   instance_type = "t3.micro"              # $0.0104/hour = ~$7.50/month

#   vpc_security_group_ids = [aws_security_group.example.id]
#   subnet_id              = data.aws_subnet.default.id

#   tags = {
#     Name = "${var.project_name}-${var.environment}-instance"
#   }
# }

# # Security group necesario
# resource "aws_security_group" "example" {
#   name_prefix = "${var.project_name}-${var.environment}-"
#   vpc_id      = data.aws_vpc.existing.id

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "${var.project_name}-${var.environment}-sg"
#   }
# }

# # Subnet por defecto
# data "aws_subnet" "default" {
#   vpc_id            = data.aws_vpc.existing.id
#   default_for_az    = true
#   availability_zone = "${var.aws_region}a"
# }
# output "ec2_instance_id" {
#   description = "ID of the EC2 instance"
#   value       = aws_instance.example.id
# }

# output "ec2_public_ip" {
#   description = "Public IP address of the EC2 instance"
#   value       = aws_instance.example.public_ip
# }

# output "ec2_private_ip" {
#   description = "Private IP address of the EC2 instance"
#   value       = aws_instance.example.private_ip
# }