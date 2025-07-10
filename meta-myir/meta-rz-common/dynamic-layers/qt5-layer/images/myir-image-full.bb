require recipes-graphics/images/core-image-weston.bb
require include/core-image-renesas-base.inc
require include/core-image-renesas-mmp.inc
require include/core-image-bsp.inc
SUMMARY = "Renesas core image with Qt5 platform support base on core-image-weston"

IMAGE_FEATURES += "splash package-management ssh-server-dropbear hwcodecs"
LICENSE = "MIT"
inherit core-image features_check

WHITELIST_GPL-3.0 += "gnutls-locale-zh-cn libidn2-locale-zh-cn"
GLIBC_GENERATE_LOCALES = "zh_CN.UTF-8 en_GB.UTF-8 en_US.UTF-8"
IMAGE_LINGUAS = "zh-cn"

IMAGE_FEATURES:remove = "splash"
IMAGE_INSTALL_append = " packagegroup-qt5-myir "
IMAGE_INSTALL_append = " ${@oe.utils.conditional("QT_DEMO", "1", " \
			        kernel-module-uvcvideo \
			        qt5-launch-demo \
			        qt5everywheredemo \
			        cinematicexperience \
			        qtsmarthome \
			        qt5nmapper \
			        qt5nmapcarousedemo \
			        qt5ledscreen \
			        quitbattery \
			        quitindicators \
			        qtdemo-extrafiles \
				", "", d)}"
IMAGE_INSTALL_append = " \
	qtquickcontrols2 \
	tcpdump \
	vim \
	ncurses \
	readline \
	evtest \
	python3-pip \
	sqlite3 \
	libmodbus \
	udev-extraconf \
	serialcheck \
	ppp \
	valgrind \
	mmc-utils \
	hmi \
	tzdata \
	myir-tool \
	fw-config \
"

### For cross-compile Qt ###
inherit populate_sdk_qt5

IMAGE_FEATURES += " \
    dev-pkgs tools-sdk \
    tools-debug debug-tweaks \
"

#TOOLCHAIN_HOST_TASK_append = " nativesdk-bison nativesdk-flex nativesdk-python3-pycryptodome nativesdk-python3-pycryptodomex "

#TOOLCHAIN_HOST_TASK_append = " nativesdk-qtbase-tools nativesdk-qtwayland-tools "

FEATURE_PACKAGES_tools-sdk += " packagegroup-qt5-toolchain-target kernel-devsrc "

# Post process after installed sdk
sdk_post_process () {
        # Set up kernel for building kernel config now
        echo "configuring scripts of kernel source for building .ko file..."
        $SUDO_EXEC bash -c 'source "$0" && cd "${OECORE_TARGET_SYSROOT=}/usr/src/kernel" && make scripts' $target_sdk_dir/environment-setup-@REAL_MULTIMACH_TARGET_SYS@
}
SDK_POST_INSTALL_COMMAND_append = " ${sdk_post_process}"

export SOURCE_DIR="${THISDIR}/environment-setup"
append_setup () {
    install -d ${SDK_OUTPUT}/${SDKPATH}/sysroots/${SDK_SYS}/environment-setup.d/
    cp ${SOURCE_DIR}/environment-setup-append.sh ${SDK_OUTPUT}/${SDKPATH}/sysroots/${SDK_SYS}/environment-setup.d/
}
SDK_POSTPROCESS_COMMAND_prepend = " append_setup;"

### For self-compile Qt ###
setup_qt_env () {
        if [ ! -e ${IMAGE_ROOTFS}/${sysconfdir}/profile.d/setup_qt_env ]
        then
                echo 'export PATH=$PATH:/usr/bin/qt5' > ${IMAGE_ROOTFS}${sysconfdir}/profile.d/setup_qt_env
                echo 'export INCLUDEPATH=$INCLUDEPATH:/usr/include/qt5' >> ${IMAGE_ROOTFS}${sysconfdir}/profile.d/setup_qt_env
        fi
}
ROOTFS_POSTPROCESS_COMMAND += 'setup_qt_env;'
