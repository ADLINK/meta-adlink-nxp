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

