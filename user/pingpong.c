#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"
int main()
{
    int pd[2];
    pipe(pd);
    //int *status;
    if(fork()==0)//子进程
    {
        char buf[10];
        if(read(pd[1],buf,sizeof(buf)>=0))
        {
            printf("<%d>:received ping\n",getpid());
            write(pd[1],"h\n",1);
        }
        else{
            exit(1);
        }
        exit(0);
    }
    else//父进程
    {
        //父进程应该向子进程发送一个字节
        write(pd[1],"h\n",1);
        wait((int*) 0);
        char buf[10];
        if(read(pd[1],buf,sizeof(buf)>=0))
        {
            printf("<%d>:received pong\n",getpid());
            exit(0);
        }
        exit(1);
    }
    exit(0);
}