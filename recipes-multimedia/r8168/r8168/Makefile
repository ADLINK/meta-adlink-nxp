TARGET_MODULE:=r8168
 
SRC := $(shell pwd)
 
 $(TARGET_MODULE)-objs := r8168_n.o r8168_asf.o rtl_eeprom.o rtltool.o
 
obj-m := $(TARGET_MODULE).o


all: modules

driver: modules


modules:
	$(MAKE) -C $(KERNEL_SRC) M=$(SRC) $@


modules_install:
	$(MAKE) -C $(KERNEL_SRC) M=$(SRC) modules_install


clean:
	rm -rf *.o *.ko *.mod.c     
