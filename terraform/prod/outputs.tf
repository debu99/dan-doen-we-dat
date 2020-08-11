output "s3_bucket_name" {
    value = aws_s3_bucket.ddwd.bucket_domain_name
}

output "ec2_ip_addresses" {
    value = [aws_instance.ddwd.*.public_ip]
}

output "mysql_db_host" {
    value = aws_db_instance.ddwd.address
}