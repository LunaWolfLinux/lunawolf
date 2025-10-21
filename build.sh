sudo rm -rf ../work
sudo rm -rf ../out

cd profile
sudo mkarchiso -v -w ../../work/ -o ../../out .
