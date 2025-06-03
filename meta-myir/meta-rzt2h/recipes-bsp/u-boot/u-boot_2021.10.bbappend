SYSROOT_DIRS_append = " /boot"

#UBOOT_URI ?= "git://github.com/renesas-rz/renesas-u-boot-cip.git;protocol=https"
UBOOT_URI ?= "git://gitee.com/renesas_1/myir-renesas-uboot.git;protocol=https"
UBOOT_BRANCH ?= "develop_v2021"
#UBOOT_REV ?= "0adf5cb2dbbe47d304f7276aa4000b1cc4575fe7"
UBOOT_REV ?= "430418c0674af71fca7b294fa143b6ffbc7a664e"

SRC_URI = "${UBOOT_URI};branch=${UBOOT_BRANCH}"
SRCREV = "${UBOOT_REV}"
