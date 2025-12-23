SUMMARY = "Temp Ctrl"
DESCRIPTION = "Temperature Control"
LICENSE = "GPL-2"
LIC_FILES_CHKSUM = "file://licenses/GPL-2;md5=94d55d512a9ba36caa9b7df079bae19f"

S = "${WORKDIR}"

SRC_URI = " \
     file://licenses/GPL-2 \
     file://qspi-pnsn.service \
     file://libmyir_code.so.1 \
     file://qspi_read_pnsn \
     "
inherit systemd

do_install() {
        install -d -m 755 ${D}${systemd_system_unitdir}
	install -d ${D}/usr/bin 
	install -d ${D}/usr/lib64

        install -m 644 ${WORKDIR}/qspi-pnsn.service ${D}${systemd_system_unitdir}/qspi-pnsn.service
	install -m 755 ${WORKDIR}/qspi_read_pnsn ${D}/usr/bin
	install -m 755  ${WORKDIR}/libmyir_code.so.1 ${D}/usr/lib64
	cd ${D}/usr/lib64
	ln -sf libmyir_code.so.1 libmyir_code.so
}

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "qspi-pnsn.service"
SYSTEMD_AUTO_ENABLE = "enable"

FILES_${PN} =" /usr/lib64  \
		/usr/bin/qspi_read_pnsn \
		${systemd_system_unitdir}/qspi-pnsn.service \
"
#INSANE_SKIP:eeprom-pnsn-dev += "dev-elf"
#FILES_${PN} += " /usr/lib/libmyir_code.so  "
#FILES_${PN}-dev = " /usr/lib/libmyir_code.so"
#INSANE_SKIP:${PN} += " dev-so already-stripped"
