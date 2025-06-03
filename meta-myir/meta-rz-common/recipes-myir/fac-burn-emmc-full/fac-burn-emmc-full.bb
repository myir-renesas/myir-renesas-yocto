SUMMARY = "for sdcard program"
DESCRIPTION = "use sdcard boot up and program full image to emmc"

#LICENSE = "GPLv2"
LICENSE = "MIT"
#LIC_FILES_CHKSUM = "file://licenses/GPL-2;md5=94d55d512a9ba36caa9b7df079bae19f"
LIC_FILES_CHKSUM = "file://COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

inherit  systemd

S = "${WORKDIR}"

SRC_URI = "file://home/root/burn_emmc.sh \
           file://fac-burn-emmc.service \
	   file://COPYING.MIT \
          "

do_install(){
  install -d ${D}${systemd_system_unitdir}
        install -d ${D}/home/root/mfgimage
        install -d ${D}/home/root/mfgimage/bootloader

        install -m 755 ${WORKDIR}/fac-burn-emmc.service ${D}${systemd_system_unitdir}/fac-burn-emmc.service

        install -m 755 ${WORKDIR}/home/root/burn_emmc.sh ${D}/home/root/burn_emmc.sh
 
        for i in ${IMAGE_BOOT_FILES};do
                install -m 755 ${DEPLOY_DIR_IMAGE}/${i} ${D}/home/root/mfgimage/bootloader/${i}
        done


        install -m 755 ${DEPLOY_DIR_IMAGE}/myir-image-full-${MACHINE}.tar.gz  ${D}/home/root/mfgimage/myir-image-full-${MACHINE}.tar.gz
}


FILES_${PN} = "/"

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "fac-burn-emmc.service"
SYSTEMD_AUTO_ENABLE = "enable"
