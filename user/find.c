#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
  
  char *p;

  // Find first character after last slash.在/之后找到第一个字符
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  return p+1;
}


void find(char *path, const char *filename)
{
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    if((fd = open(path,0)) < 0){//先打开这个路径
    fprintf(2, "find: cannot open %s\n", path);
    return;
    }
    //ftstat系统调用  打开的文件描述符的文件的一些状态写道st
    if (fstat(fd, &st) < 0) {
    fprintf(2, "find: cannot fstat %s\n", path);
    close(fd);
    return;
    }

    //选择不同的文件来打印
    switch(st.type){
        case T_FILE:
        if(strcmp(filename,fmtname(path))==0) printf("%s\n",path);

        break;

        case T_DIR://文件夹的话就要递归进取
        if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
            printf("ls: path too long\n");
            break;
        }
        strcpy(buf, path);//path是不能改的 const
        p = buf+strlen(buf);
        *p++ = '/';//和*(p++)一样  p++先指向下一个  然后在解饮用

        while(read(fd, &de, sizeof(de)) == sizeof(de)){
        if(de.inum == 0||strcmp(de.name, ".")==0||strcmp(de.name,"..")==0)
            continue;
        memmove(p, de.name, DIRSIZ);//de.name复制到p
        p[DIRSIZ] = 0;
        if(stat(buf, &st) < 0){//找不到这个路径
            printf("find: cannot stat %s\n", buf);
            continue;
        }
        find(buf,filename);
        }
        break;
    }
    close(fd);
    
}
int main(int argc, char *argv[])
{
    if (argc != 3) {
    fprintf(2, "usage: find <directory> <filename>\n");
    exit(1);
    }
  for(int i=2; i<argc; i++)
    find(argv[1], argv[i]);
  exit(0);
}