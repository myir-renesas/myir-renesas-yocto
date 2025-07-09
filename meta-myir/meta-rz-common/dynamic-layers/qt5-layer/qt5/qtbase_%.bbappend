# Copyright (C) 2013 Eric Bénard - Eukréa Electromatique
# Copyright (C) 2016 O.S. Systems Software LTDA.
# Copyright (C) 2016 Freescale Semiconductor
# Copyright 2017-2018 NXP

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

IMX_BACKEND = \
    "${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'wayland',\
        bb.utils.contains('DISTRO_FEATURES',     'x11',     'x11', \
                                                             'fb', d), d)}"

SRC_URI_append = " \
    file://qt5-${IMX_BACKEND}.sh \
"

PARALLEL_MAKEINST = ""
PARALLEL_MAKE_task-install = "${PARALLEL_MAKEINST}"
# switch to GLES 2 support
PACKAGECONFIG_GL = "${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'gles2', '', d)}"
#
DEP = " mtdev libxkbcommon freetype fontconfig libinput libproxy"
PACKAGECONFIG_remove = "openssl"
PACKAGECONFIG_append = " alsa sql-sqlite sql-sqlite2 openssl icu accessibility examples"

# Select wayland as the default platform abstraction plugin for Qt
CONF_ADD_X11 = "${@bb.utils.contains('DISTRO_FEATURES', 'x11', ' -qpa xcb -xcb -xcb-xlib -system-xcb -eglfs', '', d)}"
CONF_ADD_WAYLAND = "${@bb.utils.contains('DISTRO_FEATURES', 'wayland', ' -qpa wayland -no-xcb -wayland', '', d)}"
PACKAGECONFIG_CONFARGS_append += "\
        -no-kms \
        -no-gbm \
        -no-evdev \
        -no-sse2 \
        -no-sse3 \
	-qpa wayland \
	-no-xcb \
"

PACKAGECONFIG_append += " sm linuxfb gles2 tslib cups"
PACKAGECONFIG[nis] = ""

do_install_append () {
    if ls ${D}${libdir}/pkgconfig/Qt5*.pc >/dev/null 2>&1; then
        sed -i 's,-L${STAGING_DIR_HOST}/usr/lib,,' ${D}${libdir}/pkgconfig/Qt5*.pc
    fi
    install -d ${D}${sysconfdir}/profile.d/
    install -m 0755 ${WORKDIR}/qt5-${IMX_BACKEND}.sh ${D}${sysconfdir}/profile.d/qt5.sh
}

FILES_${PN} += "${sysconfdir}/profile.d/qt5.sh"

INSANE_SKIP_${PN}-plugins = " file-rdeps"
INSANE_SKIP_${PN}_append = " file-rdeps"
INSANE_SKIP_${PN}-examples_append = " file-rdeps"
