
require recipes-core/images/core-image-minimal.bb
require include/core-image-renesas-base.inc
require include/core-image-bsp.inc

#IMAGE_INSTALL_append += " \
#    fac-burn-emmc-full \
#"
IMAGE_INSTALL += " \
	fac-burn-emmc-full \
"
