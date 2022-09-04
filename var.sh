echo "Sleeping for 30 Secoonds"
sleep 30
echo "Sleept for 30 Secoonds"

sudo apt -y update
sudo apt install -y ansible
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
echo "localhost ansible_connection=local"  > hosts
#ansible-pull --accept-host-key -d /home/ubuntu/git --key-file=/home/ubuntu/aws_lajolla_public.pem -C HEAD -U 'git@github.com:marly10/keycode.git' -i hosts
