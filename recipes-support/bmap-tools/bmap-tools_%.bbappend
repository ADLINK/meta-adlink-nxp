# bmap-tools_3.5.bbappend

# Use the archived ZIP snapshot instead of Git
SRC_URI = "https://github.com/intel/bmap-tools/archive/refs/heads/master.zip"

# Provide checksums (replace with exact values if needed)
SRC_URI[md5sum] = "ac57c7b1d02d97c3331c6c6143c96160"
SRC_URI[sha256sum] = "4061b8a4e558e517ebed51b5cb8a3e3b6a1b6475a5234f540689a3937cdf8497"

# Set source directory correctly (matches unzipped folder)
S = "${WORKDIR}/bmap-tools-main"

# Correct license file
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

PV = "3.5"
# Add Python native dependency
DEPENDS += "python3-native"

