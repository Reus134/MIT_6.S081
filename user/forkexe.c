//forkexe.c:fork then exec

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
int 
main()
{
    int status;
    int pid =fork();//fork一个子进程
    if(pid==0)
    {
        //child process
        printf("child process\n");
        char *argv[] ={"THIS", "IS","ECHO",0};//0是结束标注
        exec("echo", argv);//"本来是执行echo"用来执行argvs 然后不会返回
        printf("exe failed\n");
        exit(1);//1表示的是异常退出
    }
    else
    {
        //parent process
        printf("parent process\n");
        wait(&status);//注意wait系统调用会把等待子进程终止 然后把子进程的信息存储在status里面
        printf("the child process exited with status %d\n", status);

    }
    exit(0);
}