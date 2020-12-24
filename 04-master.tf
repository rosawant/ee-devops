



resource "aws_instance" "jenkins" {
	ami = "${lookup(var.ami, var.region)}"
	instance_type = "${var.instance_jenkins}"
	count = "${var.jenkins_count}"
	key_name      = "${var.key}"
    security_groups = ["${aws_security_group.public_sg.id}"]
	subnet_id       = "${element(aws_subnet.public_subnet.*.id, count.index + 0)}"
	root_block_device {
		volume_size = "8"
		volume_type = "gp2"
		delete_on_termination = true
	}

	provisioner "file" {
   		source      = "install.sh"
    	destination = "/tmp/install.sh"
  	}

	provisioner "file" {
   		source      = "config"
    	destination = "/tmp/"
  	}

  	provisioner "remote-exec" {
    	inline = [
			"yum install -y dos2unix",
			"dos2unix /tmp/install.sh",
	        "sudo sh /tmp/install.sh",
   	 	]
  	}

	connection {
    	user        = "centos"
		type        = "ssh"
		password    = ""
    	private_key = "${file("${var.pubkey}")}"
  	}
		tags = {
   	 		Name = "jenkins-master"
  	}
}


resource "aws_instance" "app-server" {
	ami = "${lookup(var.ami, var.region)}"
	instance_type = "${var.instance_app}"
	count = "${var.app_count}"
	key_name      = "${var.key}"
    security_groups = ["${aws_security_group.private_sg.id}"]
	subnet_id       = "${element(aws_subnet.private_subnet.*.id, count.index + 0)}"
	root_block_device {
		volume_size = "8"
		volume_type = "gp2"
		delete_on_termination = true
	}
	user_data = "${file("user_data.sh")}"
		tags = {
   	 		Name = "app-server"
  	}
}

