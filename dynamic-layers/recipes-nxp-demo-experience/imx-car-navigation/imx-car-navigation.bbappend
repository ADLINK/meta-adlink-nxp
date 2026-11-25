# Backport of NXP's fix in meta-nxp-demo-experience wrynose-6.18.37-2.1.0:
# fetch the CANopenNode submodule in do_fetch (gitsm). With plain git:// the
# recipe's "git submodule update" runs in do_compile, where bitbake blocks
# network access ("Could not resolve host: github.com").
SRC_URI = "gitsm://github.com/CANopenNode/CANopenLinux.git;branch=master;protocol=https"
