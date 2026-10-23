require conf/distro/sota.conf.inc

SOTA_MACHINE = "imx"

# Milestone 1: OSTree only, no aktualizr client yet.
SOTA_CLIENT_PROV = ""
IMAGE_INSTALL:remove:sota = "aktualizr aktualizr-info"

# One version label per published commit, so two builds are never labelled the
# same. DATETIME is excluded from the task hash, so this does not force a
# rebuild: unchanged content comes from sstate and keeps its existing label.
OSTREE_COMMIT_VERSION = "${DISTRO_VERSION}-${DATETIME}"
OSTREE_COMMIT_VERSION[vardepsexclude] = "DATETIME"

# Persistent repo outside the build directory, which a clean build would
# otherwise destroy along with every deployed device's update history.
# Defaults beside the sources; override in local.conf to publish elsewhere.
OSTREE_REPO = "${@os.path.dirname(d.getVar('TOPDIR'))}/ostree-repo/${MACHINE}"

# OSTree keeps the running deployment and its rollback target on the same
# filesystem, but wic sizes the rootfs partition for one.
# Reserve more room for the second parition: without it there is no space
# for an update and every "ostree admin upgrade" fails on the device.
IMAGE_ROOTFS_EXTRA_SPACE = "2097152"
