/* Read MAC from sysfs entry,
 * set to net interface
 */

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>


int read_sysfs_file(char *sysfile, unsigned char *value, unsigned short size)
{
	int fd, ret;

	fd = open(sysfile, O_RDONLY);
	if(fd < 0)
		return -1;

	ret = read(fd, value, size); 
	if (ret > 0)
		close(fd);
	else {
		close(fd);
		return -1;
	}

	return 0;
}


int main(int argc, char *argv[])
{
	char sysfile[128];
	unsigned char pBuffer[64];
	unsigned short size;
	int ret, i;

	unsigned char MAC[20];
	unsigned char command[128];

	size = sizeof(sysfile);
	memset(sysfile, 0, sizeof(sysfile));
	memset(pBuffer, 0, sizeof(pBuffer));

	sprintf(sysfile, "/sys/bus/platform/devices/adl-bmc-boardinfo/information/mac_address");

	ret = read_sysfs_file(sysfile, pBuffer, size);
	if(ret < 0) {
		printf("Error! Reading sysfs file ... \n");
		exit(-1);
	}

	//pBuffer is 16 byte data from BMC
	for(i=0; i<16; i++) {
		if(pBuffer[i] != 0x00)
			break;
	}

	if(i == 16) {
		printf("Error! No valid MAC address from BMC .. \n");
		exit(-1);
	}

	//we assume MAC 1 is stored from pBuffer[0] to pBuffer[5], assign to argv[1] interface
	if(argc >= 2) {
		memset(MAC, 0, sizeof(MAC));

		memset(command, 0, sizeof(command));
		sprintf(command, "ifconfig %s down", argv[1]);
		system(command);

		memset(command, 0, sizeof(command));
		sprintf(MAC, "%x:%x:%x:%x:%x:%x", pBuffer[0], pBuffer[1], pBuffer[2], pBuffer[3], pBuffer[4], pBuffer[5]);
		sprintf(command, "ifconfig %s hw ether %s", argv[1], MAC);
		system(command);

		memset(command, 0, sizeof(command));
		sprintf(command, "ifconfig %s up", argv[1]);
		system(command);
	}

	//We assume MAC 2 is stored from pBuffer[7] to pBuffer[12], assign to argv[2] interface
	if(argc >=3 ) {
		memset(MAC, 0, sizeof(MAC));

		memset(command, 0, sizeof(command));
		sprintf(command, "ifconfig %s down", argv[2]);
		system(command);

		memset(command, 0, sizeof(command));
		sprintf(MAC, "%x:%x:%x:%x:%x:%x", pBuffer[7], pBuffer[8], pBuffer[9], pBuffer[10], pBuffer[11], pBuffer[12]);
		sprintf(command, "ifconfig %s hw ether %s", argv[2], MAC);
		system(command);

		memset(command, 0, sizeof(command));
		sprintf(command, "ifconfig %s up", argv[2]);
		system(command);
	}

	return 0;
}
