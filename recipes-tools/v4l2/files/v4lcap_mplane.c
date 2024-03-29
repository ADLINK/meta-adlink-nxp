/*
 *  V4L2 video capture example
 *
 *  This program can be used and distributed without restrictions.
 *
 *      This program is provided with the V4L2 API
 * see http://linuxtv.org/docs.php for more information
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <getopt.h>             /* getopt_long() */

#include <fcntl.h>              /* low-level i/o */
#include <unistd.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/mman.h>
#include <sys/ioctl.h>

#include <linux/videodev2.h>

#define CLEAR(x) memset(&(x), 0, sizeof(x))

#define NUM_PLANES 1

enum vb2_memory {
	VB2_MEMORY_UNKNOWN      = 0,
	VB2_MEMORY_MMAP         = 1,
};

struct buffer {
        void   *start[NUM_PLANES];
        size_t  length[NUM_PLANES];
};

static char dev_name[20];
static char convertcmd[100];
static int fd = -1;
struct buffer *buffers;
static unsigned int n_buffers;
static int out_buf;
static int frame_count = 1;
static int frame_number = 0;
static int img_width = 2112;
static int img_height = 1568;
static int status;

static int xioctl(int fh, int request, void *arg)
{
        int r;
	int i = 0;
        do {
                r = ioctl(fh, request, arg);
        } while (-1 == r && EINTR == errno);

        return r;
}

static void process_image(const void *p, int size)
{
        char filename[15];
	frame_number++;
        sprintf(filename, "frame-%d.raw", frame_number);
        FILE *fp=fopen(filename,"wb");
 
	fwrite(p, size, 1, fp);

        fflush(fp);
        fclose(fp);
}

static int read_frame(void)
{
        struct v4l2_buffer buf;
	struct v4l2_plane mplanes[1];
        unsigned int i;

	CLEAR(buf);

	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	buf.memory = VB2_MEMORY_MMAP;
	buf.m.planes    = mplanes;
	buf.length      = NUM_PLANES;

	if (-1 == xioctl(fd, VIDIOC_DQBUF, &buf)) {
		switch (errno) {
		case EAGAIN:
			return 0;
		default:
			fprintf(stderr, "VIDIOC_DQBUF: error - %d\n", errno);
			exit(EXIT_FAILURE);
		}
	}

	assert(buf.index < n_buffers);
	printf("plane bytesused: %u\n", buf.m.planes->bytesused);
	process_image(buffers[buf.index].start[0], buf.m.planes->bytesused);

	if (-1 == xioctl(fd, VIDIOC_QBUF, &buf)) {
		fprintf(stderr, "VIDIOC_QBUF error: %d\n", errno);
		exit(EXIT_FAILURE);
	}

        return 1;
}

static void stop_capturing(void)
{
        enum v4l2_buf_type type;
	type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	if (-1 == xioctl(fd, VIDIOC_STREAMOFF, &type)) {
		fprintf(stderr, "VIDIOC_STREAMOFF: error - %d\n", errno);
		exit(EXIT_FAILURE);
	}
}

static void mainloop(void)
{
        unsigned int count;

        count = frame_count;

	while (count-- > 0) {
		for (;;) {
			fd_set fds;
			struct timeval tv;
			int r;

			FD_ZERO(&fds);
			FD_SET(fd, &fds);

			/* Timeout. */
			tv.tv_sec = 4;
			tv.tv_usec = 0;

			r = select(fd + 1, &fds, NULL, NULL, &tv);

			if (-1 == r) {
				if (EINTR == errno)
					continue;
				fprintf(stderr, "select error\n");
				exit(EXIT_FAILURE);
			}

			if (0 == r) {
				fprintf(stderr, "select timeout\n");
				stop_capturing();
				exit(EXIT_FAILURE);
			}

			if (read_frame())
				break;
			/* EAGAIN - continue select loop. */
		}
	}
}

static void start_capturing(void)
{
        unsigned int i;
        enum v4l2_buf_type type;

	for (i = 0; i < n_buffers; ++i) {
		struct v4l2_buffer buf;
		struct v4l2_plane mplanes[1];

		CLEAR(buf);
		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
		buf.memory = VB2_MEMORY_MMAP;
		buf.index = i;
		buf.m.planes	= mplanes;
		buf.length	= NUM_PLANES;

		if (-1 == xioctl(fd, VIDIOC_QBUF, &buf)) {
			fprintf(stderr, "VIDIOC_QBUF error: %d\n", errno);
			exit(EXIT_FAILURE);
		}
	}

	type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	if (-1 == xioctl(fd, VIDIOC_STREAMON, &type)) {
		fprintf(stderr, "VIDIOC_STREAMON error: %d\n", errno);
		exit(EXIT_FAILURE);
	}
}

static void uninit_device(void)
{
        unsigned int i, j;
	for (i = 0; i < n_buffers; ++i)
		for (j = 0; j < NUM_PLANES; j++)
			munmap(buffers[i].start[j], buffers[i].length[j]);
        free(buffers);
}

static void init_mmap(void)
{
        struct v4l2_requestbuffers req;

        CLEAR(req);

        req.count = 4;
        req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
        req.memory = VB2_MEMORY_MMAP;

        if (-1 == xioctl(fd, VIDIOC_REQBUFS, &req)) {
        	fprintf(stderr, "VIDIOC_REQBUFS: error - %d\n", errno);
		exit(EXIT_FAILURE);
	}

        if (req.count < 2) {
                fprintf(stderr, "Insufficient buffer memory on %s\n",
                         dev_name);
                exit(EXIT_FAILURE);
        }

        buffers = calloc(req.count, sizeof(*buffers));

        if (!buffers) {
                fprintf(stderr, "Out of memory\n");
                exit(EXIT_FAILURE);
        }

        for (n_buffers = 0; n_buffers < req.count; ++n_buffers) {
                struct v4l2_buffer buf;
		struct v4l2_plane mplanes[NUM_PLANES];

                CLEAR(buf);

                buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
                buf.memory      = VB2_MEMORY_MMAP;
                buf.index       = n_buffers;
		buf.m.planes	= mplanes;
		buf.length	= NUM_PLANES;
 
		if (-1 == xioctl(fd, VIDIOC_QUERYBUF, &buf)) {
        		fprintf(stderr, "VIDIOC_QUERYBUF: error - %d\n", errno);
			exit(EXIT_FAILURE);
		}

		for(int j=0; j<NUM_PLANES; j++) {
                	buffers[n_buffers].length[j] = buf.m.planes[j].length;
			buffers[n_buffers].start[j] = mmap(NULL, buf.m.planes[j].length,
						PROT_READ | PROT_WRITE, /* recommended */
						MAP_SHARED,             /* recommended */
						fd, buf.m.planes[j].m.mem_offset);
                	if (MAP_FAILED == buffers[n_buffers].start[j]) {
				fprintf(stderr, "mmap: error - %d\n", errno);
				exit(EXIT_FAILURE);
			}
		}
        }
}


static void init_device(void)
{
        struct v4l2_capability cap;
        struct v4l2_cropcap cropcap;
        struct v4l2_crop crop;
        struct v4l2_format fmt;
	struct v4l2_streamparm parm;
        unsigned int min;

        if (-1 == xioctl(fd, VIDIOC_QUERYCAP, &cap)) {
        	fprintf(stderr, "VIDIOC_QUERYCAP: error - %d\n", errno);
		exit(EXIT_FAILURE);
	}

        if (!(cap.capabilities & V4L2_CAP_VIDEO_CAPTURE_MPLANE)) {
                fprintf(stderr, "%s is no video capture device\n",
                         dev_name);
                exit(EXIT_FAILURE);
        }

	if (!(cap.capabilities & V4L2_CAP_STREAMING)) {
		fprintf(stderr, "%s does not support streaming i/o\n",
			 dev_name);
		exit(EXIT_FAILURE);
	}

        CLEAR(fmt);

        fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
 
	fmt.fmt.pix_mp.width       = img_width; //replace
	fmt.fmt.pix_mp.height      = img_height; //replace
	fmt.fmt.pix_mp.pixelformat = V4L2_PIX_FMT_SBGGR8; //replace
	//fmt.fmt.pix_mp.pixelformat = V4L2_PIX_FMT_SBGGR10; //replace
	fmt.fmt.pix_mp.field       = V4L2_FIELD_ANY;
	fmt.fmt.pix_mp.num_planes  = 1;
	fmt.fmt.pix_mp.plane_fmt[0].bytesperline  = img_width;
	fmt.fmt.pix_mp.plane_fmt[0].sizeimage  = img_width * img_height;

	if (-1 == xioctl(fd, VIDIOC_S_FMT, &fmt)) {
		fprintf(stderr, "VIDIOC_S_FMT: error: %d\n", errno);
		exit(EXIT_FAILURE);
	}

	init_mmap();
}

static void close_device(void)
{
        if (-1 == close(fd)) {
                fprintf(stderr, "Failed to close device\n");
		exit(EXIT_FAILURE);
	}

        fd = -1;
}

static void open_device(void)
{
        fd = open(dev_name, O_RDWR /* required *//* | O_NONBLOCK*/, 0);

        if (fd == -1) {
                fprintf(stderr, "Cannot open '%s': %d\n", dev_name, errno);
                exit(EXIT_FAILURE);
        }
}

static void usage(FILE *fp, int argc, char **argv)
{
        fprintf(fp,
                 "Usage: %s [options]\n\n"
                 "Options:\n"
                 "-d | --device name   Video device name [%s]\n"
                 "-h | --help          Print this message\n"
                 "-c | --count         Number of frames to grab [%i]\n"
                 "-w | --width         Frame width\n"
                 "-v | --height        Frame height\n"
                 "",
                 argv[0], dev_name, frame_count);
}

int main(int argc, char **argv)
{
	int opt;
        strcpy(dev_name, "/dev/video0");

	while((opt = getopt(argc, argv, ":d:c:w:hv:")) != -1)
	{
		switch(opt)
		{
			case 'h':
                        	usage(stdout, argc, argv);
				exit(0);
			case 'd':
				strcpy(dev_name, optarg);
				break;
			case 'o':
				out_buf++;
				break;
			case 'c':
				frame_count = atoi(optarg);
				break;
			case 'w':
				img_width = atoi(optarg);
				break;
			case 'v':
				img_height = atoi(optarg);
				break;
			case '?':
				printf("unknown option: %c\n", optopt);
                        	usage(stderr, argc, argv);
				exit(EXIT_FAILURE);
			break;
		}
	}

	printf("\nvideo node: %s\n", dev_name);
	printf("frame count: %d\n", frame_count);
	printf("frame width: %d\n", img_width);
	printf("frame height: %d\n\n", img_height);
       
	open_device();
        init_device();
        start_capturing();
        mainloop();
        stop_capturing();
        uninit_device();
        close_device();

	//convert -size 2112x1568 -depth 8 gray:frame-2.raw sme1.png
	printf("\nRaw capture completed ... \n");
	printf("\nConverting to greyscale... may take a while...\n\n");
	while(frame_count > 0)
	{
		sprintf(convertcmd, "convert -size %dx%d -depth 8 gray:frame-%d.raw image-%d.png",
				img_width, img_height, frame_count, frame_count);
		status = system(convertcmd);
		if(status == 0)
			printf("Converted frame-%d.raw to image-%d.png\n",
						frame_count, frame_count);
		else
			printf("Failed conversion for frame-%d.raw\n", frame_count);
		frame_count--;
	}
	
	printf("\ngreyscale processing completed.\n\n");

        fprintf(stderr, "\n");
        return 0;
}

