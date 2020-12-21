# ee-demo-tf

# Pre-Requisite:
1. Create own ssh key for login.(e.g demo.pem)
2. Update "env.tfvars" 

# Terraform will create below resources after execution
1. Create VPC With private and public subnet with igw and nat gateway
2. Create one jenkins master instance (Public Subnet) and one app server(private Subnet)
3. Install Jenkins and ansible on jenkins master

# Steps to execute
```
terraform apply --var-file="env.tfvars"
```

# Validation:
1. Jenkins will run on http://public_ip:8080/
2. Create jenkins job uding Jenkinsfile present under config/

