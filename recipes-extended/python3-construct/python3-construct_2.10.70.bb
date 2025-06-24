SUMMARY = "A powerful declarative symmetric parser/builder for binary data"
HOMEPAGE = "https://construct.readthedocs.io/en/latest/"
SECTION = "devel/python"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=202b39559c1c79fe4715ce81e9e0ac02"

SRC_URI[sha256sum] = "4d2472f9684731e58cc9c56c463be63baa1447d674e0d66aeb5627b22f512c29"

inherit pypi setuptools3

BBCLASSEXTEND = "native nativesdk"

