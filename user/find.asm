
user/_find：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  
  char *p;

  // Find first character after last slash.在/之后找到第一个字符
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	00000097          	auipc	ra,0x0
  10:	2a6080e7          	jalr	678(ra) # 2b2 <strlen>
  14:	1502                	slli	a0,a0,0x20
  16:	9101                	srli	a0,a0,0x20
  18:	9526                	add	a0,a0,s1
  1a:	02f00713          	li	a4,47
  1e:	00956963          	bltu	a0,s1,30 <fmtname+0x30>
  22:	00054783          	lbu	a5,0(a0)
  26:	00e78563          	beq	a5,a4,30 <fmtname+0x30>
  2a:	157d                	addi	a0,a0,-1
  2c:	fe957be3          	bgeu	a0,s1,22 <fmtname+0x22>
    ;
  return p+1;
}
  30:	0505                	addi	a0,a0,1
  32:	60e2                	ld	ra,24(sp)
  34:	6442                	ld	s0,16(sp)
  36:	64a2                	ld	s1,8(sp)
  38:	6105                	addi	sp,sp,32
  3a:	8082                	ret

000000000000003c <find>:


void find(char *path, const char *filename)
{
  3c:	d8010113          	addi	sp,sp,-640
  40:	26113c23          	sd	ra,632(sp)
  44:	26813823          	sd	s0,624(sp)
  48:	26913423          	sd	s1,616(sp)
  4c:	27213023          	sd	s2,608(sp)
  50:	25313c23          	sd	s3,600(sp)
  54:	25413823          	sd	s4,592(sp)
  58:	25513423          	sd	s5,584(sp)
  5c:	25613023          	sd	s6,576(sp)
  60:	23713c23          	sd	s7,568(sp)
  64:	0500                	addi	s0,sp,640
  66:	892a                	mv	s2,a0
  68:	89ae                	mv	s3,a1
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    if((fd = open(path,0)) < 0){//先打开这个路径
  6a:	4581                	li	a1,0
  6c:	00000097          	auipc	ra,0x0
  70:	4b4080e7          	jalr	1204(ra) # 520 <open>
  74:	06054b63          	bltz	a0,ea <find+0xae>
  78:	84aa                	mv	s1,a0
    fprintf(2, "find: cannot open %s\n", path);
    return;
    }
    //ftstat系统调用  打开的文件描述符的文件的一些状态写道st
    if (fstat(fd, &st) < 0) {
  7a:	d8840593          	addi	a1,s0,-632
  7e:	00000097          	auipc	ra,0x0
  82:	4ba080e7          	jalr	1210(ra) # 538 <fstat>
  86:	06054d63          	bltz	a0,100 <find+0xc4>
    close(fd);
    return;
    }

    //选择不同的文件来打印
    switch(st.type){
  8a:	d9041783          	lh	a5,-624(s0)
  8e:	0007869b          	sext.w	a3,a5
  92:	4705                	li	a4,1
  94:	0ae68063          	beq	a3,a4,134 <find+0xf8>
  98:	4709                	li	a4,2
  9a:	00e69e63          	bne	a3,a4,b6 <find+0x7a>
        case T_FILE:
        if(strcmp(filename,fmtname(path))==0) printf("%s\n",path);
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	f60080e7          	jalr	-160(ra) # 0 <fmtname>
  a8:	85aa                	mv	a1,a0
  aa:	854e                	mv	a0,s3
  ac:	00000097          	auipc	ra,0x0
  b0:	1da080e7          	jalr	474(ra) # 286 <strcmp>
  b4:	c535                	beqz	a0,120 <find+0xe4>
        }
        find(buf,filename);
        }
        break;
    }
    close(fd);
  b6:	8526                	mv	a0,s1
  b8:	00000097          	auipc	ra,0x0
  bc:	450080e7          	jalr	1104(ra) # 508 <close>
    
}
  c0:	27813083          	ld	ra,632(sp)
  c4:	27013403          	ld	s0,624(sp)
  c8:	26813483          	ld	s1,616(sp)
  cc:	26013903          	ld	s2,608(sp)
  d0:	25813983          	ld	s3,600(sp)
  d4:	25013a03          	ld	s4,592(sp)
  d8:	24813a83          	ld	s5,584(sp)
  dc:	24013b03          	ld	s6,576(sp)
  e0:	23813b83          	ld	s7,568(sp)
  e4:	28010113          	addi	sp,sp,640
  e8:	8082                	ret
    fprintf(2, "find: cannot open %s\n", path);
  ea:	864a                	mv	a2,s2
  ec:	00001597          	auipc	a1,0x1
  f0:	91458593          	addi	a1,a1,-1772 # a00 <malloc+0xea>
  f4:	4509                	li	a0,2
  f6:	00000097          	auipc	ra,0x0
  fa:	734080e7          	jalr	1844(ra) # 82a <fprintf>
    return;
  fe:	b7c9                	j	c0 <find+0x84>
    fprintf(2, "find: cannot fstat %s\n", path);
 100:	864a                	mv	a2,s2
 102:	00001597          	auipc	a1,0x1
 106:	91658593          	addi	a1,a1,-1770 # a18 <malloc+0x102>
 10a:	4509                	li	a0,2
 10c:	00000097          	auipc	ra,0x0
 110:	71e080e7          	jalr	1822(ra) # 82a <fprintf>
    close(fd);
 114:	8526                	mv	a0,s1
 116:	00000097          	auipc	ra,0x0
 11a:	3f2080e7          	jalr	1010(ra) # 508 <close>
    return;
 11e:	b74d                	j	c0 <find+0x84>
        if(strcmp(filename,fmtname(path))==0) printf("%s\n",path);
 120:	85ca                	mv	a1,s2
 122:	00001517          	auipc	a0,0x1
 126:	90e50513          	addi	a0,a0,-1778 # a30 <malloc+0x11a>
 12a:	00000097          	auipc	ra,0x0
 12e:	72e080e7          	jalr	1838(ra) # 858 <printf>
 132:	b751                	j	b6 <find+0x7a>
        if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 134:	854a                	mv	a0,s2
 136:	00000097          	auipc	ra,0x0
 13a:	17c080e7          	jalr	380(ra) # 2b2 <strlen>
 13e:	2541                	addiw	a0,a0,16
 140:	20000793          	li	a5,512
 144:	00a7fb63          	bgeu	a5,a0,15a <find+0x11e>
            printf("ls: path too long\n");
 148:	00001517          	auipc	a0,0x1
 14c:	8f050513          	addi	a0,a0,-1808 # a38 <malloc+0x122>
 150:	00000097          	auipc	ra,0x0
 154:	708080e7          	jalr	1800(ra) # 858 <printf>
            break;
 158:	bfb9                	j	b6 <find+0x7a>
        strcpy(buf, path);//path是不能改的 const
 15a:	85ca                	mv	a1,s2
 15c:	db040513          	addi	a0,s0,-592
 160:	00000097          	auipc	ra,0x0
 164:	10a080e7          	jalr	266(ra) # 26a <strcpy>
        p = buf+strlen(buf);
 168:	db040513          	addi	a0,s0,-592
 16c:	00000097          	auipc	ra,0x0
 170:	146080e7          	jalr	326(ra) # 2b2 <strlen>
 174:	02051913          	slli	s2,a0,0x20
 178:	02095913          	srli	s2,s2,0x20
 17c:	db040793          	addi	a5,s0,-592
 180:	993e                	add	s2,s2,a5
        *p++ = '/';//和*(p++)一样  p++先指向下一个  然后在解饮用
 182:	00190b13          	addi	s6,s2,1
 186:	02f00793          	li	a5,47
 18a:	00f90023          	sb	a5,0(s2)
        if(de.inum == 0||strcmp(de.name, ".")==0||strcmp(de.name,"..")==0)
 18e:	00001a97          	auipc	s5,0x1
 192:	8c2a8a93          	addi	s5,s5,-1854 # a50 <malloc+0x13a>
 196:	00001b97          	auipc	s7,0x1
 19a:	8c2b8b93          	addi	s7,s7,-1854 # a58 <malloc+0x142>
 19e:	da240a13          	addi	s4,s0,-606
        while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1a2:	4641                	li	a2,16
 1a4:	da040593          	addi	a1,s0,-608
 1a8:	8526                	mv	a0,s1
 1aa:	00000097          	auipc	ra,0x0
 1ae:	34e080e7          	jalr	846(ra) # 4f8 <read>
 1b2:	47c1                	li	a5,16
 1b4:	f0f511e3          	bne	a0,a5,b6 <find+0x7a>
        if(de.inum == 0||strcmp(de.name, ".")==0||strcmp(de.name,"..")==0)
 1b8:	da045783          	lhu	a5,-608(s0)
 1bc:	d3fd                	beqz	a5,1a2 <find+0x166>
 1be:	85d6                	mv	a1,s5
 1c0:	8552                	mv	a0,s4
 1c2:	00000097          	auipc	ra,0x0
 1c6:	0c4080e7          	jalr	196(ra) # 286 <strcmp>
 1ca:	dd61                	beqz	a0,1a2 <find+0x166>
 1cc:	85de                	mv	a1,s7
 1ce:	8552                	mv	a0,s4
 1d0:	00000097          	auipc	ra,0x0
 1d4:	0b6080e7          	jalr	182(ra) # 286 <strcmp>
 1d8:	d569                	beqz	a0,1a2 <find+0x166>
        memmove(p, de.name, DIRSIZ);//de.name复制到p
 1da:	4639                	li	a2,14
 1dc:	da240593          	addi	a1,s0,-606
 1e0:	855a                	mv	a0,s6
 1e2:	00000097          	auipc	ra,0x0
 1e6:	248080e7          	jalr	584(ra) # 42a <memmove>
        p[DIRSIZ] = 0;
 1ea:	000907a3          	sb	zero,15(s2)
        if(stat(buf, &st) < 0){//找不到这个路径
 1ee:	d8840593          	addi	a1,s0,-632
 1f2:	db040513          	addi	a0,s0,-592
 1f6:	00000097          	auipc	ra,0x0
 1fa:	1a4080e7          	jalr	420(ra) # 39a <stat>
 1fe:	00054a63          	bltz	a0,212 <find+0x1d6>
        find(buf,filename);
 202:	85ce                	mv	a1,s3
 204:	db040513          	addi	a0,s0,-592
 208:	00000097          	auipc	ra,0x0
 20c:	e34080e7          	jalr	-460(ra) # 3c <find>
 210:	bf49                	j	1a2 <find+0x166>
            printf("find: cannot stat %s\n", buf);
 212:	db040593          	addi	a1,s0,-592
 216:	00001517          	auipc	a0,0x1
 21a:	84a50513          	addi	a0,a0,-1974 # a60 <malloc+0x14a>
 21e:	00000097          	auipc	ra,0x0
 222:	63a080e7          	jalr	1594(ra) # 858 <printf>
            continue;
 226:	bfb5                	j	1a2 <find+0x166>

0000000000000228 <main>:
int main(int argc, char *argv[])
{
 228:	1141                	addi	sp,sp,-16
 22a:	e406                	sd	ra,8(sp)
 22c:	e022                	sd	s0,0(sp)
 22e:	0800                	addi	s0,sp,16
    if (argc != 3) {
 230:	470d                	li	a4,3
 232:	00e51e63          	bne	a0,a4,24e <main+0x26>
 236:	87ae                	mv	a5,a1
    fprintf(2, "usage: find <directory> <filename>\n");
    exit(1);
    }
  for(int i=2; i<argc; i++)
    find(argv[1], argv[i]);
 238:	698c                	ld	a1,16(a1)
 23a:	6788                	ld	a0,8(a5)
 23c:	00000097          	auipc	ra,0x0
 240:	e00080e7          	jalr	-512(ra) # 3c <find>
  exit(0);
 244:	4501                	li	a0,0
 246:	00000097          	auipc	ra,0x0
 24a:	29a080e7          	jalr	666(ra) # 4e0 <exit>
    fprintf(2, "usage: find <directory> <filename>\n");
 24e:	00001597          	auipc	a1,0x1
 252:	82a58593          	addi	a1,a1,-2006 # a78 <malloc+0x162>
 256:	4509                	li	a0,2
 258:	00000097          	auipc	ra,0x0
 25c:	5d2080e7          	jalr	1490(ra) # 82a <fprintf>
    exit(1);
 260:	4505                	li	a0,1
 262:	00000097          	auipc	ra,0x0
 266:	27e080e7          	jalr	638(ra) # 4e0 <exit>

000000000000026a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 26a:	1141                	addi	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 270:	87aa                	mv	a5,a0
 272:	0585                	addi	a1,a1,1
 274:	0785                	addi	a5,a5,1
 276:	fff5c703          	lbu	a4,-1(a1)
 27a:	fee78fa3          	sb	a4,-1(a5)
 27e:	fb75                	bnez	a4,272 <strcpy+0x8>
    ;
  return os;
}
 280:	6422                	ld	s0,8(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret

0000000000000286 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 286:	1141                	addi	sp,sp,-16
 288:	e422                	sd	s0,8(sp)
 28a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 28c:	00054783          	lbu	a5,0(a0)
 290:	cb91                	beqz	a5,2a4 <strcmp+0x1e>
 292:	0005c703          	lbu	a4,0(a1)
 296:	00f71763          	bne	a4,a5,2a4 <strcmp+0x1e>
    p++, q++;
 29a:	0505                	addi	a0,a0,1
 29c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 29e:	00054783          	lbu	a5,0(a0)
 2a2:	fbe5                	bnez	a5,292 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2a4:	0005c503          	lbu	a0,0(a1)
}
 2a8:	40a7853b          	subw	a0,a5,a0
 2ac:	6422                	ld	s0,8(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret

00000000000002b2 <strlen>:

uint
strlen(const char *s)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2b8:	00054783          	lbu	a5,0(a0)
 2bc:	cf91                	beqz	a5,2d8 <strlen+0x26>
 2be:	0505                	addi	a0,a0,1
 2c0:	87aa                	mv	a5,a0
 2c2:	4685                	li	a3,1
 2c4:	9e89                	subw	a3,a3,a0
 2c6:	00f6853b          	addw	a0,a3,a5
 2ca:	0785                	addi	a5,a5,1
 2cc:	fff7c703          	lbu	a4,-1(a5)
 2d0:	fb7d                	bnez	a4,2c6 <strlen+0x14>
    ;
  return n;
}
 2d2:	6422                	ld	s0,8(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret
  for(n = 0; s[n]; n++)
 2d8:	4501                	li	a0,0
 2da:	bfe5                	j	2d2 <strlen+0x20>

00000000000002dc <memset>:

void*
memset(void *dst, int c, uint n)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e422                	sd	s0,8(sp)
 2e0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2e2:	ce09                	beqz	a2,2fc <memset+0x20>
 2e4:	87aa                	mv	a5,a0
 2e6:	fff6071b          	addiw	a4,a2,-1
 2ea:	1702                	slli	a4,a4,0x20
 2ec:	9301                	srli	a4,a4,0x20
 2ee:	0705                	addi	a4,a4,1
 2f0:	972a                	add	a4,a4,a0
    cdst[i] = c;
 2f2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2f6:	0785                	addi	a5,a5,1
 2f8:	fee79de3          	bne	a5,a4,2f2 <memset+0x16>
  }
  return dst;
}
 2fc:	6422                	ld	s0,8(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret

0000000000000302 <strchr>:

char*
strchr(const char *s, char c)
{
 302:	1141                	addi	sp,sp,-16
 304:	e422                	sd	s0,8(sp)
 306:	0800                	addi	s0,sp,16
  for(; *s; s++)
 308:	00054783          	lbu	a5,0(a0)
 30c:	cb99                	beqz	a5,322 <strchr+0x20>
    if(*s == c)
 30e:	00f58763          	beq	a1,a5,31c <strchr+0x1a>
  for(; *s; s++)
 312:	0505                	addi	a0,a0,1
 314:	00054783          	lbu	a5,0(a0)
 318:	fbfd                	bnez	a5,30e <strchr+0xc>
      return (char*)s;
  return 0;
 31a:	4501                	li	a0,0
}
 31c:	6422                	ld	s0,8(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret
  return 0;
 322:	4501                	li	a0,0
 324:	bfe5                	j	31c <strchr+0x1a>

0000000000000326 <gets>:

char*
gets(char *buf, int max)
{
 326:	711d                	addi	sp,sp,-96
 328:	ec86                	sd	ra,88(sp)
 32a:	e8a2                	sd	s0,80(sp)
 32c:	e4a6                	sd	s1,72(sp)
 32e:	e0ca                	sd	s2,64(sp)
 330:	fc4e                	sd	s3,56(sp)
 332:	f852                	sd	s4,48(sp)
 334:	f456                	sd	s5,40(sp)
 336:	f05a                	sd	s6,32(sp)
 338:	ec5e                	sd	s7,24(sp)
 33a:	1080                	addi	s0,sp,96
 33c:	8baa                	mv	s7,a0
 33e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 340:	892a                	mv	s2,a0
 342:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 344:	4aa9                	li	s5,10
 346:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 348:	89a6                	mv	s3,s1
 34a:	2485                	addiw	s1,s1,1
 34c:	0344d863          	bge	s1,s4,37c <gets+0x56>
    cc = read(0, &c, 1);
 350:	4605                	li	a2,1
 352:	faf40593          	addi	a1,s0,-81
 356:	4501                	li	a0,0
 358:	00000097          	auipc	ra,0x0
 35c:	1a0080e7          	jalr	416(ra) # 4f8 <read>
    if(cc < 1)
 360:	00a05e63          	blez	a0,37c <gets+0x56>
    buf[i++] = c;
 364:	faf44783          	lbu	a5,-81(s0)
 368:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 36c:	01578763          	beq	a5,s5,37a <gets+0x54>
 370:	0905                	addi	s2,s2,1
 372:	fd679be3          	bne	a5,s6,348 <gets+0x22>
  for(i=0; i+1 < max; ){
 376:	89a6                	mv	s3,s1
 378:	a011                	j	37c <gets+0x56>
 37a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 37c:	99de                	add	s3,s3,s7
 37e:	00098023          	sb	zero,0(s3)
  return buf;
}
 382:	855e                	mv	a0,s7
 384:	60e6                	ld	ra,88(sp)
 386:	6446                	ld	s0,80(sp)
 388:	64a6                	ld	s1,72(sp)
 38a:	6906                	ld	s2,64(sp)
 38c:	79e2                	ld	s3,56(sp)
 38e:	7a42                	ld	s4,48(sp)
 390:	7aa2                	ld	s5,40(sp)
 392:	7b02                	ld	s6,32(sp)
 394:	6be2                	ld	s7,24(sp)
 396:	6125                	addi	sp,sp,96
 398:	8082                	ret

000000000000039a <stat>:

int
stat(const char *n, struct stat *st)
{
 39a:	1101                	addi	sp,sp,-32
 39c:	ec06                	sd	ra,24(sp)
 39e:	e822                	sd	s0,16(sp)
 3a0:	e426                	sd	s1,8(sp)
 3a2:	e04a                	sd	s2,0(sp)
 3a4:	1000                	addi	s0,sp,32
 3a6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a8:	4581                	li	a1,0
 3aa:	00000097          	auipc	ra,0x0
 3ae:	176080e7          	jalr	374(ra) # 520 <open>
  if(fd < 0)
 3b2:	02054563          	bltz	a0,3dc <stat+0x42>
 3b6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3b8:	85ca                	mv	a1,s2
 3ba:	00000097          	auipc	ra,0x0
 3be:	17e080e7          	jalr	382(ra) # 538 <fstat>
 3c2:	892a                	mv	s2,a0
  close(fd);
 3c4:	8526                	mv	a0,s1
 3c6:	00000097          	auipc	ra,0x0
 3ca:	142080e7          	jalr	322(ra) # 508 <close>
  return r;
}
 3ce:	854a                	mv	a0,s2
 3d0:	60e2                	ld	ra,24(sp)
 3d2:	6442                	ld	s0,16(sp)
 3d4:	64a2                	ld	s1,8(sp)
 3d6:	6902                	ld	s2,0(sp)
 3d8:	6105                	addi	sp,sp,32
 3da:	8082                	ret
    return -1;
 3dc:	597d                	li	s2,-1
 3de:	bfc5                	j	3ce <stat+0x34>

00000000000003e0 <atoi>:

int
atoi(const char *s)
{
 3e0:	1141                	addi	sp,sp,-16
 3e2:	e422                	sd	s0,8(sp)
 3e4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e6:	00054603          	lbu	a2,0(a0)
 3ea:	fd06079b          	addiw	a5,a2,-48
 3ee:	0ff7f793          	andi	a5,a5,255
 3f2:	4725                	li	a4,9
 3f4:	02f76963          	bltu	a4,a5,426 <atoi+0x46>
 3f8:	86aa                	mv	a3,a0
  n = 0;
 3fa:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3fc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3fe:	0685                	addi	a3,a3,1
 400:	0025179b          	slliw	a5,a0,0x2
 404:	9fa9                	addw	a5,a5,a0
 406:	0017979b          	slliw	a5,a5,0x1
 40a:	9fb1                	addw	a5,a5,a2
 40c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 410:	0006c603          	lbu	a2,0(a3)
 414:	fd06071b          	addiw	a4,a2,-48
 418:	0ff77713          	andi	a4,a4,255
 41c:	fee5f1e3          	bgeu	a1,a4,3fe <atoi+0x1e>
  return n;
}
 420:	6422                	ld	s0,8(sp)
 422:	0141                	addi	sp,sp,16
 424:	8082                	ret
  n = 0;
 426:	4501                	li	a0,0
 428:	bfe5                	j	420 <atoi+0x40>

000000000000042a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 42a:	1141                	addi	sp,sp,-16
 42c:	e422                	sd	s0,8(sp)
 42e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 430:	02b57663          	bgeu	a0,a1,45c <memmove+0x32>
    while(n-- > 0)
 434:	02c05163          	blez	a2,456 <memmove+0x2c>
 438:	fff6079b          	addiw	a5,a2,-1
 43c:	1782                	slli	a5,a5,0x20
 43e:	9381                	srli	a5,a5,0x20
 440:	0785                	addi	a5,a5,1
 442:	97aa                	add	a5,a5,a0
  dst = vdst;
 444:	872a                	mv	a4,a0
      *dst++ = *src++;
 446:	0585                	addi	a1,a1,1
 448:	0705                	addi	a4,a4,1
 44a:	fff5c683          	lbu	a3,-1(a1)
 44e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 452:	fee79ae3          	bne	a5,a4,446 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 456:	6422                	ld	s0,8(sp)
 458:	0141                	addi	sp,sp,16
 45a:	8082                	ret
    dst += n;
 45c:	00c50733          	add	a4,a0,a2
    src += n;
 460:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 462:	fec05ae3          	blez	a2,456 <memmove+0x2c>
 466:	fff6079b          	addiw	a5,a2,-1
 46a:	1782                	slli	a5,a5,0x20
 46c:	9381                	srli	a5,a5,0x20
 46e:	fff7c793          	not	a5,a5
 472:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 474:	15fd                	addi	a1,a1,-1
 476:	177d                	addi	a4,a4,-1
 478:	0005c683          	lbu	a3,0(a1)
 47c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 480:	fee79ae3          	bne	a5,a4,474 <memmove+0x4a>
 484:	bfc9                	j	456 <memmove+0x2c>

0000000000000486 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 486:	1141                	addi	sp,sp,-16
 488:	e422                	sd	s0,8(sp)
 48a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 48c:	ca05                	beqz	a2,4bc <memcmp+0x36>
 48e:	fff6069b          	addiw	a3,a2,-1
 492:	1682                	slli	a3,a3,0x20
 494:	9281                	srli	a3,a3,0x20
 496:	0685                	addi	a3,a3,1
 498:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 49a:	00054783          	lbu	a5,0(a0)
 49e:	0005c703          	lbu	a4,0(a1)
 4a2:	00e79863          	bne	a5,a4,4b2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4a6:	0505                	addi	a0,a0,1
    p2++;
 4a8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4aa:	fed518e3          	bne	a0,a3,49a <memcmp+0x14>
  }
  return 0;
 4ae:	4501                	li	a0,0
 4b0:	a019                	j	4b6 <memcmp+0x30>
      return *p1 - *p2;
 4b2:	40e7853b          	subw	a0,a5,a4
}
 4b6:	6422                	ld	s0,8(sp)
 4b8:	0141                	addi	sp,sp,16
 4ba:	8082                	ret
  return 0;
 4bc:	4501                	li	a0,0
 4be:	bfe5                	j	4b6 <memcmp+0x30>

00000000000004c0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4c0:	1141                	addi	sp,sp,-16
 4c2:	e406                	sd	ra,8(sp)
 4c4:	e022                	sd	s0,0(sp)
 4c6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4c8:	00000097          	auipc	ra,0x0
 4cc:	f62080e7          	jalr	-158(ra) # 42a <memmove>
}
 4d0:	60a2                	ld	ra,8(sp)
 4d2:	6402                	ld	s0,0(sp)
 4d4:	0141                	addi	sp,sp,16
 4d6:	8082                	ret

00000000000004d8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4d8:	4885                	li	a7,1
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4e0:	4889                	li	a7,2
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4e8:	488d                	li	a7,3
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4f0:	4891                	li	a7,4
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <read>:
.global read
read:
 li a7, SYS_read
 4f8:	4895                	li	a7,5
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <write>:
.global write
write:
 li a7, SYS_write
 500:	48c1                	li	a7,16
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <close>:
.global close
close:
 li a7, SYS_close
 508:	48d5                	li	a7,21
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <kill>:
.global kill
kill:
 li a7, SYS_kill
 510:	4899                	li	a7,6
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <exec>:
.global exec
exec:
 li a7, SYS_exec
 518:	489d                	li	a7,7
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <open>:
.global open
open:
 li a7, SYS_open
 520:	48bd                	li	a7,15
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 528:	48c5                	li	a7,17
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 530:	48c9                	li	a7,18
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 538:	48a1                	li	a7,8
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <link>:
.global link
link:
 li a7, SYS_link
 540:	48cd                	li	a7,19
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 548:	48d1                	li	a7,20
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 550:	48a5                	li	a7,9
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <dup>:
.global dup
dup:
 li a7, SYS_dup
 558:	48a9                	li	a7,10
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 560:	48ad                	li	a7,11
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 568:	48b1                	li	a7,12
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 570:	48b5                	li	a7,13
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 578:	48b9                	li	a7,14
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 580:	1101                	addi	sp,sp,-32
 582:	ec06                	sd	ra,24(sp)
 584:	e822                	sd	s0,16(sp)
 586:	1000                	addi	s0,sp,32
 588:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 58c:	4605                	li	a2,1
 58e:	fef40593          	addi	a1,s0,-17
 592:	00000097          	auipc	ra,0x0
 596:	f6e080e7          	jalr	-146(ra) # 500 <write>
}
 59a:	60e2                	ld	ra,24(sp)
 59c:	6442                	ld	s0,16(sp)
 59e:	6105                	addi	sp,sp,32
 5a0:	8082                	ret

00000000000005a2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5a2:	7139                	addi	sp,sp,-64
 5a4:	fc06                	sd	ra,56(sp)
 5a6:	f822                	sd	s0,48(sp)
 5a8:	f426                	sd	s1,40(sp)
 5aa:	f04a                	sd	s2,32(sp)
 5ac:	ec4e                	sd	s3,24(sp)
 5ae:	0080                	addi	s0,sp,64
 5b0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5b2:	c299                	beqz	a3,5b8 <printint+0x16>
 5b4:	0805c863          	bltz	a1,644 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5b8:	2581                	sext.w	a1,a1
  neg = 0;
 5ba:	4881                	li	a7,0
 5bc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5c0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5c2:	2601                	sext.w	a2,a2
 5c4:	00000517          	auipc	a0,0x0
 5c8:	4e450513          	addi	a0,a0,1252 # aa8 <digits>
 5cc:	883a                	mv	a6,a4
 5ce:	2705                	addiw	a4,a4,1
 5d0:	02c5f7bb          	remuw	a5,a1,a2
 5d4:	1782                	slli	a5,a5,0x20
 5d6:	9381                	srli	a5,a5,0x20
 5d8:	97aa                	add	a5,a5,a0
 5da:	0007c783          	lbu	a5,0(a5)
 5de:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5e2:	0005879b          	sext.w	a5,a1
 5e6:	02c5d5bb          	divuw	a1,a1,a2
 5ea:	0685                	addi	a3,a3,1
 5ec:	fec7f0e3          	bgeu	a5,a2,5cc <printint+0x2a>
  if(neg)
 5f0:	00088b63          	beqz	a7,606 <printint+0x64>
    buf[i++] = '-';
 5f4:	fd040793          	addi	a5,s0,-48
 5f8:	973e                	add	a4,a4,a5
 5fa:	02d00793          	li	a5,45
 5fe:	fef70823          	sb	a5,-16(a4)
 602:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 606:	02e05863          	blez	a4,636 <printint+0x94>
 60a:	fc040793          	addi	a5,s0,-64
 60e:	00e78933          	add	s2,a5,a4
 612:	fff78993          	addi	s3,a5,-1
 616:	99ba                	add	s3,s3,a4
 618:	377d                	addiw	a4,a4,-1
 61a:	1702                	slli	a4,a4,0x20
 61c:	9301                	srli	a4,a4,0x20
 61e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 622:	fff94583          	lbu	a1,-1(s2)
 626:	8526                	mv	a0,s1
 628:	00000097          	auipc	ra,0x0
 62c:	f58080e7          	jalr	-168(ra) # 580 <putc>
  while(--i >= 0)
 630:	197d                	addi	s2,s2,-1
 632:	ff3918e3          	bne	s2,s3,622 <printint+0x80>
}
 636:	70e2                	ld	ra,56(sp)
 638:	7442                	ld	s0,48(sp)
 63a:	74a2                	ld	s1,40(sp)
 63c:	7902                	ld	s2,32(sp)
 63e:	69e2                	ld	s3,24(sp)
 640:	6121                	addi	sp,sp,64
 642:	8082                	ret
    x = -xx;
 644:	40b005bb          	negw	a1,a1
    neg = 1;
 648:	4885                	li	a7,1
    x = -xx;
 64a:	bf8d                	j	5bc <printint+0x1a>

000000000000064c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 64c:	7119                	addi	sp,sp,-128
 64e:	fc86                	sd	ra,120(sp)
 650:	f8a2                	sd	s0,112(sp)
 652:	f4a6                	sd	s1,104(sp)
 654:	f0ca                	sd	s2,96(sp)
 656:	ecce                	sd	s3,88(sp)
 658:	e8d2                	sd	s4,80(sp)
 65a:	e4d6                	sd	s5,72(sp)
 65c:	e0da                	sd	s6,64(sp)
 65e:	fc5e                	sd	s7,56(sp)
 660:	f862                	sd	s8,48(sp)
 662:	f466                	sd	s9,40(sp)
 664:	f06a                	sd	s10,32(sp)
 666:	ec6e                	sd	s11,24(sp)
 668:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 66a:	0005c903          	lbu	s2,0(a1)
 66e:	18090f63          	beqz	s2,80c <vprintf+0x1c0>
 672:	8aaa                	mv	s5,a0
 674:	8b32                	mv	s6,a2
 676:	00158493          	addi	s1,a1,1
  state = 0;
 67a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 67c:	02500a13          	li	s4,37
      if(c == 'd'){
 680:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 684:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 688:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 68c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 690:	00000b97          	auipc	s7,0x0
 694:	418b8b93          	addi	s7,s7,1048 # aa8 <digits>
 698:	a839                	j	6b6 <vprintf+0x6a>
        putc(fd, c);
 69a:	85ca                	mv	a1,s2
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	ee2080e7          	jalr	-286(ra) # 580 <putc>
 6a6:	a019                	j	6ac <vprintf+0x60>
    } else if(state == '%'){
 6a8:	01498f63          	beq	s3,s4,6c6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6ac:	0485                	addi	s1,s1,1
 6ae:	fff4c903          	lbu	s2,-1(s1)
 6b2:	14090d63          	beqz	s2,80c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6b6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6ba:	fe0997e3          	bnez	s3,6a8 <vprintf+0x5c>
      if(c == '%'){
 6be:	fd479ee3          	bne	a5,s4,69a <vprintf+0x4e>
        state = '%';
 6c2:	89be                	mv	s3,a5
 6c4:	b7e5                	j	6ac <vprintf+0x60>
      if(c == 'd'){
 6c6:	05878063          	beq	a5,s8,706 <vprintf+0xba>
      } else if(c == 'l') {
 6ca:	05978c63          	beq	a5,s9,722 <vprintf+0xd6>
      } else if(c == 'x') {
 6ce:	07a78863          	beq	a5,s10,73e <vprintf+0xf2>
      } else if(c == 'p') {
 6d2:	09b78463          	beq	a5,s11,75a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6d6:	07300713          	li	a4,115
 6da:	0ce78663          	beq	a5,a4,7a6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6de:	06300713          	li	a4,99
 6e2:	0ee78e63          	beq	a5,a4,7de <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6e6:	11478863          	beq	a5,s4,7f6 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6ea:	85d2                	mv	a1,s4
 6ec:	8556                	mv	a0,s5
 6ee:	00000097          	auipc	ra,0x0
 6f2:	e92080e7          	jalr	-366(ra) # 580 <putc>
        putc(fd, c);
 6f6:	85ca                	mv	a1,s2
 6f8:	8556                	mv	a0,s5
 6fa:	00000097          	auipc	ra,0x0
 6fe:	e86080e7          	jalr	-378(ra) # 580 <putc>
      }
      state = 0;
 702:	4981                	li	s3,0
 704:	b765                	j	6ac <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 706:	008b0913          	addi	s2,s6,8
 70a:	4685                	li	a3,1
 70c:	4629                	li	a2,10
 70e:	000b2583          	lw	a1,0(s6)
 712:	8556                	mv	a0,s5
 714:	00000097          	auipc	ra,0x0
 718:	e8e080e7          	jalr	-370(ra) # 5a2 <printint>
 71c:	8b4a                	mv	s6,s2
      state = 0;
 71e:	4981                	li	s3,0
 720:	b771                	j	6ac <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 722:	008b0913          	addi	s2,s6,8
 726:	4681                	li	a3,0
 728:	4629                	li	a2,10
 72a:	000b2583          	lw	a1,0(s6)
 72e:	8556                	mv	a0,s5
 730:	00000097          	auipc	ra,0x0
 734:	e72080e7          	jalr	-398(ra) # 5a2 <printint>
 738:	8b4a                	mv	s6,s2
      state = 0;
 73a:	4981                	li	s3,0
 73c:	bf85                	j	6ac <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 73e:	008b0913          	addi	s2,s6,8
 742:	4681                	li	a3,0
 744:	4641                	li	a2,16
 746:	000b2583          	lw	a1,0(s6)
 74a:	8556                	mv	a0,s5
 74c:	00000097          	auipc	ra,0x0
 750:	e56080e7          	jalr	-426(ra) # 5a2 <printint>
 754:	8b4a                	mv	s6,s2
      state = 0;
 756:	4981                	li	s3,0
 758:	bf91                	j	6ac <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 75a:	008b0793          	addi	a5,s6,8
 75e:	f8f43423          	sd	a5,-120(s0)
 762:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 766:	03000593          	li	a1,48
 76a:	8556                	mv	a0,s5
 76c:	00000097          	auipc	ra,0x0
 770:	e14080e7          	jalr	-492(ra) # 580 <putc>
  putc(fd, 'x');
 774:	85ea                	mv	a1,s10
 776:	8556                	mv	a0,s5
 778:	00000097          	auipc	ra,0x0
 77c:	e08080e7          	jalr	-504(ra) # 580 <putc>
 780:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 782:	03c9d793          	srli	a5,s3,0x3c
 786:	97de                	add	a5,a5,s7
 788:	0007c583          	lbu	a1,0(a5)
 78c:	8556                	mv	a0,s5
 78e:	00000097          	auipc	ra,0x0
 792:	df2080e7          	jalr	-526(ra) # 580 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 796:	0992                	slli	s3,s3,0x4
 798:	397d                	addiw	s2,s2,-1
 79a:	fe0914e3          	bnez	s2,782 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 79e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	b721                	j	6ac <vprintf+0x60>
        s = va_arg(ap, char*);
 7a6:	008b0993          	addi	s3,s6,8
 7aa:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7ae:	02090163          	beqz	s2,7d0 <vprintf+0x184>
        while(*s != 0){
 7b2:	00094583          	lbu	a1,0(s2)
 7b6:	c9a1                	beqz	a1,806 <vprintf+0x1ba>
          putc(fd, *s);
 7b8:	8556                	mv	a0,s5
 7ba:	00000097          	auipc	ra,0x0
 7be:	dc6080e7          	jalr	-570(ra) # 580 <putc>
          s++;
 7c2:	0905                	addi	s2,s2,1
        while(*s != 0){
 7c4:	00094583          	lbu	a1,0(s2)
 7c8:	f9e5                	bnez	a1,7b8 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7ca:	8b4e                	mv	s6,s3
      state = 0;
 7cc:	4981                	li	s3,0
 7ce:	bdf9                	j	6ac <vprintf+0x60>
          s = "(null)";
 7d0:	00000917          	auipc	s2,0x0
 7d4:	2d090913          	addi	s2,s2,720 # aa0 <malloc+0x18a>
        while(*s != 0){
 7d8:	02800593          	li	a1,40
 7dc:	bff1                	j	7b8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7de:	008b0913          	addi	s2,s6,8
 7e2:	000b4583          	lbu	a1,0(s6)
 7e6:	8556                	mv	a0,s5
 7e8:	00000097          	auipc	ra,0x0
 7ec:	d98080e7          	jalr	-616(ra) # 580 <putc>
 7f0:	8b4a                	mv	s6,s2
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	bd65                	j	6ac <vprintf+0x60>
        putc(fd, c);
 7f6:	85d2                	mv	a1,s4
 7f8:	8556                	mv	a0,s5
 7fa:	00000097          	auipc	ra,0x0
 7fe:	d86080e7          	jalr	-634(ra) # 580 <putc>
      state = 0;
 802:	4981                	li	s3,0
 804:	b565                	j	6ac <vprintf+0x60>
        s = va_arg(ap, char*);
 806:	8b4e                	mv	s6,s3
      state = 0;
 808:	4981                	li	s3,0
 80a:	b54d                	j	6ac <vprintf+0x60>
    }
  }
}
 80c:	70e6                	ld	ra,120(sp)
 80e:	7446                	ld	s0,112(sp)
 810:	74a6                	ld	s1,104(sp)
 812:	7906                	ld	s2,96(sp)
 814:	69e6                	ld	s3,88(sp)
 816:	6a46                	ld	s4,80(sp)
 818:	6aa6                	ld	s5,72(sp)
 81a:	6b06                	ld	s6,64(sp)
 81c:	7be2                	ld	s7,56(sp)
 81e:	7c42                	ld	s8,48(sp)
 820:	7ca2                	ld	s9,40(sp)
 822:	7d02                	ld	s10,32(sp)
 824:	6de2                	ld	s11,24(sp)
 826:	6109                	addi	sp,sp,128
 828:	8082                	ret

000000000000082a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 82a:	715d                	addi	sp,sp,-80
 82c:	ec06                	sd	ra,24(sp)
 82e:	e822                	sd	s0,16(sp)
 830:	1000                	addi	s0,sp,32
 832:	e010                	sd	a2,0(s0)
 834:	e414                	sd	a3,8(s0)
 836:	e818                	sd	a4,16(s0)
 838:	ec1c                	sd	a5,24(s0)
 83a:	03043023          	sd	a6,32(s0)
 83e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 842:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 846:	8622                	mv	a2,s0
 848:	00000097          	auipc	ra,0x0
 84c:	e04080e7          	jalr	-508(ra) # 64c <vprintf>
}
 850:	60e2                	ld	ra,24(sp)
 852:	6442                	ld	s0,16(sp)
 854:	6161                	addi	sp,sp,80
 856:	8082                	ret

0000000000000858 <printf>:

void
printf(const char *fmt, ...)
{
 858:	711d                	addi	sp,sp,-96
 85a:	ec06                	sd	ra,24(sp)
 85c:	e822                	sd	s0,16(sp)
 85e:	1000                	addi	s0,sp,32
 860:	e40c                	sd	a1,8(s0)
 862:	e810                	sd	a2,16(s0)
 864:	ec14                	sd	a3,24(s0)
 866:	f018                	sd	a4,32(s0)
 868:	f41c                	sd	a5,40(s0)
 86a:	03043823          	sd	a6,48(s0)
 86e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 872:	00840613          	addi	a2,s0,8
 876:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 87a:	85aa                	mv	a1,a0
 87c:	4505                	li	a0,1
 87e:	00000097          	auipc	ra,0x0
 882:	dce080e7          	jalr	-562(ra) # 64c <vprintf>
}
 886:	60e2                	ld	ra,24(sp)
 888:	6442                	ld	s0,16(sp)
 88a:	6125                	addi	sp,sp,96
 88c:	8082                	ret

000000000000088e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 88e:	1141                	addi	sp,sp,-16
 890:	e422                	sd	s0,8(sp)
 892:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 894:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 898:	00000797          	auipc	a5,0x0
 89c:	2287b783          	ld	a5,552(a5) # ac0 <freep>
 8a0:	a805                	j	8d0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8a2:	4618                	lw	a4,8(a2)
 8a4:	9db9                	addw	a1,a1,a4
 8a6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8aa:	6398                	ld	a4,0(a5)
 8ac:	6318                	ld	a4,0(a4)
 8ae:	fee53823          	sd	a4,-16(a0)
 8b2:	a091                	j	8f6 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8b4:	ff852703          	lw	a4,-8(a0)
 8b8:	9e39                	addw	a2,a2,a4
 8ba:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8bc:	ff053703          	ld	a4,-16(a0)
 8c0:	e398                	sd	a4,0(a5)
 8c2:	a099                	j	908 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c4:	6398                	ld	a4,0(a5)
 8c6:	00e7e463          	bltu	a5,a4,8ce <free+0x40>
 8ca:	00e6ea63          	bltu	a3,a4,8de <free+0x50>
{
 8ce:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d0:	fed7fae3          	bgeu	a5,a3,8c4 <free+0x36>
 8d4:	6398                	ld	a4,0(a5)
 8d6:	00e6e463          	bltu	a3,a4,8de <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8da:	fee7eae3          	bltu	a5,a4,8ce <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8de:	ff852583          	lw	a1,-8(a0)
 8e2:	6390                	ld	a2,0(a5)
 8e4:	02059713          	slli	a4,a1,0x20
 8e8:	9301                	srli	a4,a4,0x20
 8ea:	0712                	slli	a4,a4,0x4
 8ec:	9736                	add	a4,a4,a3
 8ee:	fae60ae3          	beq	a2,a4,8a2 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8f2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8f6:	4790                	lw	a2,8(a5)
 8f8:	02061713          	slli	a4,a2,0x20
 8fc:	9301                	srli	a4,a4,0x20
 8fe:	0712                	slli	a4,a4,0x4
 900:	973e                	add	a4,a4,a5
 902:	fae689e3          	beq	a3,a4,8b4 <free+0x26>
  } else
    p->s.ptr = bp;
 906:	e394                	sd	a3,0(a5)
  freep = p;
 908:	00000717          	auipc	a4,0x0
 90c:	1af73c23          	sd	a5,440(a4) # ac0 <freep>
}
 910:	6422                	ld	s0,8(sp)
 912:	0141                	addi	sp,sp,16
 914:	8082                	ret

0000000000000916 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 916:	7139                	addi	sp,sp,-64
 918:	fc06                	sd	ra,56(sp)
 91a:	f822                	sd	s0,48(sp)
 91c:	f426                	sd	s1,40(sp)
 91e:	f04a                	sd	s2,32(sp)
 920:	ec4e                	sd	s3,24(sp)
 922:	e852                	sd	s4,16(sp)
 924:	e456                	sd	s5,8(sp)
 926:	e05a                	sd	s6,0(sp)
 928:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 92a:	02051493          	slli	s1,a0,0x20
 92e:	9081                	srli	s1,s1,0x20
 930:	04bd                	addi	s1,s1,15
 932:	8091                	srli	s1,s1,0x4
 934:	0014899b          	addiw	s3,s1,1
 938:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 93a:	00000517          	auipc	a0,0x0
 93e:	18653503          	ld	a0,390(a0) # ac0 <freep>
 942:	c515                	beqz	a0,96e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 944:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 946:	4798                	lw	a4,8(a5)
 948:	02977f63          	bgeu	a4,s1,986 <malloc+0x70>
 94c:	8a4e                	mv	s4,s3
 94e:	0009871b          	sext.w	a4,s3
 952:	6685                	lui	a3,0x1
 954:	00d77363          	bgeu	a4,a3,95a <malloc+0x44>
 958:	6a05                	lui	s4,0x1
 95a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 95e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 962:	00000917          	auipc	s2,0x0
 966:	15e90913          	addi	s2,s2,350 # ac0 <freep>
  if(p == (char*)-1)
 96a:	5afd                	li	s5,-1
 96c:	a88d                	j	9de <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 96e:	00000797          	auipc	a5,0x0
 972:	15a78793          	addi	a5,a5,346 # ac8 <base>
 976:	00000717          	auipc	a4,0x0
 97a:	14f73523          	sd	a5,330(a4) # ac0 <freep>
 97e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 980:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 984:	b7e1                	j	94c <malloc+0x36>
      if(p->s.size == nunits)
 986:	02e48b63          	beq	s1,a4,9bc <malloc+0xa6>
        p->s.size -= nunits;
 98a:	4137073b          	subw	a4,a4,s3
 98e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 990:	1702                	slli	a4,a4,0x20
 992:	9301                	srli	a4,a4,0x20
 994:	0712                	slli	a4,a4,0x4
 996:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 998:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 99c:	00000717          	auipc	a4,0x0
 9a0:	12a73223          	sd	a0,292(a4) # ac0 <freep>
      return (void*)(p + 1);
 9a4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9a8:	70e2                	ld	ra,56(sp)
 9aa:	7442                	ld	s0,48(sp)
 9ac:	74a2                	ld	s1,40(sp)
 9ae:	7902                	ld	s2,32(sp)
 9b0:	69e2                	ld	s3,24(sp)
 9b2:	6a42                	ld	s4,16(sp)
 9b4:	6aa2                	ld	s5,8(sp)
 9b6:	6b02                	ld	s6,0(sp)
 9b8:	6121                	addi	sp,sp,64
 9ba:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9bc:	6398                	ld	a4,0(a5)
 9be:	e118                	sd	a4,0(a0)
 9c0:	bff1                	j	99c <malloc+0x86>
  hp->s.size = nu;
 9c2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9c6:	0541                	addi	a0,a0,16
 9c8:	00000097          	auipc	ra,0x0
 9cc:	ec6080e7          	jalr	-314(ra) # 88e <free>
  return freep;
 9d0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9d4:	d971                	beqz	a0,9a8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d8:	4798                	lw	a4,8(a5)
 9da:	fa9776e3          	bgeu	a4,s1,986 <malloc+0x70>
    if(p == freep)
 9de:	00093703          	ld	a4,0(s2)
 9e2:	853e                	mv	a0,a5
 9e4:	fef719e3          	bne	a4,a5,9d6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9e8:	8552                	mv	a0,s4
 9ea:	00000097          	auipc	ra,0x0
 9ee:	b7e080e7          	jalr	-1154(ra) # 568 <sbrk>
  if(p == (char*)-1)
 9f2:	fd5518e3          	bne	a0,s5,9c2 <malloc+0xac>
        return 0;
 9f6:	4501                	li	a0,0
 9f8:	bf45                	j	9a8 <malloc+0x92>
