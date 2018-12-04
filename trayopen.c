#include <sys/ioctl.h>
#include <fcntl.h>
#include <linux/cdrom.h>

int main(int argc,char **argv) {
    int cdrom;
    int status=1;

    if ((cdrom = open(argv[1],O_RDONLY | O_NONBLOCK)) < 0) {
        printf("Unable to open device %s",argv[1]);
        exit(1);
    }

    if (ioctl(cdrom,CDROM_DRIVE_STATUS) == CDS_TRAY_OPEN) {
        status=0;
    }

    close(cdrom);
    exit(status);
}
