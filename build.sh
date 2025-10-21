sudo mkdir /tmp/archiso
sudo umount /tmp/archiso
sudo mount -t tmpfs -o size=16G tmpfs /tmp/archiso
sudo rm -rf ../out

cd profile
sudo ./mklunawolfiso -v -w /tmp/archiso -o ../../out .
sudo umount /tmp/archiso
