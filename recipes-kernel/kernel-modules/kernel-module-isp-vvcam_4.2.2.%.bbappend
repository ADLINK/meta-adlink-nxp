#
# imx678 camera sensor
#
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

IMX678_PATCHES = " \
file://0001-isp-vvcam-imx678.patch \
file://0002-Fix-imx678-driver-bug.patch \
file://0003-Support-clock-source-from-host.patch \
file://0004-vvcam-imx678-beautify-kernel-logs-and-codes.patch \
file://0005-vvcam-set-AllPixel-mode-to-12bits-bit-width.patch \
"

SRC_URI += "${@bb.utils.contains('IMAGE_FEATURES', 'imx678', "${IMX678_PATCHES}", '', d)}"

do_patch[prefuncs] += "reset_source_path"
python reset_source_path() {
    workdir = d.getVar("WORKDIR")
    d.setVar("S", "{}/git".format(workdir))
}

do_patch[postfuncs] += "set_module_path"
python set_module_path() {
    workdir = d.getVar("WORKDIR")
    d.setVar("S", "{}/git/vvcam/v4l2".format(workdir))
}

KERNEL_MODULE_AUTOLOAD:append = " ${@bb.utils.contains('IMAGE_FEATURES', 'imx678', 'imx678', '', d)}"
