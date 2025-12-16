require u-boot.inc
SYSROOT_DIRS_append = " /boot"

#UBOOT_URI ?= "git://github.com/renesas-rz/renesas-u-boot-cip.git;protocol=https"
UBOOT_URI ?= "git://github.com/myir-renesas/myir-renesas-uboot.git;protocol=https"
UBOOT_BRANCH ?= "develop_v2021"
UBOOT_REV ?= "9bd39dbfd2cdf52d8b8a3c2348fa1377b777c7c2"

SRC_URI = "${UBOOT_URI};branch=${UBOOT_BRANCH}"
SRCREV = "${UBOOT_REV}"
