data "aws_security_group" "ssh" {
  id = "sg-0747026767ceec6b5"
}

resource "aws_instance" "ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = "aws_lajolla_public"
  vpc_security_group_ids = [
    "sg-0747026767ceec6b5",
    "sg-06700b3cf3acc1772"
  ]

  tags = {
    Name = "new-instance_lajolla"
  }

  # Let's create and attach an ebs volume 
  # when we create the instance
  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_type = "gp2"
    volume_size = 8
  }

  provisioner "file" {
    source      = "var.sh"
    destination = "/home/ubuntu/var.sh"
  }

  # Copy in the bash script we want to execute.
  # The source is the location of the bash script
  # on the local linux box you are executing terraform
  # from.  The destination is on the new AWS instance.
  provisioner "file" {
    source      = "providers.tf"
    destination = "/home/ubuntu/providers.tf"
  }

  provisioner "file" {
    source      = "/Users/rickymarly/.ssh/aws_lajolla"
    destination = "/home/ubuntu/aws_lajolla"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("/Users/rickymarly/.ssh/aws_lajolla")
    timeout     = "4m"
  }

  provisioner "remote-exec" {
    inline = [
      "touch hello.txt",
      "echo hello world remote provisioner >> hello.txt",
      "sudo apt update",
      "sudo apt install ansible",
      #sudo apt install ansible
      "chmod +x /home/ubuntu/var.sh",
      "bash /home/ubuntu/var.sh",
      "ansible-pull --accept-host-key -d /home/ubuntu/git --key-file=/home/ubuntu/aws_lajolla -C HEAD -U 'git@github.com:marly10/keycode.git'",
    ]
  }

  //command used to install splunk:
  //sudo apt update 
  //  /home/ubuntu/.ssh/aws_lajolla
  //sudo apt install alien
  //wget -O splunk-9.0.0.1-9e907cedecb1-linux-2.6-x86_64.rpm "https://download.splunk.com/products/splunk/releases/9.0.0.1/linux/splunk-9.0.0.1-9e907cedecb1-linux-2.6-x86_64.rpm"
  //sudo alien *.rpm
  //sudo dpkg -i package_name.deb or sudo apt install ./package_name.deb
}

