SUMMARY = "Sample Qt Application without GPU"
DESCRIPTION = "A Qt app for showing network and CPU load for the Renesas RZ processor."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://main.cpp;beginline=1;endline=21;md5=6de6f07209c4bd8c4465e22f197c8a07"

PV = "1.0.0"

DEPENDS = "qtbase"

SRC_URI = "git://github.com/pedwo/netdisp;protocol=https"
SRCREV = "f84d2b02d1d3a98e6cdc76bf3426ff921e46e54a"

S = "${WORKDIR}/git"

inherit qmake5
