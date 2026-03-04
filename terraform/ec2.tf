# # ec2.tf - TEST FILE: Intentional security issues for Snyk demo

# resource "aws_instance" "example" {
#   ami           = "ami-0c02fb55956c7d316"
#   instance_type = "t3.micro"

#   vpc_security_group_ids = [aws_security_group.example.id]
#   subnet_id              = data.aws_subnet.default.id

#   # ❌ ISSUE 1: Metadata service v1 habilitado (IMDSv1)
#   # Snyk: SNYK-CC-TF-130 - permite SSRF attacks para robar credenciales IAM
#   metadata_options {
#     http_endpoint               = "enabled"
#     http_tokens                 = "optional" # Debería ser "required" (IMDSv2)
#     http_put_response_hop_limit = 2          # Debería ser 1
#   }

#   # ❌ ISSUE 2: Volumen root sin encriptación
#   # Snyk: SNYK-CC-TF-2 - datos en reposo sin cifrar
#   root_block_device {
#     volume_size = 20
#     encrypted   = false # Debería ser true
#   }

#   tags = {
#     Name = "${var.project_name}-${var.environment}-instance"
#   }
# }

# resource "aws_security_group" "example" {
#   name_prefix = "${var.project_name}-${var.environment}-"
#   vpc_id      = data.aws_vpc.existing.id

#   # ❌ ISSUE 3: Ingress abierto a todo el mundo en SSH (puerto 22)
#   # Snyk: SNYK-CC-TF-1 - expone SSH públicamente
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Debería ser tu IP o un CIDR restringido
#   }

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
