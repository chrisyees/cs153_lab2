
_lab1:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
        printf(1,"\n%d",x);
	return fib(x - 1) + fib(x - 2) + fib(x - 3) + fib(x - 4);
}

int main(int argc, char *argv[])
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 10             	sub    $0x10,%esp

	int x = atoi(argv[1]);
    1009:	8b 45 0c             	mov    0xc(%ebp),%eax
    100c:	8b 40 04             	mov    0x4(%eax),%eax
    100f:	89 04 24             	mov    %eax,(%esp)
    1012:	e8 a9 02 00 00       	call   12c0 <atoi>
	x = fib(x);
    1017:	89 04 24             	mov    %eax,(%esp)
    101a:	e8 21 00 00 00       	call   1040 <fib>
	printf(1,"\nResult: %d\n", x);
    101f:	c7 44 24 04 25 18 00 	movl   $0x1825,0x4(%esp)
    1026:	00 
    1027:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    102e:	89 44 24 08          	mov    %eax,0x8(%esp)
    1032:	e8 49 04 00 00       	call   1480 <printf>
	exit();
    1037:	e8 e6 02 00 00       	call   1322 <exit>
    103c:	66 90                	xchg   %ax,%ax
    103e:	66 90                	xchg   %ax,%ax

00001040 <fib>:
#include "types.h"
#include "user.h"

int fib(int x) {
    1040:	55                   	push   %ebp
    1041:	89 e5                	mov    %esp,%ebp
    1043:	57                   	push   %edi
    1044:	56                   	push   %esi
    1045:	53                   	push   %ebx
    1046:	83 ec 1c             	sub    $0x1c,%esp
    1049:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if(x == 0)
    104c:	83 fb 01             	cmp    $0x1,%ebx
    104f:	0f 86 96 00 00 00    	jbe    10eb <fib+0xab>
		return 1;
	if(x == 1)
		return 1;
	if(x == 2)
    1055:	83 fb 02             	cmp    $0x2,%ebx
    1058:	0f 84 94 00 00 00    	je     10f2 <fib+0xb2>
		return 2;
	if(x == 3)
    105e:	83 fb 03             	cmp    $0x3,%ebx
    1061:	0f 84 92 00 00 00    	je     10f9 <fib+0xb9>
    1067:	31 f6                	xor    %esi,%esi
    1069:	eb 0f                	jmp    107a <fib+0x3a>
    106b:	90                   	nop
    106c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int fib(int x) {
	if(x == 0)
		return 1;
	if(x == 1)
		return 1;
	if(x == 2)
    1070:	83 fb 02             	cmp    $0x2,%ebx
    1073:	74 5b                	je     10d0 <fib+0x90>
		return 2;
	if(x == 3)
    1075:	83 fb 03             	cmp    $0x3,%ebx
    1078:	74 66                	je     10e0 <fib+0xa0>
		return 3;
        printf(1,"\n%d",x);
    107a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    107e:	c7 44 24 04 21 18 00 	movl   $0x1821,0x4(%esp)
    1085:	00 
    1086:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    108d:	e8 ee 03 00 00       	call   1480 <printf>
    1092:	8d 43 ff             	lea    -0x1(%ebx),%eax
	return fib(x - 1) + fib(x - 2) + fib(x - 3) + fib(x - 4);
    1095:	89 04 24             	mov    %eax,(%esp)
    1098:	e8 a3 ff ff ff       	call   1040 <fib>
    109d:	89 c7                	mov    %eax,%edi
    109f:	8d 43 fe             	lea    -0x2(%ebx),%eax
    10a2:	89 04 24             	mov    %eax,(%esp)
    10a5:	e8 96 ff ff ff       	call   1040 <fib>
    10aa:	01 c7                	add    %eax,%edi
    10ac:	8d 43 fd             	lea    -0x3(%ebx),%eax
    10af:	83 eb 04             	sub    $0x4,%ebx
    10b2:	89 04 24             	mov    %eax,(%esp)
    10b5:	e8 86 ff ff ff       	call   1040 <fib>
    10ba:	01 c7                	add    %eax,%edi
    10bc:	01 fe                	add    %edi,%esi
#include "types.h"
#include "user.h"

int fib(int x) {
	if(x == 0)
    10be:	83 fb 01             	cmp    $0x1,%ebx
    10c1:	77 ad                	ja     1070 <fib+0x30>
    10c3:	8d 46 01             	lea    0x1(%esi),%eax
		return 2;
	if(x == 3)
		return 3;
        printf(1,"\n%d",x);
	return fib(x - 1) + fib(x - 2) + fib(x - 3) + fib(x - 4);
}
    10c6:	83 c4 1c             	add    $0x1c,%esp
    10c9:	5b                   	pop    %ebx
    10ca:	5e                   	pop    %esi
    10cb:	5f                   	pop    %edi
    10cc:	5d                   	pop    %ebp
    10cd:	c3                   	ret    
    10ce:	66 90                	xchg   %ax,%ax
    10d0:	83 c4 1c             	add    $0x1c,%esp
    10d3:	5b                   	pop    %ebx
    10d4:	8d 46 02             	lea    0x2(%esi),%eax
    10d7:	5e                   	pop    %esi
    10d8:	5f                   	pop    %edi
    10d9:	5d                   	pop    %ebp
    10da:	c3                   	ret    
    10db:	90                   	nop
    10dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    10e0:	83 c4 1c             	add    $0x1c,%esp
    10e3:	5b                   	pop    %ebx
    10e4:	8d 46 03             	lea    0x3(%esi),%eax
    10e7:	5e                   	pop    %esi
    10e8:	5f                   	pop    %edi
    10e9:	5d                   	pop    %ebp
    10ea:	c3                   	ret    
#include "types.h"
#include "user.h"

int fib(int x) {
	if(x == 0)
    10eb:	b8 01 00 00 00       	mov    $0x1,%eax
    10f0:	eb d4                	jmp    10c6 <fib+0x86>
		return 1;
	if(x == 1)
		return 1;
	if(x == 2)
    10f2:	b8 02 00 00 00       	mov    $0x2,%eax
    10f7:	eb cd                	jmp    10c6 <fib+0x86>
		return 2;
	if(x == 3)
    10f9:	b8 03 00 00 00       	mov    $0x3,%eax
    10fe:	eb c6                	jmp    10c6 <fib+0x86>

00001100 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1100:	55                   	push   %ebp
    1101:	89 e5                	mov    %esp,%ebp
    1103:	8b 45 08             	mov    0x8(%ebp),%eax
    1106:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1109:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    110a:	89 c2                	mov    %eax,%edx
    110c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1110:	83 c1 01             	add    $0x1,%ecx
    1113:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    1117:	83 c2 01             	add    $0x1,%edx
    111a:	84 db                	test   %bl,%bl
    111c:	88 5a ff             	mov    %bl,-0x1(%edx)
    111f:	75 ef                	jne    1110 <strcpy+0x10>
    ;
  return os;
}
    1121:	5b                   	pop    %ebx
    1122:	5d                   	pop    %ebp
    1123:	c3                   	ret    
    1124:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    112a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001130 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1130:	55                   	push   %ebp
    1131:	89 e5                	mov    %esp,%ebp
    1133:	8b 55 08             	mov    0x8(%ebp),%edx
    1136:	53                   	push   %ebx
    1137:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    113a:	0f b6 02             	movzbl (%edx),%eax
    113d:	84 c0                	test   %al,%al
    113f:	74 2d                	je     116e <strcmp+0x3e>
    1141:	0f b6 19             	movzbl (%ecx),%ebx
    1144:	38 d8                	cmp    %bl,%al
    1146:	74 0e                	je     1156 <strcmp+0x26>
    1148:	eb 2b                	jmp    1175 <strcmp+0x45>
    114a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1150:	38 c8                	cmp    %cl,%al
    1152:	75 15                	jne    1169 <strcmp+0x39>
    p++, q++;
    1154:	89 d9                	mov    %ebx,%ecx
    1156:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1159:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
    115c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    115f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
    1163:	84 c0                	test   %al,%al
    1165:	75 e9                	jne    1150 <strcmp+0x20>
    1167:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1169:	29 c8                	sub    %ecx,%eax
}
    116b:	5b                   	pop    %ebx
    116c:	5d                   	pop    %ebp
    116d:	c3                   	ret    
    116e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1171:	31 c0                	xor    %eax,%eax
    1173:	eb f4                	jmp    1169 <strcmp+0x39>
    1175:	0f b6 cb             	movzbl %bl,%ecx
    1178:	eb ef                	jmp    1169 <strcmp+0x39>
    117a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001180 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
    1180:	55                   	push   %ebp
    1181:	89 e5                	mov    %esp,%ebp
    1183:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    1186:	80 39 00             	cmpb   $0x0,(%ecx)
    1189:	74 12                	je     119d <strlen+0x1d>
    118b:	31 d2                	xor    %edx,%edx
    118d:	8d 76 00             	lea    0x0(%esi),%esi
    1190:	83 c2 01             	add    $0x1,%edx
    1193:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    1197:	89 d0                	mov    %edx,%eax
    1199:	75 f5                	jne    1190 <strlen+0x10>
    ;
  return n;
}
    119b:	5d                   	pop    %ebp
    119c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
    119d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
    119f:	5d                   	pop    %ebp
    11a0:	c3                   	ret    
    11a1:	eb 0d                	jmp    11b0 <memset>
    11a3:	90                   	nop
    11a4:	90                   	nop
    11a5:	90                   	nop
    11a6:	90                   	nop
    11a7:	90                   	nop
    11a8:	90                   	nop
    11a9:	90                   	nop
    11aa:	90                   	nop
    11ab:	90                   	nop
    11ac:	90                   	nop
    11ad:	90                   	nop
    11ae:	90                   	nop
    11af:	90                   	nop

000011b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11b0:	55                   	push   %ebp
    11b1:	89 e5                	mov    %esp,%ebp
    11b3:	8b 55 08             	mov    0x8(%ebp),%edx
    11b6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    11b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
    11ba:	8b 45 0c             	mov    0xc(%ebp),%eax
    11bd:	89 d7                	mov    %edx,%edi
    11bf:	fc                   	cld    
    11c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    11c2:	89 d0                	mov    %edx,%eax
    11c4:	5f                   	pop    %edi
    11c5:	5d                   	pop    %ebp
    11c6:	c3                   	ret    
    11c7:	89 f6                	mov    %esi,%esi
    11c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000011d0 <strchr>:

char*
strchr(const char *s, char c)
{
    11d0:	55                   	push   %ebp
    11d1:	89 e5                	mov    %esp,%ebp
    11d3:	8b 45 08             	mov    0x8(%ebp),%eax
    11d6:	53                   	push   %ebx
    11d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
    11da:	0f b6 18             	movzbl (%eax),%ebx
    11dd:	84 db                	test   %bl,%bl
    11df:	74 1d                	je     11fe <strchr+0x2e>
    if(*s == c)
    11e1:	38 d3                	cmp    %dl,%bl
    11e3:	89 d1                	mov    %edx,%ecx
    11e5:	75 0d                	jne    11f4 <strchr+0x24>
    11e7:	eb 17                	jmp    1200 <strchr+0x30>
    11e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11f0:	38 ca                	cmp    %cl,%dl
    11f2:	74 0c                	je     1200 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    11f4:	83 c0 01             	add    $0x1,%eax
    11f7:	0f b6 10             	movzbl (%eax),%edx
    11fa:	84 d2                	test   %dl,%dl
    11fc:	75 f2                	jne    11f0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
    11fe:	31 c0                	xor    %eax,%eax
}
    1200:	5b                   	pop    %ebx
    1201:	5d                   	pop    %ebp
    1202:	c3                   	ret    
    1203:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001210 <gets>:

char*
gets(char *buf, int max)
{
    1210:	55                   	push   %ebp
    1211:	89 e5                	mov    %esp,%ebp
    1213:	57                   	push   %edi
    1214:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1215:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
    1217:	53                   	push   %ebx
    1218:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    121b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    121e:	eb 31                	jmp    1251 <gets+0x41>
    cc = read(0, &c, 1);
    1220:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1227:	00 
    1228:	89 7c 24 04          	mov    %edi,0x4(%esp)
    122c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1233:	e8 02 01 00 00       	call   133a <read>
    if(cc < 1)
    1238:	85 c0                	test   %eax,%eax
    123a:	7e 1d                	jle    1259 <gets+0x49>
      break;
    buf[i++] = c;
    123c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1240:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    1242:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
    1245:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    1247:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
    124b:	74 0c                	je     1259 <gets+0x49>
    124d:	3c 0a                	cmp    $0xa,%al
    124f:	74 08                	je     1259 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1251:	8d 5e 01             	lea    0x1(%esi),%ebx
    1254:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    1257:	7c c7                	jl     1220 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1259:	8b 45 08             	mov    0x8(%ebp),%eax
    125c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1260:	83 c4 2c             	add    $0x2c,%esp
    1263:	5b                   	pop    %ebx
    1264:	5e                   	pop    %esi
    1265:	5f                   	pop    %edi
    1266:	5d                   	pop    %ebp
    1267:	c3                   	ret    
    1268:	90                   	nop
    1269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001270 <stat>:

int
stat(char *n, struct stat *st)
{
    1270:	55                   	push   %ebp
    1271:	89 e5                	mov    %esp,%ebp
    1273:	56                   	push   %esi
    1274:	53                   	push   %ebx
    1275:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1278:	8b 45 08             	mov    0x8(%ebp),%eax
    127b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1282:	00 
    1283:	89 04 24             	mov    %eax,(%esp)
    1286:	e8 d7 00 00 00       	call   1362 <open>
  if(fd < 0)
    128b:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    128d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
    128f:	78 27                	js     12b8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    1291:	8b 45 0c             	mov    0xc(%ebp),%eax
    1294:	89 1c 24             	mov    %ebx,(%esp)
    1297:	89 44 24 04          	mov    %eax,0x4(%esp)
    129b:	e8 da 00 00 00       	call   137a <fstat>
  close(fd);
    12a0:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
    12a3:	89 c6                	mov    %eax,%esi
  close(fd);
    12a5:	e8 a0 00 00 00       	call   134a <close>
  return r;
    12aa:	89 f0                	mov    %esi,%eax
}
    12ac:	83 c4 10             	add    $0x10,%esp
    12af:	5b                   	pop    %ebx
    12b0:	5e                   	pop    %esi
    12b1:	5d                   	pop    %ebp
    12b2:	c3                   	ret    
    12b3:	90                   	nop
    12b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
    12b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12bd:	eb ed                	jmp    12ac <stat+0x3c>
    12bf:	90                   	nop

000012c0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
    12c0:	55                   	push   %ebp
    12c1:	89 e5                	mov    %esp,%ebp
    12c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
    12c6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    12c7:	0f be 11             	movsbl (%ecx),%edx
    12ca:	8d 42 d0             	lea    -0x30(%edx),%eax
    12cd:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
    12cf:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    12d4:	77 17                	ja     12ed <atoi+0x2d>
    12d6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
    12d8:	83 c1 01             	add    $0x1,%ecx
    12db:	8d 04 80             	lea    (%eax,%eax,4),%eax
    12de:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    12e2:	0f be 11             	movsbl (%ecx),%edx
    12e5:	8d 5a d0             	lea    -0x30(%edx),%ebx
    12e8:	80 fb 09             	cmp    $0x9,%bl
    12eb:	76 eb                	jbe    12d8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
    12ed:	5b                   	pop    %ebx
    12ee:	5d                   	pop    %ebp
    12ef:	c3                   	ret    

000012f0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    12f0:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12f1:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
    12f3:	89 e5                	mov    %esp,%ebp
    12f5:	56                   	push   %esi
    12f6:	8b 45 08             	mov    0x8(%ebp),%eax
    12f9:	53                   	push   %ebx
    12fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
    12fd:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1300:	85 db                	test   %ebx,%ebx
    1302:	7e 12                	jle    1316 <memmove+0x26>
    1304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
    1308:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    130c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    130f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1312:	39 da                	cmp    %ebx,%edx
    1314:	75 f2                	jne    1308 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
    1316:	5b                   	pop    %ebx
    1317:	5e                   	pop    %esi
    1318:	5d                   	pop    %ebp
    1319:	c3                   	ret    

0000131a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    131a:	b8 01 00 00 00       	mov    $0x1,%eax
    131f:	cd 40                	int    $0x40
    1321:	c3                   	ret    

00001322 <exit>:
SYSCALL(exit)
    1322:	b8 02 00 00 00       	mov    $0x2,%eax
    1327:	cd 40                	int    $0x40
    1329:	c3                   	ret    

0000132a <wait>:
SYSCALL(wait)
    132a:	b8 03 00 00 00       	mov    $0x3,%eax
    132f:	cd 40                	int    $0x40
    1331:	c3                   	ret    

00001332 <pipe>:
SYSCALL(pipe)
    1332:	b8 04 00 00 00       	mov    $0x4,%eax
    1337:	cd 40                	int    $0x40
    1339:	c3                   	ret    

0000133a <read>:
SYSCALL(read)
    133a:	b8 05 00 00 00       	mov    $0x5,%eax
    133f:	cd 40                	int    $0x40
    1341:	c3                   	ret    

00001342 <write>:
SYSCALL(write)
    1342:	b8 10 00 00 00       	mov    $0x10,%eax
    1347:	cd 40                	int    $0x40
    1349:	c3                   	ret    

0000134a <close>:
SYSCALL(close)
    134a:	b8 15 00 00 00       	mov    $0x15,%eax
    134f:	cd 40                	int    $0x40
    1351:	c3                   	ret    

00001352 <kill>:
SYSCALL(kill)
    1352:	b8 06 00 00 00       	mov    $0x6,%eax
    1357:	cd 40                	int    $0x40
    1359:	c3                   	ret    

0000135a <exec>:
SYSCALL(exec)
    135a:	b8 07 00 00 00       	mov    $0x7,%eax
    135f:	cd 40                	int    $0x40
    1361:	c3                   	ret    

00001362 <open>:
SYSCALL(open)
    1362:	b8 0f 00 00 00       	mov    $0xf,%eax
    1367:	cd 40                	int    $0x40
    1369:	c3                   	ret    

0000136a <mknod>:
SYSCALL(mknod)
    136a:	b8 11 00 00 00       	mov    $0x11,%eax
    136f:	cd 40                	int    $0x40
    1371:	c3                   	ret    

00001372 <unlink>:
SYSCALL(unlink)
    1372:	b8 12 00 00 00       	mov    $0x12,%eax
    1377:	cd 40                	int    $0x40
    1379:	c3                   	ret    

0000137a <fstat>:
SYSCALL(fstat)
    137a:	b8 08 00 00 00       	mov    $0x8,%eax
    137f:	cd 40                	int    $0x40
    1381:	c3                   	ret    

00001382 <link>:
SYSCALL(link)
    1382:	b8 13 00 00 00       	mov    $0x13,%eax
    1387:	cd 40                	int    $0x40
    1389:	c3                   	ret    

0000138a <mkdir>:
SYSCALL(mkdir)
    138a:	b8 14 00 00 00       	mov    $0x14,%eax
    138f:	cd 40                	int    $0x40
    1391:	c3                   	ret    

00001392 <chdir>:
SYSCALL(chdir)
    1392:	b8 09 00 00 00       	mov    $0x9,%eax
    1397:	cd 40                	int    $0x40
    1399:	c3                   	ret    

0000139a <dup>:
SYSCALL(dup)
    139a:	b8 0a 00 00 00       	mov    $0xa,%eax
    139f:	cd 40                	int    $0x40
    13a1:	c3                   	ret    

000013a2 <getpid>:
SYSCALL(getpid)
    13a2:	b8 0b 00 00 00       	mov    $0xb,%eax
    13a7:	cd 40                	int    $0x40
    13a9:	c3                   	ret    

000013aa <sbrk>:
SYSCALL(sbrk)
    13aa:	b8 0c 00 00 00       	mov    $0xc,%eax
    13af:	cd 40                	int    $0x40
    13b1:	c3                   	ret    

000013b2 <sleep>:
SYSCALL(sleep)
    13b2:	b8 0d 00 00 00       	mov    $0xd,%eax
    13b7:	cd 40                	int    $0x40
    13b9:	c3                   	ret    

000013ba <uptime>:
SYSCALL(uptime)
    13ba:	b8 0e 00 00 00       	mov    $0xe,%eax
    13bf:	cd 40                	int    $0x40
    13c1:	c3                   	ret    

000013c2 <shm_open>:
SYSCALL(shm_open)
    13c2:	b8 16 00 00 00       	mov    $0x16,%eax
    13c7:	cd 40                	int    $0x40
    13c9:	c3                   	ret    

000013ca <shm_close>:
SYSCALL(shm_close)	
    13ca:	b8 17 00 00 00       	mov    $0x17,%eax
    13cf:	cd 40                	int    $0x40
    13d1:	c3                   	ret    
    13d2:	66 90                	xchg   %ax,%ax
    13d4:	66 90                	xchg   %ax,%ax
    13d6:	66 90                	xchg   %ax,%ax
    13d8:	66 90                	xchg   %ax,%ax
    13da:	66 90                	xchg   %ax,%ax
    13dc:	66 90                	xchg   %ax,%ax
    13de:	66 90                	xchg   %ax,%ax

000013e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    13e0:	55                   	push   %ebp
    13e1:	89 e5                	mov    %esp,%ebp
    13e3:	57                   	push   %edi
    13e4:	56                   	push   %esi
    13e5:	89 c6                	mov    %eax,%esi
    13e7:	53                   	push   %ebx
    13e8:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    13eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    13ee:	85 db                	test   %ebx,%ebx
    13f0:	74 09                	je     13fb <printint+0x1b>
    13f2:	89 d0                	mov    %edx,%eax
    13f4:	c1 e8 1f             	shr    $0x1f,%eax
    13f7:	84 c0                	test   %al,%al
    13f9:	75 75                	jne    1470 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    13fb:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13fd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    1404:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    1407:	31 ff                	xor    %edi,%edi
    1409:	89 ce                	mov    %ecx,%esi
    140b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    140e:	eb 02                	jmp    1412 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
    1410:	89 cf                	mov    %ecx,%edi
    1412:	31 d2                	xor    %edx,%edx
    1414:	f7 f6                	div    %esi
    1416:	8d 4f 01             	lea    0x1(%edi),%ecx
    1419:	0f b6 92 39 18 00 00 	movzbl 0x1839(%edx),%edx
  }while((x /= base) != 0);
    1420:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    1422:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
    1425:	75 e9                	jne    1410 <printint+0x30>
  if(neg)
    1427:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    142a:	89 c8                	mov    %ecx,%eax
    142c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
    142f:	85 d2                	test   %edx,%edx
    1431:	74 08                	je     143b <printint+0x5b>
    buf[i++] = '-';
    1433:	8d 4f 02             	lea    0x2(%edi),%ecx
    1436:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
    143b:	8d 79 ff             	lea    -0x1(%ecx),%edi
    143e:	66 90                	xchg   %ax,%ax
    1440:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
    1445:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1448:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    144f:	00 
    1450:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    1454:	89 34 24             	mov    %esi,(%esp)
    1457:	88 45 d7             	mov    %al,-0x29(%ebp)
    145a:	e8 e3 fe ff ff       	call   1342 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    145f:	83 ff ff             	cmp    $0xffffffff,%edi
    1462:	75 dc                	jne    1440 <printint+0x60>
    putc(fd, buf[i]);
}
    1464:	83 c4 4c             	add    $0x4c,%esp
    1467:	5b                   	pop    %ebx
    1468:	5e                   	pop    %esi
    1469:	5f                   	pop    %edi
    146a:	5d                   	pop    %ebp
    146b:	c3                   	ret    
    146c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    1470:	89 d0                	mov    %edx,%eax
    1472:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    1474:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    147b:	eb 87                	jmp    1404 <printint+0x24>
    147d:	8d 76 00             	lea    0x0(%esi),%esi

00001480 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1480:	55                   	push   %ebp
    1481:	89 e5                	mov    %esp,%ebp
    1483:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1484:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1486:	56                   	push   %esi
    1487:	53                   	push   %ebx
    1488:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    148b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    148e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1491:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    1494:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
    1497:	0f b6 13             	movzbl (%ebx),%edx
    149a:	83 c3 01             	add    $0x1,%ebx
    149d:	84 d2                	test   %dl,%dl
    149f:	75 39                	jne    14da <printf+0x5a>
    14a1:	e9 c2 00 00 00       	jmp    1568 <printf+0xe8>
    14a6:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    14a8:	83 fa 25             	cmp    $0x25,%edx
    14ab:	0f 84 bf 00 00 00    	je     1570 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    14b1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    14b4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    14bb:	00 
    14bc:	89 44 24 04          	mov    %eax,0x4(%esp)
    14c0:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    14c3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    14c6:	e8 77 fe ff ff       	call   1342 <write>
    14cb:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    14ce:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
    14d2:	84 d2                	test   %dl,%dl
    14d4:	0f 84 8e 00 00 00    	je     1568 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
    14da:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    14dc:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
    14df:	74 c7                	je     14a8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    14e1:	83 ff 25             	cmp    $0x25,%edi
    14e4:	75 e5                	jne    14cb <printf+0x4b>
      if(c == 'd'){
    14e6:	83 fa 64             	cmp    $0x64,%edx
    14e9:	0f 84 31 01 00 00    	je     1620 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    14ef:	25 f7 00 00 00       	and    $0xf7,%eax
    14f4:	83 f8 70             	cmp    $0x70,%eax
    14f7:	0f 84 83 00 00 00    	je     1580 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    14fd:	83 fa 73             	cmp    $0x73,%edx
    1500:	0f 84 a2 00 00 00    	je     15a8 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1506:	83 fa 63             	cmp    $0x63,%edx
    1509:	0f 84 35 01 00 00    	je     1644 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    150f:	83 fa 25             	cmp    $0x25,%edx
    1512:	0f 84 e0 00 00 00    	je     15f8 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1518:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    151b:	83 c3 01             	add    $0x1,%ebx
    151e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1525:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1526:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1528:	89 44 24 04          	mov    %eax,0x4(%esp)
    152c:	89 34 24             	mov    %esi,(%esp)
    152f:	89 55 d0             	mov    %edx,-0x30(%ebp)
    1532:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
    1536:	e8 07 fe ff ff       	call   1342 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    153b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    153e:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1541:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1548:	00 
    1549:	89 44 24 04          	mov    %eax,0x4(%esp)
    154d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    1550:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1553:	e8 ea fd ff ff       	call   1342 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1558:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
    155c:	84 d2                	test   %dl,%dl
    155e:	0f 85 76 ff ff ff    	jne    14da <printf+0x5a>
    1564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1568:	83 c4 3c             	add    $0x3c,%esp
    156b:	5b                   	pop    %ebx
    156c:	5e                   	pop    %esi
    156d:	5f                   	pop    %edi
    156e:	5d                   	pop    %ebp
    156f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    1570:	bf 25 00 00 00       	mov    $0x25,%edi
    1575:	e9 51 ff ff ff       	jmp    14cb <printf+0x4b>
    157a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    1580:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1583:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1588:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    158a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1591:	8b 10                	mov    (%eax),%edx
    1593:	89 f0                	mov    %esi,%eax
    1595:	e8 46 fe ff ff       	call   13e0 <printint>
        ap++;
    159a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    159e:	e9 28 ff ff ff       	jmp    14cb <printf+0x4b>
    15a3:	90                   	nop
    15a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
    15a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
    15ab:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
    15af:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
    15b1:	b8 32 18 00 00       	mov    $0x1832,%eax
    15b6:	85 ff                	test   %edi,%edi
    15b8:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
    15bb:	0f b6 07             	movzbl (%edi),%eax
    15be:	84 c0                	test   %al,%al
    15c0:	74 2a                	je     15ec <printf+0x16c>
    15c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    15c8:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    15cb:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
    15ce:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    15d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    15d8:	00 
    15d9:	89 44 24 04          	mov    %eax,0x4(%esp)
    15dd:	89 34 24             	mov    %esi,(%esp)
    15e0:	e8 5d fd ff ff       	call   1342 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    15e5:	0f b6 07             	movzbl (%edi),%eax
    15e8:	84 c0                	test   %al,%al
    15ea:	75 dc                	jne    15c8 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    15ec:	31 ff                	xor    %edi,%edi
    15ee:	e9 d8 fe ff ff       	jmp    14cb <printf+0x4b>
    15f3:	90                   	nop
    15f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    15f8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    15fb:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    15fd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1604:	00 
    1605:	89 44 24 04          	mov    %eax,0x4(%esp)
    1609:	89 34 24             	mov    %esi,(%esp)
    160c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
    1610:	e8 2d fd ff ff       	call   1342 <write>
    1615:	e9 b1 fe ff ff       	jmp    14cb <printf+0x4b>
    161a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    1620:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1623:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1628:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    162b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1632:	8b 10                	mov    (%eax),%edx
    1634:	89 f0                	mov    %esi,%eax
    1636:	e8 a5 fd ff ff       	call   13e0 <printint>
        ap++;
    163b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    163f:	e9 87 fe ff ff       	jmp    14cb <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    1644:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1647:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    1649:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    164b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1652:	00 
    1653:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    1656:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1659:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    165c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1660:	e8 dd fc ff ff       	call   1342 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
    1665:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    1669:	e9 5d fe ff ff       	jmp    14cb <printf+0x4b>
    166e:	66 90                	xchg   %ax,%ax

00001670 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1670:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1671:	a1 3c 1b 00 00       	mov    0x1b3c,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
    1676:	89 e5                	mov    %esp,%ebp
    1678:	57                   	push   %edi
    1679:	56                   	push   %esi
    167a:	53                   	push   %ebx
    167b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    167e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1680:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1683:	39 d0                	cmp    %edx,%eax
    1685:	72 11                	jb     1698 <free+0x28>
    1687:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1688:	39 c8                	cmp    %ecx,%eax
    168a:	72 04                	jb     1690 <free+0x20>
    168c:	39 ca                	cmp    %ecx,%edx
    168e:	72 10                	jb     16a0 <free+0x30>
    1690:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1692:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1694:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1696:	73 f0                	jae    1688 <free+0x18>
    1698:	39 ca                	cmp    %ecx,%edx
    169a:	72 04                	jb     16a0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    169c:	39 c8                	cmp    %ecx,%eax
    169e:	72 f0                	jb     1690 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    16a0:	8b 73 fc             	mov    -0x4(%ebx),%esi
    16a3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
    16a6:	39 cf                	cmp    %ecx,%edi
    16a8:	74 1e                	je     16c8 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    16aa:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
    16ad:	8b 48 04             	mov    0x4(%eax),%ecx
    16b0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
    16b3:	39 f2                	cmp    %esi,%edx
    16b5:	74 28                	je     16df <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    16b7:	89 10                	mov    %edx,(%eax)
  freep = p;
    16b9:	a3 3c 1b 00 00       	mov    %eax,0x1b3c
}
    16be:	5b                   	pop    %ebx
    16bf:	5e                   	pop    %esi
    16c0:	5f                   	pop    %edi
    16c1:	5d                   	pop    %ebp
    16c2:	c3                   	ret    
    16c3:	90                   	nop
    16c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    16c8:	03 71 04             	add    0x4(%ecx),%esi
    16cb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    16ce:	8b 08                	mov    (%eax),%ecx
    16d0:	8b 09                	mov    (%ecx),%ecx
    16d2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    16d5:	8b 48 04             	mov    0x4(%eax),%ecx
    16d8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
    16db:	39 f2                	cmp    %esi,%edx
    16dd:	75 d8                	jne    16b7 <free+0x47>
    p->s.size += bp->s.size;
    16df:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
    16e2:	a3 3c 1b 00 00       	mov    %eax,0x1b3c
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    16e7:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16ea:	8b 53 f8             	mov    -0x8(%ebx),%edx
    16ed:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
    16ef:	5b                   	pop    %ebx
    16f0:	5e                   	pop    %esi
    16f1:	5f                   	pop    %edi
    16f2:	5d                   	pop    %ebp
    16f3:	c3                   	ret    
    16f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    16fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001700 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1700:	55                   	push   %ebp
    1701:	89 e5                	mov    %esp,%ebp
    1703:	57                   	push   %edi
    1704:	56                   	push   %esi
    1705:	53                   	push   %ebx
    1706:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1709:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    170c:	8b 1d 3c 1b 00 00    	mov    0x1b3c,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1712:	8d 48 07             	lea    0x7(%eax),%ecx
    1715:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
    1718:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    171a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
    171d:	0f 84 9b 00 00 00    	je     17be <malloc+0xbe>
    1723:	8b 13                	mov    (%ebx),%edx
    1725:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    1728:	39 fe                	cmp    %edi,%esi
    172a:	76 64                	jbe    1790 <malloc+0x90>
    172c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    1733:	bb 00 80 00 00       	mov    $0x8000,%ebx
    1738:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    173b:	eb 0e                	jmp    174b <malloc+0x4b>
    173d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1740:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1742:	8b 78 04             	mov    0x4(%eax),%edi
    1745:	39 fe                	cmp    %edi,%esi
    1747:	76 4f                	jbe    1798 <malloc+0x98>
    1749:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    174b:	3b 15 3c 1b 00 00    	cmp    0x1b3c,%edx
    1751:	75 ed                	jne    1740 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    1753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1756:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    175c:	bf 00 10 00 00       	mov    $0x1000,%edi
    1761:	0f 43 fe             	cmovae %esi,%edi
    1764:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
    1767:	89 04 24             	mov    %eax,(%esp)
    176a:	e8 3b fc ff ff       	call   13aa <sbrk>
  if(p == (char*)-1)
    176f:	83 f8 ff             	cmp    $0xffffffff,%eax
    1772:	74 18                	je     178c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    1774:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
    1777:	83 c0 08             	add    $0x8,%eax
    177a:	89 04 24             	mov    %eax,(%esp)
    177d:	e8 ee fe ff ff       	call   1670 <free>
  return freep;
    1782:	8b 15 3c 1b 00 00    	mov    0x1b3c,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    1788:	85 d2                	test   %edx,%edx
    178a:	75 b4                	jne    1740 <malloc+0x40>
        return 0;
    178c:	31 c0                	xor    %eax,%eax
    178e:	eb 20                	jmp    17b0 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    1790:	89 d0                	mov    %edx,%eax
    1792:	89 da                	mov    %ebx,%edx
    1794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    1798:	39 fe                	cmp    %edi,%esi
    179a:	74 1c                	je     17b8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    179c:	29 f7                	sub    %esi,%edi
    179e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
    17a1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
    17a4:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
    17a7:	89 15 3c 1b 00 00    	mov    %edx,0x1b3c
      return (void*)(p + 1);
    17ad:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    17b0:	83 c4 1c             	add    $0x1c,%esp
    17b3:	5b                   	pop    %ebx
    17b4:	5e                   	pop    %esi
    17b5:	5f                   	pop    %edi
    17b6:	5d                   	pop    %ebp
    17b7:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
    17b8:	8b 08                	mov    (%eax),%ecx
    17ba:	89 0a                	mov    %ecx,(%edx)
    17bc:	eb e9                	jmp    17a7 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    17be:	c7 05 3c 1b 00 00 40 	movl   $0x1b40,0x1b3c
    17c5:	1b 00 00 
    base.s.size = 0;
    17c8:	ba 40 1b 00 00       	mov    $0x1b40,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    17cd:	c7 05 40 1b 00 00 40 	movl   $0x1b40,0x1b40
    17d4:	1b 00 00 
    base.s.size = 0;
    17d7:	c7 05 44 1b 00 00 00 	movl   $0x0,0x1b44
    17de:	00 00 00 
    17e1:	e9 46 ff ff ff       	jmp    172c <malloc+0x2c>
    17e6:	66 90                	xchg   %ax,%ax
    17e8:	66 90                	xchg   %ax,%ax
    17ea:	66 90                	xchg   %ax,%ax
    17ec:	66 90                	xchg   %ax,%ax
    17ee:	66 90                	xchg   %ax,%ax

000017f0 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    17f0:	55                   	push   %ebp
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    17f1:	b9 01 00 00 00       	mov    $0x1,%ecx
    17f6:	89 e5                	mov    %esp,%ebp
    17f8:	8b 55 08             	mov    0x8(%ebp),%edx
    17fb:	90                   	nop
    17fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1800:	89 c8                	mov    %ecx,%eax
    1802:	f0 87 02             	lock xchg %eax,(%edx)
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    1805:	85 c0                	test   %eax,%eax
    1807:	75 f7                	jne    1800 <uacquire+0x10>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    1809:	0f ae f0             	mfence 
}
    180c:	5d                   	pop    %ebp
    180d:	c3                   	ret    
    180e:	66 90                	xchg   %ax,%ax

00001810 <urelease>:

void urelease (struct uspinlock *lk) {
    1810:	55                   	push   %ebp
    1811:	89 e5                	mov    %esp,%ebp
    1813:	8b 45 08             	mov    0x8(%ebp),%eax
  __sync_synchronize();
    1816:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    1819:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    181f:	5d                   	pop    %ebp
    1820:	c3                   	ret    
