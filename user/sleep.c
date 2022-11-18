#include "kernel/types.h"
#include "user/user.h"


int main(int argc, char const * argv[])//注意这const 因为atoi的参数是const
{
    if(argc!=2)
    {
        printf("args error\n");
        exit(1);
    }
    int time=atoi(argv[1]);
    sleep(time);
    exit(0);
}

