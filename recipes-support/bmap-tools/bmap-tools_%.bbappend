LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"
SRC_URI = "git://github.com/intel/${BPN};branch=main;protocol=https"
SRCREV = "7fa2f176d7d4c828705c938fa35152d57fe61c0a"
BASEVER = "3.7"
PYTHON_DIR:class-target = "python3"
PYTHON_SITEPACKAGES_DIR:class-target = "${libdir}/${PYTHON_DIR}/dist-packages"
inherit setuptools3_legacy

