output "jenkins_public_ip" {
  value       = "aws_instance.jenkins.public_ip"
  description = "Jenkins instance Public IP"  
}

output "app_instance_ip" {
  value       = "aws_instance.app-server.private_ip"
  description = "Jenkins instance Public IP"  
}