output "instance_id" {
  value = aws_instance.this.id
}

output "ami_id" {
  value = data.aws_ami.amazon_linux_2.id
}

output "private_dns" {
  value = aws_instance.this.private_dns
}

output "private_ips" {
  value = {
    for k, v in data.aws_network_interface.eni : k => v.private_ip
  }
}
