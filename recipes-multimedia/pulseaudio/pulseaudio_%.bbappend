FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}/imx:"

SRC_URI:append = " \
               file://default.pa \ 
		"
