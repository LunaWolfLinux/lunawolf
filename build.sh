sudo mkdir /tmp/lunaiso
sudo umount /tmp/lunaiso
sudo mount -t tmpfs -o size=20G tmpfs /tmp/lunaiso
sudo rm -rf ../out

cd profile
sudo ./mklunawolfiso -v -w /tmp/lunaiso -o ../../out .
sudo umount /tmp/lunaiso
