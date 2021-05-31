output "ec2_pub_ip" {
  value = aws_instance.ec2.public_ip
}
output "pub_subnet_1_id" {
  value = module.vpc.public_subnets[0]
}
output "pub_subnet_2_id" {
  value = module.vpc.public_subnets[1]
}
output "pri_subnet_1_id" {
  value = module.vpc.private_subnets[0]
}
output "pri_subnet_2_id" {
  value = module.vpc.private_subnets[1]
}
