do_fix_patch () {
  sed -i 's,^enum ,typedef enum ,g' ${S}/pseudo_ipc.h
  sed -i 's,#endif,#endif\n#define _STAT_VER 0\n#define _MKNOD_VER 0\n,g' ${S}/ports/linux/portdefs.h
}
addtask fix_patch before do_configure after do_patch

