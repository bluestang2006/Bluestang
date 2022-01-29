#!/usr/bin/env bash

#sudo apt install libglvnd-dev=1.3.2-1 libglvnd-core-dev=1.3.2-1 libglvnd0=1.3.2-1 libegl1=1.3.2-1 libgles1=1.3.2-1 libgles2=1.3.2-1 libgles-dev=1.3.2-1 libgl1=1.3.2-1 libgl-dev=1.3.2-1 libglx0=1.3.2-1 libglx-dev=1.3.2-1 libopengl0=1.3.2-1 libopengl-dev=1.3.2-1 libegl-dev=1.3.2-1

:<<'MYCOMMENT'
***DPKG VERSION NUMBERS***
MYCOMMENT

COUNTER=0
vDRM=2.4.109-4
vGLVND=1.4.0-2
vMESA=22.0.1-4
vSDL=2.0.20+dfsg-3
vVK=1.3.204.0-1
vWL=1.20.90-1
vWLP=1.25-1
vSTD=0.6.3-2

SVN=https://github.com/bluestang2006/Debian-Pkgs/trunk
XORG=https://salsa.debian.org/xorg-team
LOG=raw/debian-unstable/debian/changelog

build_dpkg()
{
    dpkg-buildpackage -b -us -uc
    cd $SRCSDIR; sudo dpkg -i *.deb
    sudo rm -rv *.deb *.buildinfo *.changes *.udeb
}

:<<'MYCOMMENT'
***APT UPDATE&UPGRADE/GET BUILD DEPENDENCIES***
MYCOMMENT

let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mApt Update & Full-Upgrade\e[39m"
    sudo apt update && sudo apt full-upgrade -y

if [ "$(dpkg -s build-essential | awk '/Version:/{gsub(",","");print $2}')" != "12.9" ]; then

let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mInstalling Dependencies\e[39m"
    sudo apt install -y libxcb-randr0-dev libxrandr-dev \
         libxcb-xinerama0-dev libxinerama-dev libxcursor-dev \
         libxcb-cursor-dev libxkbcommon-dev xutils-dev \
         libpthread-stubs0-dev libpciaccess-dev x11proto-gl-dev \
         libffi-dev x11proto-xext-dev libxcb1-dev libxcb-*dev \
         bison flex libssl-dev libgnutls28-dev x11proto-dri2-dev \
         x11proto-dri3-dev libx11-dev libxcb-glx0-dev debhelper \
         libx11-xcb-dev libxext-dev libxdamage-dev libxfixes-dev \
         libva-dev x11proto-randr-dev x11proto-present-dev \
         libclc-dev libelf-dev git build-essential mesa-utils \
         libgbm-dev libxshmfence-dev libxxf86vm-dev valgrind \
         libunwind-dev libzstd-dev googletest cmake meson \
         spirv-tools spirv-headers glslang-tools glslang-dev \
         libevdev-dev mesa-utils mesa-utils-extra dos2unix \
         libsdl2-mixer-dev libsdl2-image-dev libsdl2-ttf-dev \
         quilt xsltproc python3-libxml2 xvfb subversion \
         devscripts libv4l-dev python3-pip python3-docutils \
         sqlite3 libsensors-dev libvdpau-dev python3-mako \
         llvm-11-dev libclang-11-dev graphviz doxygen \
         libclang-cpp11-dev libudev-dev libpixman-1-dev \
         libsamplerate0-dev fcitx-libs-dev libpipewire-0.3-dev \
         libatomic-ops-dev libvulkan-dev libglvnd-core-dev \
         vulkan-tools ninja-build libcunit1-dev libcairo2-dev \
         libinput-dev libxml2-dev xmlto docbook-xsl scdoc \
         libsystemd-dev
fi

if [ -d $SRCSDIR ]; then
    SRCSDIR="/home/pi/sources/"
else
    cd $HOME; mkdir sources
    SRCSDIR="/home/pi/sources/"
fi

:<<'MYCOMMENT'
***WAYLAND***
MYCOMMENT

if [ "$(dpkg -s libwayland-dev | awk '/Version:/{gsub(",","");print $2}')" != "$vWL" ]; then
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mGet WAYLAND\e[39m"

DIR="/home/pi/sources/wayland"

if [ -d "$DIR" ]; then
    cd $DIR; git pull
else
    cd $SRCSDIR; git clone https://gitlab.freedesktop.org/wayland/wayland.git wayland
    cd $DIR
fi

    svn checkout $SVN/wayland/debian
    cd $DIR/debian; sudo rm -r changelog
    wget $XORG/wayland/wayland/-/$LOG
    cd $DIR; DEBEMAIL="Bluestang <bluestang2006@gmail.com>" dch -v $vWL "Upstream WAYLAND"
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mBuild WAYLAND\e[39m"
    build_dpkg
fi

if [ "$(dpkg -s libwayland-dev | awk '/Version:/{gsub(",","");print $2}')" != "$vWL" ]; then
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mWAYLAND is Up-to-Date\e[39m"
fi

:<<'MYCOMMENT'
***WAYLAND PROTOCOLS***
MYCOMMENT

if [ "$(dpkg -s wayland-protocols | awk '/Version:/{gsub(",","");print $2}')" != "$vWLP" ]; then
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mGet WAYLAND PROTOCOLS\e[39m"

DIR="/home/pi/sources/wayland-protocols"

if [ -d "$DIR" ]; then
    cd $DIR; git pull
else
    cd $SRCSDIR; git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git wayland-protocols
    cd $DIR
fi

    svn checkout $SVN/wayland-protocols/debian
    cd $DIR/debian; sudo rm -r changelog
    wget $XORG/wayland/wayland-protocols/-/$LOG
    cd $DIR; DEBEMAIL="Bluestang <bluestang2006@gmail.com>" dch -v $vWLP "Upstream WAYLAND PROTOCOLS"
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mBuild WAYLAND PROTOCOLS\e[39m"
    build_dpkg
fi

if [ "$(dpkg -s wayland-protocols | awk '/Version:/{gsub(",","");print $2}')" != "$vWLP" ]; then
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mWAYLAND PROTOCOLS is Up-to-Date\e[39m"
fi

:<<'MYCOMMENT'
***SEATD***
MYCOMMENT

if [ "$(dpkg -s  libseat-dev | awk '/Version:/{gsub(",","");print $2}')" != "$vSTD" ]; then
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mGet SEATD\e[39m"

DIR="/home/pi/sources/seatd"

if [ -d "$DIR" ]; then
    cd $DIR; git pull
else
    cd $SRCSDIR; git clone --single-branch --branch debian/master https://git.devuan.org/devuan/seatd.git seatd
    cd $DIR
fi

let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mBuild SEATD\e[39m"
    build_dpkg
fi

if [ "$(dpkg -s  libseat-dev | awk '/Version:/{gsub(",","");print $2}')" != "$vSTD" ]; then
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mSEATD is Up-to-Date\e[39m"
fi

:<<'MYCOMMENT'
***VULKAN HEADERS/LOADER***
MYCOMMENT

if [ "$(dpkg -s libvulkan-dev | awk '/Version:/{gsub(",","");print $2}')" != "$vVK" ]; then
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mGet VULKAN\e[39m"

DIR="/home/pi/sources/vulkan_loader"

if [ -d "$DIR" ]; then
    cd $DIR; git pull; cd vulkan-headers; git pull; cd ..
else
    cd $SRCSDIR; git clone https://github.com/KhronosGroup/Vulkan-Loader.git vulkan_loader
    cd $DIR; git clone https://github.com/KhronosGroup/Vulkan-Headers.git vulkan-headers
fi

    svn checkout $SVN/vulkan/debian
    cd $DIR/debian; sudo rm -r changelog
    wget $XORG/vulkan/vulkan-loader/-/$LOG
    cd $DIR; DEBEMAIL="Bluestang <bluestang2006@gmail.com>" dch -v $vVK "Upstream VULKAN"
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mBuild VULKAN\e[39m"
    build_dpkg
fi

if [ "$(dpkg -s libvulkan-dev | awk '/Version:/{gsub(",","");print $2}')" == "$vVK" ]; then
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mVULKAN is Up-to-Date\e[39m"
fi

:<<'MYCOMMENT'
***LIBDRM***
MYCOMMENT

if [ "$(dpkg -s libdrm2 | awk '/Version:/{gsub(",","");print $2}')" != "$vDRM" ]; then
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mGet MESA DRM\e[39m" 

DIR="/home/pi/sources/mesa_drm"

if [ -d "$DIR" ]; then
    cd $DIR; git pull
else
    cd $SRCSDIR; git clone --single-branch --branch main https://github.com/freedesktop/mesa-drm.git mesa_drm
    cd $DIR
fi

    svn checkout $SVN/libdrm/debian
    cd $DIR/debian; sudo rm -r changelog
    wget $XORG/lib/libdrm/-/$LOG
    cd $DIR; DEBEMAIL="Bluestang <bluestang2006@gmail.com>" dch -v $vDRM "Upstream LIBDRM"
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mBuild MESA DRM\e[39m"
    build_dpkg
fi

if [ "$(dpkg -s libdrm2 | awk '/Version:/{gsub(",","");print $2}')" == "$vDRM" ]; then
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mMESA DRM is Up-to-Date\e[39m"
fi

DIR="/opt/retropie/supplementary/mesa-drm"

if [ -d "$DIR" ]; then
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mCopy MESA DRM to RetroPie\e[39m"
    sudo cp -v /usr/lib/aarch64-linux-gnu/libdrm.so.2.4.0 /opt/retropie/supplementary/mesa-drm
    cd $DIR; sudo ln -sf libdrm.so.2.4.0 libdrm.so.2
else
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mRetroPie Not Installed - Moving On\e[39m"
fi

:<<'MYCOMMENT'
***LIBGLVND***
MYCOMMENT

if [ "$(dpkg -s libglvnd-dev | awk '/Version:/{gsub(",","");print $2}')" == "1.3.2-1" ]; then
sudo dpkg -r --force-depends libglvnd-dev
fi

if [ "$(dpkg -s libglvnd0 | awk '/Version:/{gsub(",","");print $2}')" != "$vGLVND" ]; then
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mGet LIBGLVND\e[39m" 

DIR="/home/pi/sources/mesa_glvnd"

if [ -d "$DIR" ]; then
    cd $DIR; git pull
else
    cd $SRCSDIR; git clone --single-branch --branch master https://github.com/NVIDIA/libglvnd.git mesa_glvnd
    cd $DIR
fi
    svn checkout $SVN/libglvnd/debian
    cd $DIR/debian; sudo rm -r changelog
    wget $XORG/lib/libglvnd/-/$LOG
    cd $DIR; DEBEMAIL="Bluestang <bluestang2006@gmail.com>" dch -v $vGLVND "Upstream LIBGLVND"
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mBuild LIBGLVND\e[39m"
    build_dpkg
fi

if [ "$(dpkg -s libglvnd0 | awk '/Version:/{gsub(",","");print $2}')" == "$vGLVND" ]; then
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mLIBGLVND is Up-to-Date\e[39m"
fi

:<<'MYCOMMENT'
***MESA***
MYCOMMENT

if [ "$(dpkg -s libgbm1 | awk '/Version:/{gsub(",","");print $2}')" != "$vMESA" ]; then
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mGet v3dv\e[39m"

DIR="/home/pi/sources/mesa_vulkan"

if [ -d "$DIR" ]; then
    cd $DIR; git pull
else
    cd $SRCSDIR; git clone --single-branch --branch main https://github.com/freedesktop/mesa.git mesa_vulkan
    cd $DIR
fi
    svn checkout $SVN/mesa/debian
    cd $DIR/debian; sudo rm -r changelog
    wget $XORG/lib/mesa/-/$LOG
    cd $DIR; DEBEMAIL="Bluestang <bluestang2006@gmail.com>" dch -v $vMESA "Upstream MESA"
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mBuild v3dv\e[39m"
    build_dpkg
fi

if [ "$(dpkg -s libgbm1 | awk '/Version:/{gsub(",","");print $2}')" == "$vMESA" ]; then
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mv3dv is Up-to-Date\e[39m"
fi

:<<'MYCOMMENT'
***VULKAN-TOOLS***
MYCOMMENT

if [ "$(dpkg -s vulkan-tools | awk '/Version:/{gsub(",","");print $2}')" != "$vVK" ]; then
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mGet VULKAN TOOLS\e[39m" 

DIR="/home/pi/vulkan_tools"

if [ -d "$DIR" ]; then
    cd $DIR; git pull
else
    cd $SRCSDIR; git clone https://github.com/KhronosGroup/Vulkan-Tools.git vulkan_tools
    cd $DIR
fi
    svn checkout $SVN/vulkan-tools/debian
    cd $DIR/debian; sudo rm -r changelog
    wget $XORG/vulkan/vulkan-tools/-/$LOG
    cd $DIR; DEBEMAIL="Bluestang <bluestang2006@gmail.com>" dch -v $vVK "Upstream VULKAN TOOLS"
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mBuild VULKAN TOOLS\e[39m"
    build_dpkg
fi

if [ "$(dpkg -s vulkan-tools | awk '/Version:/{gsub(",","");print $2}')" == "$vVK" ]; then
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mVULKAN TOOLS is Up-to-Date\e[39m"
fi

:<<'MYCOMMENT'
***SDL2***
MYCOMMENT

if [ "$(dpkg -s libsdl2-dev | awk '/Version:/{gsub(",","");print $2}')" != "$vSDL" ]; then
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mGet SDL2\e[39m"

DIR="/home/pi/sources/SDL"
SDL="$(echo $vSDL | awk '{ print substr( $0, 1, length($0)-7 ) }')"

if [ -d "$DIR" ]; then
    cd $DIR; git pull
else
    cd ~; git clone --single-branch --branch release-$SDL https://github.com/libsdl-org/SDL.git SDL
    cd $DIR; sudo rm -r debian
fi
    svn checkout $SVN/SDL/debian
    cd $DIR/debian; sudo rm -r changelog
    wget https://salsa.debian.org/sdl-team/libsdl2/-/raw/master/debian/changelog
    cd $DIR; DEBEMAIL="Bluestang <bluestang2006@gmail.com>" dch -v $vSDL "Upstream SDL2"
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mBuild SDL2\e[39m"
    build_dpkg
fi

if [ "$(dpkg -s libsdl2-dev | awk '/Version:/{gsub(",","");print $2}')" == "$vSDL" ]; then
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mSDL2 is Up-to-Date\e[39m"
fi
	
:<<'MYCOMMENT'
***VERIFY PKGS***
MYCOMMENT

let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mDisplay Updated Mesa Driver\e[39m"
    vulkaninfo | grep 'apiVersion\|driverVersion\|deviceName\|Vulkan Instance Version'
    glxinfo -B
let COUNTER++
echo -e "\e[1m\e[94m$COUNTER. \e[96mSDL2 Version:\e[39m"
    sdl2-config --version
