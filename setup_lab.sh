# update yum
sudo yum update -y
# install vim
sudo yum install vim -y 
git clone https://github.com/quydx/vim-setup.git
cd vim-setup/
./setup.sh
cd 
# set zsh + oh my zsh
sudo yum install zsh 
sudo yum install wget
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"



