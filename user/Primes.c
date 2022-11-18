#include "kernel/types.h"
#include "user/user.h"
#define RD 0
#define WR 1

void primes(int lpipe[2])
{
    //注意每一个子进程要关闭lpipe的写端
    close(lpipe[1]);//不用写了就关闭

    int rpipe[2];
    pipe(rpipe);
    int top;
    if(read(lpipe[0],&top,sizeof(top))==0)
    {
        printf("没有东西读了");
        exit(0);
    }
    printf("primes(%d)\n",top);
    //往右边写入
    int data;
    while(read(lpipe[0],&data,sizeof(top)!=0))
    {
        if(data%top)
            write(rpipe[1],&data,sizeof(top));
    }
    close(rpipe[1]);//右边不需要写了
    close(lpipe[0]);//左边也不需要读了
    if(fork()==0)
    {
        primes(rpipe);//子进程和父进程都需要从左边读取 输送给右边pipe
    }
    else
    {
       close(rpipe[0]);//主进程不需要读rpipe 到这里以及写完了 所以可以关闭读端
       wait(0);
    }
}
int main()
{
    int p[2];
    pipe(p);

    for (int i = 2; i <= 35; ++i) //写入初始数据
        //注意这个&i 第二个参数是一块内存地址 void* 指向
        write(p[1], &i, sizeof(i));

    if (fork() == 0) {
        primes(p);//递归
    } else 
    {
    close(p[0]);
    close(p[1]);
    wait(0);
    }
    exit(0);
}