#!/bin/sh

export BB_ROOT
BB_ROOT="/opt"

## Download toolchains
# wget -c https://releases.linaro.org/components/toolchain/binaries/5.3-2016.02/arm-linux-gnueabihf/gcc-linaro-5.3-2016.02-x86_64_arm-linux-gnueabihf.tar.xz
# tar xf gcc-linaro-5.3-2016.02-x86_64_arm-linux-gnueabihf.tar.xz

# wget -c https://releases.linaro.org/components/toolchain/binaries/5.3-2016.02/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz

# wget -c https://publishing-ie-linaro-org.s3.amazonaws.com/releases/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz
tar xf gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz
tar xf sysroot-glibc-linaro-2.25-2019.12-arm-linux-gnueabihf.tar.xz
## export env
export CROSS="${BB_ROOT}"/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
export SYSROOT="${BB_ROOT}"/sysroot-glibc-linaro-2.25-2019.12-arm-linux-gnueabihf/usr/
export PATH="/opt/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/:$PATH"

cd ${BB_ROOT}
## install zlib
wget https://src.fedoraproject.org/repo/pkgs/R/zlib-1.2.8.tar.gz/44d667c142d7cda120332623eab69f40/zlib-1.2.8.tar.gz
tar zxvf zlib-1.2.8.tar.gz
cd zlib-1.2.8
CROSS_PREFIX="${CROSS}" ./configure --prefix="${SYSROOT}"
make && make install

cd ${BB_ROOT}
### install binutils
wget https://ftp.gnu.org/gnu/binutils/binutils-2.35.1.tar.bz2
tar -jxvf binutils-2.35.1.tar.bz2
mkdir -p binutils-build && cd binutils-build
../binutils-2.35.1/configure \
    --prefix=/opt/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf \
    --with-sysroot="${SYSROOT}" \
    --target=arm-linux-gnueabihf \
    --with-arch=arm \
    --with-fpu=vfp \
    --with-float=hard \
    --disable-multilib \
    --disable-libquadmath \
    --disable-libquadmath-support
make && make install

cd ${BB_ROOT}

## install gawk
apt update
apt -y upgrade
apt install -y gawk
apt install python-dev
pip3 install -r ./scripts/requirements.txt
apt-get install python3-dev
apt-get install gcc-multilib


cd ${BB_ROOT}
# install glib2.33
wget http://ftp.gnu.org/gnu/libc/glibc-2.33.tar.xz
tar -xJf glibc-2.33.tar.xz
mkdir glibc-build
cd glibc-build/
../glibc-2.33/configure arm-linux-gnueabihf --target=arm-linux-gnueabihf --build=i686-pc-linux-gnu --prefix=/opt/sysroot-glibc-linaro-2.25-2019.12-arm-linux-gnueabihf --enable-add-ons
make -j8
make install install_root=/opt/sysroot-glibc-linaro-2.25-2019.12-arm-linux-gnueabihf
cd ${BB_ROOT}

# Configure for cross-compiling.
apt install -y intltool

# install libsepol
wget https://repo.pureos.net/pureos/pool/main/libs/libsepol/libsepol_2.8-1.debian.tar.xz
tar -xJf libsepol_2.8-1.debian.tar.xz
cd libsepol_2.8-1.debian


## install pcre
wget https://ftp.halifax.rwth-aachen.de/osdn/sfnet/p/pc/pcre/pcre2/10.32/pcre2-10.32.tar.gz
tar xzf pcre2-10.32.tar.gz
cd pcre2-10.32
./configure CC=arm-linux-gnueabihf-gcc \
--prefix=/opt/sysroot-glibc-linaro-2.25-2019.12-arm-linux-gnueabihf \
--host=arm-linux-gnueabihf
make && make install

## install selinux
## build selinux lib: libselinux-3.4.tar.gz
tar zxvf selinux-3.4.tar.gz
cd selinux-3.4
make arch="arm" CC=arm-linux-gnueabihf-gcc LIBDIR=/opt/sysroot-glibc-linaro-2.25-2019.12-arm-linux-gnueabihf/lib/
# --host=arm-linux-gnueabihf \
# --prefix=/opt/sysroot-glibc-linaro-2.25-2019.12-arm-linux-gnueabihf

CC=arm-linux-gnueabihf-gcc PREFIX=/opt/sysroot-glibc-linaro-2.25-2019.12-arm-linux-gnueabihf \
SHLIBDIR=/opt/sysroot-glibc-linaro-2.25-2019.12-arm-linux-gnueabihflib \
EXTRA_CFLAGS=-Wno-error install -j4 in directory /tmp/cpkg-d1ed96da884c7eac/libsepol-2.8 with environment Just [("PATH","/home/vanessa/.cpkg/flex-2.6.3-777520caeb10703e/bin:/home/vanessa/.cpkg/m4-1.4.18-2dd85e496a3e65f6/bin:/home/vanessa/.cpkg/bison-3.2.2-782868ee9f3406c5/bin:/home/vanessa/.cpkg/m4-1.4.18-2dd85e496a3e65f6/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"),("LDFLAGS",""),("CPPFLAGS","-I/home/vanessa/.cpkg/flex-2.6.3-777520caeb10703e/include"),("PKG_CONFIG_PATH","")]

## install expat
wget http://distfiles.macports.org/expat/expat-2.4.2.tar.bz2
tar -jxvf expat-2.4.2.tar.bz2
cd expat-2.4.2
./configure --without-tests --without-examples \
--prefix=/opt/sysroot-glibc-linaro-2.25-2019.12-arm-linux-gnueabihf \
--host=arm-linux-gnueabihf \
CC=arm-linux-gnueabihf-gcc \
CXX=arm-linux-gnueabihf-gcc++
make
make install

cd ${BB_ROOT}
## install ldbus
wget https://dbus.freedesktop.org/releases/dbus/dbus-1.13.12.tar.xz
tar xvf dbus-1.13.12.tar.xz
cd dbus-1.13.12
./configure --disable-doxygen-docs --disable-xml-doc --with-x=no ac_cv_have_abstract_sockets=yes \
--prefix=/opt/sysroot-glibc-linaro-2.25-2019.12-arm-linux-gnueabihf \
--host=arm-linux-gnueabihf \
CC=arm-linux-gnueabihf-gcc \
CXX=arm-linux-gnueabihf-gcc++ \
CFLAGS=-I/opt/sysroot-glibc-linaro-2.25-2019.12-arm-linux-gnueabihf/include \
LDFLAGS=-L/opt/sysroot-glibc-linaro-2.25-2019.12-arm-linux-gnueabihf/lib \
LIBS=-lexpat
make
make install

cd ${BB_ROOT}
## install avahi
wget https://github.com/lathiat/avahi/releases/download/v0.7/avahi-0.7.tar.gz
tar -xf avahi-0.7.tar.gz

cd avahi-0.7
./configure --host=arm-linux-gnueabihf --prefix=/opt/sysroot-glibc-linaro-2.25-2019.12-arm-linux-gnueabihf \
   CPPFLAGS=-I/opt/sysroot-glibc-linaro-2.25-2019.12-arm-linux-gnueabihf/include \
   LDFLAGS=-L/opt/sysroot-glibc-linaro-2.25-2019.12-arm-linux-gnueabihf/lib \
   PKG_CONFIG_PATH=/opt/sysroot-glibc-linaro-2.25-2019.12-arm-linux-gnueabihf/usr/lib/pkgconfig \
   --with-distro=none \
   --disable-glib --disable-gobject --disable-gdbm --disable-qt3 --disable-qt4 --disable-gtk --disable-gtk3 --disable-mono --disable-monodoc --disable-python --disable-expat \
   --enable-compat-libdns_sd \
   --with-systemdsystemunitdir=no \
   LIBDAEMON_CFLAGS=" " \
   LIBDAEMON_LIBS=-ldaemon
# Cross-compile and install into ${RPI_LIBS}.
make
make install


#install python

curl https://www.python.org/ftp/python/3.9.5/Python-3.9.5.tgz -O -J -L && \
tar xzf Python-3.9.5.tgz -C /usr/src/ && \
rm -f /usr/bin/python3 && \
/usr/src/Python-3.9.5/configure --enable-optimizations \
--prefix=/usr/bin/python3 \
--host=arm-linux-gnueabihf \
--target=arm-linux-gnueabihf && \
make install && \
ln -s /usr/bin/python3/bin/python3.9 /usr/bin/python3.9 && \
rm Python-3.9.5.tgz

wget https://www.python.org/ftp/python/3.9.5/Python-3.9.5.tgz
tar xvf Python-3.9.5.tgz
cd Python-3.9.5/
./configure --enable-optimizations --host=arm-linux-gnueabihf
make
sudo make altinstall
