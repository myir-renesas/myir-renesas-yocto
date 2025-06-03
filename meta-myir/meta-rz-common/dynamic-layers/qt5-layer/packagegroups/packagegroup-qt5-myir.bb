# TODO add license
DESCRIPTION = "All Demos Packages for Qt5"

LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
    packagegroup-qt5-myir \
    packagegroup-qt5-myir-examples \
"

ALLOW_EMPTY_${PN} = "1"

# Requires Wayland to work
QT5_WAYLAND_PACKAGES = " \
    qtwayland \
    qtwayland-plugins \
    qtwayland-tools \
"

QT5_EXAMPLES = " \
	qtbase-examples \
	qtdeclarative-examples \
	qtmultimedia-examples \
"

RDEPENDS_${PN} += " \
	qtbase \
	qtbase-plugins \
	qtbase-tools \
	qtbase-fonts \
	${@bb.utils.contains("DISTRO_FEATURES", "wayland", "${QT5_WAYLAND_PACKAGES}", "", d)} \
	qtdeclarative \
	qtdeclarative-plugins \
	qtdeclarative-tools \
	qtdeclarative-qmlplugins \
	qtimageformats-plugins \
	qtgraphicaleffects-qmlplugins \
	qtconnectivity \
	qtconnectivity-qmlplugins \
	qtlocation-plugins-position \
	qtlocation-qmlplugins-positioning \
	qtlocation-positioning \
	qtsvg \
	qtsvg-plugins \
	qtsensors \
	qtsensors-plugins \
	qtsensors-qmlplugins \
	qtscript \
	qtserialport \
	qt5-qml-presentation-system \
	qtquickcontrols2 \
	qtquickcontrols \
"

RDEPENDS_${PN}-examples += " \
	${PN} \
	${QT5_EXAMPLES} \
"
