FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/imx:"

SRC_URI_append = " \
               file://default.pa \ 
		"
