
#To be fixed, including these demo file lead to build error

QT5_IMAGE_INSTALL_common_remove = "${@bb.utils.contains('MACHINE', 'lec-imx8mp', ' packagegroup-qt5-demos', '', d)}"
