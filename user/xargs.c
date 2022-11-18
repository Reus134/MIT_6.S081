#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define stdin 0
#define stdout 1
#define stderr 2
#define MAX_ARG_LEN 1024
#include "kernel/param.h"
int
main(int argc, char *argv[])
{
  int pid,n,buf_index=0;
  char buf,arg[MAX_ARG_LEN], *args[MAXARG];

  if(argc < 2){
    printf("args error!\n");
    exit(0);
  }
  //1.读取xargs之后的参数
  printf("%d\n",argc);
  for(int i=1;i<argc;i++)
    {
    args[i-1]=argv[i];
    printf("%s\n",args[i-1]);
    }
  //2.读取stdin的参数 一个一个的读
  while((n=read(stdin,&buf,1)>0))
  {
    if(buf=='\n')
    {
      arg[buf_index]=0;//读完了
      if((pid=fork())<0)
      {
        fprintf(stderr,"fork error\n");
      }
      else if(pid==0)
      {
        //子进程
        args[argc-1]=arg;//放进去
        args[argc]=0;
        exec(args[0],args);//exec
      }
      else{
        //父进程
        wait(0);
        buf_index=0;
      }
    }
    else{
      arg[buf_index++]=buf;//buf是一个字符
    }
  }
  
  exit(0);
}

