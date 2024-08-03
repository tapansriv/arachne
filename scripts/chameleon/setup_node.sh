#!/bin/bash 

a=$1

scp chameleon_vimrc $a:/home/cc/.vimrc
scp ~/tapan-key-october.pem $a:/home/cc/.ssh/id_rsa

ssh $a "ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts"
ssh $a "git clone git@github.com:TheDataStation/arachne.git"

ssh $a "mkdir ~/arachne/config"
scp ~/arachne/config/config.properties $a:/home/cc/arachne/config 


## TPC-DS Generation Folder
ssh $a "sudo apt install -y gcc-9"
ssh $a "sudo apt install -y python3-pip"
ssh $a "cd ~/arachne; python3 -m pip install -r requirements.txt" 
ssh $a "echo 'export EDITOR=vim' >> ~/.bashrc"
ssh $a 'git config --global user.email "tapansriv@gmail.com"; git config --global user.name "Tapan Srivastava'
# scp -r ~/Downloads/DSGen-software-code-3.2-2.0rc1 $a:/home/cc
# scp gen_tpcds.sh $a:/home/cc/DSGen-software-code-3.2-2.0rc1/tools

# sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/DEVICE_NAME

