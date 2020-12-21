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
 Copy config/deploy.yml to jenkins server
 Add demo.pub under ~/.ssh/demo.pub with persmission 0600
 Add app server host to /etc/ansible/hosts
 ```
 [app-server]
 <app-server-ip>
 ```

# Validation:
1. Jenkins will run on http://public_ip:8080/
2. Create jenkins job uding Jenkinsfile present under config/
3. Build job- it will run maven build, unit tests and jar will be deployed using ansible 

