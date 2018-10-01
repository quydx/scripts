#!/bin/bash
set -e
sudo yum install yum-utils -y 
sudo yum install -y epel-release
# update yum
sudo yum update -y
# install vim
sudo yum install vim -y 
sudo yum install git -y
git clone https://github.com/quydx/vim-setup.git
cd vim-setup/
./setup.sh
cd 
# set zsh + oh my zsh
sudo yum install zsh -y
sudo yum install wget -y
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"



