FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

SRC_URI_append = " \
		   file://0003-supports-Chinese-encoding.patch \
                "
