//copy.c :copy input to output

#include "kernel/types.h"
#include "user/user.h"

int
main()
{
    char buf[64];

    while(1)
    {
        int n=read(0,buf,sizeof(buf));//将n个字节读入buf；返回读取的字节数；如果文件结束，返回0
        if(n<=0)//读不到了 break
        {
            break;
        }
        write(1,buf,n);//从buf 写n 个字节到文件描述符fd; 返回n
    }
    
    exit(0);
}