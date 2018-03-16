
_shm_cnt:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
   struct uspinlock lock;
   int cnt;
};

int main(int argc, char *argv[])
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	57                   	push   %edi
//which we can now use but will be shared between the two processes
  
shm_open(1,(char **)&counter);
printf(1,"hi"); 
 // printf(1,"%s returned successfully from shm_open with counter %x\n", pid? "Child": "Parent", counter); 
  for(i = 0; i < 10000; i++)
    1004:	31 ff                	xor    %edi,%edi
   struct uspinlock lock;
   int cnt;
};

int main(int argc, char *argv[])
{
    1006:	56                   	push   %esi
    1007:	53                   	push   %ebx
     uacquire(&(counter->lock));
     counter->cnt++;
     urelease(&(counter->lock));
printf(1,"%d \n", i);
//print something because we are curious and to give a chance to switch process
     if(i%1000 == 0)
    1008:	bb d3 4d 62 10       	mov    $0x10624dd3,%ebx
   struct uspinlock lock;
   int cnt;
};

int main(int argc, char *argv[])
{
    100d:	83 e4 f0             	and    $0xfffffff0,%esp
    1010:	83 ec 30             	sub    $0x30,%esp
int pid;
int i=0;
struct shm_cnt *counter;
  pid=fork();
    1013:	e8 52 03 00 00       	call   136a <fork>
  sleep(1);
    1018:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
int main(int argc, char *argv[])
{
int pid;
int i=0;
struct shm_cnt *counter;
  pid=fork();
    101f:	89 c6                	mov    %eax,%esi
  sleep(1);
    1021:	e8 dc 03 00 00       	call   1402 <sleep>

//shm_open: first process will create the page, the second will just attach to the same page
//we get the virtual address of the page returned into counter
//which we can now use but will be shared between the two processes
  
shm_open(1,(char **)&counter);
    1026:	8d 44 24 2c          	lea    0x2c(%esp),%eax
    102a:	89 44 24 04          	mov    %eax,0x4(%esp)
    102e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1035:	e8 d8 03 00 00       	call   1412 <shm_open>
printf(1,"hi"); 
    103a:	c7 44 24 04 81 18 00 	movl   $0x1881,0x4(%esp)
    1041:	00 
    1042:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1049:	e8 82 04 00 00       	call   14d0 <printf>
    104e:	66 90                	xchg   %ax,%ax
 // printf(1,"%s returned successfully from shm_open with counter %x\n", pid? "Child": "Parent", counter); 
  for(i = 0; i < 10000; i++)
    {
     uacquire(&(counter->lock));
    1050:	8b 44 24 2c          	mov    0x2c(%esp),%eax
    1054:	89 04 24             	mov    %eax,(%esp)
    1057:	e8 e4 07 00 00       	call   1840 <uacquire>
     counter->cnt++;
    105c:	8b 44 24 2c          	mov    0x2c(%esp),%eax
    1060:	83 40 04 01          	addl   $0x1,0x4(%eax)
     urelease(&(counter->lock));
    1064:	89 04 24             	mov    %eax,(%esp)
    1067:	e8 f4 07 00 00       	call   1860 <urelease>
printf(1,"%d \n", i);
    106c:	89 7c 24 08          	mov    %edi,0x8(%esp)
    1070:	c7 44 24 04 84 18 00 	movl   $0x1884,0x4(%esp)
    1077:	00 
    1078:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    107f:	e8 4c 04 00 00       	call   14d0 <printf>
//print something because we are curious and to give a chance to switch process
     if(i%1000 == 0)
    1084:	89 f8                	mov    %edi,%eax
    1086:	f7 eb                	imul   %ebx
    1088:	89 f8                	mov    %edi,%eax
    108a:	c1 f8 1f             	sar    $0x1f,%eax
    108d:	c1 fa 06             	sar    $0x6,%edx
    1090:	29 c2                	sub    %eax,%edx
    1092:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    1098:	39 d7                	cmp    %edx,%edi
    109a:	75 3e                	jne    10da <main+0xda>
       printf(1,"Counter in %s is %d at address %x\n",pid? "Parent" : "Child", counter->cnt, counter);
    109c:	8b 54 24 2c          	mov    0x2c(%esp),%edx
    10a0:	b8 7b 18 00 00       	mov    $0x187b,%eax
    10a5:	85 f6                	test   %esi,%esi
    10a7:	8b 4a 04             	mov    0x4(%edx),%ecx
    10aa:	89 54 24 10          	mov    %edx,0x10(%esp)
    10ae:	c7 44 24 04 c4 18 00 	movl   $0x18c4,0x4(%esp)
    10b5:	00 
    10b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10bd:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
    10c1:	b9 74 18 00 00       	mov    $0x1874,%ecx
    10c6:	0f 45 c1             	cmovne %ecx,%eax
    10c9:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
    10cd:	89 44 24 08          	mov    %eax,0x8(%esp)
    10d1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    10d5:	e8 f6 03 00 00       	call   14d0 <printf>
//which we can now use but will be shared between the two processes
  
shm_open(1,(char **)&counter);
printf(1,"hi"); 
 // printf(1,"%s returned successfully from shm_open with counter %x\n", pid? "Child": "Parent", counter); 
  for(i = 0; i < 10000; i++)
    10da:	83 c7 01             	add    $0x1,%edi
    10dd:	81 ff 10 27 00 00    	cmp    $0x2710,%edi
    10e3:	0f 85 67 ff ff ff    	jne    1050 <main+0x50>
printf(1,"%d \n", i);
//print something because we are curious and to give a chance to switch process
     if(i%1000 == 0)
       printf(1,"Counter in %s is %d at address %x\n",pid? "Parent" : "Child", counter->cnt, counter);
}
printf(1,"part2");  
    10e9:	c7 44 24 04 89 18 00 	movl   $0x1889,0x4(%esp)
    10f0:	00 
    10f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10f8:	e8 d3 03 00 00       	call   14d0 <printf>
  if(pid)
     {
       printf(1,"Counter in parent is %d\n",counter->cnt);
    10fd:	8b 44 24 2c          	mov    0x2c(%esp),%eax
//print something because we are curious and to give a chance to switch process
     if(i%1000 == 0)
       printf(1,"Counter in %s is %d at address %x\n",pid? "Parent" : "Child", counter->cnt, counter);
}
printf(1,"part2");  
  if(pid)
    1101:	85 f6                	test   %esi,%esi
     {
       printf(1,"Counter in parent is %d\n",counter->cnt);
    1103:	8b 40 04             	mov    0x4(%eax),%eax
    1106:	89 44 24 08          	mov    %eax,0x8(%esp)
//print something because we are curious and to give a chance to switch process
     if(i%1000 == 0)
       printf(1,"Counter in %s is %d at address %x\n",pid? "Parent" : "Child", counter->cnt, counter);
}
printf(1,"part2");  
  if(pid)
    110a:	74 2a                	je     1136 <main+0x136>
     {
       printf(1,"Counter in parent is %d\n",counter->cnt);
    110c:	c7 44 24 04 8f 18 00 	movl   $0x188f,0x4(%esp)
    1113:	00 
    1114:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    111b:	e8 b0 03 00 00       	call   14d0 <printf>
    wait();
    1120:	e8 55 02 00 00       	call   137a <wait>
    } else
    printf(1,"Counter in child is %d\n\n",counter->cnt);

//shm_close: first process will just detach, next one will free up the shm_table entry (but for now not the page)
   shm_close(1);
    1125:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    112c:	e8 e9 02 00 00       	call   141a <shm_close>
   exit();
    1131:	e8 3c 02 00 00       	call   1372 <exit>
  if(pid)
     {
       printf(1,"Counter in parent is %d\n",counter->cnt);
    wait();
    } else
    printf(1,"Counter in child is %d\n\n",counter->cnt);
    1136:	c7 44 24 04 a8 18 00 	movl   $0x18a8,0x4(%esp)
    113d:	00 
    113e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1145:	e8 86 03 00 00       	call   14d0 <printf>
    114a:	eb d9                	jmp    1125 <main+0x125>
    114c:	66 90                	xchg   %ax,%ax
    114e:	66 90                	xchg   %ax,%ax

00001150 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1150:	55                   	push   %ebp
    1151:	89 e5                	mov    %esp,%ebp
    1153:	8b 45 08             	mov    0x8(%ebp),%eax
    1156:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1159:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    115a:	89 c2                	mov    %eax,%edx
    115c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1160:	83 c1 01             	add    $0x1,%ecx
    1163:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    1167:	83 c2 01             	add    $0x1,%edx
    116a:	84 db                	test   %bl,%bl
    116c:	88 5a ff             	mov    %bl,-0x1(%edx)
    116f:	75 ef                	jne    1160 <strcpy+0x10>
    ;
  return os;
}
    1171:	5b                   	pop    %ebx
    1172:	5d                   	pop    %ebp
    1173:	c3                   	ret    
    1174:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    117a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001180 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1180:	55                   	push   %ebp
    1181:	89 e5                	mov    %esp,%ebp
    1183:	8b 55 08             	mov    0x8(%ebp),%edx
    1186:	53                   	push   %ebx
    1187:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    118a:	0f b6 02             	movzbl (%edx),%eax
    118d:	84 c0                	test   %al,%al
    118f:	74 2d                	je     11be <strcmp+0x3e>
    1191:	0f b6 19             	movzbl (%ecx),%ebx
    1194:	38 d8                	cmp    %bl,%al
    1196:	74 0e                	je     11a6 <strcmp+0x26>
    1198:	eb 2b                	jmp    11c5 <strcmp+0x45>
    119a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    11a0:	38 c8                	cmp    %cl,%al
    11a2:	75 15                	jne    11b9 <strcmp+0x39>
    p++, q++;
    11a4:	89 d9                	mov    %ebx,%ecx
    11a6:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    11a9:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
    11ac:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    11af:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
    11b3:	84 c0                	test   %al,%al
    11b5:	75 e9                	jne    11a0 <strcmp+0x20>
    11b7:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
    11b9:	29 c8                	sub    %ecx,%eax
}
    11bb:	5b                   	pop    %ebx
    11bc:	5d                   	pop    %ebp
    11bd:	c3                   	ret    
    11be:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    11c1:	31 c0                	xor    %eax,%eax
    11c3:	eb f4                	jmp    11b9 <strcmp+0x39>
    11c5:	0f b6 cb             	movzbl %bl,%ecx
    11c8:	eb ef                	jmp    11b9 <strcmp+0x39>
    11ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000011d0 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
    11d0:	55                   	push   %ebp
    11d1:	89 e5                	mov    %esp,%ebp
    11d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    11d6:	80 39 00             	cmpb   $0x0,(%ecx)
    11d9:	74 12                	je     11ed <strlen+0x1d>
    11db:	31 d2                	xor    %edx,%edx
    11dd:	8d 76 00             	lea    0x0(%esi),%esi
    11e0:	83 c2 01             	add    $0x1,%edx
    11e3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    11e7:	89 d0                	mov    %edx,%eax
    11e9:	75 f5                	jne    11e0 <strlen+0x10>
    ;
  return n;
}
    11eb:	5d                   	pop    %ebp
    11ec:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
    11ed:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
    11ef:	5d                   	pop    %ebp
    11f0:	c3                   	ret    
    11f1:	eb 0d                	jmp    1200 <memset>
    11f3:	90                   	nop
    11f4:	90                   	nop
    11f5:	90                   	nop
    11f6:	90                   	nop
    11f7:	90                   	nop
    11f8:	90                   	nop
    11f9:	90                   	nop
    11fa:	90                   	nop
    11fb:	90                   	nop
    11fc:	90                   	nop
    11fd:	90                   	nop
    11fe:	90                   	nop
    11ff:	90                   	nop

00001200 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1200:	55                   	push   %ebp
    1201:	89 e5                	mov    %esp,%ebp
    1203:	8b 55 08             	mov    0x8(%ebp),%edx
    1206:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1207:	8b 4d 10             	mov    0x10(%ebp),%ecx
    120a:	8b 45 0c             	mov    0xc(%ebp),%eax
    120d:	89 d7                	mov    %edx,%edi
    120f:	fc                   	cld    
    1210:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1212:	89 d0                	mov    %edx,%eax
    1214:	5f                   	pop    %edi
    1215:	5d                   	pop    %ebp
    1216:	c3                   	ret    
    1217:	89 f6                	mov    %esi,%esi
    1219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001220 <strchr>:

char*
strchr(const char *s, char c)
{
    1220:	55                   	push   %ebp
    1221:	89 e5                	mov    %esp,%ebp
    1223:	8b 45 08             	mov    0x8(%ebp),%eax
    1226:	53                   	push   %ebx
    1227:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
    122a:	0f b6 18             	movzbl (%eax),%ebx
    122d:	84 db                	test   %bl,%bl
    122f:	74 1d                	je     124e <strchr+0x2e>
    if(*s == c)
    1231:	38 d3                	cmp    %dl,%bl
    1233:	89 d1                	mov    %edx,%ecx
    1235:	75 0d                	jne    1244 <strchr+0x24>
    1237:	eb 17                	jmp    1250 <strchr+0x30>
    1239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1240:	38 ca                	cmp    %cl,%dl
    1242:	74 0c                	je     1250 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1244:	83 c0 01             	add    $0x1,%eax
    1247:	0f b6 10             	movzbl (%eax),%edx
    124a:	84 d2                	test   %dl,%dl
    124c:	75 f2                	jne    1240 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
    124e:	31 c0                	xor    %eax,%eax
}
    1250:	5b                   	pop    %ebx
    1251:	5d                   	pop    %ebp
    1252:	c3                   	ret    
    1253:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001260 <gets>:

char*
gets(char *buf, int max)
{
    1260:	55                   	push   %ebp
    1261:	89 e5                	mov    %esp,%ebp
    1263:	57                   	push   %edi
    1264:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1265:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
    1267:	53                   	push   %ebx
    1268:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    126b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    126e:	eb 31                	jmp    12a1 <gets+0x41>
    cc = read(0, &c, 1);
    1270:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1277:	00 
    1278:	89 7c 24 04          	mov    %edi,0x4(%esp)
    127c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1283:	e8 02 01 00 00       	call   138a <read>
    if(cc < 1)
    1288:	85 c0                	test   %eax,%eax
    128a:	7e 1d                	jle    12a9 <gets+0x49>
      break;
    buf[i++] = c;
    128c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1290:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    1292:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
    1295:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    1297:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
    129b:	74 0c                	je     12a9 <gets+0x49>
    129d:	3c 0a                	cmp    $0xa,%al
    129f:	74 08                	je     12a9 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    12a1:	8d 5e 01             	lea    0x1(%esi),%ebx
    12a4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    12a7:	7c c7                	jl     1270 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    12a9:	8b 45 08             	mov    0x8(%ebp),%eax
    12ac:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    12b0:	83 c4 2c             	add    $0x2c,%esp
    12b3:	5b                   	pop    %ebx
    12b4:	5e                   	pop    %esi
    12b5:	5f                   	pop    %edi
    12b6:	5d                   	pop    %ebp
    12b7:	c3                   	ret    
    12b8:	90                   	nop
    12b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000012c0 <stat>:

int
stat(char *n, struct stat *st)
{
    12c0:	55                   	push   %ebp
    12c1:	89 e5                	mov    %esp,%ebp
    12c3:	56                   	push   %esi
    12c4:	53                   	push   %ebx
    12c5:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12c8:	8b 45 08             	mov    0x8(%ebp),%eax
    12cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    12d2:	00 
    12d3:	89 04 24             	mov    %eax,(%esp)
    12d6:	e8 d7 00 00 00       	call   13b2 <open>
  if(fd < 0)
    12db:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12dd:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
    12df:	78 27                	js     1308 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    12e1:	8b 45 0c             	mov    0xc(%ebp),%eax
    12e4:	89 1c 24             	mov    %ebx,(%esp)
    12e7:	89 44 24 04          	mov    %eax,0x4(%esp)
    12eb:	e8 da 00 00 00       	call   13ca <fstat>
  close(fd);
    12f0:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
    12f3:	89 c6                	mov    %eax,%esi
  close(fd);
    12f5:	e8 a0 00 00 00       	call   139a <close>
  return r;
    12fa:	89 f0                	mov    %esi,%eax
}
    12fc:	83 c4 10             	add    $0x10,%esp
    12ff:	5b                   	pop    %ebx
    1300:	5e                   	pop    %esi
    1301:	5d                   	pop    %ebp
    1302:	c3                   	ret    
    1303:	90                   	nop
    1304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
    1308:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    130d:	eb ed                	jmp    12fc <stat+0x3c>
    130f:	90                   	nop

00001310 <atoi>:
  return r;
}

int
atoi(const char *s)
{
    1310:	55                   	push   %ebp
    1311:	89 e5                	mov    %esp,%ebp
    1313:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1316:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1317:	0f be 11             	movsbl (%ecx),%edx
    131a:	8d 42 d0             	lea    -0x30(%edx),%eax
    131d:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
    131f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    1324:	77 17                	ja     133d <atoi+0x2d>
    1326:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
    1328:	83 c1 01             	add    $0x1,%ecx
    132b:	8d 04 80             	lea    (%eax,%eax,4),%eax
    132e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1332:	0f be 11             	movsbl (%ecx),%edx
    1335:	8d 5a d0             	lea    -0x30(%edx),%ebx
    1338:	80 fb 09             	cmp    $0x9,%bl
    133b:	76 eb                	jbe    1328 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
    133d:	5b                   	pop    %ebx
    133e:	5d                   	pop    %ebp
    133f:	c3                   	ret    

00001340 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1340:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1341:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
    1343:	89 e5                	mov    %esp,%ebp
    1345:	56                   	push   %esi
    1346:	8b 45 08             	mov    0x8(%ebp),%eax
    1349:	53                   	push   %ebx
    134a:	8b 5d 10             	mov    0x10(%ebp),%ebx
    134d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1350:	85 db                	test   %ebx,%ebx
    1352:	7e 12                	jle    1366 <memmove+0x26>
    1354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
    1358:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    135c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    135f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1362:	39 da                	cmp    %ebx,%edx
    1364:	75 f2                	jne    1358 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
    1366:	5b                   	pop    %ebx
    1367:	5e                   	pop    %esi
    1368:	5d                   	pop    %ebp
    1369:	c3                   	ret    

0000136a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    136a:	b8 01 00 00 00       	mov    $0x1,%eax
    136f:	cd 40                	int    $0x40
    1371:	c3                   	ret    

00001372 <exit>:
SYSCALL(exit)
    1372:	b8 02 00 00 00       	mov    $0x2,%eax
    1377:	cd 40                	int    $0x40
    1379:	c3                   	ret    

0000137a <wait>:
SYSCALL(wait)
    137a:	b8 03 00 00 00       	mov    $0x3,%eax
    137f:	cd 40                	int    $0x40
    1381:	c3                   	ret    

00001382 <pipe>:
SYSCALL(pipe)
    1382:	b8 04 00 00 00       	mov    $0x4,%eax
    1387:	cd 40                	int    $0x40
    1389:	c3                   	ret    

0000138a <read>:
SYSCALL(read)
    138a:	b8 05 00 00 00       	mov    $0x5,%eax
    138f:	cd 40                	int    $0x40
    1391:	c3                   	ret    

00001392 <write>:
SYSCALL(write)
    1392:	b8 10 00 00 00       	mov    $0x10,%eax
    1397:	cd 40                	int    $0x40
    1399:	c3                   	ret    

0000139a <close>:
SYSCALL(close)
    139a:	b8 15 00 00 00       	mov    $0x15,%eax
    139f:	cd 40                	int    $0x40
    13a1:	c3                   	ret    

000013a2 <kill>:
SYSCALL(kill)
    13a2:	b8 06 00 00 00       	mov    $0x6,%eax
    13a7:	cd 40                	int    $0x40
    13a9:	c3                   	ret    

000013aa <exec>:
SYSCALL(exec)
    13aa:	b8 07 00 00 00       	mov    $0x7,%eax
    13af:	cd 40                	int    $0x40
    13b1:	c3                   	ret    

000013b2 <open>:
SYSCALL(open)
    13b2:	b8 0f 00 00 00       	mov    $0xf,%eax
    13b7:	cd 40                	int    $0x40
    13b9:	c3                   	ret    

000013ba <mknod>:
SYSCALL(mknod)
    13ba:	b8 11 00 00 00       	mov    $0x11,%eax
    13bf:	cd 40                	int    $0x40
    13c1:	c3                   	ret    

000013c2 <unlink>:
SYSCALL(unlink)
    13c2:	b8 12 00 00 00       	mov    $0x12,%eax
    13c7:	cd 40                	int    $0x40
    13c9:	c3                   	ret    

000013ca <fstat>:
SYSCALL(fstat)
    13ca:	b8 08 00 00 00       	mov    $0x8,%eax
    13cf:	cd 40                	int    $0x40
    13d1:	c3                   	ret    

000013d2 <link>:
SYSCALL(link)
    13d2:	b8 13 00 00 00       	mov    $0x13,%eax
    13d7:	cd 40                	int    $0x40
    13d9:	c3                   	ret    

000013da <mkdir>:
SYSCALL(mkdir)
    13da:	b8 14 00 00 00       	mov    $0x14,%eax
    13df:	cd 40                	int    $0x40
    13e1:	c3                   	ret    

000013e2 <chdir>:
SYSCALL(chdir)
    13e2:	b8 09 00 00 00       	mov    $0x9,%eax
    13e7:	cd 40                	int    $0x40
    13e9:	c3                   	ret    

000013ea <dup>:
SYSCALL(dup)
    13ea:	b8 0a 00 00 00       	mov    $0xa,%eax
    13ef:	cd 40                	int    $0x40
    13f1:	c3                   	ret    

000013f2 <getpid>:
SYSCALL(getpid)
    13f2:	b8 0b 00 00 00       	mov    $0xb,%eax
    13f7:	cd 40                	int    $0x40
    13f9:	c3                   	ret    

000013fa <sbrk>:
SYSCALL(sbrk)
    13fa:	b8 0c 00 00 00       	mov    $0xc,%eax
    13ff:	cd 40                	int    $0x40
    1401:	c3                   	ret    

00001402 <sleep>:
SYSCALL(sleep)
    1402:	b8 0d 00 00 00       	mov    $0xd,%eax
    1407:	cd 40                	int    $0x40
    1409:	c3                   	ret    

0000140a <uptime>:
SYSCALL(uptime)
    140a:	b8 0e 00 00 00       	mov    $0xe,%eax
    140f:	cd 40                	int    $0x40
    1411:	c3                   	ret    

00001412 <shm_open>:
SYSCALL(shm_open)
    1412:	b8 16 00 00 00       	mov    $0x16,%eax
    1417:	cd 40                	int    $0x40
    1419:	c3                   	ret    

0000141a <shm_close>:
SYSCALL(shm_close)	
    141a:	b8 17 00 00 00       	mov    $0x17,%eax
    141f:	cd 40                	int    $0x40
    1421:	c3                   	ret    
    1422:	66 90                	xchg   %ax,%ax
    1424:	66 90                	xchg   %ax,%ax
    1426:	66 90                	xchg   %ax,%ax
    1428:	66 90                	xchg   %ax,%ax
    142a:	66 90                	xchg   %ax,%ax
    142c:	66 90                	xchg   %ax,%ax
    142e:	66 90                	xchg   %ax,%ax

00001430 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1430:	55                   	push   %ebp
    1431:	89 e5                	mov    %esp,%ebp
    1433:	57                   	push   %edi
    1434:	56                   	push   %esi
    1435:	89 c6                	mov    %eax,%esi
    1437:	53                   	push   %ebx
    1438:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    143b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    143e:	85 db                	test   %ebx,%ebx
    1440:	74 09                	je     144b <printint+0x1b>
    1442:	89 d0                	mov    %edx,%eax
    1444:	c1 e8 1f             	shr    $0x1f,%eax
    1447:	84 c0                	test   %al,%al
    1449:	75 75                	jne    14c0 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    144b:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    144d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    1454:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    1457:	31 ff                	xor    %edi,%edi
    1459:	89 ce                	mov    %ecx,%esi
    145b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    145e:	eb 02                	jmp    1462 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
    1460:	89 cf                	mov    %ecx,%edi
    1462:	31 d2                	xor    %edx,%edx
    1464:	f7 f6                	div    %esi
    1466:	8d 4f 01             	lea    0x1(%edi),%ecx
    1469:	0f b6 92 ef 18 00 00 	movzbl 0x18ef(%edx),%edx
  }while((x /= base) != 0);
    1470:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    1472:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
    1475:	75 e9                	jne    1460 <printint+0x30>
  if(neg)
    1477:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    147a:	89 c8                	mov    %ecx,%eax
    147c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
    147f:	85 d2                	test   %edx,%edx
    1481:	74 08                	je     148b <printint+0x5b>
    buf[i++] = '-';
    1483:	8d 4f 02             	lea    0x2(%edi),%ecx
    1486:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
    148b:	8d 79 ff             	lea    -0x1(%ecx),%edi
    148e:	66 90                	xchg   %ax,%ax
    1490:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
    1495:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1498:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    149f:	00 
    14a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    14a4:	89 34 24             	mov    %esi,(%esp)
    14a7:	88 45 d7             	mov    %al,-0x29(%ebp)
    14aa:	e8 e3 fe ff ff       	call   1392 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    14af:	83 ff ff             	cmp    $0xffffffff,%edi
    14b2:	75 dc                	jne    1490 <printint+0x60>
    putc(fd, buf[i]);
}
    14b4:	83 c4 4c             	add    $0x4c,%esp
    14b7:	5b                   	pop    %ebx
    14b8:	5e                   	pop    %esi
    14b9:	5f                   	pop    %edi
    14ba:	5d                   	pop    %ebp
    14bb:	c3                   	ret    
    14bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    14c0:	89 d0                	mov    %edx,%eax
    14c2:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    14c4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    14cb:	eb 87                	jmp    1454 <printint+0x24>
    14cd:	8d 76 00             	lea    0x0(%esi),%esi

000014d0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    14d0:	55                   	push   %ebp
    14d1:	89 e5                	mov    %esp,%ebp
    14d3:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    14d4:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    14d6:	56                   	push   %esi
    14d7:	53                   	push   %ebx
    14d8:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    14db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    14de:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    14e1:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    14e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
    14e7:	0f b6 13             	movzbl (%ebx),%edx
    14ea:	83 c3 01             	add    $0x1,%ebx
    14ed:	84 d2                	test   %dl,%dl
    14ef:	75 39                	jne    152a <printf+0x5a>
    14f1:	e9 c2 00 00 00       	jmp    15b8 <printf+0xe8>
    14f6:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    14f8:	83 fa 25             	cmp    $0x25,%edx
    14fb:	0f 84 bf 00 00 00    	je     15c0 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1501:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1504:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    150b:	00 
    150c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1510:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    1513:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1516:	e8 77 fe ff ff       	call   1392 <write>
    151b:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    151e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
    1522:	84 d2                	test   %dl,%dl
    1524:	0f 84 8e 00 00 00    	je     15b8 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
    152a:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    152c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
    152f:	74 c7                	je     14f8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1531:	83 ff 25             	cmp    $0x25,%edi
    1534:	75 e5                	jne    151b <printf+0x4b>
      if(c == 'd'){
    1536:	83 fa 64             	cmp    $0x64,%edx
    1539:	0f 84 31 01 00 00    	je     1670 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    153f:	25 f7 00 00 00       	and    $0xf7,%eax
    1544:	83 f8 70             	cmp    $0x70,%eax
    1547:	0f 84 83 00 00 00    	je     15d0 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    154d:	83 fa 73             	cmp    $0x73,%edx
    1550:	0f 84 a2 00 00 00    	je     15f8 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1556:	83 fa 63             	cmp    $0x63,%edx
    1559:	0f 84 35 01 00 00    	je     1694 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    155f:	83 fa 25             	cmp    $0x25,%edx
    1562:	0f 84 e0 00 00 00    	je     1648 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1568:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    156b:	83 c3 01             	add    $0x1,%ebx
    156e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1575:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1576:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1578:	89 44 24 04          	mov    %eax,0x4(%esp)
    157c:	89 34 24             	mov    %esi,(%esp)
    157f:	89 55 d0             	mov    %edx,-0x30(%ebp)
    1582:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
    1586:	e8 07 fe ff ff       	call   1392 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    158b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    158e:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1591:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1598:	00 
    1599:	89 44 24 04          	mov    %eax,0x4(%esp)
    159d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    15a0:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    15a3:	e8 ea fd ff ff       	call   1392 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    15a8:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
    15ac:	84 d2                	test   %dl,%dl
    15ae:	0f 85 76 ff ff ff    	jne    152a <printf+0x5a>
    15b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    15b8:	83 c4 3c             	add    $0x3c,%esp
    15bb:	5b                   	pop    %ebx
    15bc:	5e                   	pop    %esi
    15bd:	5f                   	pop    %edi
    15be:	5d                   	pop    %ebp
    15bf:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    15c0:	bf 25 00 00 00       	mov    $0x25,%edi
    15c5:	e9 51 ff ff ff       	jmp    151b <printf+0x4b>
    15ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    15d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    15d3:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    15d8:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    15da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    15e1:	8b 10                	mov    (%eax),%edx
    15e3:	89 f0                	mov    %esi,%eax
    15e5:	e8 46 fe ff ff       	call   1430 <printint>
        ap++;
    15ea:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    15ee:	e9 28 ff ff ff       	jmp    151b <printf+0x4b>
    15f3:	90                   	nop
    15f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
    15f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
    15fb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
    15ff:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
    1601:	b8 e8 18 00 00       	mov    $0x18e8,%eax
    1606:	85 ff                	test   %edi,%edi
    1608:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
    160b:	0f b6 07             	movzbl (%edi),%eax
    160e:	84 c0                	test   %al,%al
    1610:	74 2a                	je     163c <printf+0x16c>
    1612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1618:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    161b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
    161e:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1621:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1628:	00 
    1629:	89 44 24 04          	mov    %eax,0x4(%esp)
    162d:	89 34 24             	mov    %esi,(%esp)
    1630:	e8 5d fd ff ff       	call   1392 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1635:	0f b6 07             	movzbl (%edi),%eax
    1638:	84 c0                	test   %al,%al
    163a:	75 dc                	jne    1618 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    163c:	31 ff                	xor    %edi,%edi
    163e:	e9 d8 fe ff ff       	jmp    151b <printf+0x4b>
    1643:	90                   	nop
    1644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1648:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    164b:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    164d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1654:	00 
    1655:	89 44 24 04          	mov    %eax,0x4(%esp)
    1659:	89 34 24             	mov    %esi,(%esp)
    165c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
    1660:	e8 2d fd ff ff       	call   1392 <write>
    1665:	e9 b1 fe ff ff       	jmp    151b <printf+0x4b>
    166a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    1670:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1673:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1678:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    167b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1682:	8b 10                	mov    (%eax),%edx
    1684:	89 f0                	mov    %esi,%eax
    1686:	e8 a5 fd ff ff       	call   1430 <printint>
        ap++;
    168b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    168f:	e9 87 fe ff ff       	jmp    151b <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    1694:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1697:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    1699:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    169b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    16a2:	00 
    16a3:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    16a6:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    16a9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    16ac:	89 44 24 04          	mov    %eax,0x4(%esp)
    16b0:	e8 dd fc ff ff       	call   1392 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
    16b5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    16b9:	e9 5d fe ff ff       	jmp    151b <printf+0x4b>
    16be:	66 90                	xchg   %ax,%ax

000016c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16c0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16c1:	a1 ac 1b 00 00       	mov    0x1bac,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
    16c6:	89 e5                	mov    %esp,%ebp
    16c8:	57                   	push   %edi
    16c9:	56                   	push   %esi
    16ca:	53                   	push   %ebx
    16cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16ce:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
    16d0:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16d3:	39 d0                	cmp    %edx,%eax
    16d5:	72 11                	jb     16e8 <free+0x28>
    16d7:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16d8:	39 c8                	cmp    %ecx,%eax
    16da:	72 04                	jb     16e0 <free+0x20>
    16dc:	39 ca                	cmp    %ecx,%edx
    16de:	72 10                	jb     16f0 <free+0x30>
    16e0:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16e2:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16e4:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16e6:	73 f0                	jae    16d8 <free+0x18>
    16e8:	39 ca                	cmp    %ecx,%edx
    16ea:	72 04                	jb     16f0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16ec:	39 c8                	cmp    %ecx,%eax
    16ee:	72 f0                	jb     16e0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    16f0:	8b 73 fc             	mov    -0x4(%ebx),%esi
    16f3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
    16f6:	39 cf                	cmp    %ecx,%edi
    16f8:	74 1e                	je     1718 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    16fa:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
    16fd:	8b 48 04             	mov    0x4(%eax),%ecx
    1700:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
    1703:	39 f2                	cmp    %esi,%edx
    1705:	74 28                	je     172f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1707:	89 10                	mov    %edx,(%eax)
  freep = p;
    1709:	a3 ac 1b 00 00       	mov    %eax,0x1bac
}
    170e:	5b                   	pop    %ebx
    170f:	5e                   	pop    %esi
    1710:	5f                   	pop    %edi
    1711:	5d                   	pop    %ebp
    1712:	c3                   	ret    
    1713:	90                   	nop
    1714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1718:	03 71 04             	add    0x4(%ecx),%esi
    171b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    171e:	8b 08                	mov    (%eax),%ecx
    1720:	8b 09                	mov    (%ecx),%ecx
    1722:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1725:	8b 48 04             	mov    0x4(%eax),%ecx
    1728:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
    172b:	39 f2                	cmp    %esi,%edx
    172d:	75 d8                	jne    1707 <free+0x47>
    p->s.size += bp->s.size;
    172f:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
    1732:	a3 ac 1b 00 00       	mov    %eax,0x1bac
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1737:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    173a:	8b 53 f8             	mov    -0x8(%ebx),%edx
    173d:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
    173f:	5b                   	pop    %ebx
    1740:	5e                   	pop    %esi
    1741:	5f                   	pop    %edi
    1742:	5d                   	pop    %ebp
    1743:	c3                   	ret    
    1744:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    174a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001750 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1750:	55                   	push   %ebp
    1751:	89 e5                	mov    %esp,%ebp
    1753:	57                   	push   %edi
    1754:	56                   	push   %esi
    1755:	53                   	push   %ebx
    1756:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1759:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    175c:	8b 1d ac 1b 00 00    	mov    0x1bac,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1762:	8d 48 07             	lea    0x7(%eax),%ecx
    1765:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
    1768:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    176a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
    176d:	0f 84 9b 00 00 00    	je     180e <malloc+0xbe>
    1773:	8b 13                	mov    (%ebx),%edx
    1775:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    1778:	39 fe                	cmp    %edi,%esi
    177a:	76 64                	jbe    17e0 <malloc+0x90>
    177c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    1783:	bb 00 80 00 00       	mov    $0x8000,%ebx
    1788:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    178b:	eb 0e                	jmp    179b <malloc+0x4b>
    178d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1790:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1792:	8b 78 04             	mov    0x4(%eax),%edi
    1795:	39 fe                	cmp    %edi,%esi
    1797:	76 4f                	jbe    17e8 <malloc+0x98>
    1799:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    179b:	3b 15 ac 1b 00 00    	cmp    0x1bac,%edx
    17a1:	75 ed                	jne    1790 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    17a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    17a6:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    17ac:	bf 00 10 00 00       	mov    $0x1000,%edi
    17b1:	0f 43 fe             	cmovae %esi,%edi
    17b4:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
    17b7:	89 04 24             	mov    %eax,(%esp)
    17ba:	e8 3b fc ff ff       	call   13fa <sbrk>
  if(p == (char*)-1)
    17bf:	83 f8 ff             	cmp    $0xffffffff,%eax
    17c2:	74 18                	je     17dc <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    17c4:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
    17c7:	83 c0 08             	add    $0x8,%eax
    17ca:	89 04 24             	mov    %eax,(%esp)
    17cd:	e8 ee fe ff ff       	call   16c0 <free>
  return freep;
    17d2:	8b 15 ac 1b 00 00    	mov    0x1bac,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    17d8:	85 d2                	test   %edx,%edx
    17da:	75 b4                	jne    1790 <malloc+0x40>
        return 0;
    17dc:	31 c0                	xor    %eax,%eax
    17de:	eb 20                	jmp    1800 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    17e0:	89 d0                	mov    %edx,%eax
    17e2:	89 da                	mov    %ebx,%edx
    17e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    17e8:	39 fe                	cmp    %edi,%esi
    17ea:	74 1c                	je     1808 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    17ec:	29 f7                	sub    %esi,%edi
    17ee:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
    17f1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
    17f4:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
    17f7:	89 15 ac 1b 00 00    	mov    %edx,0x1bac
      return (void*)(p + 1);
    17fd:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1800:	83 c4 1c             	add    $0x1c,%esp
    1803:	5b                   	pop    %ebx
    1804:	5e                   	pop    %esi
    1805:	5f                   	pop    %edi
    1806:	5d                   	pop    %ebp
    1807:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
    1808:	8b 08                	mov    (%eax),%ecx
    180a:	89 0a                	mov    %ecx,(%edx)
    180c:	eb e9                	jmp    17f7 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    180e:	c7 05 ac 1b 00 00 b0 	movl   $0x1bb0,0x1bac
    1815:	1b 00 00 
    base.s.size = 0;
    1818:	ba b0 1b 00 00       	mov    $0x1bb0,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    181d:	c7 05 b0 1b 00 00 b0 	movl   $0x1bb0,0x1bb0
    1824:	1b 00 00 
    base.s.size = 0;
    1827:	c7 05 b4 1b 00 00 00 	movl   $0x0,0x1bb4
    182e:	00 00 00 
    1831:	e9 46 ff ff ff       	jmp    177c <malloc+0x2c>
    1836:	66 90                	xchg   %ax,%ax
    1838:	66 90                	xchg   %ax,%ax
    183a:	66 90                	xchg   %ax,%ax
    183c:	66 90                	xchg   %ax,%ax
    183e:	66 90                	xchg   %ax,%ax

00001840 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    1840:	55                   	push   %ebp
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1841:	b9 01 00 00 00       	mov    $0x1,%ecx
    1846:	89 e5                	mov    %esp,%ebp
    1848:	8b 55 08             	mov    0x8(%ebp),%edx
    184b:	90                   	nop
    184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1850:	89 c8                	mov    %ecx,%eax
    1852:	f0 87 02             	lock xchg %eax,(%edx)
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    1855:	85 c0                	test   %eax,%eax
    1857:	75 f7                	jne    1850 <uacquire+0x10>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    1859:	0f ae f0             	mfence 
}
    185c:	5d                   	pop    %ebp
    185d:	c3                   	ret    
    185e:	66 90                	xchg   %ax,%ax

00001860 <urelease>:

void urelease (struct uspinlock *lk) {
    1860:	55                   	push   %ebp
    1861:	89 e5                	mov    %esp,%ebp
    1863:	8b 45 08             	mov    0x8(%ebp),%eax
  __sync_synchronize();
    1866:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    1869:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    186f:	5d                   	pop    %ebp
    1870:	c3                   	ret    
