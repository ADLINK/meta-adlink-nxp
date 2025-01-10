#
# imx678 camera sensor
#
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
file://0001-isp-vvcam-imx678.patch \
file://0002-Fix-imx678-driver-bug.patch \
file://0003-Support-clock-source-from-host.patch \
"

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

