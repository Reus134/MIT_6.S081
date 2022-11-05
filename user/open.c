//create a new file and write to it

#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int
main()
{
    int fd=open("output.txt",O_CREATE|O_WRONLY);
    write(fd,"ooo\n",4);//往文件描述符写4个字节
    exit(0);
}