TARGET_MODULE:=r8168
 
SRC := $(shell pwd)
 

obj-m := $(TARGET_MODULE).o

$(TARGET_MODULE)-objs := r8168_asf.o rtl_eeprom.o rtltool.o
 
all: modules

driver: modules


modules:
	$(MAKE) -C $(KERNEL_SRC) M=$(SRC) $@


install:
	$(MAKE) -C $(KERNEL_SRC) M=$(SRC) modules_install


clean:
	rm -rf *.o *.ko *.mod.c     
