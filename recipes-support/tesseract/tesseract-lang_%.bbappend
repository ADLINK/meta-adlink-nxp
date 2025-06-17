# Override SRC_URI to use the zip file instead of git
SRC_URI = "https://github.com/tesseract-ocr/tessdata/archive/refs/tags/4.0.0.zip"
SRC_URI[md5sum] = "78d0e9da53d29277c0b28c2dc2ead4f9"
SRC_URI[sha256sum] = "2fd49746bba57e457e95e9ca523229dacba6c4d0de0c20f1e03bbab8caa25575"

# Update S to extracted zip directory
S = "${WORKDIR}/tessdata-4.0.0"

# Override license checksum to point to the common Apache-2.0 license file
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

# Override do_install to copy files from the extracted zip directory
do_install() {
    install -d ${D}${datadir}/tessdata
    cp -R --no-dereference --preserve=mode,links -v ${S}/*.traineddata ${D}${datadir}/tessdata
}

