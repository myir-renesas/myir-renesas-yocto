1.编译步骤：
1)为SDK创建一个新的目录，并进入该目录，例如："mkdir myd-t2h-yocto;cd myd-t2h-yocto;" 解压缩SDK软件包到当前目录，例如："tar -xzvf MYD-YT2H-Distribution-L5.10.106-V1.1.0.tar.gz"。
   如果是git方式下载SDK，则直接执行"git clone -b feature-t2h-v1.02 https://migit.goho.co/myir-yt2hx-linux/Yocto-t2h.git --recurse-submodules;cd Yocto-t2h;git submodule update --init --recursive"
2) 进入Yocto-t2h目录，cd Yocto-t2h;执行命令：
TEMPLATECONF=$PWD/meta-myir/meta-rzt2h/docs/template/conf/ source poky/oe-init-build-env build-myd-yt2h
bitbake myir-image-full
如果编译burn镜像，编译完full镜像后，执行下面命令：
bitbake myir-image-burn
