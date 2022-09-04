# cloud-init config that installs the provisioning scripts
data "local_file" "write_ssh_interval" {
  filename = "cloud-data"
}

data "local_file" "write_apt_update" {
  filename = "cloud-data-configuration"
}


data "cloudinit_config" "provision" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.local_file.write_ssh_interval.content
  }

  part {
    content_type = "text/cloud-config"
    content      = data.local_file.write_apt_update.content
  }
}

resource "aws_instance" "ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = "aws_lajolla_public"
  #user_data = data.cloudinit_config.provision.rendered

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
    source      = "/Users/rickymarly/.ssh/aws_lajolla_public.pem"
    destination = "/home/ubuntu/aws_lajolla_public.pem"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("/Users/rickymarly/.ssh/aws_lajolla_public.pem")
    timeout = "4m"
  }

  provisioner "remote-exec" {
    inline = [
      "touch hello.txt",
      "echo hello world remote provisioner >> hello.txt",
      #"sudo apt -y update",
      #"sudo apt install -y ansible",
      #"sudo apt install -y yamllint",
      
      "chmod +x /home/ubuntu/var.sh",
      "sudo bash /home/ubuntu/var.sh",
    ]
  }

 /* provisioner "local-exec" {
command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u centos --private-key ./Test-Key-1.pem -T 300 -i ${aws_instance.example.public_ip}, playbook.yml"
}*/

  //ansible-pull --accept-host-key -d /home/ubuntu/git --key-file=/home/ubuntu/aws_lajolla -C HEAD -U 'git@github.com:marly10/keycode.git' -i hosts

  //command used to install splunk:
  //sudo apt update 
  //  /home/ubuntu/.ssh/aws_lajolla
  //sudo apt install alien
  //wget -O splunk-9.0.0.1-9e907cedecb1-linux-2.6-x86_64.rpm "https://download.splunk.com/products/splunk/releases/9.0.0.1/linux/splunk-9.0.0.1-9e907cedecb1-linux-2.6-x86_64.rpm"
  //sudo alien *.rpm
  //sudo dpkg -i package_name.deb or sudo apt install ./package_name.deb

  /*
  cat << 'EOF' > /home/ubuntu/.ssh/sshd_config
ClientAliveInterval 120 
ClientAliveCountMax 720 
EOF
  */
}

