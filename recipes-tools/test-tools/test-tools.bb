SUMMARY = "Test binaries"
DESCRIPTION = "Add test binaries here which are missing in file system"
LICENSE = "CLOSED"

SRC_URI = "\
	file://sample_48000Hz.wav\
	file://sample_44100Hz.wav\
	file://sample_96000Hz.wav\
"

S = "${WORKDIR}"

do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${WORKDIR}/sample_48000Hz.wav ${D}${bindir}/sample_48000Hz.wav
	install -m 0755 ${WORKDIR}/sample_44100Hz.wav ${D}${bindir}/sample_44100Hz.wav
	install -m 0755 ${WORKDIR}/sample_96000Hz.wav ${D}${bindir}/sample_96000Hz.wav
}

do_package_qa() {
}

FILES_${PN} += "${bindir}/sample_48000Hz.wav $(bindir}/sample_44100Hz.wav ${bindir}/sample_96000Hz.wav"

