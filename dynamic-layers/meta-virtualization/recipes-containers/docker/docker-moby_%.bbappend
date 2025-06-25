FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
file://docker.service.template \
file://docker.init.template \
"

EXTRA_DOCKER_WAIT_SERVICE ?= ""
DOCKER_PARTITION_MOUNT_PATH ?= "/var/lib/docker"

MOUNT_PREFIX = ""

do_install:append () {
	if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
		install -m 644 ${WORKDIR}/docker.service.template ${D}/${systemd_unitdir}/system/docker.service
		sed -e "s|\@EXTRA_DOCKER_WAIT_SERVICE\@|${EXTRA_DOCKER_WAIT_SERVICE}|g" -i ${D}/${systemd_unitdir}/system/docker.service
		sed -e "s|\@DOCKER_PARTITION_MOUNT_PATH\@|${MOUNT_PREFIX}${DOCKER_PARTITION_MOUNT_PATH}|g" -i ${D}/${systemd_unitdir}/system/docker.service
		# enable the service, not better way but to force link the service file.
		install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
		ln -sf ${systemd_unitdir}/system/docker.service \
			${D}${sysconfdir}/systemd/system/multi-user.target.wants/docker.service
	else
		install -m 0755 ${WORKDIR}/docker.init.template ${D}${sysconfdir}/init.d/docker.init
		sed -e "s|\@DOCKER_PARTITION_MOUNT_PATH\@|${MOUNT_PREFIX}${DOCKER_PARTITION_MOUNT_PATH}|g" -i ${D}${sysconfdir}/init.d/docker.init
	fi
}

FILES:${PN} += "${sysconfdir}/systemd/system/multi-user.target.wants/"
