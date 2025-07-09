SUMMARY = "for sdcard program"
DESCRIPTION = "use sdcard boot up and program full image to emmc"

#LICENSE = "GPLv2"
LICENSE = "MIT"
#LIC_FILES_CHKSUM = "file://licenses/GPL-2;md5=94d55d512a9ba36caa9b7df079bae19f"
LIC_FILES_CHKSUM = "file://COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

RDEPENDS_${PN}_append = " qtbase"
inherit  systemd

S = "${WORKDIR}"

SRC_URI = "file://usr/bin/motor_control_simulator \
	   file://usr/bin/mxapp2 \
	   file://usr/bin/autorun.sh \
           file://autorun.service \
           file://msyh.ttc \
	   file://usr/share/fonts/ttf/msyh.ttc \
           file://usr/share/myir/ecg.dat \
           file://usr/share/myir/resp.text \
           file://usr/share/myir/Video/ \
           file://usr/share/myir/Music/ \
           file://usr/share/myir/Capture/ \
           file://usr/share/zh_CN \
	   file://COPYING.MIT \
          "

do_install(){
  install -d ${D}${systemd_system_unitdir}
        install -d ${D}${datadir}
        install -d ${D}${datadir}/myir
        install -d ${D}${datadir}/myir/Video
        install -d ${D}${datadir}/myir/Music
        install -d ${D}${datadir}/myir/Capture
        install -d ${D}${bindir}
	install -d ${D}/usr/lib64/fonts/
	install -d ${D}/usr/share/fonts/ttf/
	install -d ${D}/usr/lib/locale

        install -m 755 ${WORKDIR}/autorun.service ${D}${systemd_system_unitdir}/autorun.service

        install -m 755 ${WORKDIR}/usr/bin/* ${D}${bindir}

	install -m 755 ${WORKDIR}/msyh.ttc ${D}/usr/lib64/fonts/msyh.ttc

        install -m 755 ${WORKDIR}/usr/share/fonts/ttf/msyh.ttc ${D}/usr/share/fonts/ttf/msyh.ttc
        install -m 755 ${WORKDIR}${datadir}/myir/ecg.dat ${D}${datadir}/myir/ecg.dat
        install -m 755 ${WORKDIR}${datadir}/myir/resp.text ${D}${datadir}/myir/resp.text
        install -m 755 ${WORKDIR}${datadir}/myir/Video/* ${D}${datadir}/myir/Video
        install -m 755 ${WORKDIR}${datadir}/myir/Music/* ${D}${datadir}/myir/Music
        install -m 755 ${WORKDIR}${datadir}/myir/Capture/* ${D}${datadir}/myir/Capture
	cp -r ${WORKDIR}${datadir}/zh_CN ${D}/usr/lib/locale
 
}


FILES_${PN} = "/usr/bin/autorun.sh \
	       /usr/bin/motor_control_simulator \
	       /usr/bin/mxapp2 \
	      /usr/lib64/fonts/msyh.ttc \
	      ${datadir}/myir \
              ${datadir}/myir/Video \
              ${datadir}/myir/Music \
              ${datadir}/myir/Capture \
  	     /usr/share/fonts \
             /usr/share/fonts/ttf \
            /usr/share/fonts/ttf/msyh.ttc \
	    /usr/lib/locale \
	"

INSANE_SKIP_${PN} = "file-rdeps"
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "autorun.service"
SYSTEMD_AUTO_ENABLE = "enable"
