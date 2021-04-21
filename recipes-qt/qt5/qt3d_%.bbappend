
#To be fixed, including qt3d examples lead to build error

PACKAGECONFIG_remove = "${@bb.utils.contains('MACHINE', 'lec-imx8mp', ' examples', '', d)}"
