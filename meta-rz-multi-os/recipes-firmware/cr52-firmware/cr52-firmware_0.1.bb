SUMMARY = "CR52 RPMsg firmware"
LICENSE = "CLOSED"

EXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = " \
    file://*.elf \
    file://*.out \
"

INSANE_SKIP_${PN} = "arch"

do_install() {
    install -d ${D}/lib/firmware
    install -m 0644 ${WORKDIR}/*.elf ${D}/lib/firmware/ || true
    install -m 0644 ${WORKDIR}/*.out ${D}/lib/firmware/ || true
}

FILES_${PN} += " \
    /lib/firmware/*.elf \
    /lib/firmware/*.out \
"
