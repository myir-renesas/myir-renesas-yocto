SUMMARY = "U-Boot bootloader fw_printenv/setenv utilities"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://fw_env.config \
"
DEPENDS += "u-boot"

do_install () {
    install -d ${D}${sysconfdir}
    install -m 0644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config

   # install -d ${D}${bindir}
#	install -m 0644 ${DEPLOY_DIR_IMAGE}/fw_printenv ${D}${bindir}/fw_printenv
#	install -m 0644 ${DEPLOY_DIR_IMAGE}/fw_setenv ${D}${bindir}/fw_setenv
}

FILES:${PN} += "${sysconfdir}/  ${bindir}"
