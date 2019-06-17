# set swap space = 4GB
sudo dd if=/dev/zero of=/swapfile count=4096 bs=1MiB
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

echo "/swapfile   swap    swap    sw  0   0" >> /etc/fstab
sudo sysctl vm.swappiness=10
echo "vm.swappiness = 10" >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure = 50" >> /etc/sysctl.conf
sysctl -p
swapon --summary