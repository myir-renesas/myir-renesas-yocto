#!/bin/sh

#********************************************************************
#  copyright (C) 2014 all rights reserved
#  @file: flash_rensas.sh
#  @Created: 2025-01-17 16:00
#  @Author: AlexHu


flag=$1
if [[ X${flag} = X"plan" ]];then
plan="{\"step\":\"firmware\",\"PN\":\"xxx\",\"SN\":\"xxx\",\"CN\":\"xxx\",\"plan\":{\"num\":\"3\",\"modules\":{\"uboot\":\"0\", \"image\":\"2000\",\"rootfs\":\"40000\"}}}"
echo ">>>[${#plan}]${plan}"
exit 1
fi

ECHO_TTY="/dev/ttySC0"


## eMMC  ---> mmcblk0
DRIVE=/dev/mmcblk0

bootpart=""
rootpart=""

##Get ddr size
SDDRIV=/dev/mmcblk1
umount ${SDDRIV}p1
sleep 1
mount -t vfat ${SDDRIV}p1 /mnt/
sleep 1

imagedir=/home/root/t2h_image
. ${imagedir}/Manifest

BL2_FILE=${imagedir}/${bl2file}
FIP_FILE=${imagedir}/${fipfile}

IMAGE_FILE=${imagedir}/${imagefile}
DTBS_FILE=${imagedir}/${dtbfile}
ROOTFS_FILE=${imagedir}/${rootfsfile}

burn_start_ing(){
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


	echo 0 > /sys/class/leds/system_led/brightness
        while [ 1 ]
        do
                echo 1 > /sys/class/leds/system_led/brightness
                sleep 0.25
                echo 0 > /sys/class/leds/system_led/brightness
                sleep 0.25
	echo "*************   Updating   *************" >> ${ECHO_TTY}
        done
	
}

update_success()
{
	echo 1 > /sys/class/leds/system_led/brightness
        echo "***********************************************" >> ${ECHO_TTY}
        echo "********    SYSTEM UPDATE  SUCCEED  ***********" >> ${ECHO_TTY}
    	echo "********    SYSTEM UPDATE  SUCCEED  ***********" >> ${ECHO_TTY}
    	echo "********    SYSTEM UPDATE  SUCCEED  ***********" >> ${ECHO_TTY}
        echo "***********************************************" >> ${ECHO_TTY}
    	echo "***********************************************" >> ${ECHO_TTY}
    	echo "                                               " >> ${ECHO_TTY}
}

update_fail()
{
	echo 0 > /sys/class/leds/system_led/brightness
        echo "***********************************************" >> ${ECHO_TTY}
        echo "********    SYSTEM UPDATE  FAILED  ***********" >> ${ECHO_TTY}
        echo "********    SYSTEM UPDATE  FAILED  ***********" >> ${ECHO_TTY}
        echo "********    SYSTEM UPDATE  FAILED  ***********" >> ${ECHO_TTY}
        echo "***********************************************" >> ${ECHO_TTY}
        echo "***********************************************" >> ${ECHO_TTY}
        echo "                                               " >> ${ECHO_TTY}
}

cmd_check()
{
	if [ $1 -ne 0 ];then
		echo "$2 failed!" >> ${ECHO_TTY}
		echo
		update_fail
	fi
}

## check_file
check_file()
{
	if [ ! -s $1 ];then
		echo "invalid imagefile $1" >> ${ECHO_TTY}
		echo
		update_fail
	fi
}

fidsk_emmc(){

sfdisk --force ${DRIVE} << EOF
10M,50M,0c
60M,,83
EOF
cmd_check $? "Re-partition device"


MAX_TRIES=4

for ((i=1; i<=MAX_TRIES; i++)); do
    if [ -b "$DRIVE"p2 ]; then
        echo "[OK] $DEVICE exists (Attempt $i succeeded)" >> ${ECHO_TTY}
		umount ${DRIVE}p1
		umount ${DRIVE}p2
		mkfs.vfat -F 32 -n "boot" ${DRIVE}p1  > /dev/null 2>&1
		cmd_check $? "Formating boot partition"
		#mkfs.ext4  ${DRIVE}p2 > /dev/null 2>&1
		mkfs.ext4 -F -L "rootfs" ${DRIVE}p2 > /dev/null 2>&1
		cmd_check $? "Formating rootfs partition"
        break
    else
        echo "[WARN] $DEVICE not found (Attempt $i failed)" >> ${ECHO_TTY}
        sleep 2  # Optional delay
    fi
done

bootpart=`basename ${DRIVE}p1`
rootpart=`basename ${DRIVE}p2`
}

erasing_emmc()
{
	# Erasing eMMC
	echo -e "\n== Destroying Master Boot Record (sector 0) ==" >> ${ECHO_TTY}
	sleep 1
	echo dd if=/dev/zero of=${DRIVE} bs=512 count=1
	dd if=/dev/zero of=${DRIVE} bs=512 count=1
	sync
}

burn_boot()
{
	echo 0 > /sys/block/mmcblk0boot0/force_ro
	echo 0 > /sys/block/mmcblk0boot1/force_ro
	sleep 1
	dd if=/dev/zero of=/dev/mmcblk0boot0 bs=1M count=10 conv=fsync
	dd if=/dev/zero of=/dev/mmcblk0boot1 bs=1M count=10 conv=fsync
	sync
	dd if=${BL2_FILE} of=/dev/mmcblk0boot0 bs=512 skip=0 seek=1 conv=fsync
	cmd_check $? "Update bl2 file"
	dd if=${FIP_FILE} of=/dev/mmcblk0boot0 bs=512 skip=0 seek=768 conv=fsync
	cmd_check $? "Update fip file"
}

burn_image()
{
	mkdir -p /run/media/${bootpart}
	mount   ${DRIVE}p1   /run/media/${bootpart}

	cp ${IMAGE_FILE} /run/media/${bootpart}
	cmd_check $? "Update kernel"
	cp ${DTBS_FILE} /run/media/${bootpart}
	cmd_check $? "Update dtb"
	sync
}

burn_rootfs()
{
	## ormat: ext4
	dd if=${ROOTFS_FILE} of=${DRIVE}p2 bs=1M
	cmd_check $? "Update rootfs"
	sync
}

resize2fs_emmc()
{
	e2fsck -f  ${DRIVE}p2
   yes | resize2fs   ${DRIVE}p2
  	sync
}

burn_start_ing &
PID=$!
echo "---------------------------start erasing_emmc---------------------------" >> ${ECHO_TTY}
# erasing_emmc
echo "---------------------------end erasing_emmc---------------------------" >> ${ECHO_TTY}

echo "---------------------------start fidsk_emmc---------------------------" >> ${ECHO_TTY}
fidsk_emmc
echo "---------------------------end fidsk_emmc---------------------------" >> ${ECHO_TTY}

echo "---------------------------start burn_boot---------------------------" >> ${ECHO_TTY}
burn_boot
echo "---------------------------end burn_boot---------------------------" >> ${ECHO_TTY}

echo "---------------------------start burn_image---------------------------" >> ${ECHO_TTY}
# burn_image
echo "---------------------------end burn_image---------------------------" >> ${ECHO_TTY}

echo "---------------------------start burn_rootfs---------------------------" >> ${ECHO_TTY}
burn_rootfs
echo "---------------------------end burn_rootfs---------------------------" >> ${ECHO_TTY}

resize2fs_emmc

echo "---------------------------success---------------------------" >> ${ECHO_TTY}
echo "---------------------------success---------------------------" >> ${ECHO_TTY}
echo "---------------------------success---------------------------" >> ${ECHO_TTY}
sleep 3                                                                                       
kill $PID                                                                                     
update_success
