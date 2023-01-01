#!/bin/bash 

a=$1

scp chameleon_vimrc $a:/home/cc/.vimrc
scp ~/tapan-key-october.pem $a:/home/cc/.ssh/id_rsa

ssh $a "ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts"
ssh $a "git clone git@github.com:TheDataStation/arachneDB.git"

ssh $a "mkdir ~/arachneDB/config"
scp ~/arachneDB/config/config.properties $a:/home/cc/arachneDB/config 


## TPC-DS Generation Folder
ssh $a "sudo apt install gcc-9"
# scp -r ~/Downloads/DSGen-software-code-3.2-2.0rc1 $a:/home/cc
# scp gen_tpcds.sh $a:/home/cc/DSGen-software-code-3.2-2.0rc1/tools

