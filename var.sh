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

