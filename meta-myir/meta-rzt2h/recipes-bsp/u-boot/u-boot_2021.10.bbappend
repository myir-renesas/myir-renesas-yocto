require u-boot.inc
SYSROOT_DIRS_append = " /boot"

#UBOOT_URI ?= "git://github.com/renesas-rz/renesas-u-boot-cip.git;protocol=https"
UBOOT_URI ?= "git://github.com/myir-renesas/myir-renesas-uboot.git;protocol=https"
UBOOT_BRANCH ?= "develop_v2021"
UBOOT_REV ?= "707501c882a96d4b2f6d858dbade0f75b3af2496"

SRC_URI = "${UBOOT_URI};branch=${UBOOT_BRANCH}"
SRCREV = "${UBOOT_REV}"
