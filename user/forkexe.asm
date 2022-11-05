
user/_forkexe：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
int 
main()
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	0080                	addi	s0,sp,64
    int status;
    int pid =fork();//fork一个子进程
   8:	00000097          	auipc	ra,0x0
   c:	310080e7          	jalr	784(ra) # 318 <fork>
    if(pid==0)
  10:	e125                	bnez	a0,70 <main+0x70>
    {
        //child process
        printf("child process\n");
  12:	00001517          	auipc	a0,0x1
  16:	84650513          	addi	a0,a0,-1978 # 858 <malloc+0x102>
  1a:	00000097          	auipc	ra,0x0
  1e:	67e080e7          	jalr	1662(ra) # 698 <printf>
        char *argv[] ={"THIS", "IS","ECHO",0};//0是结束标注
  22:	00001797          	auipc	a5,0x1
  26:	89e78793          	addi	a5,a5,-1890 # 8c0 <malloc+0x16a>
  2a:	6390                	ld	a2,0(a5)
  2c:	6794                	ld	a3,8(a5)
  2e:	6b98                	ld	a4,16(a5)
  30:	6f9c                	ld	a5,24(a5)
  32:	fcc43423          	sd	a2,-56(s0)
  36:	fcd43823          	sd	a3,-48(s0)
  3a:	fce43c23          	sd	a4,-40(s0)
  3e:	fef43023          	sd	a5,-32(s0)
        exec("echo", argv);//"本来是执行echo"用来执行argvs 然后不会返回
  42:	fc840593          	addi	a1,s0,-56
  46:	00001517          	auipc	a0,0x1
  4a:	82250513          	addi	a0,a0,-2014 # 868 <malloc+0x112>
  4e:	00000097          	auipc	ra,0x0
  52:	30a080e7          	jalr	778(ra) # 358 <exec>
        printf("exe failed\n");
  56:	00001517          	auipc	a0,0x1
  5a:	81a50513          	addi	a0,a0,-2022 # 870 <malloc+0x11a>
  5e:	00000097          	auipc	ra,0x0
  62:	63a080e7          	jalr	1594(ra) # 698 <printf>
        exit(1);//1表示的是异常退出
  66:	4505                	li	a0,1
  68:	00000097          	auipc	ra,0x0
  6c:	2b8080e7          	jalr	696(ra) # 320 <exit>
    }
    else
    {
        //parent process
        printf("parent process\n");
  70:	00001517          	auipc	a0,0x1
  74:	81050513          	addi	a0,a0,-2032 # 880 <malloc+0x12a>
  78:	00000097          	auipc	ra,0x0
  7c:	620080e7          	jalr	1568(ra) # 698 <printf>
        wait(&status);//注意wait系统调用会把等待子进程终止 然后把子进程的信息存储在status里面
  80:	fec40513          	addi	a0,s0,-20
  84:	00000097          	auipc	ra,0x0
  88:	2a4080e7          	jalr	676(ra) # 328 <wait>
        printf("the child process exited with status %d\n", status);
  8c:	fec42583          	lw	a1,-20(s0)
  90:	00001517          	auipc	a0,0x1
  94:	80050513          	addi	a0,a0,-2048 # 890 <malloc+0x13a>
  98:	00000097          	auipc	ra,0x0
  9c:	600080e7          	jalr	1536(ra) # 698 <printf>

    }
    exit(0);
  a0:	4501                	li	a0,0
  a2:	00000097          	auipc	ra,0x0
  a6:	27e080e7          	jalr	638(ra) # 320 <exit>

00000000000000aa <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e422                	sd	s0,8(sp)
  ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b0:	87aa                	mv	a5,a0
  b2:	0585                	addi	a1,a1,1
  b4:	0785                	addi	a5,a5,1
  b6:	fff5c703          	lbu	a4,-1(a1)
  ba:	fee78fa3          	sb	a4,-1(a5)
  be:	fb75                	bnez	a4,b2 <strcpy+0x8>
    ;
  return os;
}
  c0:	6422                	ld	s0,8(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e422                	sd	s0,8(sp)
  ca:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  cc:	00054783          	lbu	a5,0(a0)
  d0:	cb91                	beqz	a5,e4 <strcmp+0x1e>
  d2:	0005c703          	lbu	a4,0(a1)
  d6:	00f71763          	bne	a4,a5,e4 <strcmp+0x1e>
    p++, q++;
  da:	0505                	addi	a0,a0,1
  dc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  de:	00054783          	lbu	a5,0(a0)
  e2:	fbe5                	bnez	a5,d2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  e4:	0005c503          	lbu	a0,0(a1)
}
  e8:	40a7853b          	subw	a0,a5,a0
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <strlen>:

uint
strlen(const char *s)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e422                	sd	s0,8(sp)
  f6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  f8:	00054783          	lbu	a5,0(a0)
  fc:	cf91                	beqz	a5,118 <strlen+0x26>
  fe:	0505                	addi	a0,a0,1
 100:	87aa                	mv	a5,a0
 102:	4685                	li	a3,1
 104:	9e89                	subw	a3,a3,a0
 106:	00f6853b          	addw	a0,a3,a5
 10a:	0785                	addi	a5,a5,1
 10c:	fff7c703          	lbu	a4,-1(a5)
 110:	fb7d                	bnez	a4,106 <strlen+0x14>
    ;
  return n;
}
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret
  for(n = 0; s[n]; n++)
 118:	4501                	li	a0,0
 11a:	bfe5                	j	112 <strlen+0x20>

000000000000011c <memset>:

void*
memset(void *dst, int c, uint n)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e422                	sd	s0,8(sp)
 120:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 122:	ce09                	beqz	a2,13c <memset+0x20>
 124:	87aa                	mv	a5,a0
 126:	fff6071b          	addiw	a4,a2,-1
 12a:	1702                	slli	a4,a4,0x20
 12c:	9301                	srli	a4,a4,0x20
 12e:	0705                	addi	a4,a4,1
 130:	972a                	add	a4,a4,a0
    cdst[i] = c;
 132:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 136:	0785                	addi	a5,a5,1
 138:	fee79de3          	bne	a5,a4,132 <memset+0x16>
  }
  return dst;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <strchr>:

char*
strchr(const char *s, char c)
{
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
  for(; *s; s++)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cb99                	beqz	a5,162 <strchr+0x20>
    if(*s == c)
 14e:	00f58763          	beq	a1,a5,15c <strchr+0x1a>
  for(; *s; s++)
 152:	0505                	addi	a0,a0,1
 154:	00054783          	lbu	a5,0(a0)
 158:	fbfd                	bnez	a5,14e <strchr+0xc>
      return (char*)s;
  return 0;
 15a:	4501                	li	a0,0
}
 15c:	6422                	ld	s0,8(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret
  return 0;
 162:	4501                	li	a0,0
 164:	bfe5                	j	15c <strchr+0x1a>

0000000000000166 <gets>:

char*
gets(char *buf, int max)
{
 166:	711d                	addi	sp,sp,-96
 168:	ec86                	sd	ra,88(sp)
 16a:	e8a2                	sd	s0,80(sp)
 16c:	e4a6                	sd	s1,72(sp)
 16e:	e0ca                	sd	s2,64(sp)
 170:	fc4e                	sd	s3,56(sp)
 172:	f852                	sd	s4,48(sp)
 174:	f456                	sd	s5,40(sp)
 176:	f05a                	sd	s6,32(sp)
 178:	ec5e                	sd	s7,24(sp)
 17a:	1080                	addi	s0,sp,96
 17c:	8baa                	mv	s7,a0
 17e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 180:	892a                	mv	s2,a0
 182:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 184:	4aa9                	li	s5,10
 186:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 188:	89a6                	mv	s3,s1
 18a:	2485                	addiw	s1,s1,1
 18c:	0344d863          	bge	s1,s4,1bc <gets+0x56>
    cc = read(0, &c, 1);
 190:	4605                	li	a2,1
 192:	faf40593          	addi	a1,s0,-81
 196:	4501                	li	a0,0
 198:	00000097          	auipc	ra,0x0
 19c:	1a0080e7          	jalr	416(ra) # 338 <read>
    if(cc < 1)
 1a0:	00a05e63          	blez	a0,1bc <gets+0x56>
    buf[i++] = c;
 1a4:	faf44783          	lbu	a5,-81(s0)
 1a8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ac:	01578763          	beq	a5,s5,1ba <gets+0x54>
 1b0:	0905                	addi	s2,s2,1
 1b2:	fd679be3          	bne	a5,s6,188 <gets+0x22>
  for(i=0; i+1 < max; ){
 1b6:	89a6                	mv	s3,s1
 1b8:	a011                	j	1bc <gets+0x56>
 1ba:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1bc:	99de                	add	s3,s3,s7
 1be:	00098023          	sb	zero,0(s3)
  return buf;
}
 1c2:	855e                	mv	a0,s7
 1c4:	60e6                	ld	ra,88(sp)
 1c6:	6446                	ld	s0,80(sp)
 1c8:	64a6                	ld	s1,72(sp)
 1ca:	6906                	ld	s2,64(sp)
 1cc:	79e2                	ld	s3,56(sp)
 1ce:	7a42                	ld	s4,48(sp)
 1d0:	7aa2                	ld	s5,40(sp)
 1d2:	7b02                	ld	s6,32(sp)
 1d4:	6be2                	ld	s7,24(sp)
 1d6:	6125                	addi	sp,sp,96
 1d8:	8082                	ret

00000000000001da <stat>:

int
stat(const char *n, struct stat *st)
{
 1da:	1101                	addi	sp,sp,-32
 1dc:	ec06                	sd	ra,24(sp)
 1de:	e822                	sd	s0,16(sp)
 1e0:	e426                	sd	s1,8(sp)
 1e2:	e04a                	sd	s2,0(sp)
 1e4:	1000                	addi	s0,sp,32
 1e6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e8:	4581                	li	a1,0
 1ea:	00000097          	auipc	ra,0x0
 1ee:	176080e7          	jalr	374(ra) # 360 <open>
  if(fd < 0)
 1f2:	02054563          	bltz	a0,21c <stat+0x42>
 1f6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f8:	85ca                	mv	a1,s2
 1fa:	00000097          	auipc	ra,0x0
 1fe:	17e080e7          	jalr	382(ra) # 378 <fstat>
 202:	892a                	mv	s2,a0
  close(fd);
 204:	8526                	mv	a0,s1
 206:	00000097          	auipc	ra,0x0
 20a:	142080e7          	jalr	322(ra) # 348 <close>
  return r;
}
 20e:	854a                	mv	a0,s2
 210:	60e2                	ld	ra,24(sp)
 212:	6442                	ld	s0,16(sp)
 214:	64a2                	ld	s1,8(sp)
 216:	6902                	ld	s2,0(sp)
 218:	6105                	addi	sp,sp,32
 21a:	8082                	ret
    return -1;
 21c:	597d                	li	s2,-1
 21e:	bfc5                	j	20e <stat+0x34>

0000000000000220 <atoi>:

int
atoi(const char *s)
{
 220:	1141                	addi	sp,sp,-16
 222:	e422                	sd	s0,8(sp)
 224:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 226:	00054603          	lbu	a2,0(a0)
 22a:	fd06079b          	addiw	a5,a2,-48
 22e:	0ff7f793          	andi	a5,a5,255
 232:	4725                	li	a4,9
 234:	02f76963          	bltu	a4,a5,266 <atoi+0x46>
 238:	86aa                	mv	a3,a0
  n = 0;
 23a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 23c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 23e:	0685                	addi	a3,a3,1
 240:	0025179b          	slliw	a5,a0,0x2
 244:	9fa9                	addw	a5,a5,a0
 246:	0017979b          	slliw	a5,a5,0x1
 24a:	9fb1                	addw	a5,a5,a2
 24c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 250:	0006c603          	lbu	a2,0(a3)
 254:	fd06071b          	addiw	a4,a2,-48
 258:	0ff77713          	andi	a4,a4,255
 25c:	fee5f1e3          	bgeu	a1,a4,23e <atoi+0x1e>
  return n;
}
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret
  n = 0;
 266:	4501                	li	a0,0
 268:	bfe5                	j	260 <atoi+0x40>

000000000000026a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 26a:	1141                	addi	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 270:	02b57663          	bgeu	a0,a1,29c <memmove+0x32>
    while(n-- > 0)
 274:	02c05163          	blez	a2,296 <memmove+0x2c>
 278:	fff6079b          	addiw	a5,a2,-1
 27c:	1782                	slli	a5,a5,0x20
 27e:	9381                	srli	a5,a5,0x20
 280:	0785                	addi	a5,a5,1
 282:	97aa                	add	a5,a5,a0
  dst = vdst;
 284:	872a                	mv	a4,a0
      *dst++ = *src++;
 286:	0585                	addi	a1,a1,1
 288:	0705                	addi	a4,a4,1
 28a:	fff5c683          	lbu	a3,-1(a1)
 28e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 292:	fee79ae3          	bne	a5,a4,286 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 296:	6422                	ld	s0,8(sp)
 298:	0141                	addi	sp,sp,16
 29a:	8082                	ret
    dst += n;
 29c:	00c50733          	add	a4,a0,a2
    src += n;
 2a0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2a2:	fec05ae3          	blez	a2,296 <memmove+0x2c>
 2a6:	fff6079b          	addiw	a5,a2,-1
 2aa:	1782                	slli	a5,a5,0x20
 2ac:	9381                	srli	a5,a5,0x20
 2ae:	fff7c793          	not	a5,a5
 2b2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2b4:	15fd                	addi	a1,a1,-1
 2b6:	177d                	addi	a4,a4,-1
 2b8:	0005c683          	lbu	a3,0(a1)
 2bc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2c0:	fee79ae3          	bne	a5,a4,2b4 <memmove+0x4a>
 2c4:	bfc9                	j	296 <memmove+0x2c>

00000000000002c6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e422                	sd	s0,8(sp)
 2ca:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2cc:	ca05                	beqz	a2,2fc <memcmp+0x36>
 2ce:	fff6069b          	addiw	a3,a2,-1
 2d2:	1682                	slli	a3,a3,0x20
 2d4:	9281                	srli	a3,a3,0x20
 2d6:	0685                	addi	a3,a3,1
 2d8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2da:	00054783          	lbu	a5,0(a0)
 2de:	0005c703          	lbu	a4,0(a1)
 2e2:	00e79863          	bne	a5,a4,2f2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2e6:	0505                	addi	a0,a0,1
    p2++;
 2e8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ea:	fed518e3          	bne	a0,a3,2da <memcmp+0x14>
  }
  return 0;
 2ee:	4501                	li	a0,0
 2f0:	a019                	j	2f6 <memcmp+0x30>
      return *p1 - *p2;
 2f2:	40e7853b          	subw	a0,a5,a4
}
 2f6:	6422                	ld	s0,8(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret
  return 0;
 2fc:	4501                	li	a0,0
 2fe:	bfe5                	j	2f6 <memcmp+0x30>

0000000000000300 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 300:	1141                	addi	sp,sp,-16
 302:	e406                	sd	ra,8(sp)
 304:	e022                	sd	s0,0(sp)
 306:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 308:	00000097          	auipc	ra,0x0
 30c:	f62080e7          	jalr	-158(ra) # 26a <memmove>
}
 310:	60a2                	ld	ra,8(sp)
 312:	6402                	ld	s0,0(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret

0000000000000318 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 318:	4885                	li	a7,1
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <exit>:
.global exit
exit:
 li a7, SYS_exit
 320:	4889                	li	a7,2
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <wait>:
.global wait
wait:
 li a7, SYS_wait
 328:	488d                	li	a7,3
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 330:	4891                	li	a7,4
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <read>:
.global read
read:
 li a7, SYS_read
 338:	4895                	li	a7,5
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <write>:
.global write
write:
 li a7, SYS_write
 340:	48c1                	li	a7,16
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <close>:
.global close
close:
 li a7, SYS_close
 348:	48d5                	li	a7,21
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <kill>:
.global kill
kill:
 li a7, SYS_kill
 350:	4899                	li	a7,6
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <exec>:
.global exec
exec:
 li a7, SYS_exec
 358:	489d                	li	a7,7
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <open>:
.global open
open:
 li a7, SYS_open
 360:	48bd                	li	a7,15
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 368:	48c5                	li	a7,17
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 370:	48c9                	li	a7,18
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 378:	48a1                	li	a7,8
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <link>:
.global link
link:
 li a7, SYS_link
 380:	48cd                	li	a7,19
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 388:	48d1                	li	a7,20
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 390:	48a5                	li	a7,9
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <dup>:
.global dup
dup:
 li a7, SYS_dup
 398:	48a9                	li	a7,10
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a0:	48ad                	li	a7,11
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3a8:	48b1                	li	a7,12
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3b0:	48b5                	li	a7,13
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b8:	48b9                	li	a7,14
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3c0:	1101                	addi	sp,sp,-32
 3c2:	ec06                	sd	ra,24(sp)
 3c4:	e822                	sd	s0,16(sp)
 3c6:	1000                	addi	s0,sp,32
 3c8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3cc:	4605                	li	a2,1
 3ce:	fef40593          	addi	a1,s0,-17
 3d2:	00000097          	auipc	ra,0x0
 3d6:	f6e080e7          	jalr	-146(ra) # 340 <write>
}
 3da:	60e2                	ld	ra,24(sp)
 3dc:	6442                	ld	s0,16(sp)
 3de:	6105                	addi	sp,sp,32
 3e0:	8082                	ret

00000000000003e2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e2:	7139                	addi	sp,sp,-64
 3e4:	fc06                	sd	ra,56(sp)
 3e6:	f822                	sd	s0,48(sp)
 3e8:	f426                	sd	s1,40(sp)
 3ea:	f04a                	sd	s2,32(sp)
 3ec:	ec4e                	sd	s3,24(sp)
 3ee:	0080                	addi	s0,sp,64
 3f0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f2:	c299                	beqz	a3,3f8 <printint+0x16>
 3f4:	0805c863          	bltz	a1,484 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3f8:	2581                	sext.w	a1,a1
  neg = 0;
 3fa:	4881                	li	a7,0
 3fc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 400:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 402:	2601                	sext.w	a2,a2
 404:	00000517          	auipc	a0,0x0
 408:	4e450513          	addi	a0,a0,1252 # 8e8 <digits>
 40c:	883a                	mv	a6,a4
 40e:	2705                	addiw	a4,a4,1
 410:	02c5f7bb          	remuw	a5,a1,a2
 414:	1782                	slli	a5,a5,0x20
 416:	9381                	srli	a5,a5,0x20
 418:	97aa                	add	a5,a5,a0
 41a:	0007c783          	lbu	a5,0(a5)
 41e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 422:	0005879b          	sext.w	a5,a1
 426:	02c5d5bb          	divuw	a1,a1,a2
 42a:	0685                	addi	a3,a3,1
 42c:	fec7f0e3          	bgeu	a5,a2,40c <printint+0x2a>
  if(neg)
 430:	00088b63          	beqz	a7,446 <printint+0x64>
    buf[i++] = '-';
 434:	fd040793          	addi	a5,s0,-48
 438:	973e                	add	a4,a4,a5
 43a:	02d00793          	li	a5,45
 43e:	fef70823          	sb	a5,-16(a4)
 442:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 446:	02e05863          	blez	a4,476 <printint+0x94>
 44a:	fc040793          	addi	a5,s0,-64
 44e:	00e78933          	add	s2,a5,a4
 452:	fff78993          	addi	s3,a5,-1
 456:	99ba                	add	s3,s3,a4
 458:	377d                	addiw	a4,a4,-1
 45a:	1702                	slli	a4,a4,0x20
 45c:	9301                	srli	a4,a4,0x20
 45e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 462:	fff94583          	lbu	a1,-1(s2)
 466:	8526                	mv	a0,s1
 468:	00000097          	auipc	ra,0x0
 46c:	f58080e7          	jalr	-168(ra) # 3c0 <putc>
  while(--i >= 0)
 470:	197d                	addi	s2,s2,-1
 472:	ff3918e3          	bne	s2,s3,462 <printint+0x80>
}
 476:	70e2                	ld	ra,56(sp)
 478:	7442                	ld	s0,48(sp)
 47a:	74a2                	ld	s1,40(sp)
 47c:	7902                	ld	s2,32(sp)
 47e:	69e2                	ld	s3,24(sp)
 480:	6121                	addi	sp,sp,64
 482:	8082                	ret
    x = -xx;
 484:	40b005bb          	negw	a1,a1
    neg = 1;
 488:	4885                	li	a7,1
    x = -xx;
 48a:	bf8d                	j	3fc <printint+0x1a>

000000000000048c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 48c:	7119                	addi	sp,sp,-128
 48e:	fc86                	sd	ra,120(sp)
 490:	f8a2                	sd	s0,112(sp)
 492:	f4a6                	sd	s1,104(sp)
 494:	f0ca                	sd	s2,96(sp)
 496:	ecce                	sd	s3,88(sp)
 498:	e8d2                	sd	s4,80(sp)
 49a:	e4d6                	sd	s5,72(sp)
 49c:	e0da                	sd	s6,64(sp)
 49e:	fc5e                	sd	s7,56(sp)
 4a0:	f862                	sd	s8,48(sp)
 4a2:	f466                	sd	s9,40(sp)
 4a4:	f06a                	sd	s10,32(sp)
 4a6:	ec6e                	sd	s11,24(sp)
 4a8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4aa:	0005c903          	lbu	s2,0(a1)
 4ae:	18090f63          	beqz	s2,64c <vprintf+0x1c0>
 4b2:	8aaa                	mv	s5,a0
 4b4:	8b32                	mv	s6,a2
 4b6:	00158493          	addi	s1,a1,1
  state = 0;
 4ba:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4bc:	02500a13          	li	s4,37
      if(c == 'd'){
 4c0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4c4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4c8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4cc:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4d0:	00000b97          	auipc	s7,0x0
 4d4:	418b8b93          	addi	s7,s7,1048 # 8e8 <digits>
 4d8:	a839                	j	4f6 <vprintf+0x6a>
        putc(fd, c);
 4da:	85ca                	mv	a1,s2
 4dc:	8556                	mv	a0,s5
 4de:	00000097          	auipc	ra,0x0
 4e2:	ee2080e7          	jalr	-286(ra) # 3c0 <putc>
 4e6:	a019                	j	4ec <vprintf+0x60>
    } else if(state == '%'){
 4e8:	01498f63          	beq	s3,s4,506 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4ec:	0485                	addi	s1,s1,1
 4ee:	fff4c903          	lbu	s2,-1(s1)
 4f2:	14090d63          	beqz	s2,64c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4f6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4fa:	fe0997e3          	bnez	s3,4e8 <vprintf+0x5c>
      if(c == '%'){
 4fe:	fd479ee3          	bne	a5,s4,4da <vprintf+0x4e>
        state = '%';
 502:	89be                	mv	s3,a5
 504:	b7e5                	j	4ec <vprintf+0x60>
      if(c == 'd'){
 506:	05878063          	beq	a5,s8,546 <vprintf+0xba>
      } else if(c == 'l') {
 50a:	05978c63          	beq	a5,s9,562 <vprintf+0xd6>
      } else if(c == 'x') {
 50e:	07a78863          	beq	a5,s10,57e <vprintf+0xf2>
      } else if(c == 'p') {
 512:	09b78463          	beq	a5,s11,59a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 516:	07300713          	li	a4,115
 51a:	0ce78663          	beq	a5,a4,5e6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 51e:	06300713          	li	a4,99
 522:	0ee78e63          	beq	a5,a4,61e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 526:	11478863          	beq	a5,s4,636 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 52a:	85d2                	mv	a1,s4
 52c:	8556                	mv	a0,s5
 52e:	00000097          	auipc	ra,0x0
 532:	e92080e7          	jalr	-366(ra) # 3c0 <putc>
        putc(fd, c);
 536:	85ca                	mv	a1,s2
 538:	8556                	mv	a0,s5
 53a:	00000097          	auipc	ra,0x0
 53e:	e86080e7          	jalr	-378(ra) # 3c0 <putc>
      }
      state = 0;
 542:	4981                	li	s3,0
 544:	b765                	j	4ec <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 546:	008b0913          	addi	s2,s6,8
 54a:	4685                	li	a3,1
 54c:	4629                	li	a2,10
 54e:	000b2583          	lw	a1,0(s6)
 552:	8556                	mv	a0,s5
 554:	00000097          	auipc	ra,0x0
 558:	e8e080e7          	jalr	-370(ra) # 3e2 <printint>
 55c:	8b4a                	mv	s6,s2
      state = 0;
 55e:	4981                	li	s3,0
 560:	b771                	j	4ec <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 562:	008b0913          	addi	s2,s6,8
 566:	4681                	li	a3,0
 568:	4629                	li	a2,10
 56a:	000b2583          	lw	a1,0(s6)
 56e:	8556                	mv	a0,s5
 570:	00000097          	auipc	ra,0x0
 574:	e72080e7          	jalr	-398(ra) # 3e2 <printint>
 578:	8b4a                	mv	s6,s2
      state = 0;
 57a:	4981                	li	s3,0
 57c:	bf85                	j	4ec <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 57e:	008b0913          	addi	s2,s6,8
 582:	4681                	li	a3,0
 584:	4641                	li	a2,16
 586:	000b2583          	lw	a1,0(s6)
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	e56080e7          	jalr	-426(ra) # 3e2 <printint>
 594:	8b4a                	mv	s6,s2
      state = 0;
 596:	4981                	li	s3,0
 598:	bf91                	j	4ec <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 59a:	008b0793          	addi	a5,s6,8
 59e:	f8f43423          	sd	a5,-120(s0)
 5a2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5a6:	03000593          	li	a1,48
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	e14080e7          	jalr	-492(ra) # 3c0 <putc>
  putc(fd, 'x');
 5b4:	85ea                	mv	a1,s10
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	e08080e7          	jalr	-504(ra) # 3c0 <putc>
 5c0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5c2:	03c9d793          	srli	a5,s3,0x3c
 5c6:	97de                	add	a5,a5,s7
 5c8:	0007c583          	lbu	a1,0(a5)
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	df2080e7          	jalr	-526(ra) # 3c0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5d6:	0992                	slli	s3,s3,0x4
 5d8:	397d                	addiw	s2,s2,-1
 5da:	fe0914e3          	bnez	s2,5c2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5de:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	b721                	j	4ec <vprintf+0x60>
        s = va_arg(ap, char*);
 5e6:	008b0993          	addi	s3,s6,8
 5ea:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5ee:	02090163          	beqz	s2,610 <vprintf+0x184>
        while(*s != 0){
 5f2:	00094583          	lbu	a1,0(s2)
 5f6:	c9a1                	beqz	a1,646 <vprintf+0x1ba>
          putc(fd, *s);
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	dc6080e7          	jalr	-570(ra) # 3c0 <putc>
          s++;
 602:	0905                	addi	s2,s2,1
        while(*s != 0){
 604:	00094583          	lbu	a1,0(s2)
 608:	f9e5                	bnez	a1,5f8 <vprintf+0x16c>
        s = va_arg(ap, char*);
 60a:	8b4e                	mv	s6,s3
      state = 0;
 60c:	4981                	li	s3,0
 60e:	bdf9                	j	4ec <vprintf+0x60>
          s = "(null)";
 610:	00000917          	auipc	s2,0x0
 614:	2d090913          	addi	s2,s2,720 # 8e0 <malloc+0x18a>
        while(*s != 0){
 618:	02800593          	li	a1,40
 61c:	bff1                	j	5f8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 61e:	008b0913          	addi	s2,s6,8
 622:	000b4583          	lbu	a1,0(s6)
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	d98080e7          	jalr	-616(ra) # 3c0 <putc>
 630:	8b4a                	mv	s6,s2
      state = 0;
 632:	4981                	li	s3,0
 634:	bd65                	j	4ec <vprintf+0x60>
        putc(fd, c);
 636:	85d2                	mv	a1,s4
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	d86080e7          	jalr	-634(ra) # 3c0 <putc>
      state = 0;
 642:	4981                	li	s3,0
 644:	b565                	j	4ec <vprintf+0x60>
        s = va_arg(ap, char*);
 646:	8b4e                	mv	s6,s3
      state = 0;
 648:	4981                	li	s3,0
 64a:	b54d                	j	4ec <vprintf+0x60>
    }
  }
}
 64c:	70e6                	ld	ra,120(sp)
 64e:	7446                	ld	s0,112(sp)
 650:	74a6                	ld	s1,104(sp)
 652:	7906                	ld	s2,96(sp)
 654:	69e6                	ld	s3,88(sp)
 656:	6a46                	ld	s4,80(sp)
 658:	6aa6                	ld	s5,72(sp)
 65a:	6b06                	ld	s6,64(sp)
 65c:	7be2                	ld	s7,56(sp)
 65e:	7c42                	ld	s8,48(sp)
 660:	7ca2                	ld	s9,40(sp)
 662:	7d02                	ld	s10,32(sp)
 664:	6de2                	ld	s11,24(sp)
 666:	6109                	addi	sp,sp,128
 668:	8082                	ret

000000000000066a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 66a:	715d                	addi	sp,sp,-80
 66c:	ec06                	sd	ra,24(sp)
 66e:	e822                	sd	s0,16(sp)
 670:	1000                	addi	s0,sp,32
 672:	e010                	sd	a2,0(s0)
 674:	e414                	sd	a3,8(s0)
 676:	e818                	sd	a4,16(s0)
 678:	ec1c                	sd	a5,24(s0)
 67a:	03043023          	sd	a6,32(s0)
 67e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 682:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 686:	8622                	mv	a2,s0
 688:	00000097          	auipc	ra,0x0
 68c:	e04080e7          	jalr	-508(ra) # 48c <vprintf>
}
 690:	60e2                	ld	ra,24(sp)
 692:	6442                	ld	s0,16(sp)
 694:	6161                	addi	sp,sp,80
 696:	8082                	ret

0000000000000698 <printf>:

void
printf(const char *fmt, ...)
{
 698:	711d                	addi	sp,sp,-96
 69a:	ec06                	sd	ra,24(sp)
 69c:	e822                	sd	s0,16(sp)
 69e:	1000                	addi	s0,sp,32
 6a0:	e40c                	sd	a1,8(s0)
 6a2:	e810                	sd	a2,16(s0)
 6a4:	ec14                	sd	a3,24(s0)
 6a6:	f018                	sd	a4,32(s0)
 6a8:	f41c                	sd	a5,40(s0)
 6aa:	03043823          	sd	a6,48(s0)
 6ae:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6b2:	00840613          	addi	a2,s0,8
 6b6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6ba:	85aa                	mv	a1,a0
 6bc:	4505                	li	a0,1
 6be:	00000097          	auipc	ra,0x0
 6c2:	dce080e7          	jalr	-562(ra) # 48c <vprintf>
}
 6c6:	60e2                	ld	ra,24(sp)
 6c8:	6442                	ld	s0,16(sp)
 6ca:	6125                	addi	sp,sp,96
 6cc:	8082                	ret

00000000000006ce <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ce:	1141                	addi	sp,sp,-16
 6d0:	e422                	sd	s0,8(sp)
 6d2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d8:	00000797          	auipc	a5,0x0
 6dc:	2287b783          	ld	a5,552(a5) # 900 <freep>
 6e0:	a805                	j	710 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6e2:	4618                	lw	a4,8(a2)
 6e4:	9db9                	addw	a1,a1,a4
 6e6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ea:	6398                	ld	a4,0(a5)
 6ec:	6318                	ld	a4,0(a4)
 6ee:	fee53823          	sd	a4,-16(a0)
 6f2:	a091                	j	736 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6f4:	ff852703          	lw	a4,-8(a0)
 6f8:	9e39                	addw	a2,a2,a4
 6fa:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6fc:	ff053703          	ld	a4,-16(a0)
 700:	e398                	sd	a4,0(a5)
 702:	a099                	j	748 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 704:	6398                	ld	a4,0(a5)
 706:	00e7e463          	bltu	a5,a4,70e <free+0x40>
 70a:	00e6ea63          	bltu	a3,a4,71e <free+0x50>
{
 70e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 710:	fed7fae3          	bgeu	a5,a3,704 <free+0x36>
 714:	6398                	ld	a4,0(a5)
 716:	00e6e463          	bltu	a3,a4,71e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71a:	fee7eae3          	bltu	a5,a4,70e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 71e:	ff852583          	lw	a1,-8(a0)
 722:	6390                	ld	a2,0(a5)
 724:	02059713          	slli	a4,a1,0x20
 728:	9301                	srli	a4,a4,0x20
 72a:	0712                	slli	a4,a4,0x4
 72c:	9736                	add	a4,a4,a3
 72e:	fae60ae3          	beq	a2,a4,6e2 <free+0x14>
    bp->s.ptr = p->s.ptr;
 732:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 736:	4790                	lw	a2,8(a5)
 738:	02061713          	slli	a4,a2,0x20
 73c:	9301                	srli	a4,a4,0x20
 73e:	0712                	slli	a4,a4,0x4
 740:	973e                	add	a4,a4,a5
 742:	fae689e3          	beq	a3,a4,6f4 <free+0x26>
  } else
    p->s.ptr = bp;
 746:	e394                	sd	a3,0(a5)
  freep = p;
 748:	00000717          	auipc	a4,0x0
 74c:	1af73c23          	sd	a5,440(a4) # 900 <freep>
}
 750:	6422                	ld	s0,8(sp)
 752:	0141                	addi	sp,sp,16
 754:	8082                	ret

0000000000000756 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 756:	7139                	addi	sp,sp,-64
 758:	fc06                	sd	ra,56(sp)
 75a:	f822                	sd	s0,48(sp)
 75c:	f426                	sd	s1,40(sp)
 75e:	f04a                	sd	s2,32(sp)
 760:	ec4e                	sd	s3,24(sp)
 762:	e852                	sd	s4,16(sp)
 764:	e456                	sd	s5,8(sp)
 766:	e05a                	sd	s6,0(sp)
 768:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 76a:	02051493          	slli	s1,a0,0x20
 76e:	9081                	srli	s1,s1,0x20
 770:	04bd                	addi	s1,s1,15
 772:	8091                	srli	s1,s1,0x4
 774:	0014899b          	addiw	s3,s1,1
 778:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 77a:	00000517          	auipc	a0,0x0
 77e:	18653503          	ld	a0,390(a0) # 900 <freep>
 782:	c515                	beqz	a0,7ae <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 784:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 786:	4798                	lw	a4,8(a5)
 788:	02977f63          	bgeu	a4,s1,7c6 <malloc+0x70>
 78c:	8a4e                	mv	s4,s3
 78e:	0009871b          	sext.w	a4,s3
 792:	6685                	lui	a3,0x1
 794:	00d77363          	bgeu	a4,a3,79a <malloc+0x44>
 798:	6a05                	lui	s4,0x1
 79a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 79e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7a2:	00000917          	auipc	s2,0x0
 7a6:	15e90913          	addi	s2,s2,350 # 900 <freep>
  if(p == (char*)-1)
 7aa:	5afd                	li	s5,-1
 7ac:	a88d                	j	81e <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 7ae:	00000797          	auipc	a5,0x0
 7b2:	15a78793          	addi	a5,a5,346 # 908 <base>
 7b6:	00000717          	auipc	a4,0x0
 7ba:	14f73523          	sd	a5,330(a4) # 900 <freep>
 7be:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7c0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7c4:	b7e1                	j	78c <malloc+0x36>
      if(p->s.size == nunits)
 7c6:	02e48b63          	beq	s1,a4,7fc <malloc+0xa6>
        p->s.size -= nunits;
 7ca:	4137073b          	subw	a4,a4,s3
 7ce:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7d0:	1702                	slli	a4,a4,0x20
 7d2:	9301                	srli	a4,a4,0x20
 7d4:	0712                	slli	a4,a4,0x4
 7d6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7d8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7dc:	00000717          	auipc	a4,0x0
 7e0:	12a73223          	sd	a0,292(a4) # 900 <freep>
      return (void*)(p + 1);
 7e4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7e8:	70e2                	ld	ra,56(sp)
 7ea:	7442                	ld	s0,48(sp)
 7ec:	74a2                	ld	s1,40(sp)
 7ee:	7902                	ld	s2,32(sp)
 7f0:	69e2                	ld	s3,24(sp)
 7f2:	6a42                	ld	s4,16(sp)
 7f4:	6aa2                	ld	s5,8(sp)
 7f6:	6b02                	ld	s6,0(sp)
 7f8:	6121                	addi	sp,sp,64
 7fa:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7fc:	6398                	ld	a4,0(a5)
 7fe:	e118                	sd	a4,0(a0)
 800:	bff1                	j	7dc <malloc+0x86>
  hp->s.size = nu;
 802:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 806:	0541                	addi	a0,a0,16
 808:	00000097          	auipc	ra,0x0
 80c:	ec6080e7          	jalr	-314(ra) # 6ce <free>
  return freep;
 810:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 814:	d971                	beqz	a0,7e8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 816:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 818:	4798                	lw	a4,8(a5)
 81a:	fa9776e3          	bgeu	a4,s1,7c6 <malloc+0x70>
    if(p == freep)
 81e:	00093703          	ld	a4,0(s2)
 822:	853e                	mv	a0,a5
 824:	fef719e3          	bne	a4,a5,816 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 828:	8552                	mv	a0,s4
 82a:	00000097          	auipc	ra,0x0
 82e:	b7e080e7          	jalr	-1154(ra) # 3a8 <sbrk>
  if(p == (char*)-1)
 832:	fd5518e3          	bne	a0,s5,802 <malloc+0xac>
        return 0;
 836:	4501                	li	a0,0
 838:	bf45                	j	7e8 <malloc+0x92>
