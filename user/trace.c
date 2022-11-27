#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

int main(int argc,char *argv[])
{
    if (trace(atoi(argv[1])) < 0)
    {
        fprintf(2, "%s: trace failed\n", argv[0]);
        exit(1);
    }

    char * nargv[3];
    for(int i = 2; i < argc && i < 4; i++){
        nargv[i-2] = argv[i];
    }
    exec(nargv[0],nargv);

    exit(0);
}