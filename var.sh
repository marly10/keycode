echo "Sleeping for 30 Secoonds"
sleep 30
echo "Sleept for 30 Secoonds"

sudo apt -y update
sudo apt -y upgrade
sudo apt-add-repository --yes --update ppa:ansible/ansible

sudo apt -y install ansible


sudo apt install -y yamllint
mkdir addingThings
touch addingThings/nada.txt
touch /home/ubuntu/.ssh/sshd_config 
chmod 700 /home/ubuntu/.ssh/sshd_config
cat << 'EOF' > /home/ubuntu/.ssh/sshd_config
ClientAliveInterval 120 
ClientAliveCountMax 720 
EOF
echo "this is my ansible-tf life" > addingThings/nada.txt
echo "[all]"  "localhost ansible_connection=local"  > hosts
#ansible-pull --accept-host-key -d /home/ubuntu/git --key-file=/home/ubuntu/aws_lajolla_public.pem -C HEAD -U 'git@github.com:marly10/keycode.git' -i hosts
#ansible 2.9.27

echo "The AnsiblevVersion i want ansible 2.9.27" 
ansible --version
echo "Completed Provisioning" 
ansible-pull -U https://github.com/marly10/keycode.git --key-file=/home/ubuntu/aws_lajolla_public.pem -C master file_creator.yml

