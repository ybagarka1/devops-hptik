output "ec2_pubic_ip" {
  value = "${aws_instance.hptik_web.associate_public_ip_address}"
}

output "db_server_address" {
  value = "${aws_db_instance.hptik_rds.address}"
}

output "web_server_address" {
  value = "${aws_instance.hptik_web.public_dns}"
}
