FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

inherit update-alternatives

ALTERNATIVE_${PN} = "stream"

ALTERNATIVE_LINK_NAME[stream] = "${bindir}/stream"
ALTERNATIVE_PRIORITY[stream] = "200"
ALTERNATIVE_TARGET[stream] = "${bindir}/stream"
