
user/_Primes：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <primes>:
#include "user/user.h"
#define RD 0
#define WR 1

void primes(int lpipe[2])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
    //注意每一个子进程要关闭lpipe的写端
    close(lpipe[1]);//不用写了就关闭
   c:	4148                	lw	a0,4(a0)
   e:	00000097          	auipc	ra,0x0
  12:	3fc080e7          	jalr	1020(ra) # 40a <close>

    int rpipe[2];
    pipe(rpipe);
  16:	fd840513          	addi	a0,s0,-40
  1a:	00000097          	auipc	ra,0x0
  1e:	3d8080e7          	jalr	984(ra) # 3f2 <pipe>
    int top;
    if(read(lpipe[0],&top,sizeof(top))==0)
  22:	4611                	li	a2,4
  24:	fd440593          	addi	a1,s0,-44
  28:	4088                	lw	a0,0(s1)
  2a:	00000097          	auipc	ra,0x0
  2e:	3d0080e7          	jalr	976(ra) # 3fa <read>
  32:	c529                	beqz	a0,7c <primes+0x7c>
    {
        printf("没有东西读了");
        exit(0);
    }
    printf("primes(%d)\n",top);
  34:	fd442583          	lw	a1,-44(s0)
  38:	00001517          	auipc	a0,0x1
  3c:	8e050513          	addi	a0,a0,-1824 # 918 <malloc+0x100>
  40:	00000097          	auipc	ra,0x0
  44:	71a080e7          	jalr	1818(ra) # 75a <printf>
    //往右边写入
    int data;
    while(read(lpipe[0],&data,sizeof(top)!=0))
  48:	4605                	li	a2,1
  4a:	fd040593          	addi	a1,s0,-48
  4e:	4088                	lw	a0,0(s1)
  50:	00000097          	auipc	ra,0x0
  54:	3aa080e7          	jalr	938(ra) # 3fa <read>
  58:	cd1d                	beqz	a0,96 <primes+0x96>
    {
        if(data%top)
  5a:	fd042783          	lw	a5,-48(s0)
  5e:	fd442703          	lw	a4,-44(s0)
  62:	02e7e7bb          	remw	a5,a5,a4
  66:	d3ed                	beqz	a5,48 <primes+0x48>
            write(rpipe[1],&data,sizeof(top));
  68:	4611                	li	a2,4
  6a:	fd040593          	addi	a1,s0,-48
  6e:	fdc42503          	lw	a0,-36(s0)
  72:	00000097          	auipc	ra,0x0
  76:	390080e7          	jalr	912(ra) # 402 <write>
  7a:	b7f9                	j	48 <primes+0x48>
        printf("没有东西读了");
  7c:	00001517          	auipc	a0,0x1
  80:	88450513          	addi	a0,a0,-1916 # 900 <malloc+0xe8>
  84:	00000097          	auipc	ra,0x0
  88:	6d6080e7          	jalr	1750(ra) # 75a <printf>
        exit(0);
  8c:	4501                	li	a0,0
  8e:	00000097          	auipc	ra,0x0
  92:	354080e7          	jalr	852(ra) # 3e2 <exit>
    }
    close(rpipe[1]);//右边不需要写了
  96:	fdc42503          	lw	a0,-36(s0)
  9a:	00000097          	auipc	ra,0x0
  9e:	370080e7          	jalr	880(ra) # 40a <close>
    close(lpipe[0]);//左边也不需要读了
  a2:	4088                	lw	a0,0(s1)
  a4:	00000097          	auipc	ra,0x0
  a8:	366080e7          	jalr	870(ra) # 40a <close>
    if(fork()==0)
  ac:	00000097          	auipc	ra,0x0
  b0:	32e080e7          	jalr	814(ra) # 3da <fork>
  b4:	ed01                	bnez	a0,cc <primes+0xcc>
    {
        primes(rpipe);//子进程和父进程都需要从左边读取 输送给右边pipe
  b6:	fd840513          	addi	a0,s0,-40
  ba:	00000097          	auipc	ra,0x0
  be:	f46080e7          	jalr	-186(ra) # 0 <primes>
    else
    {
       close(rpipe[0]);//主进程不需要读rpipe 到这里以及写完了 所以可以关闭读端
       wait(0);
    }
}
  c2:	70a2                	ld	ra,40(sp)
  c4:	7402                	ld	s0,32(sp)
  c6:	64e2                	ld	s1,24(sp)
  c8:	6145                	addi	sp,sp,48
  ca:	8082                	ret
       close(rpipe[0]);//主进程不需要读rpipe 到这里以及写完了 所以可以关闭读端
  cc:	fd842503          	lw	a0,-40(s0)
  d0:	00000097          	auipc	ra,0x0
  d4:	33a080e7          	jalr	826(ra) # 40a <close>
       wait(0);
  d8:	4501                	li	a0,0
  da:	00000097          	auipc	ra,0x0
  de:	310080e7          	jalr	784(ra) # 3ea <wait>
}
  e2:	b7c5                	j	c2 <primes+0xc2>

00000000000000e4 <main>:
int main()
{
  e4:	7179                	addi	sp,sp,-48
  e6:	f406                	sd	ra,40(sp)
  e8:	f022                	sd	s0,32(sp)
  ea:	ec26                	sd	s1,24(sp)
  ec:	1800                	addi	s0,sp,48
    int p[2];
    pipe(p);
  ee:	fd840513          	addi	a0,s0,-40
  f2:	00000097          	auipc	ra,0x0
  f6:	300080e7          	jalr	768(ra) # 3f2 <pipe>

    for (int i = 2; i <= 35; ++i) //写入初始数据
  fa:	4789                	li	a5,2
  fc:	fcf42a23          	sw	a5,-44(s0)
 100:	02300493          	li	s1,35
        //注意这个&i 第二个参数是一块内存地址 void* 指向
        write(p[1], &i, sizeof(i));
 104:	4611                	li	a2,4
 106:	fd440593          	addi	a1,s0,-44
 10a:	fdc42503          	lw	a0,-36(s0)
 10e:	00000097          	auipc	ra,0x0
 112:	2f4080e7          	jalr	756(ra) # 402 <write>
    for (int i = 2; i <= 35; ++i) //写入初始数据
 116:	fd442783          	lw	a5,-44(s0)
 11a:	2785                	addiw	a5,a5,1
 11c:	0007871b          	sext.w	a4,a5
 120:	fcf42a23          	sw	a5,-44(s0)
 124:	fee4d0e3          	bge	s1,a4,104 <main+0x20>

    if (fork() == 0) {
 128:	00000097          	auipc	ra,0x0
 12c:	2b2080e7          	jalr	690(ra) # 3da <fork>
 130:	ed01                	bnez	a0,148 <main+0x64>
        primes(p);//递归
 132:	fd840513          	addi	a0,s0,-40
 136:	00000097          	auipc	ra,0x0
 13a:	eca080e7          	jalr	-310(ra) # 0 <primes>
    {
    close(p[0]);
    close(p[1]);
    wait(0);
    }
    exit(0);
 13e:	4501                	li	a0,0
 140:	00000097          	auipc	ra,0x0
 144:	2a2080e7          	jalr	674(ra) # 3e2 <exit>
    close(p[0]);
 148:	fd842503          	lw	a0,-40(s0)
 14c:	00000097          	auipc	ra,0x0
 150:	2be080e7          	jalr	702(ra) # 40a <close>
    close(p[1]);
 154:	fdc42503          	lw	a0,-36(s0)
 158:	00000097          	auipc	ra,0x0
 15c:	2b2080e7          	jalr	690(ra) # 40a <close>
    wait(0);
 160:	4501                	li	a0,0
 162:	00000097          	auipc	ra,0x0
 166:	288080e7          	jalr	648(ra) # 3ea <wait>
 16a:	bfd1                	j	13e <main+0x5a>

000000000000016c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 16c:	1141                	addi	sp,sp,-16
 16e:	e422                	sd	s0,8(sp)
 170:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 172:	87aa                	mv	a5,a0
 174:	0585                	addi	a1,a1,1
 176:	0785                	addi	a5,a5,1
 178:	fff5c703          	lbu	a4,-1(a1)
 17c:	fee78fa3          	sb	a4,-1(a5)
 180:	fb75                	bnez	a4,174 <strcpy+0x8>
    ;
  return os;
}
 182:	6422                	ld	s0,8(sp)
 184:	0141                	addi	sp,sp,16
 186:	8082                	ret

0000000000000188 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 188:	1141                	addi	sp,sp,-16
 18a:	e422                	sd	s0,8(sp)
 18c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 18e:	00054783          	lbu	a5,0(a0)
 192:	cb91                	beqz	a5,1a6 <strcmp+0x1e>
 194:	0005c703          	lbu	a4,0(a1)
 198:	00f71763          	bne	a4,a5,1a6 <strcmp+0x1e>
    p++, q++;
 19c:	0505                	addi	a0,a0,1
 19e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a0:	00054783          	lbu	a5,0(a0)
 1a4:	fbe5                	bnez	a5,194 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1a6:	0005c503          	lbu	a0,0(a1)
}
 1aa:	40a7853b          	subw	a0,a5,a0
 1ae:	6422                	ld	s0,8(sp)
 1b0:	0141                	addi	sp,sp,16
 1b2:	8082                	ret

00000000000001b4 <strlen>:

uint
strlen(const char *s)
{
 1b4:	1141                	addi	sp,sp,-16
 1b6:	e422                	sd	s0,8(sp)
 1b8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1ba:	00054783          	lbu	a5,0(a0)
 1be:	cf91                	beqz	a5,1da <strlen+0x26>
 1c0:	0505                	addi	a0,a0,1
 1c2:	87aa                	mv	a5,a0
 1c4:	4685                	li	a3,1
 1c6:	9e89                	subw	a3,a3,a0
 1c8:	00f6853b          	addw	a0,a3,a5
 1cc:	0785                	addi	a5,a5,1
 1ce:	fff7c703          	lbu	a4,-1(a5)
 1d2:	fb7d                	bnez	a4,1c8 <strlen+0x14>
    ;
  return n;
}
 1d4:	6422                	ld	s0,8(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret
  for(n = 0; s[n]; n++)
 1da:	4501                	li	a0,0
 1dc:	bfe5                	j	1d4 <strlen+0x20>

00000000000001de <memset>:

void*
memset(void *dst, int c, uint n)
{
 1de:	1141                	addi	sp,sp,-16
 1e0:	e422                	sd	s0,8(sp)
 1e2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1e4:	ce09                	beqz	a2,1fe <memset+0x20>
 1e6:	87aa                	mv	a5,a0
 1e8:	fff6071b          	addiw	a4,a2,-1
 1ec:	1702                	slli	a4,a4,0x20
 1ee:	9301                	srli	a4,a4,0x20
 1f0:	0705                	addi	a4,a4,1
 1f2:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1f4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1f8:	0785                	addi	a5,a5,1
 1fa:	fee79de3          	bne	a5,a4,1f4 <memset+0x16>
  }
  return dst;
}
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	addi	sp,sp,16
 202:	8082                	ret

0000000000000204 <strchr>:

char*
strchr(const char *s, char c)
{
 204:	1141                	addi	sp,sp,-16
 206:	e422                	sd	s0,8(sp)
 208:	0800                	addi	s0,sp,16
  for(; *s; s++)
 20a:	00054783          	lbu	a5,0(a0)
 20e:	cb99                	beqz	a5,224 <strchr+0x20>
    if(*s == c)
 210:	00f58763          	beq	a1,a5,21e <strchr+0x1a>
  for(; *s; s++)
 214:	0505                	addi	a0,a0,1
 216:	00054783          	lbu	a5,0(a0)
 21a:	fbfd                	bnez	a5,210 <strchr+0xc>
      return (char*)s;
  return 0;
 21c:	4501                	li	a0,0
}
 21e:	6422                	ld	s0,8(sp)
 220:	0141                	addi	sp,sp,16
 222:	8082                	ret
  return 0;
 224:	4501                	li	a0,0
 226:	bfe5                	j	21e <strchr+0x1a>

0000000000000228 <gets>:

char*
gets(char *buf, int max)
{
 228:	711d                	addi	sp,sp,-96
 22a:	ec86                	sd	ra,88(sp)
 22c:	e8a2                	sd	s0,80(sp)
 22e:	e4a6                	sd	s1,72(sp)
 230:	e0ca                	sd	s2,64(sp)
 232:	fc4e                	sd	s3,56(sp)
 234:	f852                	sd	s4,48(sp)
 236:	f456                	sd	s5,40(sp)
 238:	f05a                	sd	s6,32(sp)
 23a:	ec5e                	sd	s7,24(sp)
 23c:	1080                	addi	s0,sp,96
 23e:	8baa                	mv	s7,a0
 240:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 242:	892a                	mv	s2,a0
 244:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 246:	4aa9                	li	s5,10
 248:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 24a:	89a6                	mv	s3,s1
 24c:	2485                	addiw	s1,s1,1
 24e:	0344d863          	bge	s1,s4,27e <gets+0x56>
    cc = read(0, &c, 1);
 252:	4605                	li	a2,1
 254:	faf40593          	addi	a1,s0,-81
 258:	4501                	li	a0,0
 25a:	00000097          	auipc	ra,0x0
 25e:	1a0080e7          	jalr	416(ra) # 3fa <read>
    if(cc < 1)
 262:	00a05e63          	blez	a0,27e <gets+0x56>
    buf[i++] = c;
 266:	faf44783          	lbu	a5,-81(s0)
 26a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 26e:	01578763          	beq	a5,s5,27c <gets+0x54>
 272:	0905                	addi	s2,s2,1
 274:	fd679be3          	bne	a5,s6,24a <gets+0x22>
  for(i=0; i+1 < max; ){
 278:	89a6                	mv	s3,s1
 27a:	a011                	j	27e <gets+0x56>
 27c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 27e:	99de                	add	s3,s3,s7
 280:	00098023          	sb	zero,0(s3)
  return buf;
}
 284:	855e                	mv	a0,s7
 286:	60e6                	ld	ra,88(sp)
 288:	6446                	ld	s0,80(sp)
 28a:	64a6                	ld	s1,72(sp)
 28c:	6906                	ld	s2,64(sp)
 28e:	79e2                	ld	s3,56(sp)
 290:	7a42                	ld	s4,48(sp)
 292:	7aa2                	ld	s5,40(sp)
 294:	7b02                	ld	s6,32(sp)
 296:	6be2                	ld	s7,24(sp)
 298:	6125                	addi	sp,sp,96
 29a:	8082                	ret

000000000000029c <stat>:

int
stat(const char *n, struct stat *st)
{
 29c:	1101                	addi	sp,sp,-32
 29e:	ec06                	sd	ra,24(sp)
 2a0:	e822                	sd	s0,16(sp)
 2a2:	e426                	sd	s1,8(sp)
 2a4:	e04a                	sd	s2,0(sp)
 2a6:	1000                	addi	s0,sp,32
 2a8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2aa:	4581                	li	a1,0
 2ac:	00000097          	auipc	ra,0x0
 2b0:	176080e7          	jalr	374(ra) # 422 <open>
  if(fd < 0)
 2b4:	02054563          	bltz	a0,2de <stat+0x42>
 2b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ba:	85ca                	mv	a1,s2
 2bc:	00000097          	auipc	ra,0x0
 2c0:	17e080e7          	jalr	382(ra) # 43a <fstat>
 2c4:	892a                	mv	s2,a0
  close(fd);
 2c6:	8526                	mv	a0,s1
 2c8:	00000097          	auipc	ra,0x0
 2cc:	142080e7          	jalr	322(ra) # 40a <close>
  return r;
}
 2d0:	854a                	mv	a0,s2
 2d2:	60e2                	ld	ra,24(sp)
 2d4:	6442                	ld	s0,16(sp)
 2d6:	64a2                	ld	s1,8(sp)
 2d8:	6902                	ld	s2,0(sp)
 2da:	6105                	addi	sp,sp,32
 2dc:	8082                	ret
    return -1;
 2de:	597d                	li	s2,-1
 2e0:	bfc5                	j	2d0 <stat+0x34>

00000000000002e2 <atoi>:

int
atoi(const char *s)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e422                	sd	s0,8(sp)
 2e6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e8:	00054603          	lbu	a2,0(a0)
 2ec:	fd06079b          	addiw	a5,a2,-48
 2f0:	0ff7f793          	andi	a5,a5,255
 2f4:	4725                	li	a4,9
 2f6:	02f76963          	bltu	a4,a5,328 <atoi+0x46>
 2fa:	86aa                	mv	a3,a0
  n = 0;
 2fc:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2fe:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 300:	0685                	addi	a3,a3,1
 302:	0025179b          	slliw	a5,a0,0x2
 306:	9fa9                	addw	a5,a5,a0
 308:	0017979b          	slliw	a5,a5,0x1
 30c:	9fb1                	addw	a5,a5,a2
 30e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 312:	0006c603          	lbu	a2,0(a3)
 316:	fd06071b          	addiw	a4,a2,-48
 31a:	0ff77713          	andi	a4,a4,255
 31e:	fee5f1e3          	bgeu	a1,a4,300 <atoi+0x1e>
  return n;
}
 322:	6422                	ld	s0,8(sp)
 324:	0141                	addi	sp,sp,16
 326:	8082                	ret
  n = 0;
 328:	4501                	li	a0,0
 32a:	bfe5                	j	322 <atoi+0x40>

000000000000032c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 32c:	1141                	addi	sp,sp,-16
 32e:	e422                	sd	s0,8(sp)
 330:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 332:	02b57663          	bgeu	a0,a1,35e <memmove+0x32>
    while(n-- > 0)
 336:	02c05163          	blez	a2,358 <memmove+0x2c>
 33a:	fff6079b          	addiw	a5,a2,-1
 33e:	1782                	slli	a5,a5,0x20
 340:	9381                	srli	a5,a5,0x20
 342:	0785                	addi	a5,a5,1
 344:	97aa                	add	a5,a5,a0
  dst = vdst;
 346:	872a                	mv	a4,a0
      *dst++ = *src++;
 348:	0585                	addi	a1,a1,1
 34a:	0705                	addi	a4,a4,1
 34c:	fff5c683          	lbu	a3,-1(a1)
 350:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 354:	fee79ae3          	bne	a5,a4,348 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 358:	6422                	ld	s0,8(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret
    dst += n;
 35e:	00c50733          	add	a4,a0,a2
    src += n;
 362:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 364:	fec05ae3          	blez	a2,358 <memmove+0x2c>
 368:	fff6079b          	addiw	a5,a2,-1
 36c:	1782                	slli	a5,a5,0x20
 36e:	9381                	srli	a5,a5,0x20
 370:	fff7c793          	not	a5,a5
 374:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 376:	15fd                	addi	a1,a1,-1
 378:	177d                	addi	a4,a4,-1
 37a:	0005c683          	lbu	a3,0(a1)
 37e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 382:	fee79ae3          	bne	a5,a4,376 <memmove+0x4a>
 386:	bfc9                	j	358 <memmove+0x2c>

0000000000000388 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 388:	1141                	addi	sp,sp,-16
 38a:	e422                	sd	s0,8(sp)
 38c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 38e:	ca05                	beqz	a2,3be <memcmp+0x36>
 390:	fff6069b          	addiw	a3,a2,-1
 394:	1682                	slli	a3,a3,0x20
 396:	9281                	srli	a3,a3,0x20
 398:	0685                	addi	a3,a3,1
 39a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 39c:	00054783          	lbu	a5,0(a0)
 3a0:	0005c703          	lbu	a4,0(a1)
 3a4:	00e79863          	bne	a5,a4,3b4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3a8:	0505                	addi	a0,a0,1
    p2++;
 3aa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3ac:	fed518e3          	bne	a0,a3,39c <memcmp+0x14>
  }
  return 0;
 3b0:	4501                	li	a0,0
 3b2:	a019                	j	3b8 <memcmp+0x30>
      return *p1 - *p2;
 3b4:	40e7853b          	subw	a0,a5,a4
}
 3b8:	6422                	ld	s0,8(sp)
 3ba:	0141                	addi	sp,sp,16
 3bc:	8082                	ret
  return 0;
 3be:	4501                	li	a0,0
 3c0:	bfe5                	j	3b8 <memcmp+0x30>

00000000000003c2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3c2:	1141                	addi	sp,sp,-16
 3c4:	e406                	sd	ra,8(sp)
 3c6:	e022                	sd	s0,0(sp)
 3c8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3ca:	00000097          	auipc	ra,0x0
 3ce:	f62080e7          	jalr	-158(ra) # 32c <memmove>
}
 3d2:	60a2                	ld	ra,8(sp)
 3d4:	6402                	ld	s0,0(sp)
 3d6:	0141                	addi	sp,sp,16
 3d8:	8082                	ret

00000000000003da <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3da:	4885                	li	a7,1
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3e2:	4889                	li	a7,2
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ea:	488d                	li	a7,3
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3f2:	4891                	li	a7,4
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <read>:
.global read
read:
 li a7, SYS_read
 3fa:	4895                	li	a7,5
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <write>:
.global write
write:
 li a7, SYS_write
 402:	48c1                	li	a7,16
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <close>:
.global close
close:
 li a7, SYS_close
 40a:	48d5                	li	a7,21
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <kill>:
.global kill
kill:
 li a7, SYS_kill
 412:	4899                	li	a7,6
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <exec>:
.global exec
exec:
 li a7, SYS_exec
 41a:	489d                	li	a7,7
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <open>:
.global open
open:
 li a7, SYS_open
 422:	48bd                	li	a7,15
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 42a:	48c5                	li	a7,17
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 432:	48c9                	li	a7,18
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 43a:	48a1                	li	a7,8
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <link>:
.global link
link:
 li a7, SYS_link
 442:	48cd                	li	a7,19
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 44a:	48d1                	li	a7,20
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 452:	48a5                	li	a7,9
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <dup>:
.global dup
dup:
 li a7, SYS_dup
 45a:	48a9                	li	a7,10
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 462:	48ad                	li	a7,11
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 46a:	48b1                	li	a7,12
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 472:	48b5                	li	a7,13
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 47a:	48b9                	li	a7,14
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 482:	1101                	addi	sp,sp,-32
 484:	ec06                	sd	ra,24(sp)
 486:	e822                	sd	s0,16(sp)
 488:	1000                	addi	s0,sp,32
 48a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 48e:	4605                	li	a2,1
 490:	fef40593          	addi	a1,s0,-17
 494:	00000097          	auipc	ra,0x0
 498:	f6e080e7          	jalr	-146(ra) # 402 <write>
}
 49c:	60e2                	ld	ra,24(sp)
 49e:	6442                	ld	s0,16(sp)
 4a0:	6105                	addi	sp,sp,32
 4a2:	8082                	ret

00000000000004a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a4:	7139                	addi	sp,sp,-64
 4a6:	fc06                	sd	ra,56(sp)
 4a8:	f822                	sd	s0,48(sp)
 4aa:	f426                	sd	s1,40(sp)
 4ac:	f04a                	sd	s2,32(sp)
 4ae:	ec4e                	sd	s3,24(sp)
 4b0:	0080                	addi	s0,sp,64
 4b2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4b4:	c299                	beqz	a3,4ba <printint+0x16>
 4b6:	0805c863          	bltz	a1,546 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4ba:	2581                	sext.w	a1,a1
  neg = 0;
 4bc:	4881                	li	a7,0
 4be:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4c2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4c4:	2601                	sext.w	a2,a2
 4c6:	00000517          	auipc	a0,0x0
 4ca:	46a50513          	addi	a0,a0,1130 # 930 <digits>
 4ce:	883a                	mv	a6,a4
 4d0:	2705                	addiw	a4,a4,1
 4d2:	02c5f7bb          	remuw	a5,a1,a2
 4d6:	1782                	slli	a5,a5,0x20
 4d8:	9381                	srli	a5,a5,0x20
 4da:	97aa                	add	a5,a5,a0
 4dc:	0007c783          	lbu	a5,0(a5)
 4e0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4e4:	0005879b          	sext.w	a5,a1
 4e8:	02c5d5bb          	divuw	a1,a1,a2
 4ec:	0685                	addi	a3,a3,1
 4ee:	fec7f0e3          	bgeu	a5,a2,4ce <printint+0x2a>
  if(neg)
 4f2:	00088b63          	beqz	a7,508 <printint+0x64>
    buf[i++] = '-';
 4f6:	fd040793          	addi	a5,s0,-48
 4fa:	973e                	add	a4,a4,a5
 4fc:	02d00793          	li	a5,45
 500:	fef70823          	sb	a5,-16(a4)
 504:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 508:	02e05863          	blez	a4,538 <printint+0x94>
 50c:	fc040793          	addi	a5,s0,-64
 510:	00e78933          	add	s2,a5,a4
 514:	fff78993          	addi	s3,a5,-1
 518:	99ba                	add	s3,s3,a4
 51a:	377d                	addiw	a4,a4,-1
 51c:	1702                	slli	a4,a4,0x20
 51e:	9301                	srli	a4,a4,0x20
 520:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 524:	fff94583          	lbu	a1,-1(s2)
 528:	8526                	mv	a0,s1
 52a:	00000097          	auipc	ra,0x0
 52e:	f58080e7          	jalr	-168(ra) # 482 <putc>
  while(--i >= 0)
 532:	197d                	addi	s2,s2,-1
 534:	ff3918e3          	bne	s2,s3,524 <printint+0x80>
}
 538:	70e2                	ld	ra,56(sp)
 53a:	7442                	ld	s0,48(sp)
 53c:	74a2                	ld	s1,40(sp)
 53e:	7902                	ld	s2,32(sp)
 540:	69e2                	ld	s3,24(sp)
 542:	6121                	addi	sp,sp,64
 544:	8082                	ret
    x = -xx;
 546:	40b005bb          	negw	a1,a1
    neg = 1;
 54a:	4885                	li	a7,1
    x = -xx;
 54c:	bf8d                	j	4be <printint+0x1a>

000000000000054e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 54e:	7119                	addi	sp,sp,-128
 550:	fc86                	sd	ra,120(sp)
 552:	f8a2                	sd	s0,112(sp)
 554:	f4a6                	sd	s1,104(sp)
 556:	f0ca                	sd	s2,96(sp)
 558:	ecce                	sd	s3,88(sp)
 55a:	e8d2                	sd	s4,80(sp)
 55c:	e4d6                	sd	s5,72(sp)
 55e:	e0da                	sd	s6,64(sp)
 560:	fc5e                	sd	s7,56(sp)
 562:	f862                	sd	s8,48(sp)
 564:	f466                	sd	s9,40(sp)
 566:	f06a                	sd	s10,32(sp)
 568:	ec6e                	sd	s11,24(sp)
 56a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 56c:	0005c903          	lbu	s2,0(a1)
 570:	18090f63          	beqz	s2,70e <vprintf+0x1c0>
 574:	8aaa                	mv	s5,a0
 576:	8b32                	mv	s6,a2
 578:	00158493          	addi	s1,a1,1
  state = 0;
 57c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 57e:	02500a13          	li	s4,37
      if(c == 'd'){
 582:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 586:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 58a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 58e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 592:	00000b97          	auipc	s7,0x0
 596:	39eb8b93          	addi	s7,s7,926 # 930 <digits>
 59a:	a839                	j	5b8 <vprintf+0x6a>
        putc(fd, c);
 59c:	85ca                	mv	a1,s2
 59e:	8556                	mv	a0,s5
 5a0:	00000097          	auipc	ra,0x0
 5a4:	ee2080e7          	jalr	-286(ra) # 482 <putc>
 5a8:	a019                	j	5ae <vprintf+0x60>
    } else if(state == '%'){
 5aa:	01498f63          	beq	s3,s4,5c8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5ae:	0485                	addi	s1,s1,1
 5b0:	fff4c903          	lbu	s2,-1(s1)
 5b4:	14090d63          	beqz	s2,70e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5b8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5bc:	fe0997e3          	bnez	s3,5aa <vprintf+0x5c>
      if(c == '%'){
 5c0:	fd479ee3          	bne	a5,s4,59c <vprintf+0x4e>
        state = '%';
 5c4:	89be                	mv	s3,a5
 5c6:	b7e5                	j	5ae <vprintf+0x60>
      if(c == 'd'){
 5c8:	05878063          	beq	a5,s8,608 <vprintf+0xba>
      } else if(c == 'l') {
 5cc:	05978c63          	beq	a5,s9,624 <vprintf+0xd6>
      } else if(c == 'x') {
 5d0:	07a78863          	beq	a5,s10,640 <vprintf+0xf2>
      } else if(c == 'p') {
 5d4:	09b78463          	beq	a5,s11,65c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5d8:	07300713          	li	a4,115
 5dc:	0ce78663          	beq	a5,a4,6a8 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e0:	06300713          	li	a4,99
 5e4:	0ee78e63          	beq	a5,a4,6e0 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5e8:	11478863          	beq	a5,s4,6f8 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ec:	85d2                	mv	a1,s4
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	e92080e7          	jalr	-366(ra) # 482 <putc>
        putc(fd, c);
 5f8:	85ca                	mv	a1,s2
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	e86080e7          	jalr	-378(ra) # 482 <putc>
      }
      state = 0;
 604:	4981                	li	s3,0
 606:	b765                	j	5ae <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 608:	008b0913          	addi	s2,s6,8
 60c:	4685                	li	a3,1
 60e:	4629                	li	a2,10
 610:	000b2583          	lw	a1,0(s6)
 614:	8556                	mv	a0,s5
 616:	00000097          	auipc	ra,0x0
 61a:	e8e080e7          	jalr	-370(ra) # 4a4 <printint>
 61e:	8b4a                	mv	s6,s2
      state = 0;
 620:	4981                	li	s3,0
 622:	b771                	j	5ae <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 624:	008b0913          	addi	s2,s6,8
 628:	4681                	li	a3,0
 62a:	4629                	li	a2,10
 62c:	000b2583          	lw	a1,0(s6)
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	e72080e7          	jalr	-398(ra) # 4a4 <printint>
 63a:	8b4a                	mv	s6,s2
      state = 0;
 63c:	4981                	li	s3,0
 63e:	bf85                	j	5ae <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 640:	008b0913          	addi	s2,s6,8
 644:	4681                	li	a3,0
 646:	4641                	li	a2,16
 648:	000b2583          	lw	a1,0(s6)
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	e56080e7          	jalr	-426(ra) # 4a4 <printint>
 656:	8b4a                	mv	s6,s2
      state = 0;
 658:	4981                	li	s3,0
 65a:	bf91                	j	5ae <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 65c:	008b0793          	addi	a5,s6,8
 660:	f8f43423          	sd	a5,-120(s0)
 664:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 668:	03000593          	li	a1,48
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	e14080e7          	jalr	-492(ra) # 482 <putc>
  putc(fd, 'x');
 676:	85ea                	mv	a1,s10
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	e08080e7          	jalr	-504(ra) # 482 <putc>
 682:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 684:	03c9d793          	srli	a5,s3,0x3c
 688:	97de                	add	a5,a5,s7
 68a:	0007c583          	lbu	a1,0(a5)
 68e:	8556                	mv	a0,s5
 690:	00000097          	auipc	ra,0x0
 694:	df2080e7          	jalr	-526(ra) # 482 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 698:	0992                	slli	s3,s3,0x4
 69a:	397d                	addiw	s2,s2,-1
 69c:	fe0914e3          	bnez	s2,684 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6a0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	b721                	j	5ae <vprintf+0x60>
        s = va_arg(ap, char*);
 6a8:	008b0993          	addi	s3,s6,8
 6ac:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6b0:	02090163          	beqz	s2,6d2 <vprintf+0x184>
        while(*s != 0){
 6b4:	00094583          	lbu	a1,0(s2)
 6b8:	c9a1                	beqz	a1,708 <vprintf+0x1ba>
          putc(fd, *s);
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	dc6080e7          	jalr	-570(ra) # 482 <putc>
          s++;
 6c4:	0905                	addi	s2,s2,1
        while(*s != 0){
 6c6:	00094583          	lbu	a1,0(s2)
 6ca:	f9e5                	bnez	a1,6ba <vprintf+0x16c>
        s = va_arg(ap, char*);
 6cc:	8b4e                	mv	s6,s3
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	bdf9                	j	5ae <vprintf+0x60>
          s = "(null)";
 6d2:	00000917          	auipc	s2,0x0
 6d6:	25690913          	addi	s2,s2,598 # 928 <malloc+0x110>
        while(*s != 0){
 6da:	02800593          	li	a1,40
 6de:	bff1                	j	6ba <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6e0:	008b0913          	addi	s2,s6,8
 6e4:	000b4583          	lbu	a1,0(s6)
 6e8:	8556                	mv	a0,s5
 6ea:	00000097          	auipc	ra,0x0
 6ee:	d98080e7          	jalr	-616(ra) # 482 <putc>
 6f2:	8b4a                	mv	s6,s2
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	bd65                	j	5ae <vprintf+0x60>
        putc(fd, c);
 6f8:	85d2                	mv	a1,s4
 6fa:	8556                	mv	a0,s5
 6fc:	00000097          	auipc	ra,0x0
 700:	d86080e7          	jalr	-634(ra) # 482 <putc>
      state = 0;
 704:	4981                	li	s3,0
 706:	b565                	j	5ae <vprintf+0x60>
        s = va_arg(ap, char*);
 708:	8b4e                	mv	s6,s3
      state = 0;
 70a:	4981                	li	s3,0
 70c:	b54d                	j	5ae <vprintf+0x60>
    }
  }
}
 70e:	70e6                	ld	ra,120(sp)
 710:	7446                	ld	s0,112(sp)
 712:	74a6                	ld	s1,104(sp)
 714:	7906                	ld	s2,96(sp)
 716:	69e6                	ld	s3,88(sp)
 718:	6a46                	ld	s4,80(sp)
 71a:	6aa6                	ld	s5,72(sp)
 71c:	6b06                	ld	s6,64(sp)
 71e:	7be2                	ld	s7,56(sp)
 720:	7c42                	ld	s8,48(sp)
 722:	7ca2                	ld	s9,40(sp)
 724:	7d02                	ld	s10,32(sp)
 726:	6de2                	ld	s11,24(sp)
 728:	6109                	addi	sp,sp,128
 72a:	8082                	ret

000000000000072c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 72c:	715d                	addi	sp,sp,-80
 72e:	ec06                	sd	ra,24(sp)
 730:	e822                	sd	s0,16(sp)
 732:	1000                	addi	s0,sp,32
 734:	e010                	sd	a2,0(s0)
 736:	e414                	sd	a3,8(s0)
 738:	e818                	sd	a4,16(s0)
 73a:	ec1c                	sd	a5,24(s0)
 73c:	03043023          	sd	a6,32(s0)
 740:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 744:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 748:	8622                	mv	a2,s0
 74a:	00000097          	auipc	ra,0x0
 74e:	e04080e7          	jalr	-508(ra) # 54e <vprintf>
}
 752:	60e2                	ld	ra,24(sp)
 754:	6442                	ld	s0,16(sp)
 756:	6161                	addi	sp,sp,80
 758:	8082                	ret

000000000000075a <printf>:

void
printf(const char *fmt, ...)
{
 75a:	711d                	addi	sp,sp,-96
 75c:	ec06                	sd	ra,24(sp)
 75e:	e822                	sd	s0,16(sp)
 760:	1000                	addi	s0,sp,32
 762:	e40c                	sd	a1,8(s0)
 764:	e810                	sd	a2,16(s0)
 766:	ec14                	sd	a3,24(s0)
 768:	f018                	sd	a4,32(s0)
 76a:	f41c                	sd	a5,40(s0)
 76c:	03043823          	sd	a6,48(s0)
 770:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 774:	00840613          	addi	a2,s0,8
 778:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 77c:	85aa                	mv	a1,a0
 77e:	4505                	li	a0,1
 780:	00000097          	auipc	ra,0x0
 784:	dce080e7          	jalr	-562(ra) # 54e <vprintf>
}
 788:	60e2                	ld	ra,24(sp)
 78a:	6442                	ld	s0,16(sp)
 78c:	6125                	addi	sp,sp,96
 78e:	8082                	ret

0000000000000790 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 790:	1141                	addi	sp,sp,-16
 792:	e422                	sd	s0,8(sp)
 794:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 796:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79a:	00000797          	auipc	a5,0x0
 79e:	1ae7b783          	ld	a5,430(a5) # 948 <freep>
 7a2:	a805                	j	7d2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7a4:	4618                	lw	a4,8(a2)
 7a6:	9db9                	addw	a1,a1,a4
 7a8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ac:	6398                	ld	a4,0(a5)
 7ae:	6318                	ld	a4,0(a4)
 7b0:	fee53823          	sd	a4,-16(a0)
 7b4:	a091                	j	7f8 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7b6:	ff852703          	lw	a4,-8(a0)
 7ba:	9e39                	addw	a2,a2,a4
 7bc:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7be:	ff053703          	ld	a4,-16(a0)
 7c2:	e398                	sd	a4,0(a5)
 7c4:	a099                	j	80a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c6:	6398                	ld	a4,0(a5)
 7c8:	00e7e463          	bltu	a5,a4,7d0 <free+0x40>
 7cc:	00e6ea63          	bltu	a3,a4,7e0 <free+0x50>
{
 7d0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d2:	fed7fae3          	bgeu	a5,a3,7c6 <free+0x36>
 7d6:	6398                	ld	a4,0(a5)
 7d8:	00e6e463          	bltu	a3,a4,7e0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7dc:	fee7eae3          	bltu	a5,a4,7d0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7e0:	ff852583          	lw	a1,-8(a0)
 7e4:	6390                	ld	a2,0(a5)
 7e6:	02059713          	slli	a4,a1,0x20
 7ea:	9301                	srli	a4,a4,0x20
 7ec:	0712                	slli	a4,a4,0x4
 7ee:	9736                	add	a4,a4,a3
 7f0:	fae60ae3          	beq	a2,a4,7a4 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7f4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7f8:	4790                	lw	a2,8(a5)
 7fa:	02061713          	slli	a4,a2,0x20
 7fe:	9301                	srli	a4,a4,0x20
 800:	0712                	slli	a4,a4,0x4
 802:	973e                	add	a4,a4,a5
 804:	fae689e3          	beq	a3,a4,7b6 <free+0x26>
  } else
    p->s.ptr = bp;
 808:	e394                	sd	a3,0(a5)
  freep = p;
 80a:	00000717          	auipc	a4,0x0
 80e:	12f73f23          	sd	a5,318(a4) # 948 <freep>
}
 812:	6422                	ld	s0,8(sp)
 814:	0141                	addi	sp,sp,16
 816:	8082                	ret

0000000000000818 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 818:	7139                	addi	sp,sp,-64
 81a:	fc06                	sd	ra,56(sp)
 81c:	f822                	sd	s0,48(sp)
 81e:	f426                	sd	s1,40(sp)
 820:	f04a                	sd	s2,32(sp)
 822:	ec4e                	sd	s3,24(sp)
 824:	e852                	sd	s4,16(sp)
 826:	e456                	sd	s5,8(sp)
 828:	e05a                	sd	s6,0(sp)
 82a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 82c:	02051493          	slli	s1,a0,0x20
 830:	9081                	srli	s1,s1,0x20
 832:	04bd                	addi	s1,s1,15
 834:	8091                	srli	s1,s1,0x4
 836:	0014899b          	addiw	s3,s1,1
 83a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 83c:	00000517          	auipc	a0,0x0
 840:	10c53503          	ld	a0,268(a0) # 948 <freep>
 844:	c515                	beqz	a0,870 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 846:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 848:	4798                	lw	a4,8(a5)
 84a:	02977f63          	bgeu	a4,s1,888 <malloc+0x70>
 84e:	8a4e                	mv	s4,s3
 850:	0009871b          	sext.w	a4,s3
 854:	6685                	lui	a3,0x1
 856:	00d77363          	bgeu	a4,a3,85c <malloc+0x44>
 85a:	6a05                	lui	s4,0x1
 85c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 860:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 864:	00000917          	auipc	s2,0x0
 868:	0e490913          	addi	s2,s2,228 # 948 <freep>
  if(p == (char*)-1)
 86c:	5afd                	li	s5,-1
 86e:	a88d                	j	8e0 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 870:	00000797          	auipc	a5,0x0
 874:	0e078793          	addi	a5,a5,224 # 950 <base>
 878:	00000717          	auipc	a4,0x0
 87c:	0cf73823          	sd	a5,208(a4) # 948 <freep>
 880:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 882:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 886:	b7e1                	j	84e <malloc+0x36>
      if(p->s.size == nunits)
 888:	02e48b63          	beq	s1,a4,8be <malloc+0xa6>
        p->s.size -= nunits;
 88c:	4137073b          	subw	a4,a4,s3
 890:	c798                	sw	a4,8(a5)
        p += p->s.size;
 892:	1702                	slli	a4,a4,0x20
 894:	9301                	srli	a4,a4,0x20
 896:	0712                	slli	a4,a4,0x4
 898:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 89a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 89e:	00000717          	auipc	a4,0x0
 8a2:	0aa73523          	sd	a0,170(a4) # 948 <freep>
      return (void*)(p + 1);
 8a6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8aa:	70e2                	ld	ra,56(sp)
 8ac:	7442                	ld	s0,48(sp)
 8ae:	74a2                	ld	s1,40(sp)
 8b0:	7902                	ld	s2,32(sp)
 8b2:	69e2                	ld	s3,24(sp)
 8b4:	6a42                	ld	s4,16(sp)
 8b6:	6aa2                	ld	s5,8(sp)
 8b8:	6b02                	ld	s6,0(sp)
 8ba:	6121                	addi	sp,sp,64
 8bc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8be:	6398                	ld	a4,0(a5)
 8c0:	e118                	sd	a4,0(a0)
 8c2:	bff1                	j	89e <malloc+0x86>
  hp->s.size = nu;
 8c4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8c8:	0541                	addi	a0,a0,16
 8ca:	00000097          	auipc	ra,0x0
 8ce:	ec6080e7          	jalr	-314(ra) # 790 <free>
  return freep;
 8d2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8d6:	d971                	beqz	a0,8aa <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8da:	4798                	lw	a4,8(a5)
 8dc:	fa9776e3          	bgeu	a4,s1,888 <malloc+0x70>
    if(p == freep)
 8e0:	00093703          	ld	a4,0(s2)
 8e4:	853e                	mv	a0,a5
 8e6:	fef719e3          	bne	a4,a5,8d8 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8ea:	8552                	mv	a0,s4
 8ec:	00000097          	auipc	ra,0x0
 8f0:	b7e080e7          	jalr	-1154(ra) # 46a <sbrk>
  if(p == (char*)-1)
 8f4:	fd5518e3          	bne	a0,s5,8c4 <malloc+0xac>
        return 0;
 8f8:	4501                	li	a0,0
 8fa:	bf45                	j	8aa <malloc+0x92>
