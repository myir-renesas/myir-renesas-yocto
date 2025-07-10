1.编译步骤：

1)为SDK创建一个新的目录，并进入该目录，例如："mkdir myd-t2h-yocto;cd myd-t2h-yocto;" 解压缩SDK软件包到当前目录，例如："tar -xzvf MYD-YT2H-Distribution-L5.10.106-V1.1.0.tar.gz"。
   如果是git方式下载SDK，则直接执行:
"git clone -b develop-t2h-yocto-3.1.31 https://github.com/myir-renesas/myir-renesas-yocto.git --recurse-submodules;cd myir-renesas-yocto;git submodule update --init --recursive"

2) 进入myir-renesas-yocto目录，cd myir-renesas-yocto;执行命令：
TEMPLATECONF=$PWD/meta-myir/meta-rzt2h/docs/template/conf/ source poky/oe-init-build-env build-myd-yt2h
bitbake myir-image-full
如果编译burn镜像，编译完full镜像后，执行下面命令：
bitbake myir-image-burn
