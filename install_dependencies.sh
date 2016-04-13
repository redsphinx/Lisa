#!/usr/bin/env bash

######################################################################
# Torch install
######################################################################


#TOPDIR=$PWD
TOPDIR=///hpc/sw

# Prefix:
#PREFIX=$PWD/torch
PREFIX=$TOPDIR/torch7-2016.03.10
echo "Installing Torch into: $PREFIX"

#if [[ `uname` != 'Linux' ]]; then
#  echo 'Platform unsupported, only available for Linux'
#  exit
#fi
#if [[ `which apt-get` == '' ]]; then
#    echo 'apt-get not found, platform not supported'
#    exit
#fi

# Install dependencies for Torch:
#sudo apt-get update
#sudo apt-get install -qqy build-essential
#sudo apt-get install -qqy gcc g++
#sudo apt-get install -qqy cmake
#sudo apt-get install -qqy curl
#sudo apt-get install -qqy libreadline-dev
#sudo apt-get install -qqy git-core
#sudo apt-get install -qqy libjpeg-dev
#sudo apt-get install -qqy libpng-dev
#sudo apt-get install -qqy ncurses-dev
#sudo apt-get install -qqy imagemagick
#sudo apt-get install -qqy unzip
#sudo apt-get update


echo "==> Torch7's dependencies have been installed"





# Build and install Torch7
cd /tmp
#cd ~/
rm -rf luajit-rocks
git clone https://github.com/torch/luajit-rocks.git
cd luajit-rocks
mkdir -p build
cd build
git checkout master; git pull
rm -f CMakeCache.txt
echo "YOU ARE HERE 1"
cmake .. -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_BUILD_TYPE=Release
echo "YOU ARE HERE 2"
RET=$?; if [ $RET -ne 0 ]; then echo "Error. Exiting."; exit $RET; fi
make 
echo "YOU ARE HERE 2.1"
RET=$?; if [ $RET -ne 0 ]; then echo "Error. Exiting."; exit $RET; fi
make install 
echo "YOU ARE HERE 2.2"
RET=$?; if [ $RET -ne 0 ]; then echo "Error. Exiting."; exit $RET; fi

echo "YOU ARE HERE 3"

path_to_nvcc=$(which nvcc)
if [ -x "$path_to_nvcc" ]
then
    cutorch=ok
    cunn=ok
fi

echo "YOU ARE HERE 4"
# Install base packages:
$PREFIX/bin/luarocks install cwrap --local
$PREFIX/bin/luarocks install paths --local
$PREFIX/bin/luarocks install torch --local
$PREFIX/bin/luarocks install nn --local

echo "YOU ARE HERE 5"
[ -n "$cutorch" ] && \
($PREFIX/bin/luarocks install cutorch)
[ -n "$cunn" ] && \
($PREFIX/bin/luarocks install cunn)

echo "YOU ARE HERE 6"
$PREFIX/bin/luarocks install luafilesystem --local
$PREFIX/bin/luarocks install penlight --local
$PREFIX/bin/luarocks install sys --local
$PREFIX/bin/luarocks install xlua --local
$PREFIX/bin/luarocks install image --local
$PREFIX/bin/luarocks install env --local

echo ""
echo "=> Torch7 has been installed successfully"
echo ""


echo "Installing nngraph ... "
$PREFIX/bin/luarocks install nngraph --local
RET=$?; if [ $RET -ne 0 ]; then echo "Error. Exiting."; exit $RET; fi
echo "nngraph installation completed"

echo "Installing Xitari ... "
cd /tmp
#cd ~/
rm -rf xitari
git clone https://github.com/deepmind/xitari.git
cd xitari
$PREFIX/bin/luarocks make --local
RET=$?; if [ $RET -ne 0 ]; then echo "Error. Exiting."; exit $RET; fi
echo "Xitari installation completed"

echo "Installing Alewrap ... "
cd /tmp
#cd ~/
rm -rf alewrap
git clone https://github.com/deepmind/alewrap.git
cd alewrap
$PREFIX/bin/luarocks make --local
RET=$?; if [ $RET -ne 0 ]; then echo "Error. Exiting."; exit $RET; fi
echo "Alewrap installation completed"

echo
echo "You can run experiments by executing: "
echo
echo "   ./run_cpu game_name"
echo
echo "            or   "
echo
echo "   ./run_gpu game_name"
echo
echo "For this you need to provide the rom files of the respective games (game_name.bin) in the roms/ directory"
echo

