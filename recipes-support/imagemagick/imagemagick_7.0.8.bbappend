# Fix for using tarball instead of git
LIC_FILES_CHKSUM = "file://LICENSE;md5=05ff94b3ff59fe6fa7489fa26e3d9142"

SRC_URI = "https://github.com/ImageMagick/ImageMagick/archive/refs/tags/7.0.8-47.tar.gz"
SRC_URI[md5sum] = "ae26b845894f455e42b9630db2e74a94"
SRC_URI[sha256sum] = "8d2bfa68fea5ca04b62c095da8c4707bb62cd1961a25d03162ac3112d42b346a"

S = "${WORKDIR}/ImageMagick-7.0.8-47"

