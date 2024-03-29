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
#include <linux/i2c.h>
#include <linux/i2c-dev.h>
#include <sys/ioctl.h>

#define PATH_SIZE 256
#define MAX_DEV_LIST 256
#define MAX_BUF_SIZE 256
#define SEMA_I2C_ADDR 0x28

int open_i2c_host(void)
{
	int fd, fd_, ret;
	char path_name[PATH_SIZE] = {0};
	long addr = SEMA_I2C_ADDR << 1;
	char tx_data[5] = {0};
	char rx_data[MAX_BUF_SIZE] = {0};

	struct i2c_msg  msgs[2];
	struct i2c_rdwr_ioctl_data msgset;

	tx_data[0] = 0x30;

	msgs[0].addr  = SEMA_I2C_ADDR;
	msgs[0].flags = 0;
	msgs[0].buf   = tx_data;
	msgs[0].len   = 1;
	msgs[1].addr  = SEMA_I2C_ADDR;
	msgs[1].flags = I2C_M_RD;
	msgs[1].buf   = rx_data;
	msgs[1].len   = MAX_BUF_SIZE - 1;

	msgset.msgs  = msgs;
	msgset.nmsgs = 2;

	for(fd_ = 0; fd_ < MAX_DEV_LIST; fd_++)
	{
		memset(path_name, 0, PATH_SIZE);
		sprintf(path_name, "/dev/i2c-%d", fd_);
		if((fd = open(path_name, O_RDWR)) == -1)
		{
			if(errno == EACCES)
			{
				return -EACCES;
			}
			continue;
		}

		if((ret = ioctl(fd, I2C_RDWR, &msgset)) != -1)
		{
			return fd;
		}
		close(fd);
	}

	return -1;
}

int enter_admin_mode(int fd)
{
	char tx_data[5] = {0};
	char rx_data[MAX_BUF_SIZE] = {0};

	struct i2c_msg  msgs[2];
	struct i2c_rdwr_ioctl_data msgset;

	if(fd < 0)
	{
		return -1;
	}

	tx_data[0] = 0x50;
	tx_data[1] = 0x4;
	tx_data[2] = 0xAE;
	tx_data[3] = 0xCD;
	tx_data[4] = 0x17;
	tx_data[5] = 0x51;

	msgs[0].addr  = SEMA_I2C_ADDR;
	msgs[0].flags = 0;
	msgs[0].buf   = tx_data;
	msgs[0].len   = 6;

	msgset.msgs  = msgs;
	msgset.nmsgs = 1;

	if(ioctl(fd, I2C_RDWR, &msgset) < 0)
	{
		return -1;
	}

	return 0;
}

int leave_admin_mode(int fd)
{
	char tx_data[5] = {0};
	char rx_data[MAX_BUF_SIZE] = {0};

	struct i2c_msg  msgs[2];
	struct i2c_rdwr_ioctl_data msgset;

	if(fd < 0)
	{
		return -1;
	}

	tx_data[0] = 0x5F;
	memset(rx_data, 0, sizeof(rx_data));

	msgs[0].addr  = SEMA_I2C_ADDR;
	msgs[0].flags = 0;
	msgs[0].buf   = tx_data;
	msgs[0].len   = 1;
	msgs[1].addr  = SEMA_I2C_ADDR;
	msgs[1].flags = I2C_M_RD;
	msgs[1].buf   = rx_data;
	msgs[1].len   = MAX_BUF_SIZE - 1;

	msgset.msgs  = msgs;
	msgset.nmsgs = 2;

	if(ioctl(fd, I2C_RDWR, &msgset) < 0)
	{
		return -1;
	}

	return 0;
}

int read_odm_data(int fd, int offset, char *buf, int len)
{
	char tx_data[5] = {0};
	char rx_data[MAX_BUF_SIZE] = {0}, i;

	struct i2c_msg  msgs[2];
	struct i2c_rdwr_ioctl_data msgset;

	if(fd < 0)
	{
		return -1;
	}

	tx_data[0] = 0x40;
	tx_data[1] = 0x3;
	tx_data[2] = 0x04;
	tx_data[3] = 0x10 * offset;
	tx_data[4] = 0x10;

	msgs[0].addr  = SEMA_I2C_ADDR;
	msgs[0].flags = 0;
	msgs[0].buf   = tx_data;
	msgs[0].len   = 5;

	msgset.msgs  = msgs;
	msgset.nmsgs = 1;

	if(ioctl(fd, I2C_RDWR, &msgset) < 0)
	{
		return -1;
	}

	memset(rx_data, 0, sizeof(rx_data));
	tx_data[0] = 0x42;
	tx_data[1] = 0x10;

	msgs[0].addr  = SEMA_I2C_ADDR;
	msgs[0].flags = 0;
	msgs[0].buf   = tx_data;
	msgs[0].len   = 2;
	msgs[1].addr  = SEMA_I2C_ADDR;
	msgs[1].flags = I2C_M_RD;
	msgs[1].buf   = rx_data;
	msgs[1].len   = MAX_BUF_SIZE - 1;

	msgset.msgs  = msgs;
	msgset.nmsgs = 2;

	if(ioctl(fd, I2C_RDWR, &msgset) < 0)
	{
		return -1;
	}

	for(i = 0; i < 0x10 && i < len ; i++)
	{
		buf[i] = rx_data[i+1];
	}

	return 0;
}

int main(int argc, char *argv[])
{
	unsigned char pBuffer[64];
	unsigned short size;
	int ret, i, fd;
	char buffer[100] = {0};

	unsigned char MAC[20];
	unsigned char command[128];

	if((fd = open_i2c_host()) < 0)
	{
		if(fd == -EACCES)
		{
			printf("sudo privilege missing\n");
			return -EACCES;
		}
		printf("BMC not found\n");
	}


	if(enter_admin_mode(fd) != 0)
	{
		printf("Error in entering admin mode\n");
		return -1;
	}

	if(read_odm_data(fd, 6, buffer, sizeof(buffer)) == 0)
	{
		for(i = 0; i < 16; i++)
		{
			printf("%02x",buffer[i]);
		}
		printf("\n");
	}

	if(leave_admin_mode(fd) != 0)
	{
		printf("Error in leaving admin mode\n");
		return -1;
	}

	//we assume MAC 1 is stored from buffer[0] to buffer[5], assign to argv[1] interface
	if(argc >= 2) {
		memset(MAC, 0, sizeof(MAC));

		memset(command, 0, sizeof(command));
		sprintf(command, "ip link set dev %s down", argv[1]);
		system(command);

		memset(command, 0, sizeof(command));
		sprintf(MAC, "%x:%x:%x:%x:%x:%x", buffer[0], buffer[1], buffer[2], buffer[3], buffer[4], buffer[5]);
		sprintf(command, "ip link set dev %s address %s", argv[1], MAC);
		system(command);

		memset(command, 0, sizeof(command));
		sprintf(command, "ip link set dev %s up", argv[1]);
		system(command);
	}

	//We assume MAC 2 is stored from buffer[6] to buffer[11], assign to argv[2] interface
	if(argc >=3 ) {
		memset(MAC, 0, sizeof(MAC));

		memset(command, 0, sizeof(command));
		sprintf(command, "ip link set dev %s down", argv[2]);
		system(command);

		memset(command, 0, sizeof(command));
		sprintf(MAC, "%x:%x:%x:%x:%x:%x", buffer[6], buffer[7], buffer[8], buffer[9], buffer[10], buffer[11]);
		sprintf(command, "ip link set dev %s address %s", argv[2], MAC);
		system(command);

		memset(command, 0, sizeof(command));
		sprintf(command, "ip link set dev %s up", argv[2]);
		system(command);
	}

	return 0;
}
