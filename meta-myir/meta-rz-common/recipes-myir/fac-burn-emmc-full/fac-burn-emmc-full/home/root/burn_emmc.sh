#!/bin/sh
PART=0
EMMC_NODE=/dev/mmcblk${PART}

RCW_FILE=/home/root/mfgimage/bl2_emmc.pbl
UBOOT_FILE=/home/root/mfgimage/fip_uboot.bin
KERNEL_DTB_DIR=/home/root/mfgimage/kernel_dtb
KERNEL_DTB=/home/root/mfgimage/myb-yt2hx-display.dtb
ROOTFS_FILE_EXT2=/home/root/mfgimage/myir-image-full-myd-yt2h.tar.gz
DP_FIRMWARE=/home/root/mfgimage/ls1028a-dp-fw.bin
BOOTLOADER_DIR=/home/root/mfgimage/bootloader

MYD_J1028_NAME="myd-yt2h"

HOSTNAME=`cat /etc/hostname`

if [ x"$HOSTNAME" == x"$MYD_J1028_NAME" ];then
        led1=d22
fi

LED_PID=-1
time=0.2

ECHO_TTY="/dev/ttySC0"

burn_start_ing(){


        if [[ ${no_led} -eq 1 ]];then
                exit 0;
        fi

    echo "***********************************************" >> ${ECHO_TTY}
    echo "*************    SYSTEM UPDATE    *************" >> ${ECHO_TTY}
    echo "***********************************************" >> ${ECHO_TTY}
    echo "***********************************************" >> ${ECHO_TTY}
    echo "*************   Update starting   *************" >> ${ECHO_TTY}
    echo "***********************************************" >> ${ECHO_TTY}
    echo "                                               " >> ${ECHO_TTY}
    echo "                                               " >> ${ECHO_TTY}
    echo "                                               " >> ${ECHO_TTY}
    echo "                                               " >> ${ECHO_TTY}

        #核心板上的绿灯闪烁则烧写中
 #       echo 0 > /sys/class/leds/${led1}/brightness

        while [ 1 ]
        do
#                echo 1 > /sys/class/leds/${led1}/brightness
                sleep $time
 #               echo 0 > /sys/class/leds/${led1}/brightness
                sleep $time
        echo "*************   Updating   *************" >> ${ECHO_TTY}
        done
}

burn_faild(){
        echo $'>>>[100]{\"step\":\"firmware\",\"result\":{\"bootloader\":\"2\",\"data\":\"2\",\"kernel\":\"2\",\"rootfs\":\"2\"}}\r\n'
        if [[ ${no_led} -eq 1 ]];then
                exit 0;
        fi

    kill $LED_PID
       # 熄灭
        echo 0 > /sys/class/leds/${led1}/brightness

    echo "Update faild..."   >> ${ECHO_TTY}
    echo "Update faild..."   >> ${ECHO_TTY}
    echo "Update faild..."   >> ${ECHO_TTY}
}

burn_succeed(){
  echo $'>>>[100]{\"step\":\"firmware\",\"result\":{\"bootloader\":\"0\",\"data\":\"0\",\"kernel\":\"0\",\"rootfs\":\"0\"}}\r\n'
  if [[ ${no_led} -eq 1 ]];then
                return 0;
        fi

#    kill $LED_PID

        # 常亮
#        echo 1 > /sys/class/leds/${led1}/brightness

        echo "***********************************************" >> ${ECHO_TTY}
        echo "********    SYSTEM UPDATE  SUCCEED  ***********" >> ${ECHO_TTY}
    echo "********    SYSTEM UPDATE  SUCCEED  ***********" >> ${ECHO_TTY}
    echo "********    SYSTEM UPDATE  SUCCEED  ***********" >> ${ECHO_TTY}
        echo "***********************************************" >> ${ECHO_TTY}
    echo "***********************************************" >> ${ECHO_TTY}
    echo "                                               " >> ${ECHO_TTY}

}

echo_fun(){
        echo "***********************************************" >> ${ECHO_TTY}
        echo "********    "$1 "  ***********" >> ${ECHO_TTY}
    echo "***********************************************" >> ${ECHO_TTY}
}
cmd_check()
{
        if [ $1 -ne 0 ];then
                echo "$2 failed!"   >> ${ECHO_TTY}
        echo "$2 failed!"   >> ${ECHO_TTY}
        echo "$2 failed!"   >> ${ECHO_TTY}
                burn_faild
        exit -1
        fi
}

emmc_partition()
{

        umount /dev/mmcblk0p1 > /dev/null 2>&1
      dd if=/dev/zero of=/dev/mmcblk0 bs=1024 count=1024
        if [ $? -ne 0 ]; then
                echo "===> Format emmc failed"
                update_fail $1 $2
                exit 1
        fi
        SIZE=`fdisk -l /dev/mmcblk0 | grep Disk | awk '{print $5}'`

        echo DISK SIZE - $SIZE bytes

        CYLINDERS=475 #`echo $SIZE/255/63/512 | bc`

#        {
#           16M,170M,83
#           186M,,83
#        } | sfdisk -u S /dev/mmcblk1 >/dev/null 2>&1

sfdisk -u S /dev/mmcblk0 <<EOF                                       
    10M,,83                       
EOF
        if [ $? -ne 0 ]; then
                echo "===> eMMC partition failed"
                update_fail $1 $2
                exit 1
        fi


      #  umount /dev/mmcblk0p1 > /dev/null 2>&1
      #  sleep 1
      #  mkfs.vfat /dev/mmcblk0p1 <<EOF                                                                              
#y                                                                            
#EOF                                             
#        if [ $? -ne 0 ]; then
#                echo "===> Creating boot partition failed"
#                update_fail $1 $2
#                exit 1
#        fi


        umount /dev/mmcblk0p1 > /dev/null 2>&1
        sleep 1
        mkfs.ext4 -L "rootfs" /dev/mmcblk0p1 <<EOF                              
y                                                                      
EOF
        if [ $? -ne 0 ]; then
                echo "===> Creating rootfs partition failed"
                update_fail $1 $2
                exit 1
        fi
        mkfs.ext4 -L "rootfs" /dev/mmcblk0p1 <<EOF                  
y                                                                   
EOF
        #mkdir -p /home/root/boot  > /dev/null 2>&1
        #mount /dev/mmcblk0p1 /home/root/boot  > /dev/null 2>&1
        mkdir -p /home/root/rootfs  > /dev/null 2>&1
        mount -t ext4 /dev/mmcblk0p1 /home/root/rootfs > /dev/null 2>&1
}

mksdcard(){
    #partition size in 10M
    BOOT_ROM_SIZE=16
    KERNEL_DTB_SIZE=170

    if [   $# -lt 1 ];then
        echo format node not exist
        exit 1
    else
        echo exist
    fi
    node=$1
    echo $node

   # dd if=/dev/zero of=${node} bs=1k count=8192

sfdisk --force ${node} <<EOF
    ${BOOT_ROM_SIZE}M,${KERNEL_DTB_SIZE}M,83
    $(($KERNEL_DTB_SIZE + 16))M,,83
EOF
    while [ 1 ]
    do
        if [ -b ${node}p2 ];then
                break
        else
                sleep 0.5
                echo ${node}p2 not exist
        fi
    done
}

enable_bootpart(){
    mmc bootpart enable 1 1 /dev/mmcblk${PART}
}

burn_bootloader(){

    umount /run/media/* > /dev/null 2>&1
    umount /dev/mmcblk0p1/ > /dev/null 2>&1
    mkdir -p /home/root/boot
    mount -t vfat /dev/mmcblk0p1 /home/root/boot
    cp ${BOOTLOADER_DIR}/* /home/root/boot
    cmd_check $? "burn kernel dtb faild"
    sync
    umount /home/root/boot > /dev/null 2>&1
}

burn_rootfs_ext4(){
       umount /run/media/* > /dev/null 2>&1                                                                                                         
    umount /dev/mmcblk1p2/ > /dev/null 2>&1

date  042911302026.10
tar xf ${ROOTFS_FILE_EXT2} -C /home/root/rootfs
    cmd_check $? "burn root faild"
    sync
    umount /run/media/* > /dev/null 2>&1
    umount /home/root/rootfs > /dev/null 2>&1
}

check_rootfs(){
    mkdir -p /mnt/mmcblk${PART}p2
    mount /dev/mmcblk${PART}p2 /mnt/ > /dev/null 2>&1
    cp ${KERNEL_DTB} /mnt/boot -f
    sync
    rootfs_hostname=`cat /mnt/etc/hostname`
    echo_fun "rootfs_hostname:$rootfs_hostname"

    if [ x"$rootfs_hostname" != x"$HOSTNAME" ];then
       echo_fun "not equal"
     #  reboot
    else
       echo_fun "equal"
    fi
    umount /mnt/ > /dev/null 2>&1
}

burn_start_ing &
#LED_PID=$!
umount /run/media/* > /dev/null 2>&1
echo_fun "start format mmc "
emmc_partition
#echo_fun "start burn bootloader"
#burn_bootloader
echo_fun "start burn rootfs "
burn_rootfs_ext4
check_rootfs
burn_succeed

if [ x"$HOSTNAME" == x"$MYS_NAME" ];then
  reboot
fi
