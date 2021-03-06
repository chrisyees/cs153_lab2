
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 2d 10 80       	mov    $0x80102de0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 14             	sub    $0x14,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 a0 6d 10 	movl   $0x80106da0,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 e0 3f 00 00       	call   80104040 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 a7 6d 10 	movl   $0x80106da7,0x4(%esp)
8010009b:	80 
8010009c:	e8 8f 3e 00 00       	call   80103f30 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000e6:	e8 45 40 00 00       	call   80104130 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 ba 40 00 00       	call   80104220 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 ff 3d 00 00       	call   80103f70 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 92 1f 00 00       	call   80102110 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100188:	c7 04 24 ae 6d 10 80 	movl   $0x80106dae,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 5b 3e 00 00       	call   80104010 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 47 1f 00 00       	jmp    80102110 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 bf 6d 10 80 	movl   $0x80106dbf,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 1a 3e 00 00       	call   80104010 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 ce 3d 00 00       	call   80103fd0 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 22 3f 00 00       	call   80104130 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
80100250:	e9 cb 3f 00 00       	jmp    80104220 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100255:	c7 04 24 c6 6d 10 80 	movl   $0x80106dc6,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 f9 14 00 00       	call   80101780 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 9d 3e 00 00       	call   80104130 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 e3 33 00 00       	call   80103690 <myproc>
801002ad:	8b 40 28             	mov    0x28(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 28 39 00 00       	call   80103bf0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    --n;
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 0a 3f 00 00       	call   80104220 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 82 13 00 00       	call   801016a0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 ec 3e 00 00       	call   80104220 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 64 13 00 00       	call   801016a0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 d5 23 00 00       	call   80102750 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 cd 6d 10 80 	movl   $0x80106dcd,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 87 77 10 80 	movl   $0x80107787,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 ac 3c 00 00       	call   80104060 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 e1 6d 10 80 	movl   $0x80106de1,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 a2 53 00 00       	call   801057b0 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx

  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 

  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 f2 52 00 00       	call   801057b0 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 e6 52 00 00       	call   801057b0 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 da 52 00 00       	call   801057b0 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 0f 3e 00 00       	call   80104310 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 52 3d 00 00       	call   80104270 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010052a:	c7 04 24 e5 6d 10 80 	movl   $0x80106de5,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  else
    x = xx;

  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 10 6e 10 80 	movzbl -0x7fef91f0(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>

  if(sign)
801005a8:	85 ff                	test   %edi,%edi
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  }while((x /= base) != 0);

  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
    consputc(buf[i]);
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 79 11 00 00       	call   80101780 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 1d 3b 00 00       	call   80104130 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 e5 3b 00 00       	call   80104220 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 5a 10 00 00       	call   801016a0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
    acquire(&cons.lock);

  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
      break;
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
      consputc(c);
      break;
    }
  }

  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 28 3b 00 00       	call   80104220 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 f8 6d 10 80       	mov    $0x80106df8,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 94 39 00 00       	call   80104130 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007a1:	c7 04 24 ff 6d 10 80 	movl   $0x80106dff,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 66 39 00 00       	call   80104130 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 f4 39 00 00       	call   80104220 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 c9 34 00 00       	call   80103d80 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 34 35 00 00       	jmp    80103e60 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 08 6e 10 	movl   $0x80106e08,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 d6 36 00 00       	call   80104040 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100997:	e8 04 19 00 00       	call   801022a0 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
//
//returns address of page fault, -1 otherwise
//(N+1) < rcr2()<ke - N + pgsize
int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sb, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 df 2c 00 00       	call   80103690 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 44 21 00 00       	call   80102b00 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 29 15 00 00       	call   80101ef0 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 3f 02 00 00    	je     80100c10 <exec+0x270>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 c7 0c 00 00       	call   801016a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 55 0f 00 00       	call   80101950 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 f8 0e 00 00       	call   80101900 <iunlockput>
    end_op();
80100a08:	e8 63 21 00 00       	call   80102b70 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 8f 5f 00 00       	call   801069c0 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 bd 0e 00 00       	call   80101950 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
      continue;
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 49 5d 00 00       	call   80106820 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 48 5c 00 00       	call   80106760 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 12 5e 00 00       	call   80106940 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 c5 0d 00 00       	call   80101900 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 2b 20 00 00       	call   80102b70 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sp = allocuvm(pgdir, KERNBASE - PGSIZE, KERNBASE - 4)) == 0)
80100b45:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b4b:	c7 44 24 08 fc ff ff 	movl   $0x7ffffffc,0x8(%esp)
80100b52:	7f 
80100b53:	c7 44 24 04 00 f0 ff 	movl   $0x7ffff000,0x4(%esp)
80100b5a:	7f 
80100b5b:	89 04 24             	mov    %eax,(%esp)
80100b5e:	e8 bd 5c 00 00       	call   80106820 <allocuvm>
80100b63:	85 c0                	test   %eax,%eax
80100b65:	0f 84 8d 00 00 00    	je     80100bf8 <exec+0x258>
  //clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = KERNBASE - 4;
  sb = KERNBASE - PGSIZE;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b6e:	8b 00                	mov    (%eax),%eax
80100b70:	85 c0                	test   %eax,%eax
80100b72:	0f 84 9b 01 00 00    	je     80100d13 <exec+0x373>
80100b78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100b7b:	31 d2                	xor    %edx,%edx
80100b7d:	bb fc ff ff 7f       	mov    $0x7ffffffc,%ebx
80100b82:	8d 71 04             	lea    0x4(%ecx),%esi
80100b85:	89 cf                	mov    %ecx,%edi
80100b87:	89 f1                	mov    %esi,%ecx
80100b89:	89 d6                	mov    %edx,%esi
80100b8b:	89 ca                	mov    %ecx,%edx
80100b8d:	eb 27                	jmp    80100bb6 <exec+0x216>
80100b8f:	90                   	nop
80100b90:	8b 95 e8 fe ff ff    	mov    -0x118(%ebp),%edx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100b96:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100b9c:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  //clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = KERNBASE - 4;
  sb = KERNBASE - PGSIZE;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ba3:	83 c6 01             	add    $0x1,%esi
80100ba6:	8b 02                	mov    (%edx),%eax
80100ba8:	89 d7                	mov    %edx,%edi
80100baa:	85 c0                	test   %eax,%eax
80100bac:	74 7d                	je     80100c2b <exec+0x28b>
80100bae:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bb1:	83 fe 20             	cmp    $0x20,%esi
80100bb4:	74 42                	je     80100bf8 <exec+0x258>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bb6:	89 04 24             	mov    %eax,(%esp)
80100bb9:	89 95 e8 fe ff ff    	mov    %edx,-0x118(%ebp)
80100bbf:	e8 cc 38 00 00       	call   80104490 <strlen>
80100bc4:	f7 d0                	not    %eax
80100bc6:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bc8:	8b 07                	mov    (%edi),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bca:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bcd:	89 04 24             	mov    %eax,(%esp)
80100bd0:	e8 bb 38 00 00       	call   80104490 <strlen>
80100bd5:	83 c0 01             	add    $0x1,%eax
80100bd8:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100bdc:	8b 07                	mov    (%edi),%eax
80100bde:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100be2:	89 44 24 08          	mov    %eax,0x8(%esp)
80100be6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bec:	89 04 24             	mov    %eax,(%esp)
80100bef:	e8 9c 60 00 00       	call   80106c90 <copyout>
80100bf4:	85 c0                	test   %eax,%eax
80100bf6:	79 98                	jns    80100b90 <exec+0x1f0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100bf8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bfe:	89 04 24             	mov    %eax,(%esp)
80100c01:	e8 3a 5d 00 00       	call   80106940 <freevm>
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100c06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c0b:	e9 02 fe ff ff       	jmp    80100a12 <exec+0x72>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100c10:	e8 5b 1f 00 00       	call   80102b70 <end_op>
    cprintf("exec: fail\n");
80100c15:	c7 04 24 21 6e 10 80 	movl   $0x80106e21,(%esp)
80100c1c:	e8 2f fa ff ff       	call   80100650 <cprintf>
    return -1;
80100c21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c26:	e9 e7 fd ff ff       	jmp    80100a12 <exec+0x72>
80100c2b:	89 f2                	mov    %esi,%edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c2d:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c34:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c38:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
80100c3f:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c45:	89 da                	mov    %ebx,%edx
80100c47:	29 c2                	sub    %eax,%edx

  sp -= (3+argc+1) * 4;
80100c49:	83 c0 0c             	add    $0xc,%eax
80100c4c:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c4e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c52:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c58:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c5c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100c60:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c67:	ff ff ff 
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c6a:	89 04 24             	mov    %eax,(%esp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c6d:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c73:	e8 18 60 00 00       	call   80106c90 <copyout>
80100c78:	85 c0                	test   %eax,%eax
80100c7a:	0f 88 78 ff ff ff    	js     80100bf8 <exec+0x258>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c80:	8b 45 08             	mov    0x8(%ebp),%eax
80100c83:	0f b6 10             	movzbl (%eax),%edx
80100c86:	84 d2                	test   %dl,%dl
80100c88:	74 19                	je     80100ca3 <exec+0x303>
80100c8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100c8d:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100c90:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c93:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100c96:	0f 44 c8             	cmove  %eax,%ecx
80100c99:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c9c:	84 d2                	test   %dl,%dl
80100c9e:	75 f0                	jne    80100c90 <exec+0x2f0>
80100ca0:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ca3:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100ca9:	8b 45 08             	mov    0x8(%ebp),%eax
80100cac:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cb3:	00 
80100cb4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cb8:	89 f8                	mov    %edi,%eax
80100cba:	83 c0 70             	add    $0x70,%eax
80100cbd:	89 04 24             	mov    %eax,(%esp)
80100cc0:	e8 8b 37 00 00       	call   80104450 <safestrcpy>
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cc5:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100ccb:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100cd1:	8b 77 08             	mov    0x8(%edi),%esi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->sb = sb;
80100cd4:	c7 47 04 00 f0 ff 7f 	movl   $0x7ffff000,0x4(%edi)
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cdb:	05 ff 0f 00 00       	add    $0xfff,%eax
80100ce0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ce5:	89 07                	mov    %eax,(%edi)
  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->sb = sb;
  curproc->tf->eip = elf.entry;  // main
80100ce7:	8b 47 1c             	mov    0x1c(%edi),%eax
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100cea:	89 57 08             	mov    %edx,0x8(%edi)
  curproc->sz = sz;
  curproc->sb = sb;
  curproc->tf->eip = elf.entry;  // main
80100ced:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100cf3:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100cf6:	8b 47 1c             	mov    0x1c(%edi),%eax
80100cf9:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100cfc:	89 3c 24             	mov    %edi,(%esp)
80100cff:	e8 bc 58 00 00       	call   801065c0 <switchuvm>
  freevm(oldpgdir);
80100d04:	89 34 24             	mov    %esi,(%esp)
80100d07:	e8 34 5c 00 00       	call   80106940 <freevm>
  return 0;
80100d0c:	31 c0                	xor    %eax,%eax
80100d0e:	e9 ff fc ff ff       	jmp    80100a12 <exec+0x72>
  //clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = KERNBASE - 4;
  sb = KERNBASE - PGSIZE;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d13:	bb fc ff ff 7f       	mov    $0x7ffffffc,%ebx
80100d18:	31 d2                	xor    %edx,%edx
80100d1a:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d20:	e9 08 ff ff ff       	jmp    80100c2d <exec+0x28d>
80100d25:	66 90                	xchg   %ax,%ax
80100d27:	66 90                	xchg   %ax,%ax
80100d29:	66 90                	xchg   %ax,%ax
80100d2b:	66 90                	xchg   %ax,%ax
80100d2d:	66 90                	xchg   %ax,%ax
80100d2f:	90                   	nop

80100d30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d30:	55                   	push   %ebp
80100d31:	89 e5                	mov    %esp,%ebp
80100d33:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d36:	c7 44 24 04 2d 6e 10 	movl   $0x80106e2d,0x4(%esp)
80100d3d:	80 
80100d3e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d45:	e8 f6 32 00 00       	call   80104040 <initlock>
}
80100d4a:	c9                   	leave  
80100d4b:	c3                   	ret    
80100d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d54:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d59:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d5c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d63:	e8 c8 33 00 00       	call   80104130 <acquire>
80100d68:	eb 11                	jmp    80100d7b <filealloc+0x2b>
80100d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d70:	83 c3 18             	add    $0x18,%ebx
80100d73:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d79:	74 25                	je     80100da0 <filealloc+0x50>
    if(f->ref == 0){
80100d7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d7e:	85 c0                	test   %eax,%eax
80100d80:	75 ee                	jne    80100d70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d82:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100d89:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d90:	e8 8b 34 00 00       	call   80104220 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d95:	83 c4 14             	add    $0x14,%esp
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
80100d98:	89 d8                	mov    %ebx,%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d9a:	5b                   	pop    %ebx
80100d9b:	5d                   	pop    %ebp
80100d9c:	c3                   	ret    
80100d9d:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100da0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100da7:	e8 74 34 00 00       	call   80104220 <release>
  return 0;
}
80100dac:	83 c4 14             	add    $0x14,%esp
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
80100daf:	31 c0                	xor    %eax,%eax
}
80100db1:	5b                   	pop    %ebx
80100db2:	5d                   	pop    %ebp
80100db3:	c3                   	ret    
80100db4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100dc0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dc0:	55                   	push   %ebp
80100dc1:	89 e5                	mov    %esp,%ebp
80100dc3:	53                   	push   %ebx
80100dc4:	83 ec 14             	sub    $0x14,%esp
80100dc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dca:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dd1:	e8 5a 33 00 00       	call   80104130 <acquire>
  if(f->ref < 1)
80100dd6:	8b 43 04             	mov    0x4(%ebx),%eax
80100dd9:	85 c0                	test   %eax,%eax
80100ddb:	7e 1a                	jle    80100df7 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100ddd:	83 c0 01             	add    $0x1,%eax
80100de0:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100de3:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dea:	e8 31 34 00 00       	call   80104220 <release>
  return f;
}
80100def:	83 c4 14             	add    $0x14,%esp
80100df2:	89 d8                	mov    %ebx,%eax
80100df4:	5b                   	pop    %ebx
80100df5:	5d                   	pop    %ebp
80100df6:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100df7:	c7 04 24 34 6e 10 80 	movl   $0x80106e34,(%esp)
80100dfe:	e8 5d f5 ff ff       	call   80100360 <panic>
80100e03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e10 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	57                   	push   %edi
80100e14:	56                   	push   %esi
80100e15:	53                   	push   %ebx
80100e16:	83 ec 1c             	sub    $0x1c,%esp
80100e19:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e1c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e23:	e8 08 33 00 00       	call   80104130 <acquire>
  if(f->ref < 1)
80100e28:	8b 57 04             	mov    0x4(%edi),%edx
80100e2b:	85 d2                	test   %edx,%edx
80100e2d:	0f 8e 89 00 00 00    	jle    80100ebc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e33:	83 ea 01             	sub    $0x1,%edx
80100e36:	85 d2                	test   %edx,%edx
80100e38:	89 57 04             	mov    %edx,0x4(%edi)
80100e3b:	74 13                	je     80100e50 <fileclose+0x40>
    release(&ftable.lock);
80100e3d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e44:	83 c4 1c             	add    $0x1c,%esp
80100e47:	5b                   	pop    %ebx
80100e48:	5e                   	pop    %esi
80100e49:	5f                   	pop    %edi
80100e4a:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e4b:	e9 d0 33 00 00       	jmp    80104220 <release>
    return;
  }
  ff = *f;
80100e50:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e54:	8b 37                	mov    (%edi),%esi
80100e56:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
80100e59:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e5f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e62:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e65:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e6f:	e8 ac 33 00 00       	call   80104220 <release>

  if(ff.type == FD_PIPE)
80100e74:	83 fe 01             	cmp    $0x1,%esi
80100e77:	74 0f                	je     80100e88 <fileclose+0x78>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e79:	83 fe 02             	cmp    $0x2,%esi
80100e7c:	74 22                	je     80100ea0 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e7e:	83 c4 1c             	add    $0x1c,%esp
80100e81:	5b                   	pop    %ebx
80100e82:	5e                   	pop    %esi
80100e83:	5f                   	pop    %edi
80100e84:	5d                   	pop    %ebp
80100e85:	c3                   	ret    
80100e86:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100e88:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100e8c:	89 1c 24             	mov    %ebx,(%esp)
80100e8f:	89 74 24 04          	mov    %esi,0x4(%esp)
80100e93:	e8 b8 23 00 00       	call   80103250 <pipeclose>
80100e98:	eb e4                	jmp    80100e7e <fileclose+0x6e>
80100e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ea0:	e8 5b 1c 00 00       	call   80102b00 <begin_op>
    iput(ff.ip);
80100ea5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ea8:	89 04 24             	mov    %eax,(%esp)
80100eab:	e8 10 09 00 00       	call   801017c0 <iput>
    end_op();
  }
}
80100eb0:	83 c4 1c             	add    $0x1c,%esp
80100eb3:	5b                   	pop    %ebx
80100eb4:	5e                   	pop    %esi
80100eb5:	5f                   	pop    %edi
80100eb6:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eb7:	e9 b4 1c 00 00       	jmp    80102b70 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100ebc:	c7 04 24 3c 6e 10 80 	movl   $0x80106e3c,(%esp)
80100ec3:	e8 98 f4 ff ff       	call   80100360 <panic>
80100ec8:	90                   	nop
80100ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ed0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ed0:	55                   	push   %ebp
80100ed1:	89 e5                	mov    %esp,%ebp
80100ed3:	53                   	push   %ebx
80100ed4:	83 ec 14             	sub    $0x14,%esp
80100ed7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100edd:	75 31                	jne    80100f10 <filestat+0x40>
    ilock(f->ip);
80100edf:	8b 43 10             	mov    0x10(%ebx),%eax
80100ee2:	89 04 24             	mov    %eax,(%esp)
80100ee5:	e8 b6 07 00 00       	call   801016a0 <ilock>
    stati(f->ip, st);
80100eea:	8b 45 0c             	mov    0xc(%ebp),%eax
80100eed:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ef1:	8b 43 10             	mov    0x10(%ebx),%eax
80100ef4:	89 04 24             	mov    %eax,(%esp)
80100ef7:	e8 24 0a 00 00       	call   80101920 <stati>
    iunlock(f->ip);
80100efc:	8b 43 10             	mov    0x10(%ebx),%eax
80100eff:	89 04 24             	mov    %eax,(%esp)
80100f02:	e8 79 08 00 00       	call   80101780 <iunlock>
    return 0;
  }
  return -1;
}
80100f07:	83 c4 14             	add    $0x14,%esp
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
80100f0a:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f0c:	5b                   	pop    %ebx
80100f0d:	5d                   	pop    %ebp
80100f0e:	c3                   	ret    
80100f0f:	90                   	nop
80100f10:	83 c4 14             	add    $0x14,%esp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f18:	5b                   	pop    %ebx
80100f19:	5d                   	pop    %ebp
80100f1a:	c3                   	ret    
80100f1b:	90                   	nop
80100f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f20 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	57                   	push   %edi
80100f24:	56                   	push   %esi
80100f25:	53                   	push   %ebx
80100f26:	83 ec 1c             	sub    $0x1c,%esp
80100f29:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f2f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f32:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f36:	74 68                	je     80100fa0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f38:	8b 03                	mov    (%ebx),%eax
80100f3a:	83 f8 01             	cmp    $0x1,%eax
80100f3d:	74 49                	je     80100f88 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f3f:	83 f8 02             	cmp    $0x2,%eax
80100f42:	75 63                	jne    80100fa7 <fileread+0x87>
    ilock(f->ip);
80100f44:	8b 43 10             	mov    0x10(%ebx),%eax
80100f47:	89 04 24             	mov    %eax,(%esp)
80100f4a:	e8 51 07 00 00       	call   801016a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f4f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f53:	8b 43 14             	mov    0x14(%ebx),%eax
80100f56:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f5a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f5e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f61:	89 04 24             	mov    %eax,(%esp)
80100f64:	e8 e7 09 00 00       	call   80101950 <readi>
80100f69:	85 c0                	test   %eax,%eax
80100f6b:	89 c6                	mov    %eax,%esi
80100f6d:	7e 03                	jle    80100f72 <fileread+0x52>
      f->off += r;
80100f6f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f72:	8b 43 10             	mov    0x10(%ebx),%eax
80100f75:	89 04 24             	mov    %eax,(%esp)
80100f78:	e8 03 08 00 00       	call   80101780 <iunlock>
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7d:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f7f:	83 c4 1c             	add    $0x1c,%esp
80100f82:	5b                   	pop    %ebx
80100f83:	5e                   	pop    %esi
80100f84:	5f                   	pop    %edi
80100f85:	5d                   	pop    %ebp
80100f86:	c3                   	ret    
80100f87:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f88:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f8b:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f8e:	83 c4 1c             	add    $0x1c,%esp
80100f91:	5b                   	pop    %ebx
80100f92:	5e                   	pop    %esi
80100f93:	5f                   	pop    %edi
80100f94:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f95:	e9 36 24 00 00       	jmp    801033d0 <piperead>
80100f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fa5:	eb d8                	jmp    80100f7f <fileread+0x5f>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fa7:	c7 04 24 46 6e 10 80 	movl   $0x80106e46,(%esp)
80100fae:	e8 ad f3 ff ff       	call   80100360 <panic>
80100fb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fc0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	57                   	push   %edi
80100fc4:	56                   	push   %esi
80100fc5:	53                   	push   %ebx
80100fc6:	83 ec 2c             	sub    $0x2c,%esp
80100fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fcc:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fcf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fd2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fd5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100fdc:	0f 84 ae 00 00 00    	je     80101090 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80100fe2:	8b 07                	mov    (%edi),%eax
80100fe4:	83 f8 01             	cmp    $0x1,%eax
80100fe7:	0f 84 c2 00 00 00    	je     801010af <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fed:	83 f8 02             	cmp    $0x2,%eax
80100ff0:	0f 85 d7 00 00 00    	jne    801010cd <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ff9:	31 db                	xor    %ebx,%ebx
80100ffb:	85 c0                	test   %eax,%eax
80100ffd:	7f 31                	jg     80101030 <filewrite+0x70>
80100fff:	e9 9c 00 00 00       	jmp    801010a0 <filewrite+0xe0>
80101004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101008:	8b 4f 10             	mov    0x10(%edi),%ecx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
8010100b:	01 47 14             	add    %eax,0x14(%edi)
8010100e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101011:	89 0c 24             	mov    %ecx,(%esp)
80101014:	e8 67 07 00 00       	call   80101780 <iunlock>
      end_op();
80101019:	e8 52 1b 00 00       	call   80102b70 <end_op>
8010101e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101021:	39 f0                	cmp    %esi,%eax
80101023:	0f 85 98 00 00 00    	jne    801010c1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101029:	01 c3                	add    %eax,%ebx
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010102b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010102e:	7e 70                	jle    801010a0 <filewrite+0xe0>
      int n1 = n - i;
80101030:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101033:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101038:	29 de                	sub    %ebx,%esi
8010103a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
80101040:	0f 4f f0             	cmovg  %eax,%esi
      if(n1 > max)
        n1 = max;

      begin_op();
80101043:	e8 b8 1a 00 00       	call   80102b00 <begin_op>
      ilock(f->ip);
80101048:	8b 47 10             	mov    0x10(%edi),%eax
8010104b:	89 04 24             	mov    %eax,(%esp)
8010104e:	e8 4d 06 00 00       	call   801016a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101053:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101057:	8b 47 14             	mov    0x14(%edi),%eax
8010105a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010105e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101061:	01 d8                	add    %ebx,%eax
80101063:	89 44 24 04          	mov    %eax,0x4(%esp)
80101067:	8b 47 10             	mov    0x10(%edi),%eax
8010106a:	89 04 24             	mov    %eax,(%esp)
8010106d:	e8 de 09 00 00       	call   80101a50 <writei>
80101072:	85 c0                	test   %eax,%eax
80101074:	7f 92                	jg     80101008 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
80101076:	8b 4f 10             	mov    0x10(%edi),%ecx
80101079:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010107c:	89 0c 24             	mov    %ecx,(%esp)
8010107f:	e8 fc 06 00 00       	call   80101780 <iunlock>
      end_op();
80101084:	e8 e7 1a 00 00       	call   80102b70 <end_op>

      if(r < 0)
80101089:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010108c:	85 c0                	test   %eax,%eax
8010108e:	74 91                	je     80101021 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101090:	83 c4 2c             	add    $0x2c,%esp
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
80101093:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101098:	5b                   	pop    %ebx
80101099:	5e                   	pop    %esi
8010109a:	5f                   	pop    %edi
8010109b:	5d                   	pop    %ebp
8010109c:	c3                   	ret    
8010109d:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010a0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010a3:	89 d8                	mov    %ebx,%eax
801010a5:	75 e9                	jne    80101090 <filewrite+0xd0>
  }
  panic("filewrite");
}
801010a7:	83 c4 2c             	add    $0x2c,%esp
801010aa:	5b                   	pop    %ebx
801010ab:	5e                   	pop    %esi
801010ac:	5f                   	pop    %edi
801010ad:	5d                   	pop    %ebp
801010ae:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010af:	8b 47 0c             	mov    0xc(%edi),%eax
801010b2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b5:	83 c4 2c             	add    $0x2c,%esp
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010bc:	e9 1f 22 00 00       	jmp    801032e0 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010c1:	c7 04 24 4f 6e 10 80 	movl   $0x80106e4f,(%esp)
801010c8:	e8 93 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010cd:	c7 04 24 55 6e 10 80 	movl   $0x80106e55,(%esp)
801010d4:	e8 87 f2 ff ff       	call   80100360 <panic>
801010d9:	66 90                	xchg   %ax,%ax
801010db:	66 90                	xchg   %ax,%ax
801010dd:	66 90                	xchg   %ax,%ax
801010df:	90                   	nop

801010e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	57                   	push   %edi
801010e4:	56                   	push   %esi
801010e5:	53                   	push   %ebx
801010e6:	83 ec 2c             	sub    $0x2c,%esp
801010e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010ec:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801010f1:	85 c0                	test   %eax,%eax
801010f3:	0f 84 8c 00 00 00    	je     80101185 <balloc+0xa5>
801010f9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101100:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101103:	89 f0                	mov    %esi,%eax
80101105:	c1 f8 0c             	sar    $0xc,%eax
80101108:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010110e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101112:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101115:	89 04 24             	mov    %eax,(%esp)
80101118:	e8 b3 ef ff ff       	call   801000d0 <bread>
8010111d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101120:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101125:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101128:	31 c0                	xor    %eax,%eax
8010112a:	eb 33                	jmp    8010115f <balloc+0x7f>
8010112c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101130:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101133:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101135:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101137:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010113a:	83 e1 07             	and    $0x7,%ecx
8010113d:	bf 01 00 00 00       	mov    $0x1,%edi
80101142:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101144:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101149:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010114b:	0f b6 fb             	movzbl %bl,%edi
8010114e:	85 cf                	test   %ecx,%edi
80101150:	74 46                	je     80101198 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101152:	83 c0 01             	add    $0x1,%eax
80101155:	83 c6 01             	add    $0x1,%esi
80101158:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010115d:	74 05                	je     80101164 <balloc+0x84>
8010115f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101162:	72 cc                	jb     80101130 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101164:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101167:	89 04 24             	mov    %eax,(%esp)
8010116a:	e8 71 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010116f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101176:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101179:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
8010117f:	0f 82 7b ff ff ff    	jb     80101100 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101185:	c7 04 24 5f 6e 10 80 	movl   $0x80106e5f,(%esp)
8010118c:	e8 cf f1 ff ff       	call   80100360 <panic>
80101191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101198:	09 d9                	or     %ebx,%ecx
8010119a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010119d:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011a1:	89 1c 24             	mov    %ebx,(%esp)
801011a4:	e8 f7 1a 00 00       	call   80102ca0 <log_write>
        brelse(bp);
801011a9:	89 1c 24             	mov    %ebx,(%esp)
801011ac:	e8 2f f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011b4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011b8:	89 04 24             	mov    %eax,(%esp)
801011bb:	e8 10 ef ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801011c0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011c7:	00 
801011c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011cf:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011d0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011d2:	8d 40 5c             	lea    0x5c(%eax),%eax
801011d5:	89 04 24             	mov    %eax,(%esp)
801011d8:	e8 93 30 00 00       	call   80104270 <memset>
  log_write(bp);
801011dd:	89 1c 24             	mov    %ebx,(%esp)
801011e0:	e8 bb 1a 00 00       	call   80102ca0 <log_write>
  brelse(bp);
801011e5:	89 1c 24             	mov    %ebx,(%esp)
801011e8:	e8 f3 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011ed:	83 c4 2c             	add    $0x2c,%esp
801011f0:	89 f0                	mov    %esi,%eax
801011f2:	5b                   	pop    %ebx
801011f3:	5e                   	pop    %esi
801011f4:	5f                   	pop    %edi
801011f5:	5d                   	pop    %ebp
801011f6:	c3                   	ret    
801011f7:	89 f6                	mov    %esi,%esi
801011f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101200 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101200:	55                   	push   %ebp
80101201:	89 e5                	mov    %esp,%ebp
80101203:	57                   	push   %edi
80101204:	89 c7                	mov    %eax,%edi
80101206:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101207:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101209:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010120a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010120f:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101212:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101219:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010121c:	e8 0f 2f 00 00       	call   80104130 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101221:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101224:	eb 14                	jmp    8010123a <iget+0x3a>
80101226:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101228:	85 f6                	test   %esi,%esi
8010122a:	74 3c                	je     80101268 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101232:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101238:	74 46                	je     80101280 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010123a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010123d:	85 c9                	test   %ecx,%ecx
8010123f:	7e e7                	jle    80101228 <iget+0x28>
80101241:	39 3b                	cmp    %edi,(%ebx)
80101243:	75 e3                	jne    80101228 <iget+0x28>
80101245:	39 53 04             	cmp    %edx,0x4(%ebx)
80101248:	75 de                	jne    80101228 <iget+0x28>
      ip->ref++;
8010124a:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
8010124d:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010124f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101256:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101259:	e8 c2 2f 00 00       	call   80104220 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010125e:	83 c4 1c             	add    $0x1c,%esp
80101261:	89 f0                	mov    %esi,%eax
80101263:	5b                   	pop    %ebx
80101264:	5e                   	pop    %esi
80101265:	5f                   	pop    %edi
80101266:	5d                   	pop    %ebp
80101267:	c3                   	ret    
80101268:	85 c9                	test   %ecx,%ecx
8010126a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010126d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101273:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101279:	75 bf                	jne    8010123a <iget+0x3a>
8010127b:	90                   	nop
8010127c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 29                	je     801012ad <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101284:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101286:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101289:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101290:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101297:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010129e:	e8 7d 2f 00 00       	call   80104220 <release>

  return ip;
}
801012a3:	83 c4 1c             	add    $0x1c,%esp
801012a6:	89 f0                	mov    %esi,%eax
801012a8:	5b                   	pop    %ebx
801012a9:	5e                   	pop    %esi
801012aa:	5f                   	pop    %edi
801012ab:	5d                   	pop    %ebp
801012ac:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012ad:	c7 04 24 75 6e 10 80 	movl   $0x80106e75,(%esp)
801012b4:	e8 a7 f0 ff ff       	call   80100360 <panic>
801012b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012c0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	89 c3                	mov    %eax,%ebx
801012c8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012cb:	83 fa 0b             	cmp    $0xb,%edx
801012ce:	77 18                	ja     801012e8 <bmap+0x28>
801012d0:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
801012d3:	8b 46 5c             	mov    0x5c(%esi),%eax
801012d6:	85 c0                	test   %eax,%eax
801012d8:	74 66                	je     80101340 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012da:	83 c4 1c             	add    $0x1c,%esp
801012dd:	5b                   	pop    %ebx
801012de:	5e                   	pop    %esi
801012df:	5f                   	pop    %edi
801012e0:	5d                   	pop    %ebp
801012e1:	c3                   	ret    
801012e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801012e8:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
801012eb:	83 fe 7f             	cmp    $0x7f,%esi
801012ee:	77 77                	ja     80101367 <bmap+0xa7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801012f0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	74 5e                	je     80101358 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801012fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801012fe:	8b 03                	mov    (%ebx),%eax
80101300:	89 04 24             	mov    %eax,(%esp)
80101303:	e8 c8 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101308:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010130c:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010130e:	8b 32                	mov    (%edx),%esi
80101310:	85 f6                	test   %esi,%esi
80101312:	75 19                	jne    8010132d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101314:	8b 03                	mov    (%ebx),%eax
80101316:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101319:	e8 c2 fd ff ff       	call   801010e0 <balloc>
8010131e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101321:	89 02                	mov    %eax,(%edx)
80101323:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101325:	89 3c 24             	mov    %edi,(%esp)
80101328:	e8 73 19 00 00       	call   80102ca0 <log_write>
    }
    brelse(bp);
8010132d:	89 3c 24             	mov    %edi,(%esp)
80101330:	e8 ab ee ff ff       	call   801001e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
80101335:	83 c4 1c             	add    $0x1c,%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101338:	89 f0                	mov    %esi,%eax
    return addr;
  }

  panic("bmap: out of range");
}
8010133a:	5b                   	pop    %ebx
8010133b:	5e                   	pop    %esi
8010133c:	5f                   	pop    %edi
8010133d:	5d                   	pop    %ebp
8010133e:	c3                   	ret    
8010133f:	90                   	nop
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101340:	8b 03                	mov    (%ebx),%eax
80101342:	e8 99 fd ff ff       	call   801010e0 <balloc>
80101347:	89 46 5c             	mov    %eax,0x5c(%esi)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010134a:	83 c4 1c             	add    $0x1c,%esp
8010134d:	5b                   	pop    %ebx
8010134e:	5e                   	pop    %esi
8010134f:	5f                   	pop    %edi
80101350:	5d                   	pop    %ebp
80101351:	c3                   	ret    
80101352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101358:	8b 03                	mov    (%ebx),%eax
8010135a:	e8 81 fd ff ff       	call   801010e0 <balloc>
8010135f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101365:	eb 93                	jmp    801012fa <bmap+0x3a>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101367:	c7 04 24 85 6e 10 80 	movl   $0x80106e85,(%esp)
8010136e:	e8 ed ef ff ff       	call   80100360 <panic>
80101373:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101380 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	56                   	push   %esi
80101384:	53                   	push   %ebx
80101385:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101388:	8b 45 08             	mov    0x8(%ebp),%eax
8010138b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101392:	00 
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101393:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101396:	89 04 24             	mov    %eax,(%esp)
80101399:	e8 32 ed ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010139e:	89 34 24             	mov    %esi,(%esp)
801013a1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013a8:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
801013a9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013ab:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801013b2:	e8 59 2f 00 00       	call   80104310 <memmove>
  brelse(bp);
801013b7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013ba:	83 c4 10             	add    $0x10,%esp
801013bd:	5b                   	pop    %ebx
801013be:	5e                   	pop    %esi
801013bf:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013c0:	e9 1b ee ff ff       	jmp    801001e0 <brelse>
801013c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	57                   	push   %edi
801013d4:	89 d7                	mov    %edx,%edi
801013d6:	56                   	push   %esi
801013d7:	53                   	push   %ebx
801013d8:	89 c3                	mov    %eax,%ebx
801013da:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013dd:	89 04 24             	mov    %eax,(%esp)
801013e0:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801013e7:	80 
801013e8:	e8 93 ff ff ff       	call   80101380 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013ed:	89 fa                	mov    %edi,%edx
801013ef:	c1 ea 0c             	shr    $0xc,%edx
801013f2:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801013f8:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
801013fb:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
80101400:	89 54 24 04          	mov    %edx,0x4(%esp)
80101404:	e8 c7 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101409:	89 f9                	mov    %edi,%ecx
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
8010140b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101411:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101413:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101416:	c1 fa 03             	sar    $0x3,%edx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101419:	d3 e3                	shl    %cl,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
8010141b:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
8010141d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101422:	0f b6 c8             	movzbl %al,%ecx
80101425:	85 d9                	test   %ebx,%ecx
80101427:	74 20                	je     80101449 <bfree+0x79>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101429:	f7 d3                	not    %ebx
8010142b:	21 c3                	and    %eax,%ebx
8010142d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101431:	89 34 24             	mov    %esi,(%esp)
80101434:	e8 67 18 00 00       	call   80102ca0 <log_write>
  brelse(bp);
80101439:	89 34 24             	mov    %esi,(%esp)
8010143c:	e8 9f ed ff ff       	call   801001e0 <brelse>
}
80101441:	83 c4 1c             	add    $0x1c,%esp
80101444:	5b                   	pop    %ebx
80101445:	5e                   	pop    %esi
80101446:	5f                   	pop    %edi
80101447:	5d                   	pop    %ebp
80101448:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101449:	c7 04 24 98 6e 10 80 	movl   $0x80106e98,(%esp)
80101450:	e8 0b ef ff ff       	call   80100360 <panic>
80101455:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101460 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	53                   	push   %ebx
80101464:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101469:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010146c:	c7 44 24 04 ab 6e 10 	movl   $0x80106eab,0x4(%esp)
80101473:	80 
80101474:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010147b:	e8 c0 2b 00 00       	call   80104040 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101480:	89 1c 24             	mov    %ebx,(%esp)
80101483:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101489:	c7 44 24 04 b2 6e 10 	movl   $0x80106eb2,0x4(%esp)
80101490:	80 
80101491:	e8 9a 2a 00 00       	call   80103f30 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101496:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010149c:	75 e2                	jne    80101480 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010149e:	8b 45 08             	mov    0x8(%ebp),%eax
801014a1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014a8:	80 
801014a9:	89 04 24             	mov    %eax,(%esp)
801014ac:	e8 cf fe ff ff       	call   80101380 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014b1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014b6:	c7 04 24 18 6f 10 80 	movl   $0x80106f18,(%esp)
801014bd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014c1:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801014c6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014ca:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801014cf:	89 44 24 14          	mov    %eax,0x14(%esp)
801014d3:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801014d8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014dc:	a1 c8 09 11 80       	mov    0x801109c8,%eax
801014e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801014e5:	a1 c4 09 11 80       	mov    0x801109c4,%eax
801014ea:	89 44 24 08          	mov    %eax,0x8(%esp)
801014ee:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801014f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801014f7:	e8 54 f1 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014fc:	83 c4 24             	add    $0x24,%esp
801014ff:	5b                   	pop    %ebx
80101500:	5d                   	pop    %ebp
80101501:	c3                   	ret    
80101502:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101510 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 2c             	sub    $0x2c,%esp
80101519:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010151c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101523:	8b 7d 08             	mov    0x8(%ebp),%edi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 a2 00 00 00    	jbe    801015d1 <ialloc+0xc1>
8010152f:	be 01 00 00 00       	mov    $0x1,%esi
80101534:	bb 01 00 00 00       	mov    $0x1,%ebx
80101539:	eb 1a                	jmp    80101555 <ialloc+0x45>
8010153b:	90                   	nop
8010153c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101540:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101546:	e8 95 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010154b:	89 de                	mov    %ebx,%esi
8010154d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101553:	73 7c                	jae    801015d1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101555:	89 f0                	mov    %esi,%eax
80101557:	c1 e8 03             	shr    $0x3,%eax
8010155a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101560:	89 3c 24             	mov    %edi,(%esp)
80101563:	89 44 24 04          	mov    %eax,0x4(%esp)
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 f0                	mov    %esi,%eax
80101570:	83 e0 07             	and    $0x7,%eax
80101573:	c1 e0 06             	shl    $0x6,%eax
80101576:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010157e:	75 c0                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101580:	89 0c 24             	mov    %ecx,(%esp)
80101583:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010158a:	00 
8010158b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101592:	00 
80101593:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101599:	e8 d2 2c 00 00       	call   80104270 <memset>
      dip->type = type;
8010159e:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015a5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015a8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015ab:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ae:	89 14 24             	mov    %edx,(%esp)
801015b1:	e8 ea 16 00 00       	call   80102ca0 <log_write>
      brelse(bp);
801015b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015b9:	89 14 24             	mov    %edx,(%esp)
801015bc:	e8 1f ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015c1:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015c4:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015c6:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015c7:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015c9:	5e                   	pop    %esi
801015ca:	5f                   	pop    %edi
801015cb:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015cc:	e9 2f fc ff ff       	jmp    80101200 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015d1:	c7 04 24 b8 6e 10 80 	movl   $0x80106eb8,(%esp)
801015d8:	e8 83 ed ff ff       	call   80100360 <panic>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi

801015e0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	83 ec 10             	sub    $0x10,%esp
801015e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801015fe:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101601:	89 04 24             	mov    %eax,(%esp)
80101604:	e8 c7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101609:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010160c:	83 e2 07             	and    $0x7,%edx
8010160f:	c1 e2 06             	shl    $0x6,%edx
80101612:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101616:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101618:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161c:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
8010161f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101623:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101627:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010162b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010162f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101633:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101637:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010163b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010163e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101641:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101645:	89 14 24             	mov    %edx,(%esp)
80101648:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010164f:	00 
80101650:	e8 bb 2c 00 00       	call   80104310 <memmove>
  log_write(bp);
80101655:	89 34 24             	mov    %esi,(%esp)
80101658:	e8 43 16 00 00       	call   80102ca0 <log_write>
  brelse(bp);
8010165d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101660:	83 c4 10             	add    $0x10,%esp
80101663:	5b                   	pop    %ebx
80101664:	5e                   	pop    %esi
80101665:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101666:	e9 75 eb ff ff       	jmp    801001e0 <brelse>
8010166b:	90                   	nop
8010166c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101670 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	53                   	push   %ebx
80101674:	83 ec 14             	sub    $0x14,%esp
80101677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010167a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101681:	e8 aa 2a 00 00       	call   80104130 <acquire>
  ip->ref++;
80101686:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010168a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101691:	e8 8a 2b 00 00       	call   80104220 <release>
  return ip;
}
80101696:	83 c4 14             	add    $0x14,%esp
80101699:	89 d8                	mov    %ebx,%eax
8010169b:	5b                   	pop    %ebx
8010169c:	5d                   	pop    %ebp
8010169d:	c3                   	ret    
8010169e:	66 90                	xchg   %ax,%ax

801016a0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	56                   	push   %esi
801016a4:	53                   	push   %ebx
801016a5:	83 ec 10             	sub    $0x10,%esp
801016a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016ab:	85 db                	test   %ebx,%ebx
801016ad:	0f 84 b3 00 00 00    	je     80101766 <ilock+0xc6>
801016b3:	8b 53 08             	mov    0x8(%ebx),%edx
801016b6:	85 d2                	test   %edx,%edx
801016b8:	0f 8e a8 00 00 00    	jle    80101766 <ilock+0xc6>
    panic("ilock");

  acquiresleep(&ip->lock);
801016be:	8d 43 0c             	lea    0xc(%ebx),%eax
801016c1:	89 04 24             	mov    %eax,(%esp)
801016c4:	e8 a7 28 00 00       	call   80103f70 <acquiresleep>

  if(ip->valid == 0){
801016c9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016cc:	85 c0                	test   %eax,%eax
801016ce:	74 08                	je     801016d8 <ilock+0x38>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016d0:	83 c4 10             	add    $0x10,%esp
801016d3:	5b                   	pop    %ebx
801016d4:	5e                   	pop    %esi
801016d5:	5d                   	pop    %ebp
801016d6:	c3                   	ret    
801016d7:	90                   	nop
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
801016db:	c1 e8 03             	shr    $0x3,%eax
801016de:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801016e8:	8b 03                	mov    (%ebx),%eax
801016ea:	89 04 24             	mov    %eax,(%esp)
801016ed:	e8 de e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016f2:	8b 53 04             	mov    0x4(%ebx),%edx
801016f5:	83 e2 07             	and    $0x7,%edx
801016f8:	c1 e2 06             	shl    $0x6,%edx
801016fb:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ff:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101701:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101704:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101707:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010170b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010170f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101713:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101717:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010171b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010171f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101723:	8b 42 fc             	mov    -0x4(%edx),%eax
80101726:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101729:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010172c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101730:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101737:	00 
80101738:	89 04 24             	mov    %eax,(%esp)
8010173b:	e8 d0 2b 00 00       	call   80104310 <memmove>
    brelse(bp);
80101740:	89 34 24             	mov    %esi,(%esp)
80101743:	e8 98 ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101748:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010174d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101754:	0f 85 76 ff ff ff    	jne    801016d0 <ilock+0x30>
      panic("ilock: no type");
8010175a:	c7 04 24 d0 6e 10 80 	movl   $0x80106ed0,(%esp)
80101761:	e8 fa eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101766:	c7 04 24 ca 6e 10 80 	movl   $0x80106eca,(%esp)
8010176d:	e8 ee eb ff ff       	call   80100360 <panic>
80101772:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101780 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	83 ec 10             	sub    $0x10,%esp
80101788:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010178b:	85 db                	test   %ebx,%ebx
8010178d:	74 24                	je     801017b3 <iunlock+0x33>
8010178f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101792:	89 34 24             	mov    %esi,(%esp)
80101795:	e8 76 28 00 00       	call   80104010 <holdingsleep>
8010179a:	85 c0                	test   %eax,%eax
8010179c:	74 15                	je     801017b3 <iunlock+0x33>
8010179e:	8b 43 08             	mov    0x8(%ebx),%eax
801017a1:	85 c0                	test   %eax,%eax
801017a3:	7e 0e                	jle    801017b3 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
801017a5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017a8:	83 c4 10             	add    $0x10,%esp
801017ab:	5b                   	pop    %ebx
801017ac:	5e                   	pop    %esi
801017ad:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017ae:	e9 1d 28 00 00       	jmp    80103fd0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017b3:	c7 04 24 df 6e 10 80 	movl   $0x80106edf,(%esp)
801017ba:	e8 a1 eb ff ff       	call   80100360 <panic>
801017bf:	90                   	nop

801017c0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 1c             	sub    $0x1c,%esp
801017c9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017cc:	8d 7e 0c             	lea    0xc(%esi),%edi
801017cf:	89 3c 24             	mov    %edi,(%esp)
801017d2:	e8 99 27 00 00       	call   80103f70 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017d7:	8b 56 4c             	mov    0x4c(%esi),%edx
801017da:	85 d2                	test   %edx,%edx
801017dc:	74 07                	je     801017e5 <iput+0x25>
801017de:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017e3:	74 2b                	je     80101810 <iput+0x50>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017e5:	89 3c 24             	mov    %edi,(%esp)
801017e8:	e8 e3 27 00 00       	call   80103fd0 <releasesleep>

  acquire(&icache.lock);
801017ed:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017f4:	e8 37 29 00 00       	call   80104130 <acquire>
  ip->ref--;
801017f9:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017fd:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101804:	83 c4 1c             	add    $0x1c,%esp
80101807:	5b                   	pop    %ebx
80101808:	5e                   	pop    %esi
80101809:	5f                   	pop    %edi
8010180a:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
8010180b:	e9 10 2a 00 00       	jmp    80104220 <release>
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101810:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101817:	e8 14 29 00 00       	call   80104130 <acquire>
    int r = ip->ref;
8010181c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010181f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101826:	e8 f5 29 00 00       	call   80104220 <release>
    if(r == 1){
8010182b:	83 fb 01             	cmp    $0x1,%ebx
8010182e:	75 b5                	jne    801017e5 <iput+0x25>
80101830:	8d 4e 30             	lea    0x30(%esi),%ecx
80101833:	89 f3                	mov    %esi,%ebx
80101835:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x87>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101843:	39 fb                	cmp    %edi,%ebx
80101845:	74 19                	je     80101860 <iput+0xa0>
    if(ip->addrs[i]){
80101847:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010184a:	85 d2                	test   %edx,%edx
8010184c:	74 f2                	je     80101840 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010184e:	8b 06                	mov    (%esi),%eax
80101850:	e8 7b fb ff ff       	call   801013d0 <bfree>
      ip->addrs[i] = 0;
80101855:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010185c:	eb e2                	jmp    80101840 <iput+0x80>
8010185e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101860:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 2b                	jne    80101898 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010186d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101874:	89 34 24             	mov    %esi,(%esp)
80101877:	e8 64 fd ff ff       	call   801015e0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010187c:	31 c0                	xor    %eax,%eax
8010187e:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101882:	89 34 24             	mov    %esi,(%esp)
80101885:	e8 56 fd ff ff       	call   801015e0 <iupdate>
      ip->valid = 0;
8010188a:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101891:	e9 4f ff ff ff       	jmp    801017e5 <iput+0x25>
80101896:	66 90                	xchg   %ax,%ax
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101898:	89 44 24 04          	mov    %eax,0x4(%esp)
8010189c:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
8010189e:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	89 04 24             	mov    %eax,(%esp)
801018a3:	e8 28 e8 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018a8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
801018ab:	8d 48 5c             	lea    0x5c(%eax),%ecx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018b1:	89 cf                	mov    %ecx,%edi
801018b3:	31 c0                	xor    %eax,%eax
801018b5:	eb 0e                	jmp    801018c5 <iput+0x105>
801018b7:	90                   	nop
801018b8:	83 c3 01             	add    $0x1,%ebx
801018bb:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018c1:	89 d8                	mov    %ebx,%eax
801018c3:	74 10                	je     801018d5 <iput+0x115>
      if(a[j])
801018c5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018c8:	85 d2                	test   %edx,%edx
801018ca:	74 ec                	je     801018b8 <iput+0xf8>
        bfree(ip->dev, a[j]);
801018cc:	8b 06                	mov    (%esi),%eax
801018ce:	e8 fd fa ff ff       	call   801013d0 <bfree>
801018d3:	eb e3                	jmp    801018b8 <iput+0xf8>
    }
    brelse(bp);
801018d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018d8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018db:	89 04 24             	mov    %eax,(%esp)
801018de:	e8 fd e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018e3:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018e9:	8b 06                	mov    (%esi),%eax
801018eb:	e8 e0 fa ff ff       	call   801013d0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f0:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018f7:	00 00 00 
801018fa:	e9 6e ff ff ff       	jmp    8010186d <iput+0xad>
801018ff:	90                   	nop

80101900 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	53                   	push   %ebx
80101904:	83 ec 14             	sub    $0x14,%esp
80101907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010190a:	89 1c 24             	mov    %ebx,(%esp)
8010190d:	e8 6e fe ff ff       	call   80101780 <iunlock>
  iput(ip);
80101912:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101915:	83 c4 14             	add    $0x14,%esp
80101918:	5b                   	pop    %ebx
80101919:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010191a:	e9 a1 fe ff ff       	jmp    801017c0 <iput>
8010191f:	90                   	nop

80101920 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	8b 55 08             	mov    0x8(%ebp),%edx
80101926:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101929:	8b 0a                	mov    (%edx),%ecx
8010192b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010192e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101931:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101934:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101938:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010193b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010193f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101943:	8b 52 58             	mov    0x58(%edx),%edx
80101946:	89 50 10             	mov    %edx,0x10(%eax)
}
80101949:	5d                   	pop    %ebp
8010194a:	c3                   	ret    
8010194b:	90                   	nop
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	57                   	push   %edi
80101954:	56                   	push   %esi
80101955:	53                   	push   %ebx
80101956:	83 ec 2c             	sub    $0x2c,%esp
80101959:	8b 45 0c             	mov    0xc(%ebp),%eax
8010195c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010195f:	8b 75 10             	mov    0x10(%ebp),%esi
80101962:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101965:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101968:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
8010196d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101970:	0f 84 aa 00 00 00    	je     80101a20 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101976:	8b 47 58             	mov    0x58(%edi),%eax
80101979:	39 f0                	cmp    %esi,%eax
8010197b:	0f 82 c7 00 00 00    	jb     80101a48 <readi+0xf8>
80101981:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101984:	89 da                	mov    %ebx,%edx
80101986:	01 f2                	add    %esi,%edx
80101988:	0f 82 ba 00 00 00    	jb     80101a48 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010198e:	89 c1                	mov    %eax,%ecx
80101990:	29 f1                	sub    %esi,%ecx
80101992:	39 d0                	cmp    %edx,%eax
80101994:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101997:	31 c0                	xor    %eax,%eax
80101999:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010199b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010199e:	74 70                	je     80101a10 <readi+0xc0>
801019a0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019a3:	89 c7                	mov    %eax,%edi
801019a5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019a8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019ab:	89 f2                	mov    %esi,%edx
801019ad:	c1 ea 09             	shr    $0x9,%edx
801019b0:	89 d8                	mov    %ebx,%eax
801019b2:	e8 09 f9 ff ff       	call   801012c0 <bmap>
801019b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019bb:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019bd:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c2:	89 04 24             	mov    %eax,(%esp)
801019c5:	e8 06 e7 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019cd:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019cf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019d1:	89 f0                	mov    %esi,%eax
801019d3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019d8:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019da:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019de:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801019e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019e7:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019ea:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ee:	01 df                	add    %ebx,%edi
801019f0:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
801019f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
801019f5:	89 04 24             	mov    %eax,(%esp)
801019f8:	e8 13 29 00 00       	call   80104310 <memmove>
    brelse(bp);
801019fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a00:	89 14 24             	mov    %edx,(%esp)
80101a03:	e8 d8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a08:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a0b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a0e:	77 98                	ja     801019a8 <readi+0x58>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a13:	83 c4 2c             	add    $0x2c,%esp
80101a16:	5b                   	pop    %ebx
80101a17:	5e                   	pop    %esi
80101a18:	5f                   	pop    %edi
80101a19:	5d                   	pop    %ebp
80101a1a:	c3                   	ret    
80101a1b:	90                   	nop
80101a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a20:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a24:	66 83 f8 09          	cmp    $0x9,%ax
80101a28:	77 1e                	ja     80101a48 <readi+0xf8>
80101a2a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a31:	85 c0                	test   %eax,%eax
80101a33:	74 13                	je     80101a48 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a35:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a38:	89 75 10             	mov    %esi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a3b:	83 c4 2c             	add    $0x2c,%esp
80101a3e:	5b                   	pop    %ebx
80101a3f:	5e                   	pop    %esi
80101a40:	5f                   	pop    %edi
80101a41:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a42:	ff e0                	jmp    *%eax
80101a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a4d:	eb c4                	jmp    80101a13 <readi+0xc3>
80101a4f:	90                   	nop

80101a50 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a50:	55                   	push   %ebp
80101a51:	89 e5                	mov    %esp,%ebp
80101a53:	57                   	push   %edi
80101a54:	56                   	push   %esi
80101a55:	53                   	push   %ebx
80101a56:	83 ec 2c             	sub    $0x2c,%esp
80101a59:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a5f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a67:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a6a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a6d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a70:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a73:	0f 84 b7 00 00 00    	je     80101b30 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a7c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a7f:	0f 82 e3 00 00 00    	jb     80101b68 <writei+0x118>
80101a85:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a88:	89 c8                	mov    %ecx,%eax
80101a8a:	01 f0                	add    %esi,%eax
80101a8c:	0f 82 d6 00 00 00    	jb     80101b68 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a92:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a97:	0f 87 cb 00 00 00    	ja     80101b68 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a9d:	85 c9                	test   %ecx,%ecx
80101a9f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101aa6:	74 77                	je     80101b1f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aa8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101aab:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101aad:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab2:	c1 ea 09             	shr    $0x9,%edx
80101ab5:	89 f8                	mov    %edi,%eax
80101ab7:	e8 04 f8 ff ff       	call   801012c0 <bmap>
80101abc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ac0:	8b 07                	mov    (%edi),%eax
80101ac2:	89 04 24             	mov    %eax,(%esp)
80101ac5:	e8 06 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aca:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101acd:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ad0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ad5:	89 f0                	mov    %esi,%eax
80101ad7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101adc:	29 c3                	sub    %eax,%ebx
80101ade:	39 cb                	cmp    %ecx,%ebx
80101ae0:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ae3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ae7:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ae9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101aed:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101af1:	89 04 24             	mov    %eax,(%esp)
80101af4:	e8 17 28 00 00       	call   80104310 <memmove>
    log_write(bp);
80101af9:	89 3c 24             	mov    %edi,(%esp)
80101afc:	e8 9f 11 00 00       	call   80102ca0 <log_write>
    brelse(bp);
80101b01:	89 3c 24             	mov    %edi,(%esp)
80101b04:	e8 d7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b09:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b0f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b12:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b15:	77 91                	ja     80101aa8 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b17:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b1d:	72 39                	jb     80101b58 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b22:	83 c4 2c             	add    $0x2c,%esp
80101b25:	5b                   	pop    %ebx
80101b26:	5e                   	pop    %esi
80101b27:	5f                   	pop    %edi
80101b28:	5d                   	pop    %ebp
80101b29:	c3                   	ret    
80101b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 2e                	ja     80101b68 <writei+0x118>
80101b3a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 23                	je     80101b68 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b45:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b48:	83 c4 2c             	add    $0x2c,%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b4f:	ff e0                	jmp    *%eax
80101b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b58:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b5b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b5e:	89 04 24             	mov    %eax,(%esp)
80101b61:	e8 7a fa ff ff       	call   801015e0 <iupdate>
80101b66:	eb b7                	jmp    80101b1f <writei+0xcf>
  }
  return n;
}
80101b68:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b70:	5b                   	pop    %ebx
80101b71:	5e                   	pop    %esi
80101b72:	5f                   	pop    %edi
80101b73:	5d                   	pop    %ebp
80101b74:	c3                   	ret    
80101b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b80 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101b86:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b89:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101b90:	00 
80101b91:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b95:	8b 45 08             	mov    0x8(%ebp),%eax
80101b98:	89 04 24             	mov    %eax,(%esp)
80101b9b:	e8 f0 27 00 00       	call   80104390 <strncmp>
}
80101ba0:	c9                   	leave  
80101ba1:	c3                   	ret    
80101ba2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 2c             	sub    $0x2c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 97 00 00 00    	jne    80101c5e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	75 0d                	jne    80101be0 <dirlookup+0x30>
80101bd3:	eb 73                	jmp    80101c48 <dirlookup+0x98>
80101bd5:	8d 76 00             	lea    0x0(%esi),%esi
80101bd8:	83 c7 10             	add    $0x10,%edi
80101bdb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bde:	76 68                	jbe    80101c48 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101be7:	00 
80101be8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101bec:	89 74 24 04          	mov    %esi,0x4(%esp)
80101bf0:	89 1c 24             	mov    %ebx,(%esp)
80101bf3:	e8 58 fd ff ff       	call   80101950 <readi>
80101bf8:	83 f8 10             	cmp    $0x10,%eax
80101bfb:	75 55                	jne    80101c52 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101bfd:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c02:	74 d4                	je     80101bd8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c04:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c07:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c0e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c15:	00 
80101c16:	89 04 24             	mov    %eax,(%esp)
80101c19:	e8 72 27 00 00       	call   80104390 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c1e:	85 c0                	test   %eax,%eax
80101c20:	75 b6                	jne    80101bd8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c22:	8b 45 10             	mov    0x10(%ebp),%eax
80101c25:	85 c0                	test   %eax,%eax
80101c27:	74 05                	je     80101c2e <dirlookup+0x7e>
        *poff = off;
80101c29:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c2e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c32:	8b 03                	mov    (%ebx),%eax
80101c34:	e8 c7 f5 ff ff       	call   80101200 <iget>
    }
  }

  return 0;
}
80101c39:	83 c4 2c             	add    $0x2c,%esp
80101c3c:	5b                   	pop    %ebx
80101c3d:	5e                   	pop    %esi
80101c3e:	5f                   	pop    %edi
80101c3f:	5d                   	pop    %ebp
80101c40:	c3                   	ret    
80101c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c48:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c4b:	31 c0                	xor    %eax,%eax
}
80101c4d:	5b                   	pop    %ebx
80101c4e:	5e                   	pop    %esi
80101c4f:	5f                   	pop    %edi
80101c50:	5d                   	pop    %ebp
80101c51:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c52:	c7 04 24 f9 6e 10 80 	movl   $0x80106ef9,(%esp)
80101c59:	e8 02 e7 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c5e:	c7 04 24 e7 6e 10 80 	movl   $0x80106ee7,(%esp)
80101c65:	e8 f6 e6 ff ff       	call   80100360 <panic>
80101c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	89 cf                	mov    %ecx,%edi
80101c76:	56                   	push   %esi
80101c77:	53                   	push   %ebx
80101c78:	89 c3                	mov    %eax,%ebx
80101c7a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c7d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c83:	0f 84 51 01 00 00    	je     80101dda <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c89:	e8 02 1a 00 00       	call   80103690 <myproc>
80101c8e:	8b 70 6c             	mov    0x6c(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c91:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c98:	e8 93 24 00 00       	call   80104130 <acquire>
  ip->ref++;
80101c9d:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101ca8:	e8 73 25 00 00       	call   80104220 <release>
80101cad:	eb 04                	jmp    80101cb3 <namex+0x43>
80101caf:	90                   	nop
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101cb0:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101cb3:	0f b6 03             	movzbl (%ebx),%eax
80101cb6:	3c 2f                	cmp    $0x2f,%al
80101cb8:	74 f6                	je     80101cb0 <namex+0x40>
    path++;
  if(*path == 0)
80101cba:	84 c0                	test   %al,%al
80101cbc:	0f 84 ed 00 00 00    	je     80101daf <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cc2:	0f b6 03             	movzbl (%ebx),%eax
80101cc5:	89 da                	mov    %ebx,%edx
80101cc7:	84 c0                	test   %al,%al
80101cc9:	0f 84 b1 00 00 00    	je     80101d80 <namex+0x110>
80101ccf:	3c 2f                	cmp    $0x2f,%al
80101cd1:	75 0f                	jne    80101ce2 <namex+0x72>
80101cd3:	e9 a8 00 00 00       	jmp    80101d80 <namex+0x110>
80101cd8:	3c 2f                	cmp    $0x2f,%al
80101cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101ce0:	74 0a                	je     80101cec <namex+0x7c>
    path++;
80101ce2:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101ce5:	0f b6 02             	movzbl (%edx),%eax
80101ce8:	84 c0                	test   %al,%al
80101cea:	75 ec                	jne    80101cd8 <namex+0x68>
80101cec:	89 d1                	mov    %edx,%ecx
80101cee:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101cf0:	83 f9 0d             	cmp    $0xd,%ecx
80101cf3:	0f 8e 8f 00 00 00    	jle    80101d88 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101cf9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101cfd:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d04:	00 
80101d05:	89 3c 24             	mov    %edi,(%esp)
80101d08:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d0b:	e8 00 26 00 00       	call   80104310 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d13:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d15:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d18:	75 0e                	jne    80101d28 <namex+0xb8>
80101d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d20:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d26:	74 f8                	je     80101d20 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d28:	89 34 24             	mov    %esi,(%esp)
80101d2b:	e8 70 f9 ff ff       	call   801016a0 <ilock>
    if(ip->type != T_DIR){
80101d30:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d35:	0f 85 85 00 00 00    	jne    80101dc0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d3e:	85 d2                	test   %edx,%edx
80101d40:	74 09                	je     80101d4b <namex+0xdb>
80101d42:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d45:	0f 84 a5 00 00 00    	je     80101df0 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d52:	00 
80101d53:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d57:	89 34 24             	mov    %esi,(%esp)
80101d5a:	e8 51 fe ff ff       	call   80101bb0 <dirlookup>
80101d5f:	85 c0                	test   %eax,%eax
80101d61:	74 5d                	je     80101dc0 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d63:	89 34 24             	mov    %esi,(%esp)
80101d66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d69:	e8 12 fa ff ff       	call   80101780 <iunlock>
  iput(ip);
80101d6e:	89 34 24             	mov    %esi,(%esp)
80101d71:	e8 4a fa ff ff       	call   801017c0 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d79:	89 c6                	mov    %eax,%esi
80101d7b:	e9 33 ff ff ff       	jmp    80101cb3 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d80:	31 c9                	xor    %ecx,%ecx
80101d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d88:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101d8c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d90:	89 3c 24             	mov    %edi,(%esp)
80101d93:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d96:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d99:	e8 72 25 00 00       	call   80104310 <memmove>
    name[len] = 0;
80101d9e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101da1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101da4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101da8:	89 d3                	mov    %edx,%ebx
80101daa:	e9 66 ff ff ff       	jmp    80101d15 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101daf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101db2:	85 c0                	test   %eax,%eax
80101db4:	75 4c                	jne    80101e02 <namex+0x192>
80101db6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101db8:	83 c4 2c             	add    $0x2c,%esp
80101dbb:	5b                   	pop    %ebx
80101dbc:	5e                   	pop    %esi
80101dbd:	5f                   	pop    %edi
80101dbe:	5d                   	pop    %ebp
80101dbf:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101dc0:	89 34 24             	mov    %esi,(%esp)
80101dc3:	e8 b8 f9 ff ff       	call   80101780 <iunlock>
  iput(ip);
80101dc8:	89 34 24             	mov    %esi,(%esp)
80101dcb:	e8 f0 f9 ff ff       	call   801017c0 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dd0:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101dd3:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dd5:	5b                   	pop    %ebx
80101dd6:	5e                   	pop    %esi
80101dd7:	5f                   	pop    %edi
80101dd8:	5d                   	pop    %ebp
80101dd9:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dda:	ba 01 00 00 00       	mov    $0x1,%edx
80101ddf:	b8 01 00 00 00       	mov    $0x1,%eax
80101de4:	e8 17 f4 ff ff       	call   80101200 <iget>
80101de9:	89 c6                	mov    %eax,%esi
80101deb:	e9 c3 fe ff ff       	jmp    80101cb3 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101df0:	89 34 24             	mov    %esi,(%esp)
80101df3:	e8 88 f9 ff ff       	call   80101780 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101df8:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101dfb:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dfd:	5b                   	pop    %ebx
80101dfe:	5e                   	pop    %esi
80101dff:	5f                   	pop    %edi
80101e00:	5d                   	pop    %ebp
80101e01:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e02:	89 34 24             	mov    %esi,(%esp)
80101e05:	e8 b6 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101e0a:	31 c0                	xor    %eax,%eax
80101e0c:	eb aa                	jmp    80101db8 <namex+0x148>
80101e0e:	66 90                	xchg   %ax,%ax

80101e10 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	57                   	push   %edi
80101e14:	56                   	push   %esi
80101e15:	53                   	push   %ebx
80101e16:	83 ec 2c             	sub    $0x2c,%esp
80101e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e1f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e26:	00 
80101e27:	89 1c 24             	mov    %ebx,(%esp)
80101e2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e2e:	e8 7d fd ff ff       	call   80101bb0 <dirlookup>
80101e33:	85 c0                	test   %eax,%eax
80101e35:	0f 85 8b 00 00 00    	jne    80101ec6 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e3b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e3e:	31 ff                	xor    %edi,%edi
80101e40:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e43:	85 c0                	test   %eax,%eax
80101e45:	75 13                	jne    80101e5a <dirlink+0x4a>
80101e47:	eb 35                	jmp    80101e7e <dirlink+0x6e>
80101e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e50:	8d 57 10             	lea    0x10(%edi),%edx
80101e53:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e56:	89 d7                	mov    %edx,%edi
80101e58:	76 24                	jbe    80101e7e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e5a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e61:	00 
80101e62:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e66:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e6a:	89 1c 24             	mov    %ebx,(%esp)
80101e6d:	e8 de fa ff ff       	call   80101950 <readi>
80101e72:	83 f8 10             	cmp    $0x10,%eax
80101e75:	75 5e                	jne    80101ed5 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101e77:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e7c:	75 d2                	jne    80101e50 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e81:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101e88:	00 
80101e89:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e8d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e90:	89 04 24             	mov    %eax,(%esp)
80101e93:	e8 68 25 00 00       	call   80104400 <strncpy>
  de.inum = inum;
80101e98:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ea2:	00 
80101ea3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ea7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101eab:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101eae:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eb2:	e8 99 fb ff ff       	call   80101a50 <writei>
80101eb7:	83 f8 10             	cmp    $0x10,%eax
80101eba:	75 25                	jne    80101ee1 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101ebc:	31 c0                	xor    %eax,%eax
}
80101ebe:	83 c4 2c             	add    $0x2c,%esp
80101ec1:	5b                   	pop    %ebx
80101ec2:	5e                   	pop    %esi
80101ec3:	5f                   	pop    %edi
80101ec4:	5d                   	pop    %ebp
80101ec5:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101ec6:	89 04 24             	mov    %eax,(%esp)
80101ec9:	e8 f2 f8 ff ff       	call   801017c0 <iput>
    return -1;
80101ece:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ed3:	eb e9                	jmp    80101ebe <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101ed5:	c7 04 24 08 6f 10 80 	movl   $0x80106f08,(%esp)
80101edc:	e8 7f e4 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ee1:	c7 04 24 06 75 10 80 	movl   $0x80107506,(%esp)
80101ee8:	e8 73 e4 ff ff       	call   80100360 <panic>
80101eed:	8d 76 00             	lea    0x0(%esi),%esi

80101ef0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101ef0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80101efb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101efe:	e8 6d fd ff ff       	call   80101c70 <namex>
}
80101f03:	c9                   	leave  
80101f04:	c3                   	ret    
80101f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f10:	55                   	push   %ebp
  return namex(path, 1, name);
80101f11:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f16:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f1e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f1f:	e9 4c fd ff ff       	jmp    80101c70 <namex>
80101f24:	66 90                	xchg   %ax,%ax
80101f26:	66 90                	xchg   %ax,%ax
80101f28:	66 90                	xchg   %ax,%ax
80101f2a:	66 90                	xchg   %ax,%ax
80101f2c:	66 90                	xchg   %ax,%ax
80101f2e:	66 90                	xchg   %ax,%ax

80101f30 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	56                   	push   %esi
80101f34:	89 c6                	mov    %eax,%esi
80101f36:	53                   	push   %ebx
80101f37:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f3a:	85 c0                	test   %eax,%eax
80101f3c:	0f 84 99 00 00 00    	je     80101fdb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f42:	8b 48 08             	mov    0x8(%eax),%ecx
80101f45:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f4b:	0f 87 7e 00 00 00    	ja     80101fcf <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f51:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f56:	66 90                	xchg   %ax,%ax
80101f58:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f59:	83 e0 c0             	and    $0xffffffc0,%eax
80101f5c:	3c 40                	cmp    $0x40,%al
80101f5e:	75 f8                	jne    80101f58 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f60:	31 db                	xor    %ebx,%ebx
80101f62:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f67:	89 d8                	mov    %ebx,%eax
80101f69:	ee                   	out    %al,(%dx)
80101f6a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f6f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f74:	ee                   	out    %al,(%dx)
80101f75:	0f b6 c1             	movzbl %cl,%eax
80101f78:	b2 f3                	mov    $0xf3,%dl
80101f7a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f7b:	89 c8                	mov    %ecx,%eax
80101f7d:	b2 f4                	mov    $0xf4,%dl
80101f7f:	c1 f8 08             	sar    $0x8,%eax
80101f82:	ee                   	out    %al,(%dx)
80101f83:	b2 f5                	mov    $0xf5,%dl
80101f85:	89 d8                	mov    %ebx,%eax
80101f87:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f88:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f8c:	b2 f6                	mov    $0xf6,%dl
80101f8e:	83 e0 01             	and    $0x1,%eax
80101f91:	c1 e0 04             	shl    $0x4,%eax
80101f94:	83 c8 e0             	or     $0xffffffe0,%eax
80101f97:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f98:	f6 06 04             	testb  $0x4,(%esi)
80101f9b:	75 13                	jne    80101fb0 <idestart+0x80>
80101f9d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fa2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fa7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fa8:	83 c4 10             	add    $0x10,%esp
80101fab:	5b                   	pop    %ebx
80101fac:	5e                   	pop    %esi
80101fad:	5d                   	pop    %ebp
80101fae:	c3                   	ret    
80101faf:	90                   	nop
80101fb0:	b2 f7                	mov    $0xf7,%dl
80101fb2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fb7:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101fb8:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101fbd:	83 c6 5c             	add    $0x5c,%esi
80101fc0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fc5:	fc                   	cld    
80101fc6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fc8:	83 c4 10             	add    $0x10,%esp
80101fcb:	5b                   	pop    %ebx
80101fcc:	5e                   	pop    %esi
80101fcd:	5d                   	pop    %ebp
80101fce:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101fcf:	c7 04 24 74 6f 10 80 	movl   $0x80106f74,(%esp)
80101fd6:	e8 85 e3 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101fdb:	c7 04 24 6b 6f 10 80 	movl   $0x80106f6b,(%esp)
80101fe2:	e8 79 e3 ff ff       	call   80100360 <panic>
80101fe7:	89 f6                	mov    %esi,%esi
80101fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ff0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80101ff6:	c7 44 24 04 86 6f 10 	movl   $0x80106f86,0x4(%esp)
80101ffd:	80 
80101ffe:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102005:	e8 36 20 00 00       	call   80104040 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010200a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010200f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102016:	83 e8 01             	sub    $0x1,%eax
80102019:	89 44 24 04          	mov    %eax,0x4(%esp)
8010201d:	e8 7e 02 00 00       	call   801022a0 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102022:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102027:	90                   	nop
80102028:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102029:	83 e0 c0             	and    $0xffffffc0,%eax
8010202c:	3c 40                	cmp    $0x40,%al
8010202e:	75 f8                	jne    80102028 <ideinit+0x38>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102030:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102035:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203a:	ee                   	out    %al,(%dx)
8010203b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102040:	b2 f7                	mov    $0xf7,%dl
80102042:	eb 09                	jmp    8010204d <ideinit+0x5d>
80102044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102048:	83 e9 01             	sub    $0x1,%ecx
8010204b:	74 0f                	je     8010205c <ideinit+0x6c>
8010204d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010204e:	84 c0                	test   %al,%al
80102050:	74 f6                	je     80102048 <ideinit+0x58>
      havedisk1 = 1;
80102052:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102059:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010205c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102061:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102066:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80102067:	c9                   	leave  
80102068:	c3                   	ret    
80102069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102070 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102079:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102080:	e8 ab 20 00 00       	call   80104130 <acquire>

  if((b = idequeue) == 0){
80102085:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010208b:	85 db                	test   %ebx,%ebx
8010208d:	74 30                	je     801020bf <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
8010208f:	8b 43 58             	mov    0x58(%ebx),%eax
80102092:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102097:	8b 33                	mov    (%ebx),%esi
80102099:	f7 c6 04 00 00 00    	test   $0x4,%esi
8010209f:	74 37                	je     801020d8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020a1:	83 e6 fb             	and    $0xfffffffb,%esi
801020a4:	83 ce 02             	or     $0x2,%esi
801020a7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020a9:	89 1c 24             	mov    %ebx,(%esp)
801020ac:	e8 cf 1c 00 00       	call   80103d80 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020b1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020b6:	85 c0                	test   %eax,%eax
801020b8:	74 05                	je     801020bf <ideintr+0x4f>
    idestart(idequeue);
801020ba:	e8 71 fe ff ff       	call   80101f30 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
801020bf:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020c6:	e8 55 21 00 00       	call   80104220 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020cb:	83 c4 1c             	add    $0x1c,%esp
801020ce:	5b                   	pop    %ebx
801020cf:	5e                   	pop    %esi
801020d0:	5f                   	pop    %edi
801020d1:	5d                   	pop    %ebp
801020d2:	c3                   	ret    
801020d3:	90                   	nop
801020d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020d8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020dd:	8d 76 00             	lea    0x0(%esi),%esi
801020e0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020e1:	89 c1                	mov    %eax,%ecx
801020e3:	83 e1 c0             	and    $0xffffffc0,%ecx
801020e6:	80 f9 40             	cmp    $0x40,%cl
801020e9:	75 f5                	jne    801020e0 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020eb:	a8 21                	test   $0x21,%al
801020ed:	75 b2                	jne    801020a1 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020ef:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020f2:	b9 80 00 00 00       	mov    $0x80,%ecx
801020f7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020fc:	fc                   	cld    
801020fd:	f3 6d                	rep insl (%dx),%es:(%edi)
801020ff:	8b 33                	mov    (%ebx),%esi
80102101:	eb 9e                	jmp    801020a1 <ideintr+0x31>
80102103:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102110 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	53                   	push   %ebx
80102114:	83 ec 14             	sub    $0x14,%esp
80102117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010211a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010211d:	89 04 24             	mov    %eax,(%esp)
80102120:	e8 eb 1e 00 00       	call   80104010 <holdingsleep>
80102125:	85 c0                	test   %eax,%eax
80102127:	0f 84 9e 00 00 00    	je     801021cb <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010212d:	8b 03                	mov    (%ebx),%eax
8010212f:	83 e0 06             	and    $0x6,%eax
80102132:	83 f8 02             	cmp    $0x2,%eax
80102135:	0f 84 a8 00 00 00    	je     801021e3 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010213b:	8b 53 04             	mov    0x4(%ebx),%edx
8010213e:	85 d2                	test   %edx,%edx
80102140:	74 0d                	je     8010214f <iderw+0x3f>
80102142:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102147:	85 c0                	test   %eax,%eax
80102149:	0f 84 88 00 00 00    	je     801021d7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010214f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102156:	e8 d5 1f 00 00       	call   80104130 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010215b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102160:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102167:	85 c0                	test   %eax,%eax
80102169:	75 07                	jne    80102172 <iderw+0x62>
8010216b:	eb 4e                	jmp    801021bb <iderw+0xab>
8010216d:	8d 76 00             	lea    0x0(%esi),%esi
80102170:	89 d0                	mov    %edx,%eax
80102172:	8b 50 58             	mov    0x58(%eax),%edx
80102175:	85 d2                	test   %edx,%edx
80102177:	75 f7                	jne    80102170 <iderw+0x60>
80102179:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010217c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010217e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102184:	74 3c                	je     801021c2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102186:	8b 03                	mov    (%ebx),%eax
80102188:	83 e0 06             	and    $0x6,%eax
8010218b:	83 f8 02             	cmp    $0x2,%eax
8010218e:	74 1a                	je     801021aa <iderw+0x9a>
    sleep(b, &idelock);
80102190:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
80102197:	80 
80102198:	89 1c 24             	mov    %ebx,(%esp)
8010219b:	e8 50 1a 00 00       	call   80103bf0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021a0:	8b 13                	mov    (%ebx),%edx
801021a2:	83 e2 06             	and    $0x6,%edx
801021a5:	83 fa 02             	cmp    $0x2,%edx
801021a8:	75 e6                	jne    80102190 <iderw+0x80>
    sleep(b, &idelock);
  }


  release(&idelock);
801021aa:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021b1:	83 c4 14             	add    $0x14,%esp
801021b4:	5b                   	pop    %ebx
801021b5:	5d                   	pop    %ebp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801021b6:	e9 65 20 00 00       	jmp    80104220 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021bb:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021c0:	eb ba                	jmp    8010217c <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021c2:	89 d8                	mov    %ebx,%eax
801021c4:	e8 67 fd ff ff       	call   80101f30 <idestart>
801021c9:	eb bb                	jmp    80102186 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021cb:	c7 04 24 8a 6f 10 80 	movl   $0x80106f8a,(%esp)
801021d2:	e8 89 e1 ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021d7:	c7 04 24 b5 6f 10 80 	movl   $0x80106fb5,(%esp)
801021de:	e8 7d e1 ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021e3:	c7 04 24 a0 6f 10 80 	movl   $0x80106fa0,(%esp)
801021ea:	e8 71 e1 ff ff       	call   80100360 <panic>
801021ef:	90                   	nop

801021f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	56                   	push   %esi
801021f4:	53                   	push   %ebx
801021f5:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021f8:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801021ff:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102202:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102209:	00 00 00 
  return ioapic->data;
8010220c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102212:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102215:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010221b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102221:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102228:	c1 e8 10             	shr    $0x10,%eax
8010222b:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010222e:	8b 43 10             	mov    0x10(%ebx),%eax
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
80102231:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102234:	39 c2                	cmp    %eax,%edx
80102236:	74 12                	je     8010224a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102238:	c7 04 24 d4 6f 10 80 	movl   $0x80106fd4,(%esp)
8010223f:	e8 0c e4 ff ff       	call   80100650 <cprintf>
80102244:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010224a:	ba 10 00 00 00       	mov    $0x10,%edx
8010224f:	31 c0                	xor    %eax,%eax
80102251:	eb 07                	jmp    8010225a <ioapicinit+0x6a>
80102253:	90                   	nop
80102254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102258:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010225a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010225c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102262:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102265:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010226b:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010226e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102271:	8d 4a 01             	lea    0x1(%edx),%ecx
80102274:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102277:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102279:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010227f:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102281:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102288:	7d ce                	jge    80102258 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010228a:	83 c4 10             	add    $0x10,%esp
8010228d:	5b                   	pop    %ebx
8010228e:	5e                   	pop    %esi
8010228f:	5d                   	pop    %ebp
80102290:	c3                   	ret    
80102291:	eb 0d                	jmp    801022a0 <ioapicenable>
80102293:	90                   	nop
80102294:	90                   	nop
80102295:	90                   	nop
80102296:	90                   	nop
80102297:	90                   	nop
80102298:	90                   	nop
80102299:	90                   	nop
8010229a:	90                   	nop
8010229b:	90                   	nop
8010229c:	90                   	nop
8010229d:	90                   	nop
8010229e:	90                   	nop
8010229f:	90                   	nop

801022a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	8b 55 08             	mov    0x8(%ebp),%edx
801022a6:	53                   	push   %ebx
801022a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022aa:	8d 5a 20             	lea    0x20(%edx),%ebx
801022ad:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022b1:	8b 15 34 26 11 80    	mov    0x80112634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022b7:	c1 e0 18             	shl    $0x18,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022ba:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022bc:	8b 15 34 26 11 80    	mov    0x80112634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c2:	83 c1 01             	add    $0x1,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022c5:	89 5a 10             	mov    %ebx,0x10(%edx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022c8:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022ca:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022d0:	89 42 10             	mov    %eax,0x10(%edx)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022d3:	5b                   	pop    %ebx
801022d4:	5d                   	pop    %ebp
801022d5:	c3                   	ret    
801022d6:	66 90                	xchg   %ax,%ax
801022d8:	66 90                	xchg   %ax,%ax
801022da:	66 90                	xchg   %ax,%ax
801022dc:	66 90                	xchg   %ax,%ax
801022de:	66 90                	xchg   %ax,%ax

801022e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 14             	sub    $0x14,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022f0:	75 7c                	jne    8010236e <kfree+0x8e>
801022f2:	81 fb f4 58 11 80    	cmp    $0x801158f4,%ebx
801022f8:	72 74                	jb     8010236e <kfree+0x8e>
801022fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102300:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102305:	77 67                	ja     8010236e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102307:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010230e:	00 
8010230f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102316:	00 
80102317:	89 1c 24             	mov    %ebx,(%esp)
8010231a:	e8 51 1f 00 00       	call   80104270 <memset>

  if(kmem.use_lock)
8010231f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102325:	85 d2                	test   %edx,%edx
80102327:	75 37                	jne    80102360 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102329:	a1 78 26 11 80       	mov    0x80112678,%eax
8010232e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102330:	a1 74 26 11 80       	mov    0x80112674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102335:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010233b:	85 c0                	test   %eax,%eax
8010233d:	75 09                	jne    80102348 <kfree+0x68>
    release(&kmem.lock);
}
8010233f:	83 c4 14             	add    $0x14,%esp
80102342:	5b                   	pop    %ebx
80102343:	5d                   	pop    %ebp
80102344:	c3                   	ret    
80102345:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102348:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010234f:	83 c4 14             	add    $0x14,%esp
80102352:	5b                   	pop    %ebx
80102353:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102354:	e9 c7 1e 00 00       	jmp    80104220 <release>
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102360:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102367:	e8 c4 1d 00 00       	call   80104130 <acquire>
8010236c:	eb bb                	jmp    80102329 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
8010236e:	c7 04 24 06 70 10 80 	movl   $0x80107006,(%esp)
80102375:	e8 e6 df ff ff       	call   80100360 <panic>
8010237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102380 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	56                   	push   %esi
80102384:	53                   	push   %ebx
80102385:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102388:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
8010238b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010238e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102394:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010239a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023a0:	39 de                	cmp    %ebx,%esi
801023a2:	73 08                	jae    801023ac <freerange+0x2c>
801023a4:	eb 18                	jmp    801023be <freerange+0x3e>
801023a6:	66 90                	xchg   %ax,%ax
801023a8:	89 da                	mov    %ebx,%edx
801023aa:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023ac:	89 14 24             	mov    %edx,(%esp)
801023af:	e8 2c ff ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023ba:	39 f0                	cmp    %esi,%eax
801023bc:	76 ea                	jbe    801023a8 <freerange+0x28>
    kfree(p);
}
801023be:	83 c4 10             	add    $0x10,%esp
801023c1:	5b                   	pop    %ebx
801023c2:	5e                   	pop    %esi
801023c3:	5d                   	pop    %ebp
801023c4:	c3                   	ret    
801023c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023d0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	56                   	push   %esi
801023d4:	53                   	push   %ebx
801023d5:	83 ec 10             	sub    $0x10,%esp
801023d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023db:	c7 44 24 04 0c 70 10 	movl   $0x8010700c,0x4(%esp)
801023e2:	80 
801023e3:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801023ea:	e8 51 1c 00 00       	call   80104040 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ef:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023f2:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801023f9:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023fc:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102402:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102408:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010240e:	39 de                	cmp    %ebx,%esi
80102410:	73 0a                	jae    8010241c <kinit1+0x4c>
80102412:	eb 1a                	jmp    8010242e <kinit1+0x5e>
80102414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102418:	89 da                	mov    %ebx,%edx
8010241a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010241c:	89 14 24             	mov    %edx,(%esp)
8010241f:	e8 bc fe ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102424:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010242a:	39 c6                	cmp    %eax,%esi
8010242c:	73 ea                	jae    80102418 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010242e:	83 c4 10             	add    $0x10,%esp
80102431:	5b                   	pop    %ebx
80102432:	5e                   	pop    %esi
80102433:	5d                   	pop    %ebp
80102434:	c3                   	ret    
80102435:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102440 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx
80102445:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102448:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
8010244b:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010244e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102454:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010245a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102460:	39 de                	cmp    %ebx,%esi
80102462:	73 08                	jae    8010246c <kinit2+0x2c>
80102464:	eb 18                	jmp    8010247e <kinit2+0x3e>
80102466:	66 90                	xchg   %ax,%ax
80102468:	89 da                	mov    %ebx,%edx
8010246a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010246c:	89 14 24             	mov    %edx,(%esp)
8010246f:	e8 6c fe ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102474:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010247a:	39 c6                	cmp    %eax,%esi
8010247c:	73 ea                	jae    80102468 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
8010247e:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102485:	00 00 00 
}
80102488:	83 c4 10             	add    $0x10,%esp
8010248b:	5b                   	pop    %ebx
8010248c:	5e                   	pop    %esi
8010248d:	5d                   	pop    %ebp
8010248e:	c3                   	ret    
8010248f:	90                   	nop

80102490 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
80102497:	a1 74 26 11 80       	mov    0x80112674,%eax
8010249c:	85 c0                	test   %eax,%eax
8010249e:	75 30                	jne    801024d0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024a0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024a6:	85 db                	test   %ebx,%ebx
801024a8:	74 08                	je     801024b2 <kalloc+0x22>
    kmem.freelist = r->next;
801024aa:	8b 13                	mov    (%ebx),%edx
801024ac:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024b2:	85 c0                	test   %eax,%eax
801024b4:	74 0c                	je     801024c2 <kalloc+0x32>
    release(&kmem.lock);
801024b6:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024bd:	e8 5e 1d 00 00       	call   80104220 <release>
  return (char*)r;
}
801024c2:	83 c4 14             	add    $0x14,%esp
801024c5:	89 d8                	mov    %ebx,%eax
801024c7:	5b                   	pop    %ebx
801024c8:	5d                   	pop    %ebp
801024c9:	c3                   	ret    
801024ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024d0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024d7:	e8 54 1c 00 00       	call   80104130 <acquire>
801024dc:	a1 74 26 11 80       	mov    0x80112674,%eax
801024e1:	eb bd                	jmp    801024a0 <kalloc+0x10>
801024e3:	66 90                	xchg   %ax,%ax
801024e5:	66 90                	xchg   %ax,%ax
801024e7:	66 90                	xchg   %ax,%ax
801024e9:	66 90                	xchg   %ax,%ax
801024eb:	66 90                	xchg   %ax,%ax
801024ed:	66 90                	xchg   %ax,%ax
801024ef:	90                   	nop

801024f0 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024f0:	ba 64 00 00 00       	mov    $0x64,%edx
801024f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024f6:	a8 01                	test   $0x1,%al
801024f8:	0f 84 ba 00 00 00    	je     801025b8 <kbdgetc+0xc8>
801024fe:	b2 60                	mov    $0x60,%dl
80102500:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102501:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102504:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010250a:	0f 84 88 00 00 00    	je     80102598 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102510:	84 c0                	test   %al,%al
80102512:	79 2c                	jns    80102540 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102514:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010251a:	f6 c2 40             	test   $0x40,%dl
8010251d:	75 05                	jne    80102524 <kbdgetc+0x34>
8010251f:	89 c1                	mov    %eax,%ecx
80102521:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102524:	0f b6 81 40 71 10 80 	movzbl -0x7fef8ec0(%ecx),%eax
8010252b:	83 c8 40             	or     $0x40,%eax
8010252e:	0f b6 c0             	movzbl %al,%eax
80102531:	f7 d0                	not    %eax
80102533:	21 d0                	and    %edx,%eax
80102535:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010253a:	31 c0                	xor    %eax,%eax
8010253c:	c3                   	ret    
8010253d:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	53                   	push   %ebx
80102544:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010254a:	f6 c3 40             	test   $0x40,%bl
8010254d:	74 09                	je     80102558 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010254f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102552:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102555:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102558:	0f b6 91 40 71 10 80 	movzbl -0x7fef8ec0(%ecx),%edx
  shift ^= togglecode[data];
8010255f:	0f b6 81 40 70 10 80 	movzbl -0x7fef8fc0(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102566:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102568:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010256a:	89 d0                	mov    %edx,%eax
8010256c:	83 e0 03             	and    $0x3,%eax
8010256f:	8b 04 85 20 70 10 80 	mov    -0x7fef8fe0(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102576:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
8010257c:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010257f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102583:	74 0b                	je     80102590 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
80102585:	8d 50 9f             	lea    -0x61(%eax),%edx
80102588:	83 fa 19             	cmp    $0x19,%edx
8010258b:	77 1b                	ja     801025a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010258d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102590:	5b                   	pop    %ebx
80102591:	5d                   	pop    %ebp
80102592:	c3                   	ret    
80102593:	90                   	nop
80102594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102598:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
8010259f:	31 c0                	xor    %eax,%eax
801025a1:	c3                   	ret    
801025a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025ab:	8d 50 20             	lea    0x20(%eax),%edx
801025ae:	83 f9 19             	cmp    $0x19,%ecx
801025b1:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
801025b4:	eb da                	jmp    80102590 <kbdgetc+0xa0>
801025b6:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025bd:	c3                   	ret    
801025be:	66 90                	xchg   %ax,%ax

801025c0 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025c6:	c7 04 24 f0 24 10 80 	movl   $0x801024f0,(%esp)
801025cd:	e8 de e1 ff ff       	call   801007b0 <consoleintr>
}
801025d2:	c9                   	leave  
801025d3:	c3                   	ret    
801025d4:	66 90                	xchg   %ax,%ax
801025d6:	66 90                	xchg   %ax,%ax
801025d8:	66 90                	xchg   %ax,%ax
801025da:	66 90                	xchg   %ax,%ax
801025dc:	66 90                	xchg   %ax,%ax
801025de:	66 90                	xchg   %ax,%ax

801025e0 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
801025e0:	55                   	push   %ebp
801025e1:	89 c1                	mov    %eax,%ecx
801025e3:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025e5:	ba 70 00 00 00       	mov    $0x70,%edx
801025ea:	53                   	push   %ebx
801025eb:	31 c0                	xor    %eax,%eax
801025ed:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025ee:	bb 71 00 00 00       	mov    $0x71,%ebx
801025f3:	89 da                	mov    %ebx,%edx
801025f5:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
801025f6:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025f9:	b2 70                	mov    $0x70,%dl
801025fb:	89 01                	mov    %eax,(%ecx)
801025fd:	b8 02 00 00 00       	mov    $0x2,%eax
80102602:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102603:	89 da                	mov    %ebx,%edx
80102605:	ec                   	in     (%dx),%al
80102606:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102609:	b2 70                	mov    $0x70,%dl
8010260b:	89 41 04             	mov    %eax,0x4(%ecx)
8010260e:	b8 04 00 00 00       	mov    $0x4,%eax
80102613:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102614:	89 da                	mov    %ebx,%edx
80102616:	ec                   	in     (%dx),%al
80102617:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010261a:	b2 70                	mov    $0x70,%dl
8010261c:	89 41 08             	mov    %eax,0x8(%ecx)
8010261f:	b8 07 00 00 00       	mov    $0x7,%eax
80102624:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102625:	89 da                	mov    %ebx,%edx
80102627:	ec                   	in     (%dx),%al
80102628:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010262b:	b2 70                	mov    $0x70,%dl
8010262d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102630:	b8 08 00 00 00       	mov    $0x8,%eax
80102635:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102636:	89 da                	mov    %ebx,%edx
80102638:	ec                   	in     (%dx),%al
80102639:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010263c:	b2 70                	mov    $0x70,%dl
8010263e:	89 41 10             	mov    %eax,0x10(%ecx)
80102641:	b8 09 00 00 00       	mov    $0x9,%eax
80102646:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102647:	89 da                	mov    %ebx,%edx
80102649:	ec                   	in     (%dx),%al
8010264a:	0f b6 d8             	movzbl %al,%ebx
8010264d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102650:	5b                   	pop    %ebx
80102651:	5d                   	pop    %ebp
80102652:	c3                   	ret    
80102653:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102660 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102660:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102665:	55                   	push   %ebp
80102666:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102668:	85 c0                	test   %eax,%eax
8010266a:	0f 84 c0 00 00 00    	je     80102730 <lapicinit+0xd0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102670:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102677:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010267d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102684:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102687:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102691:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102694:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102697:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010269e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026a1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026a4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026ab:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ae:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026b8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026be:	8b 50 30             	mov    0x30(%eax),%edx
801026c1:	c1 ea 10             	shr    $0x10,%edx
801026c4:	80 fa 03             	cmp    $0x3,%dl
801026c7:	77 6f                	ja     80102738 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d3:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026dd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e0:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ed:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026f7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fa:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026fd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102704:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102707:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010270a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102711:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102714:	8b 50 20             	mov    0x20(%eax),%edx
80102717:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102718:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010271e:	80 e6 10             	and    $0x10,%dh
80102721:	75 f5                	jne    80102718 <lapicinit+0xb8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102723:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010272a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010272d:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102730:	5d                   	pop    %ebp
80102731:	c3                   	ret    
80102732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102738:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010273f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102742:	8b 50 20             	mov    0x20(%eax),%edx
80102745:	eb 82                	jmp    801026c9 <lapicinit+0x69>
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102750:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 0c                	je     80102768 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010275c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010275f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102760:	c1 e8 18             	shr    $0x18,%eax
}
80102763:	c3                   	ret    
80102764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102768:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010276a:	5d                   	pop    %ebp
8010276b:	c3                   	ret    
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102770:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102775:	55                   	push   %ebp
80102776:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102778:	85 c0                	test   %eax,%eax
8010277a:	74 0d                	je     80102789 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010277c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102783:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102786:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102789:	5d                   	pop    %ebp
8010278a:	c3                   	ret    
8010278b:	90                   	nop
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
}
80102793:	5d                   	pop    %ebp
80102794:	c3                   	ret    
80102795:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027a0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027a0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027a1:	ba 70 00 00 00       	mov    $0x70,%edx
801027a6:	89 e5                	mov    %esp,%ebp
801027a8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027ad:	53                   	push   %ebx
801027ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027b4:	ee                   	out    %al,(%dx)
801027b5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ba:	b2 71                	mov    $0x71,%dl
801027bc:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027bd:	31 c0                	xor    %eax,%eax
801027bf:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027c5:	89 d8                	mov    %ebx,%eax
801027c7:	c1 e8 04             	shr    $0x4,%eax
801027ca:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027d0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027d5:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027d8:	c1 eb 0c             	shr    $0xc,%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027db:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027e1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027e4:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027eb:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ee:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027f1:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027f8:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027fb:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027fe:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102804:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102807:	89 da                	mov    %ebx,%edx
80102809:	80 ce 06             	or     $0x6,%dh

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010280c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102812:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102815:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010281b:	8b 48 20             	mov    0x20(%eax),%ecx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010281e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102827:	5b                   	pop    %ebx
80102828:	5d                   	pop    %ebp
80102829:	c3                   	ret    
8010282a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102830 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102830:	55                   	push   %ebp
80102831:	ba 70 00 00 00       	mov    $0x70,%edx
80102836:	89 e5                	mov    %esp,%ebp
80102838:	b8 0b 00 00 00       	mov    $0xb,%eax
8010283d:	57                   	push   %edi
8010283e:	56                   	push   %esi
8010283f:	53                   	push   %ebx
80102840:	83 ec 4c             	sub    $0x4c,%esp
80102843:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102844:	b2 71                	mov    $0x71,%dl
80102846:	ec                   	in     (%dx),%al
80102847:	88 45 b7             	mov    %al,-0x49(%ebp)
8010284a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010284d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102851:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102858:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010285d:	89 d8                	mov    %ebx,%eax
8010285f:	e8 7c fd ff ff       	call   801025e0 <fill_rtcdate>
80102864:	b8 0a 00 00 00       	mov    $0xa,%eax
80102869:	89 f2                	mov    %esi,%edx
8010286b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286c:	ba 71 00 00 00       	mov    $0x71,%edx
80102871:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102872:	84 c0                	test   %al,%al
80102874:	78 e7                	js     8010285d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102876:	89 f8                	mov    %edi,%eax
80102878:	e8 63 fd ff ff       	call   801025e0 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010287d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102884:	00 
80102885:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102889:	89 1c 24             	mov    %ebx,(%esp)
8010288c:	e8 2f 1a 00 00       	call   801042c0 <memcmp>
80102891:	85 c0                	test   %eax,%eax
80102893:	75 c3                	jne    80102858 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102895:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102899:	75 78                	jne    80102913 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010289b:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010289e:	89 c2                	mov    %eax,%edx
801028a0:	83 e0 0f             	and    $0xf,%eax
801028a3:	c1 ea 04             	shr    $0x4,%edx
801028a6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028a9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028ac:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028af:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028b2:	89 c2                	mov    %eax,%edx
801028b4:	83 e0 0f             	and    $0xf,%eax
801028b7:	c1 ea 04             	shr    $0x4,%edx
801028ba:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028bd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028c0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028c3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028c6:	89 c2                	mov    %eax,%edx
801028c8:	83 e0 0f             	and    $0xf,%eax
801028cb:	c1 ea 04             	shr    $0x4,%edx
801028ce:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028d1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028d4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801028d7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028da:	89 c2                	mov    %eax,%edx
801028dc:	83 e0 0f             	and    $0xf,%eax
801028df:	c1 ea 04             	shr    $0x4,%edx
801028e2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028e5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028e8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801028eb:	8b 45 c8             	mov    -0x38(%ebp),%eax
801028ee:	89 c2                	mov    %eax,%edx
801028f0:	83 e0 0f             	and    $0xf,%eax
801028f3:	c1 ea 04             	shr    $0x4,%edx
801028f6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801028ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102902:	89 c2                	mov    %eax,%edx
80102904:	83 e0 0f             	and    $0xf,%eax
80102907:	c1 ea 04             	shr    $0x4,%edx
8010290a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010290d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102910:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102913:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102916:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102919:	89 01                	mov    %eax,(%ecx)
8010291b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010291e:	89 41 04             	mov    %eax,0x4(%ecx)
80102921:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102924:	89 41 08             	mov    %eax,0x8(%ecx)
80102927:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010292a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010292d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102930:	89 41 10             	mov    %eax,0x10(%ecx)
80102933:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102936:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102939:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102940:	83 c4 4c             	add    $0x4c,%esp
80102943:	5b                   	pop    %ebx
80102944:	5e                   	pop    %esi
80102945:	5f                   	pop    %edi
80102946:	5d                   	pop    %ebp
80102947:	c3                   	ret    
80102948:	66 90                	xchg   %ax,%ax
8010294a:	66 90                	xchg   %ax,%ax
8010294c:	66 90                	xchg   %ax,%ax
8010294e:	66 90                	xchg   %ax,%ax

80102950 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102950:	55                   	push   %ebp
80102951:	89 e5                	mov    %esp,%ebp
80102953:	57                   	push   %edi
80102954:	56                   	push   %esi
80102955:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102956:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102958:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010295b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102960:	85 c0                	test   %eax,%eax
80102962:	7e 78                	jle    801029dc <install_trans+0x8c>
80102964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102968:	a1 b4 26 11 80       	mov    0x801126b4,%eax
8010296d:	01 d8                	add    %ebx,%eax
8010296f:	83 c0 01             	add    $0x1,%eax
80102972:	89 44 24 04          	mov    %eax,0x4(%esp)
80102976:	a1 c4 26 11 80       	mov    0x801126c4,%eax
8010297b:	89 04 24             	mov    %eax,(%esp)
8010297e:	e8 4d d7 ff ff       	call   801000d0 <bread>
80102983:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102985:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010298c:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010298f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102993:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102998:	89 04 24             	mov    %eax,(%esp)
8010299b:	e8 30 d7 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029a0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029a7:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029a8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029aa:	8d 47 5c             	lea    0x5c(%edi),%eax
801029ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801029b1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029b4:	89 04 24             	mov    %eax,(%esp)
801029b7:	e8 54 19 00 00       	call   80104310 <memmove>
    bwrite(dbuf);  // write dst to disk
801029bc:	89 34 24             	mov    %esi,(%esp)
801029bf:	e8 dc d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801029c4:	89 3c 24             	mov    %edi,(%esp)
801029c7:	e8 14 d8 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801029cc:	89 34 24             	mov    %esi,(%esp)
801029cf:	e8 0c d8 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029d4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
801029da:	7f 8c                	jg     80102968 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
801029dc:	83 c4 1c             	add    $0x1c,%esp
801029df:	5b                   	pop    %ebx
801029e0:	5e                   	pop    %esi
801029e1:	5f                   	pop    %edi
801029e2:	5d                   	pop    %ebp
801029e3:	c3                   	ret    
801029e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801029f0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801029f0:	55                   	push   %ebp
801029f1:	89 e5                	mov    %esp,%ebp
801029f3:	57                   	push   %edi
801029f4:	56                   	push   %esi
801029f5:	53                   	push   %ebx
801029f6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
801029f9:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801029fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a02:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a07:	89 04 24             	mov    %eax,(%esp)
80102a0a:	e8 c1 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a0f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a15:	31 d2                	xor    %edx,%edx
80102a17:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a19:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a1b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a1e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a21:	7e 17                	jle    80102a3a <write_head+0x4a>
80102a23:	90                   	nop
80102a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a28:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a2f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a33:	83 c2 01             	add    $0x1,%edx
80102a36:	39 da                	cmp    %ebx,%edx
80102a38:	75 ee                	jne    80102a28 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102a3a:	89 3c 24             	mov    %edi,(%esp)
80102a3d:	e8 5e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a42:	89 3c 24             	mov    %edi,(%esp)
80102a45:	e8 96 d7 ff ff       	call   801001e0 <brelse>
}
80102a4a:	83 c4 1c             	add    $0x1c,%esp
80102a4d:	5b                   	pop    %ebx
80102a4e:	5e                   	pop    %esi
80102a4f:	5f                   	pop    %edi
80102a50:	5d                   	pop    %ebp
80102a51:	c3                   	ret    
80102a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a60 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102a60:	55                   	push   %ebp
80102a61:	89 e5                	mov    %esp,%ebp
80102a63:	56                   	push   %esi
80102a64:	53                   	push   %ebx
80102a65:	83 ec 30             	sub    $0x30,%esp
80102a68:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102a6b:	c7 44 24 04 40 72 10 	movl   $0x80107240,0x4(%esp)
80102a72:	80 
80102a73:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102a7a:	e8 c1 15 00 00       	call   80104040 <initlock>
  readsb(dev, &sb);
80102a7f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102a82:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a86:	89 1c 24             	mov    %ebx,(%esp)
80102a89:	e8 f2 e8 ff ff       	call   80101380 <readsb>
  log.start = sb.logstart;
80102a8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102a91:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a94:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102a97:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a9d:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102aa1:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102aa7:	a3 b4 26 11 80       	mov    %eax,0x801126b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102aac:	e8 1f d6 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102ab1:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ab3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ab6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ab9:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102abb:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ac1:	7e 17                	jle    80102ada <initlog+0x7a>
80102ac3:	90                   	nop
80102ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102ac8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102acc:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102ad3:	83 c2 01             	add    $0x1,%edx
80102ad6:	39 da                	cmp    %ebx,%edx
80102ad8:	75 ee                	jne    80102ac8 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102ada:	89 04 24             	mov    %eax,(%esp)
80102add:	e8 fe d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102ae2:	e8 69 fe ff ff       	call   80102950 <install_trans>
  log.lh.n = 0;
80102ae7:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102aee:	00 00 00 
  write_head(); // clear the log
80102af1:	e8 fa fe ff ff       	call   801029f0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102af6:	83 c4 30             	add    $0x30,%esp
80102af9:	5b                   	pop    %ebx
80102afa:	5e                   	pop    %esi
80102afb:	5d                   	pop    %ebp
80102afc:	c3                   	ret    
80102afd:	8d 76 00             	lea    0x0(%esi),%esi

80102b00 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b06:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b0d:	e8 1e 16 00 00       	call   80104130 <acquire>
80102b12:	eb 18                	jmp    80102b2c <begin_op+0x2c>
80102b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b18:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b1f:	80 
80102b20:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b27:	e8 c4 10 00 00       	call   80103bf0 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b2c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b31:	85 c0                	test   %eax,%eax
80102b33:	75 e3                	jne    80102b18 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b35:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b3a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b40:	83 c0 01             	add    $0x1,%eax
80102b43:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b46:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b49:	83 fa 1e             	cmp    $0x1e,%edx
80102b4c:	7f ca                	jg     80102b18 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b4e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102b55:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b5a:	e8 c1 16 00 00       	call   80104220 <release>
      break;
    }
  }
}
80102b5f:	c9                   	leave  
80102b60:	c3                   	ret    
80102b61:	eb 0d                	jmp    80102b70 <end_op>
80102b63:	90                   	nop
80102b64:	90                   	nop
80102b65:	90                   	nop
80102b66:	90                   	nop
80102b67:	90                   	nop
80102b68:	90                   	nop
80102b69:	90                   	nop
80102b6a:	90                   	nop
80102b6b:	90                   	nop
80102b6c:	90                   	nop
80102b6d:	90                   	nop
80102b6e:	90                   	nop
80102b6f:	90                   	nop

80102b70 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
80102b73:	57                   	push   %edi
80102b74:	56                   	push   %esi
80102b75:	53                   	push   %ebx
80102b76:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102b79:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b80:	e8 ab 15 00 00       	call   80104130 <acquire>
  log.outstanding -= 1;
80102b85:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102b8a:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102b90:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102b93:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102b95:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102b9a:	0f 85 f3 00 00 00    	jne    80102c93 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102ba0:	85 c0                	test   %eax,%eax
80102ba2:	0f 85 cb 00 00 00    	jne    80102c73 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ba8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102baf:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102bb1:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102bb8:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bbb:	e8 60 16 00 00       	call   80104220 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bc0:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102bc5:	85 c0                	test   %eax,%eax
80102bc7:	0f 8e 90 00 00 00    	jle    80102c5d <end_op+0xed>
80102bcd:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102bd0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bd5:	01 d8                	add    %ebx,%eax
80102bd7:	83 c0 01             	add    $0x1,%eax
80102bda:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bde:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102be3:	89 04 24             	mov    %eax,(%esp)
80102be6:	e8 e5 d4 ff ff       	call   801000d0 <bread>
80102beb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102bed:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bf4:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bfb:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c00:	89 04 24             	mov    %eax,(%esp)
80102c03:	e8 c8 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c08:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c0f:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c10:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c12:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c15:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c19:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c1c:	89 04 24             	mov    %eax,(%esp)
80102c1f:	e8 ec 16 00 00       	call   80104310 <memmove>
    bwrite(to);  // write the log
80102c24:	89 34 24             	mov    %esi,(%esp)
80102c27:	e8 74 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c2c:	89 3c 24             	mov    %edi,(%esp)
80102c2f:	e8 ac d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c34:	89 34 24             	mov    %esi,(%esp)
80102c37:	e8 a4 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c3c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c42:	7c 8c                	jl     80102bd0 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c44:	e8 a7 fd ff ff       	call   801029f0 <write_head>
    install_trans(); // Now install writes to home locations
80102c49:	e8 02 fd ff ff       	call   80102950 <install_trans>
    log.lh.n = 0;
80102c4e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c55:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c58:	e8 93 fd ff ff       	call   801029f0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102c5d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c64:	e8 c7 14 00 00       	call   80104130 <acquire>
    log.committing = 0;
80102c69:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102c70:	00 00 00 
    wakeup(&log);
80102c73:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c7a:	e8 01 11 00 00       	call   80103d80 <wakeup>
    release(&log.lock);
80102c7f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c86:	e8 95 15 00 00       	call   80104220 <release>
  }
}
80102c8b:	83 c4 1c             	add    $0x1c,%esp
80102c8e:	5b                   	pop    %ebx
80102c8f:	5e                   	pop    %esi
80102c90:	5f                   	pop    %edi
80102c91:	5d                   	pop    %ebp
80102c92:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102c93:	c7 04 24 44 72 10 80 	movl   $0x80107244,(%esp)
80102c9a:	e8 c1 d6 ff ff       	call   80100360 <panic>
80102c9f:	90                   	nop

80102ca0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	53                   	push   %ebx
80102ca4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ca7:	a1 c8 26 11 80       	mov    0x801126c8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102caf:	83 f8 1d             	cmp    $0x1d,%eax
80102cb2:	0f 8f 98 00 00 00    	jg     80102d50 <log_write+0xb0>
80102cb8:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102cbe:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102cc1:	39 d0                	cmp    %edx,%eax
80102cc3:	0f 8d 87 00 00 00    	jge    80102d50 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102cc9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cce:	85 c0                	test   %eax,%eax
80102cd0:	0f 8e 86 00 00 00    	jle    80102d5c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102cd6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cdd:	e8 4e 14 00 00       	call   80104130 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102ce2:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102ce8:	83 fa 00             	cmp    $0x0,%edx
80102ceb:	7e 54                	jle    80102d41 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ced:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102cf0:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102cf2:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102cf8:	75 0f                	jne    80102d09 <log_write+0x69>
80102cfa:	eb 3c                	jmp    80102d38 <log_write+0x98>
80102cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d00:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d07:	74 2f                	je     80102d38 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d09:	83 c0 01             	add    $0x1,%eax
80102d0c:	39 d0                	cmp    %edx,%eax
80102d0e:	75 f0                	jne    80102d00 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d10:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d17:	83 c2 01             	add    $0x1,%edx
80102d1a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d20:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d23:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d2a:	83 c4 14             	add    $0x14,%esp
80102d2d:	5b                   	pop    %ebx
80102d2e:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102d2f:	e9 ec 14 00 00       	jmp    80104220 <release>
80102d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d38:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d3f:	eb df                	jmp    80102d20 <log_write+0x80>
80102d41:	8b 43 08             	mov    0x8(%ebx),%eax
80102d44:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102d49:	75 d5                	jne    80102d20 <log_write+0x80>
80102d4b:	eb ca                	jmp    80102d17 <log_write+0x77>
80102d4d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102d50:	c7 04 24 53 72 10 80 	movl   $0x80107253,(%esp)
80102d57:	e8 04 d6 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102d5c:	c7 04 24 69 72 10 80 	movl   $0x80107269,(%esp)
80102d63:	e8 f8 d5 ff ff       	call   80100360 <panic>
80102d68:	66 90                	xchg   %ax,%ax
80102d6a:	66 90                	xchg   %ax,%ax
80102d6c:	66 90                	xchg   %ax,%ax
80102d6e:	66 90                	xchg   %ax,%ax

80102d70 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102d77:	e8 f4 08 00 00       	call   80103670 <cpuid>
80102d7c:	89 c3                	mov    %eax,%ebx
80102d7e:	e8 ed 08 00 00       	call   80103670 <cpuid>
80102d83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102d87:	c7 04 24 84 72 10 80 	movl   $0x80107284,(%esp)
80102d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d92:	e8 b9 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102d97:	e8 14 27 00 00       	call   801054b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102d9c:	e8 4f 08 00 00       	call   801035f0 <mycpu>
80102da1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102da3:	b8 01 00 00 00       	mov    $0x1,%eax
80102da8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102daf:	e8 9c 0b 00 00       	call   80103950 <scheduler>
80102db4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102dc0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102dc6:	e8 d5 37 00 00       	call   801065a0 <switchkvm>
  seginit();
80102dcb:	e8 90 36 00 00       	call   80106460 <seginit>
  lapicinit();
80102dd0:	e8 8b f8 ff ff       	call   80102660 <lapicinit>
  mpmain();
80102dd5:	e8 96 ff ff ff       	call   80102d70 <mpmain>
80102dda:	66 90                	xchg   %ax,%ax
80102ddc:	66 90                	xchg   %ax,%ax
80102dde:	66 90                	xchg   %ax,%ax

80102de0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102de4:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102de9:	83 e4 f0             	and    $0xfffffff0,%esp
80102dec:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102def:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102df6:	80 
80102df7:	c7 04 24 f4 58 11 80 	movl   $0x801158f4,(%esp)
80102dfe:	e8 cd f5 ff ff       	call   801023d0 <kinit1>
  kvmalloc();      // kernel page table
80102e03:	e8 48 3c 00 00       	call   80106a50 <kvmalloc>
  mpinit();        // detect other processors
80102e08:	e8 73 01 00 00       	call   80102f80 <mpinit>
80102e0d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e10:	e8 4b f8 ff ff       	call   80102660 <lapicinit>
  seginit();       // segment descriptors
80102e15:	e8 46 36 00 00       	call   80106460 <seginit>
  picinit();       // disable pic
80102e1a:	e8 21 03 00 00       	call   80103140 <picinit>
80102e1f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e20:	e8 cb f3 ff ff       	call   801021f0 <ioapicinit>
  consoleinit();   // console hardware
80102e25:	e8 26 db ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e2a:	e8 d1 29 00 00       	call   80105800 <uartinit>
80102e2f:	90                   	nop
  pinit();         // process table
80102e30:	e8 9b 07 00 00       	call   801035d0 <pinit>
  shminit();       // shared memory
80102e35:	e8 e6 3e 00 00       	call   80106d20 <shminit>
  tvinit();        // trap vectors
80102e3a:	e8 d1 25 00 00       	call   80105410 <tvinit>
80102e3f:	90                   	nop
  binit();         // buffer cache
80102e40:	e8 fb d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102e45:	e8 e6 de ff ff       	call   80100d30 <fileinit>
  ideinit();       // disk 
80102e4a:	e8 a1 f1 ff ff       	call   80101ff0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e4f:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e56:	00 
80102e57:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e5e:	80 
80102e5f:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e66:	e8 a5 14 00 00       	call   80104310 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102e6b:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102e72:	00 00 00 
80102e75:	05 80 27 11 80       	add    $0x80112780,%eax
80102e7a:	39 d8                	cmp    %ebx,%eax
80102e7c:	76 65                	jbe    80102ee3 <main+0x103>
80102e7e:	66 90                	xchg   %ax,%ax
    if(c == mycpu())  // We've started already.
80102e80:	e8 6b 07 00 00       	call   801035f0 <mycpu>
80102e85:	39 d8                	cmp    %ebx,%eax
80102e87:	74 41                	je     80102eca <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102e89:	e8 02 f6 ff ff       	call   80102490 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102e8e:	c7 05 f8 6f 00 80 c0 	movl   $0x80102dc0,0x80006ff8
80102e95:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102e98:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102e9f:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ea2:	05 00 10 00 00       	add    $0x1000,%eax
80102ea7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102eac:	0f b6 03             	movzbl (%ebx),%eax
80102eaf:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102eb6:	00 
80102eb7:	89 04 24             	mov    %eax,(%esp)
80102eba:	e8 e1 f8 ff ff       	call   801027a0 <lapicstartap>
80102ebf:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ec0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ec6:	85 c0                	test   %eax,%eax
80102ec8:	74 f6                	je     80102ec0 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102eca:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ed1:	00 00 00 
80102ed4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102eda:	05 80 27 11 80       	add    $0x80112780,%eax
80102edf:	39 c3                	cmp    %eax,%ebx
80102ee1:	72 9d                	jb     80102e80 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102ee3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102eea:	8e 
80102eeb:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102ef2:	e8 49 f5 ff ff       	call   80102440 <kinit2>
  userinit();      // first user process
80102ef7:	e8 c4 07 00 00       	call   801036c0 <userinit>
  mpmain();        // finish this processor's setup
80102efc:	e8 6f fe ff ff       	call   80102d70 <mpmain>
80102f01:	66 90                	xchg   %ax,%ax
80102f03:	66 90                	xchg   %ax,%ax
80102f05:	66 90                	xchg   %ax,%ax
80102f07:	66 90                	xchg   %ax,%ax
80102f09:	66 90                	xchg   %ax,%ax
80102f0b:	66 90                	xchg   %ax,%ax
80102f0d:	66 90                	xchg   %ax,%ax
80102f0f:	90                   	nop

80102f10 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f14:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f1a:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f1b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f1e:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f21:	39 de                	cmp    %ebx,%esi
80102f23:	73 3c                	jae    80102f61 <mpsearch1+0x51>
80102f25:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f28:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f2f:	00 
80102f30:	c7 44 24 04 98 72 10 	movl   $0x80107298,0x4(%esp)
80102f37:	80 
80102f38:	89 34 24             	mov    %esi,(%esp)
80102f3b:	e8 80 13 00 00       	call   801042c0 <memcmp>
80102f40:	85 c0                	test   %eax,%eax
80102f42:	75 16                	jne    80102f5a <mpsearch1+0x4a>
80102f44:	31 c9                	xor    %ecx,%ecx
80102f46:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102f48:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102f4c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f4f:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102f51:	83 fa 10             	cmp    $0x10,%edx
80102f54:	75 f2                	jne    80102f48 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f56:	84 c9                	test   %cl,%cl
80102f58:	74 10                	je     80102f6a <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f5a:	83 c6 10             	add    $0x10,%esi
80102f5d:	39 f3                	cmp    %esi,%ebx
80102f5f:	77 c7                	ja     80102f28 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102f61:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102f64:	31 c0                	xor    %eax,%eax
}
80102f66:	5b                   	pop    %ebx
80102f67:	5e                   	pop    %esi
80102f68:	5d                   	pop    %ebp
80102f69:	c3                   	ret    
80102f6a:	83 c4 10             	add    $0x10,%esp
80102f6d:	89 f0                	mov    %esi,%eax
80102f6f:	5b                   	pop    %ebx
80102f70:	5e                   	pop    %esi
80102f71:	5d                   	pop    %ebp
80102f72:	c3                   	ret    
80102f73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f80 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	57                   	push   %edi
80102f84:	56                   	push   %esi
80102f85:	53                   	push   %ebx
80102f86:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102f89:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102f90:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102f97:	c1 e0 08             	shl    $0x8,%eax
80102f9a:	09 d0                	or     %edx,%eax
80102f9c:	c1 e0 04             	shl    $0x4,%eax
80102f9f:	85 c0                	test   %eax,%eax
80102fa1:	75 1b                	jne    80102fbe <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102fa3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102faa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102fb1:	c1 e0 08             	shl    $0x8,%eax
80102fb4:	09 d0                	or     %edx,%eax
80102fb6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102fb9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
80102fbe:	ba 00 04 00 00       	mov    $0x400,%edx
80102fc3:	e8 48 ff ff ff       	call   80102f10 <mpsearch1>
80102fc8:	85 c0                	test   %eax,%eax
80102fca:	89 c7                	mov    %eax,%edi
80102fcc:	0f 84 22 01 00 00    	je     801030f4 <mpinit+0x174>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102fd2:	8b 77 04             	mov    0x4(%edi),%esi
80102fd5:	85 f6                	test   %esi,%esi
80102fd7:	0f 84 30 01 00 00    	je     8010310d <mpinit+0x18d>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102fdd:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80102fe3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102fea:	00 
80102feb:	c7 44 24 04 9d 72 10 	movl   $0x8010729d,0x4(%esp)
80102ff2:	80 
80102ff3:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102ff6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80102ff9:	e8 c2 12 00 00       	call   801042c0 <memcmp>
80102ffe:	85 c0                	test   %eax,%eax
80103000:	0f 85 07 01 00 00    	jne    8010310d <mpinit+0x18d>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103006:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010300d:	3c 04                	cmp    $0x4,%al
8010300f:	0f 85 0b 01 00 00    	jne    80103120 <mpinit+0x1a0>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103015:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010301c:	85 c0                	test   %eax,%eax
8010301e:	74 21                	je     80103041 <mpinit+0xc1>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
80103020:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103022:	31 d2                	xor    %edx,%edx
80103024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103028:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010302f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103030:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103033:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103035:	39 d0                	cmp    %edx,%eax
80103037:	7f ef                	jg     80103028 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103039:	84 c9                	test   %cl,%cl
8010303b:	0f 85 cc 00 00 00    	jne    8010310d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103041:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103044:	85 c0                	test   %eax,%eax
80103046:	0f 84 c1 00 00 00    	je     8010310d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010304c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103052:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103057:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010305c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103063:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103069:	03 55 e4             	add    -0x1c(%ebp),%edx
8010306c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103070:	39 c2                	cmp    %eax,%edx
80103072:	76 1b                	jbe    8010308f <mpinit+0x10f>
80103074:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
80103077:	80 f9 04             	cmp    $0x4,%cl
8010307a:	77 74                	ja     801030f0 <mpinit+0x170>
8010307c:	ff 24 8d dc 72 10 80 	jmp    *-0x7fef8d24(,%ecx,4)
80103083:	90                   	nop
80103084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103088:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010308b:	39 c2                	cmp    %eax,%edx
8010308d:	77 e5                	ja     80103074 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010308f:	85 db                	test   %ebx,%ebx
80103091:	0f 84 93 00 00 00    	je     8010312a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103097:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
8010309b:	74 12                	je     801030af <mpinit+0x12f>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010309d:	ba 22 00 00 00       	mov    $0x22,%edx
801030a2:	b8 70 00 00 00       	mov    $0x70,%eax
801030a7:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030a8:	b2 23                	mov    $0x23,%dl
801030aa:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801030ab:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ae:	ee                   	out    %al,(%dx)
  }
}
801030af:	83 c4 1c             	add    $0x1c,%esp
801030b2:	5b                   	pop    %ebx
801030b3:	5e                   	pop    %esi
801030b4:	5f                   	pop    %edi
801030b5:	5d                   	pop    %ebp
801030b6:	c3                   	ret    
801030b7:	90                   	nop
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801030b8:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801030be:	83 fe 07             	cmp    $0x7,%esi
801030c1:	7f 17                	jg     801030da <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030c3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030c7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
801030cd:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030d4:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
801030da:	83 c0 14             	add    $0x14,%eax
      continue;
801030dd:	eb 91                	jmp    80103070 <mpinit+0xf0>
801030df:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801030e0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801030e4:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801030e7:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      p += sizeof(struct mpioapic);
      continue;
801030ed:	eb 81                	jmp    80103070 <mpinit+0xf0>
801030ef:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801030f0:	31 db                	xor    %ebx,%ebx
801030f2:	eb 83                	jmp    80103077 <mpinit+0xf7>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801030f4:	ba 00 00 01 00       	mov    $0x10000,%edx
801030f9:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801030fe:	e8 0d fe ff ff       	call   80102f10 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103103:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103105:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103107:	0f 85 c5 fe ff ff    	jne    80102fd2 <mpinit+0x52>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
8010310d:	c7 04 24 a2 72 10 80 	movl   $0x801072a2,(%esp)
80103114:	e8 47 d2 ff ff       	call   80100360 <panic>
80103119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103120:	3c 01                	cmp    $0x1,%al
80103122:	0f 84 ed fe ff ff    	je     80103015 <mpinit+0x95>
80103128:	eb e3                	jmp    8010310d <mpinit+0x18d>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
8010312a:	c7 04 24 bc 72 10 80 	movl   $0x801072bc,(%esp)
80103131:	e8 2a d2 ff ff       	call   80100360 <panic>
80103136:	66 90                	xchg   %ax,%ax
80103138:	66 90                	xchg   %ax,%ax
8010313a:	66 90                	xchg   %ax,%ax
8010313c:	66 90                	xchg   %ax,%ax
8010313e:	66 90                	xchg   %ax,%ax

80103140 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103140:	55                   	push   %ebp
80103141:	ba 21 00 00 00       	mov    $0x21,%edx
80103146:	89 e5                	mov    %esp,%ebp
80103148:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010314d:	ee                   	out    %al,(%dx)
8010314e:	b2 a1                	mov    $0xa1,%dl
80103150:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103151:	5d                   	pop    %ebp
80103152:	c3                   	ret    
80103153:	66 90                	xchg   %ax,%ax
80103155:	66 90                	xchg   %ax,%ax
80103157:	66 90                	xchg   %ax,%ax
80103159:	66 90                	xchg   %ax,%ax
8010315b:	66 90                	xchg   %ax,%ax
8010315d:	66 90                	xchg   %ax,%ax
8010315f:	90                   	nop

80103160 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	57                   	push   %edi
80103164:	56                   	push   %esi
80103165:	53                   	push   %ebx
80103166:	83 ec 1c             	sub    $0x1c,%esp
80103169:	8b 75 08             	mov    0x8(%ebp),%esi
8010316c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010316f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103175:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010317b:	e8 d0 db ff ff       	call   80100d50 <filealloc>
80103180:	85 c0                	test   %eax,%eax
80103182:	89 06                	mov    %eax,(%esi)
80103184:	0f 84 a4 00 00 00    	je     8010322e <pipealloc+0xce>
8010318a:	e8 c1 db ff ff       	call   80100d50 <filealloc>
8010318f:	85 c0                	test   %eax,%eax
80103191:	89 03                	mov    %eax,(%ebx)
80103193:	0f 84 87 00 00 00    	je     80103220 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103199:	e8 f2 f2 ff ff       	call   80102490 <kalloc>
8010319e:	85 c0                	test   %eax,%eax
801031a0:	89 c7                	mov    %eax,%edi
801031a2:	74 7c                	je     80103220 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801031a4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031ab:	00 00 00 
  p->writeopen = 1;
801031ae:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031b5:	00 00 00 
  p->nwrite = 0;
801031b8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031bf:	00 00 00 
  p->nread = 0;
801031c2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801031c9:	00 00 00 
  initlock(&p->lock, "pipe");
801031cc:	89 04 24             	mov    %eax,(%esp)
801031cf:	c7 44 24 04 f0 72 10 	movl   $0x801072f0,0x4(%esp)
801031d6:	80 
801031d7:	e8 64 0e 00 00       	call   80104040 <initlock>
  (*f0)->type = FD_PIPE;
801031dc:	8b 06                	mov    (%esi),%eax
801031de:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801031e4:	8b 06                	mov    (%esi),%eax
801031e6:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801031ea:	8b 06                	mov    (%esi),%eax
801031ec:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801031f0:	8b 06                	mov    (%esi),%eax
801031f2:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801031f5:	8b 03                	mov    (%ebx),%eax
801031f7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801031fd:	8b 03                	mov    (%ebx),%eax
801031ff:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103203:	8b 03                	mov    (%ebx),%eax
80103205:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103209:	8b 03                	mov    (%ebx),%eax
  return 0;
8010320b:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
8010320d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103210:	83 c4 1c             	add    $0x1c,%esp
80103213:	89 d8                	mov    %ebx,%eax
80103215:	5b                   	pop    %ebx
80103216:	5e                   	pop    %esi
80103217:	5f                   	pop    %edi
80103218:	5d                   	pop    %ebp
80103219:	c3                   	ret    
8010321a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103220:	8b 06                	mov    (%esi),%eax
80103222:	85 c0                	test   %eax,%eax
80103224:	74 08                	je     8010322e <pipealloc+0xce>
    fileclose(*f0);
80103226:	89 04 24             	mov    %eax,(%esp)
80103229:	e8 e2 db ff ff       	call   80100e10 <fileclose>
  if(*f1)
8010322e:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
80103230:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
80103235:	85 c0                	test   %eax,%eax
80103237:	74 d7                	je     80103210 <pipealloc+0xb0>
    fileclose(*f1);
80103239:	89 04 24             	mov    %eax,(%esp)
8010323c:	e8 cf db ff ff       	call   80100e10 <fileclose>
  return -1;
}
80103241:	83 c4 1c             	add    $0x1c,%esp
80103244:	89 d8                	mov    %ebx,%eax
80103246:	5b                   	pop    %ebx
80103247:	5e                   	pop    %esi
80103248:	5f                   	pop    %edi
80103249:	5d                   	pop    %ebp
8010324a:	c3                   	ret    
8010324b:	90                   	nop
8010324c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103250 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	56                   	push   %esi
80103254:	53                   	push   %ebx
80103255:	83 ec 10             	sub    $0x10,%esp
80103258:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010325b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010325e:	89 1c 24             	mov    %ebx,(%esp)
80103261:	e8 ca 0e 00 00       	call   80104130 <acquire>
  if(writable){
80103266:	85 f6                	test   %esi,%esi
80103268:	74 3e                	je     801032a8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010326a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103270:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103277:	00 00 00 
    wakeup(&p->nread);
8010327a:	89 04 24             	mov    %eax,(%esp)
8010327d:	e8 fe 0a 00 00       	call   80103d80 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103282:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103288:	85 d2                	test   %edx,%edx
8010328a:	75 0a                	jne    80103296 <pipeclose+0x46>
8010328c:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103292:	85 c0                	test   %eax,%eax
80103294:	74 32                	je     801032c8 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103296:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103299:	83 c4 10             	add    $0x10,%esp
8010329c:	5b                   	pop    %ebx
8010329d:	5e                   	pop    %esi
8010329e:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010329f:	e9 7c 0f 00 00       	jmp    80104220 <release>
801032a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801032a8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801032ae:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032b5:	00 00 00 
    wakeup(&p->nwrite);
801032b8:	89 04 24             	mov    %eax,(%esp)
801032bb:	e8 c0 0a 00 00       	call   80103d80 <wakeup>
801032c0:	eb c0                	jmp    80103282 <pipeclose+0x32>
801032c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801032c8:	89 1c 24             	mov    %ebx,(%esp)
801032cb:	e8 50 0f 00 00       	call   80104220 <release>
    kfree((char*)p);
801032d0:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
801032d3:	83 c4 10             	add    $0x10,%esp
801032d6:	5b                   	pop    %ebx
801032d7:	5e                   	pop    %esi
801032d8:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801032d9:	e9 02 f0 ff ff       	jmp    801022e0 <kfree>
801032de:	66 90                	xchg   %ax,%ax

801032e0 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801032e0:	55                   	push   %ebp
801032e1:	89 e5                	mov    %esp,%ebp
801032e3:	57                   	push   %edi
801032e4:	56                   	push   %esi
801032e5:	53                   	push   %ebx
801032e6:	83 ec 1c             	sub    $0x1c,%esp
801032e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801032ec:	89 1c 24             	mov    %ebx,(%esp)
801032ef:	e8 3c 0e 00 00       	call   80104130 <acquire>
  for(i = 0; i < n; i++){
801032f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
801032f7:	85 c9                	test   %ecx,%ecx
801032f9:	0f 8e b2 00 00 00    	jle    801033b1 <pipewrite+0xd1>
801032ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103302:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103308:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010330e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103314:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103317:	03 4d 10             	add    0x10(%ebp),%ecx
8010331a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010331d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103323:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103329:	39 c8                	cmp    %ecx,%eax
8010332b:	74 38                	je     80103365 <pipewrite+0x85>
8010332d:	eb 55                	jmp    80103384 <pipewrite+0xa4>
8010332f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103330:	e8 5b 03 00 00       	call   80103690 <myproc>
80103335:	8b 40 28             	mov    0x28(%eax),%eax
80103338:	85 c0                	test   %eax,%eax
8010333a:	75 33                	jne    8010336f <pipewrite+0x8f>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010333c:	89 3c 24             	mov    %edi,(%esp)
8010333f:	e8 3c 0a 00 00       	call   80103d80 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103344:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103348:	89 34 24             	mov    %esi,(%esp)
8010334b:	e8 a0 08 00 00       	call   80103bf0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103350:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103356:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010335c:	05 00 02 00 00       	add    $0x200,%eax
80103361:	39 c2                	cmp    %eax,%edx
80103363:	75 23                	jne    80103388 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103365:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010336b:	85 d2                	test   %edx,%edx
8010336d:	75 c1                	jne    80103330 <pipewrite+0x50>
        release(&p->lock);
8010336f:	89 1c 24             	mov    %ebx,(%esp)
80103372:	e8 a9 0e 00 00       	call   80104220 <release>
        return -1;
80103377:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010337c:	83 c4 1c             	add    $0x1c,%esp
8010337f:	5b                   	pop    %ebx
80103380:	5e                   	pop    %esi
80103381:	5f                   	pop    %edi
80103382:	5d                   	pop    %ebp
80103383:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103384:	89 c2                	mov    %eax,%edx
80103386:	66 90                	xchg   %ax,%ax
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103388:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010338b:	8d 42 01             	lea    0x1(%edx),%eax
8010338e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103394:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
8010339a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010339e:	0f b6 09             	movzbl (%ecx),%ecx
801033a1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801033a5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033a8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033ab:	0f 85 6c ff ff ff    	jne    8010331d <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033b1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033b7:	89 04 24             	mov    %eax,(%esp)
801033ba:	e8 c1 09 00 00       	call   80103d80 <wakeup>
  release(&p->lock);
801033bf:	89 1c 24             	mov    %ebx,(%esp)
801033c2:	e8 59 0e 00 00       	call   80104220 <release>
  return n;
801033c7:	8b 45 10             	mov    0x10(%ebp),%eax
801033ca:	eb b0                	jmp    8010337c <pipewrite+0x9c>
801033cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033d0 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
801033d0:	55                   	push   %ebp
801033d1:	89 e5                	mov    %esp,%ebp
801033d3:	57                   	push   %edi
801033d4:	56                   	push   %esi
801033d5:	53                   	push   %ebx
801033d6:	83 ec 1c             	sub    $0x1c,%esp
801033d9:	8b 75 08             	mov    0x8(%ebp),%esi
801033dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801033df:	89 34 24             	mov    %esi,(%esp)
801033e2:	e8 49 0d 00 00       	call   80104130 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801033e7:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801033ed:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801033f3:	75 5b                	jne    80103450 <piperead+0x80>
801033f5:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801033fb:	85 db                	test   %ebx,%ebx
801033fd:	74 51                	je     80103450 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801033ff:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103405:	eb 25                	jmp    8010342c <piperead+0x5c>
80103407:	90                   	nop
80103408:	89 74 24 04          	mov    %esi,0x4(%esp)
8010340c:	89 1c 24             	mov    %ebx,(%esp)
8010340f:	e8 dc 07 00 00       	call   80103bf0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103414:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010341a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103420:	75 2e                	jne    80103450 <piperead+0x80>
80103422:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103428:	85 d2                	test   %edx,%edx
8010342a:	74 24                	je     80103450 <piperead+0x80>
    if(myproc()->killed){
8010342c:	e8 5f 02 00 00       	call   80103690 <myproc>
80103431:	8b 48 28             	mov    0x28(%eax),%ecx
80103434:	85 c9                	test   %ecx,%ecx
80103436:	74 d0                	je     80103408 <piperead+0x38>
      release(&p->lock);
80103438:	89 34 24             	mov    %esi,(%esp)
8010343b:	e8 e0 0d 00 00       	call   80104220 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103440:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103443:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103448:	5b                   	pop    %ebx
80103449:	5e                   	pop    %esi
8010344a:	5f                   	pop    %edi
8010344b:	5d                   	pop    %ebp
8010344c:	c3                   	ret    
8010344d:	8d 76 00             	lea    0x0(%esi),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103450:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103453:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103455:	85 d2                	test   %edx,%edx
80103457:	7f 2b                	jg     80103484 <piperead+0xb4>
80103459:	eb 31                	jmp    8010348c <piperead+0xbc>
8010345b:	90                   	nop
8010345c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103460:	8d 48 01             	lea    0x1(%eax),%ecx
80103463:	25 ff 01 00 00       	and    $0x1ff,%eax
80103468:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010346e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103473:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103476:	83 c3 01             	add    $0x1,%ebx
80103479:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010347c:	74 0e                	je     8010348c <piperead+0xbc>
    if(p->nread == p->nwrite)
8010347e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103484:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010348a:	75 d4                	jne    80103460 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010348c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103492:	89 04 24             	mov    %eax,(%esp)
80103495:	e8 e6 08 00 00       	call   80103d80 <wakeup>
  release(&p->lock);
8010349a:	89 34 24             	mov    %esi,(%esp)
8010349d:	e8 7e 0d 00 00       	call   80104220 <release>
  return i;
}
801034a2:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
801034a5:	89 d8                	mov    %ebx,%eax
}
801034a7:	5b                   	pop    %ebx
801034a8:	5e                   	pop    %esi
801034a9:	5f                   	pop    %edi
801034aa:	5d                   	pop    %ebp
801034ab:	c3                   	ret    
801034ac:	66 90                	xchg   %ax,%ax
801034ae:	66 90                	xchg   %ax,%ax

801034b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034b4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034b9:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801034bc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034c3:	e8 68 0c 00 00       	call   80104130 <acquire>
801034c8:	eb 11                	jmp    801034db <allocproc+0x2b>
801034ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034d0:	83 eb 80             	sub    $0xffffff80,%ebx
801034d3:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801034d9:	74 7d                	je     80103558 <allocproc+0xa8>
    if(p->state == UNUSED)
801034db:	8b 43 10             	mov    0x10(%ebx),%eax
801034de:	85 c0                	test   %eax,%eax
801034e0:	75 ee                	jne    801034d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801034e2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801034e7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801034ee:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->pid = nextpid++;
801034f5:	8d 50 01             	lea    0x1(%eax),%edx
801034f8:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
801034fe:	89 43 14             	mov    %eax,0x14(%ebx)

  release(&ptable.lock);
80103501:	e8 1a 0d 00 00       	call   80104220 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103506:	e8 85 ef ff ff       	call   80102490 <kalloc>
8010350b:	85 c0                	test   %eax,%eax
8010350d:	89 43 0c             	mov    %eax,0xc(%ebx)
80103510:	74 5a                	je     8010356c <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103512:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103518:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010351d:	89 53 1c             	mov    %edx,0x1c(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103520:	c7 40 14 05 54 10 80 	movl   $0x80105405,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103527:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010352e:	00 
8010352f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103536:	00 
80103537:	89 04 24             	mov    %eax,(%esp)
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
8010353a:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010353d:	e8 2e 0d 00 00       	call   80104270 <memset>
  p->context->eip = (uint)forkret;
80103542:	8b 43 20             	mov    0x20(%ebx),%eax
80103545:	c7 40 10 80 35 10 80 	movl   $0x80103580,0x10(%eax)

  return p;
8010354c:	89 d8                	mov    %ebx,%eax
}
8010354e:	83 c4 14             	add    $0x14,%esp
80103551:	5b                   	pop    %ebx
80103552:	5d                   	pop    %ebp
80103553:	c3                   	ret    
80103554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103558:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010355f:	e8 bc 0c 00 00       	call   80104220 <release>
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103564:	83 c4 14             	add    $0x14,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
80103567:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103569:	5b                   	pop    %ebx
8010356a:	5d                   	pop    %ebp
8010356b:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010356c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return 0;
80103573:	eb d9                	jmp    8010354e <allocproc+0x9e>
80103575:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103580 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103580:	55                   	push   %ebp
80103581:	89 e5                	mov    %esp,%ebp
80103583:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103586:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010358d:	e8 8e 0c 00 00       	call   80104220 <release>

  if (first) {
80103592:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103597:	85 c0                	test   %eax,%eax
80103599:	75 05                	jne    801035a0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010359b:	c9                   	leave  
8010359c:	c3                   	ret    
8010359d:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
801035a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801035a7:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035ae:	00 00 00 
    iinit(ROOTDEV);
801035b1:	e8 aa de ff ff       	call   80101460 <iinit>
    initlog(ROOTDEV);
801035b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035bd:	e8 9e f4 ff ff       	call   80102a60 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035c2:	c9                   	leave  
801035c3:	c3                   	ret    
801035c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801035d0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801035d6:	c7 44 24 04 f5 72 10 	movl   $0x801072f5,0x4(%esp)
801035dd:	80 
801035de:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035e5:	e8 56 0a 00 00       	call   80104040 <initlock>
}
801035ea:	c9                   	leave  
801035eb:	c3                   	ret    
801035ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801035f0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	56                   	push   %esi
801035f4:	53                   	push   %ebx
801035f5:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801035f8:	9c                   	pushf  
801035f9:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
801035fa:	f6 c4 02             	test   $0x2,%ah
801035fd:	75 57                	jne    80103656 <mycpu+0x66>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
801035ff:	e8 4c f1 ff ff       	call   80102750 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103604:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010360a:	85 f6                	test   %esi,%esi
8010360c:	7e 3c                	jle    8010364a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010360e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103615:	39 c2                	cmp    %eax,%edx
80103617:	74 2d                	je     80103646 <mycpu+0x56>
80103619:	b9 30 28 11 80       	mov    $0x80112830,%ecx
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
8010361e:	31 d2                	xor    %edx,%edx
80103620:	83 c2 01             	add    $0x1,%edx
80103623:	39 f2                	cmp    %esi,%edx
80103625:	74 23                	je     8010364a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103627:	0f b6 19             	movzbl (%ecx),%ebx
8010362a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103630:	39 c3                	cmp    %eax,%ebx
80103632:	75 ec                	jne    80103620 <mycpu+0x30>
      return &cpus[i];
80103634:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010363a:	83 c4 10             	add    $0x10,%esp
8010363d:	5b                   	pop    %ebx
8010363e:	5e                   	pop    %esi
8010363f:	5d                   	pop    %ebp
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103640:	05 80 27 11 80       	add    $0x80112780,%eax
  }
  panic("unknown apicid\n");
}
80103645:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103646:	31 d2                	xor    %edx,%edx
80103648:	eb ea                	jmp    80103634 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010364a:	c7 04 24 fc 72 10 80 	movl   $0x801072fc,(%esp)
80103651:	e8 0a cd ff ff       	call   80100360 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103656:	c7 04 24 d8 73 10 80 	movl   $0x801073d8,(%esp)
8010365d:	e8 fe cc ff ff       	call   80100360 <panic>
80103662:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103670 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103676:	e8 75 ff ff ff       	call   801035f0 <mycpu>
}
8010367b:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
8010367c:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103681:	c1 f8 04             	sar    $0x4,%eax
80103684:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010368a:	c3                   	ret    
8010368b:	90                   	nop
8010368c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103690 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	53                   	push   %ebx
80103694:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103697:	e8 54 0a 00 00       	call   801040f0 <pushcli>
  c = mycpu();
8010369c:	e8 4f ff ff ff       	call   801035f0 <mycpu>
  p = c->proc;
801036a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036a7:	e8 04 0b 00 00       	call   801041b0 <popcli>
  return p;
}
801036ac:	83 c4 04             	add    $0x4,%esp
801036af:	89 d8                	mov    %ebx,%eax
801036b1:	5b                   	pop    %ebx
801036b2:	5d                   	pop    %ebp
801036b3:	c3                   	ret    
801036b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036c0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	53                   	push   %ebx
801036c4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801036c7:	e8 e4 fd ff ff       	call   801034b0 <allocproc>
801036cc:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
801036ce:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801036d3:	e8 e8 32 00 00       	call   801069c0 <setupkvm>
801036d8:	85 c0                	test   %eax,%eax
801036da:	89 43 08             	mov    %eax,0x8(%ebx)
801036dd:	0f 84 d4 00 00 00    	je     801037b7 <userinit+0xf7>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801036e3:	89 04 24             	mov    %eax,(%esp)
801036e6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
801036ed:	00 
801036ee:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
801036f5:	80 
801036f6:	e8 d5 2f 00 00       	call   801066d0 <inituvm>
  p->sz = PGSIZE;
801036fb:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103701:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103708:	00 
80103709:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103710:	00 
80103711:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103714:	89 04 24             	mov    %eax,(%esp)
80103717:	e8 54 0b 00 00       	call   80104270 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010371c:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010371f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103724:	b9 23 00 00 00       	mov    $0x23,%ecx
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103729:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010372d:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103730:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103734:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103737:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010373b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010373f:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103742:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103746:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010374a:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010374d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103754:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103757:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010375e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103761:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103768:	8d 43 70             	lea    0x70(%ebx),%eax
8010376b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103772:	00 
80103773:	c7 44 24 04 25 73 10 	movl   $0x80107325,0x4(%esp)
8010377a:	80 
8010377b:	89 04 24             	mov    %eax,(%esp)
8010377e:	e8 cd 0c 00 00       	call   80104450 <safestrcpy>
  p->cwd = namei("/");
80103783:	c7 04 24 2e 73 10 80 	movl   $0x8010732e,(%esp)
8010378a:	e8 61 e7 ff ff       	call   80101ef0 <namei>
8010378f:	89 43 6c             	mov    %eax,0x6c(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103792:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103799:	e8 92 09 00 00       	call   80104130 <acquire>

  p->state = RUNNABLE;
8010379e:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)

  release(&ptable.lock);
801037a5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037ac:	e8 6f 0a 00 00       	call   80104220 <release>
}
801037b1:	83 c4 14             	add    $0x14,%esp
801037b4:	5b                   	pop    %ebx
801037b5:	5d                   	pop    %ebp
801037b6:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
801037b7:	c7 04 24 0c 73 10 80 	movl   $0x8010730c,(%esp)
801037be:	e8 9d cb ff ff       	call   80100360 <panic>
801037c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037d0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	56                   	push   %esi
801037d4:	53                   	push   %ebx
801037d5:	83 ec 10             	sub    $0x10,%esp
801037d8:	8b 75 08             	mov    0x8(%ebp),%esi
  uint sz;
  struct proc *curproc = myproc();
801037db:	e8 b0 fe ff ff       	call   80103690 <myproc>

  sz = curproc->sz;
  if(n > 0){
801037e0:	83 fe 00             	cmp    $0x0,%esi
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();
801037e3:	89 c3                	mov    %eax,%ebx

  sz = curproc->sz;
801037e5:	8b 00                	mov    (%eax),%eax
  if(n > 0){
801037e7:	7e 2f                	jle    80103818 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801037e9:	01 c6                	add    %eax,%esi
801037eb:	89 74 24 08          	mov    %esi,0x8(%esp)
801037ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801037f3:	8b 43 08             	mov    0x8(%ebx),%eax
801037f6:	89 04 24             	mov    %eax,(%esp)
801037f9:	e8 22 30 00 00       	call   80106820 <allocuvm>
801037fe:	85 c0                	test   %eax,%eax
80103800:	74 36                	je     80103838 <growproc+0x68>
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103802:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103804:	89 1c 24             	mov    %ebx,(%esp)
80103807:	e8 b4 2d 00 00       	call   801065c0 <switchuvm>
  return 0;
8010380c:	31 c0                	xor    %eax,%eax
}
8010380e:	83 c4 10             	add    $0x10,%esp
80103811:	5b                   	pop    %ebx
80103812:	5e                   	pop    %esi
80103813:	5d                   	pop    %ebp
80103814:	c3                   	ret    
80103815:	8d 76 00             	lea    0x0(%esi),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103818:	74 e8                	je     80103802 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010381a:	01 c6                	add    %eax,%esi
8010381c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103820:	89 44 24 04          	mov    %eax,0x4(%esp)
80103824:	8b 43 08             	mov    0x8(%ebx),%eax
80103827:	89 04 24             	mov    %eax,(%esp)
8010382a:	e8 f1 30 00 00       	call   80106920 <deallocuvm>
8010382f:	85 c0                	test   %eax,%eax
80103831:	75 cf                	jne    80103802 <growproc+0x32>
80103833:	90                   	nop
80103834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103838:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010383d:	eb cf                	jmp    8010380e <growproc+0x3e>
8010383f:	90                   	nop

80103840 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	57                   	push   %edi
80103844:	56                   	push   %esi
80103845:	53                   	push   %ebx
80103846:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80103849:	e8 42 fe ff ff       	call   80103690 <myproc>
8010384e:	89 c3                	mov    %eax,%ebx

  // Allocate process.
  if((np = allocproc()) == 0){
80103850:	e8 5b fc ff ff       	call   801034b0 <allocproc>
80103855:	85 c0                	test   %eax,%eax
80103857:	89 c7                	mov    %eax,%edi
80103859:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010385c:	0f 84 c4 00 00 00    	je     80103926 <fork+0xe6>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->sb)) == 0){
80103862:	8b 43 04             	mov    0x4(%ebx),%eax
80103865:	89 44 24 08          	mov    %eax,0x8(%esp)
80103869:	8b 03                	mov    (%ebx),%eax
8010386b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010386f:	8b 43 08             	mov    0x8(%ebx),%eax
80103872:	89 04 24             	mov    %eax,(%esp)
80103875:	e8 26 32 00 00       	call   80106aa0 <copyuvm>
8010387a:	85 c0                	test   %eax,%eax
8010387c:	89 47 08             	mov    %eax,0x8(%edi)
8010387f:	0f 84 a8 00 00 00    	je     8010392d <fork+0xed>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103885:	8b 03                	mov    (%ebx),%eax
80103887:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010388a:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
  *np->tf = *curproc->tf;
8010388c:	8b 79 1c             	mov    0x1c(%ecx),%edi
8010388f:	89 c8                	mov    %ecx,%eax
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
80103891:	89 59 18             	mov    %ebx,0x18(%ecx)
  *np->tf = *curproc->tf;
80103894:	8b 73 1c             	mov    0x1c(%ebx),%esi
80103897:	b9 13 00 00 00       	mov    $0x13,%ecx
8010389c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010389e:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801038a0:	8b 40 1c             	mov    0x1c(%eax),%eax
801038a3:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801038aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
801038b0:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
801038b4:	85 c0                	test   %eax,%eax
801038b6:	74 0f                	je     801038c7 <fork+0x87>
      np->ofile[i] = filedup(curproc->ofile[i]);
801038b8:	89 04 24             	mov    %eax,(%esp)
801038bb:	e8 00 d5 ff ff       	call   80100dc0 <filedup>
801038c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038c3:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801038c7:	83 c6 01             	add    $0x1,%esi
801038ca:	83 fe 10             	cmp    $0x10,%esi
801038cd:	75 e1                	jne    801038b0 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801038cf:	8b 43 6c             	mov    0x6c(%ebx),%eax

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038d2:	83 c3 70             	add    $0x70,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801038d5:	89 04 24             	mov    %eax,(%esp)
801038d8:	e8 93 dd ff ff       	call   80101670 <idup>
801038dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801038e0:	89 47 6c             	mov    %eax,0x6c(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038e3:	8d 47 70             	lea    0x70(%edi),%eax
801038e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801038ea:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801038f1:	00 
801038f2:	89 04 24             	mov    %eax,(%esp)
801038f5:	e8 56 0b 00 00       	call   80104450 <safestrcpy>

  pid = np->pid;
801038fa:	8b 5f 14             	mov    0x14(%edi),%ebx

  acquire(&ptable.lock);
801038fd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103904:	e8 27 08 00 00       	call   80104130 <acquire>

  np->state = RUNNABLE;
80103909:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)

  release(&ptable.lock);
80103910:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103917:	e8 04 09 00 00       	call   80104220 <release>

  return pid;
8010391c:	89 d8                	mov    %ebx,%eax
}
8010391e:	83 c4 1c             	add    $0x1c,%esp
80103921:	5b                   	pop    %ebx
80103922:	5e                   	pop    %esi
80103923:	5f                   	pop    %edi
80103924:	5d                   	pop    %ebp
80103925:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103926:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010392b:	eb f1                	jmp    8010391e <fork+0xde>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->sb)) == 0){
    kfree(np->kstack);
8010392d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103930:	8b 47 0c             	mov    0xc(%edi),%eax
80103933:	89 04 24             	mov    %eax,(%esp)
80103936:	e8 a5 e9 ff ff       	call   801022e0 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
8010393b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->sb)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
80103940:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    np->state = UNUSED;
80103947:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
    return -1;
8010394e:	eb ce                	jmp    8010391e <fork+0xde>

80103950 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	57                   	push   %edi
80103954:	56                   	push   %esi
80103955:	53                   	push   %ebx
80103956:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103959:	e8 92 fc ff ff       	call   801035f0 <mycpu>
8010395e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103960:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103967:	00 00 00 
8010396a:	8d 78 04             	lea    0x4(%eax),%edi
8010396d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103970:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103971:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103978:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
8010397d:	e8 ae 07 00 00       	call   80104130 <acquire>
80103982:	eb 0f                	jmp    80103993 <scheduler+0x43>
80103984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103988:	83 eb 80             	sub    $0xffffff80,%ebx
8010398b:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103991:	74 45                	je     801039d8 <scheduler+0x88>
      if(p->state != RUNNABLE)
80103993:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
80103997:	75 ef                	jne    80103988 <scheduler+0x38>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103999:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010399f:	89 1c 24             	mov    %ebx,(%esp)
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039a2:	83 eb 80             	sub    $0xffffff80,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
801039a5:	e8 16 2c 00 00       	call   801065c0 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
801039aa:	8b 43 a0             	mov    -0x60(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
801039ad:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)

      swtch(&(c->scheduler), p->context);
801039b4:	89 3c 24             	mov    %edi,(%esp)
801039b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801039bb:	e8 eb 0a 00 00       	call   801044ab <swtch>
      switchkvm();
801039c0:	e8 db 2b 00 00       	call   801065a0 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039c5:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
801039cb:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801039d2:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039d5:	75 bc                	jne    80103993 <scheduler+0x43>
801039d7:	90                   	nop

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
801039d8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039df:	e8 3c 08 00 00       	call   80104220 <release>

  }
801039e4:	eb 8a                	jmp    80103970 <scheduler+0x20>
801039e6:	8d 76 00             	lea    0x0(%esi),%esi
801039e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039f0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	56                   	push   %esi
801039f4:	53                   	push   %ebx
801039f5:	83 ec 10             	sub    $0x10,%esp
  int intena;
  struct proc *p = myproc();
801039f8:	e8 93 fc ff ff       	call   80103690 <myproc>

  if(!holding(&ptable.lock))
801039fd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();
80103a04:	89 c3                	mov    %eax,%ebx

  if(!holding(&ptable.lock))
80103a06:	e8 b5 06 00 00       	call   801040c0 <holding>
80103a0b:	85 c0                	test   %eax,%eax
80103a0d:	74 4f                	je     80103a5e <sched+0x6e>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103a0f:	e8 dc fb ff ff       	call   801035f0 <mycpu>
80103a14:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103a1b:	75 65                	jne    80103a82 <sched+0x92>
    panic("sched locks");
  if(p->state == RUNNING)
80103a1d:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
80103a21:	74 53                	je     80103a76 <sched+0x86>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a23:	9c                   	pushf  
80103a24:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103a25:	f6 c4 02             	test   $0x2,%ah
80103a28:	75 40                	jne    80103a6a <sched+0x7a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103a2a:	e8 c1 fb ff ff       	call   801035f0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103a2f:	83 c3 20             	add    $0x20,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103a32:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103a38:	e8 b3 fb ff ff       	call   801035f0 <mycpu>
80103a3d:	8b 40 04             	mov    0x4(%eax),%eax
80103a40:	89 1c 24             	mov    %ebx,(%esp)
80103a43:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a47:	e8 5f 0a 00 00       	call   801044ab <swtch>
  mycpu()->intena = intena;
80103a4c:	e8 9f fb ff ff       	call   801035f0 <mycpu>
80103a51:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103a57:	83 c4 10             	add    $0x10,%esp
80103a5a:	5b                   	pop    %ebx
80103a5b:	5e                   	pop    %esi
80103a5c:	5d                   	pop    %ebp
80103a5d:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103a5e:	c7 04 24 30 73 10 80 	movl   $0x80107330,(%esp)
80103a65:	e8 f6 c8 ff ff       	call   80100360 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103a6a:	c7 04 24 5c 73 10 80 	movl   $0x8010735c,(%esp)
80103a71:	e8 ea c8 ff ff       	call   80100360 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103a76:	c7 04 24 4e 73 10 80 	movl   $0x8010734e,(%esp)
80103a7d:	e8 de c8 ff ff       	call   80100360 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103a82:	c7 04 24 42 73 10 80 	movl   $0x80107342,(%esp)
80103a89:	e8 d2 c8 ff ff       	call   80100360 <panic>
80103a8e:	66 90                	xchg   %ax,%ax

80103a90 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	56                   	push   %esi
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103a94:	31 f6                	xor    %esi,%esi
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103a96:	53                   	push   %ebx
80103a97:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103a9a:	e8 f1 fb ff ff       	call   80103690 <myproc>
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103a9f:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
80103aa5:	89 c3                	mov    %eax,%ebx
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103aa7:	0f 84 ea 00 00 00    	je     80103b97 <exit+0x107>
80103aad:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103ab0:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103ab4:	85 c0                	test   %eax,%eax
80103ab6:	74 10                	je     80103ac8 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103ab8:	89 04 24             	mov    %eax,(%esp)
80103abb:	e8 50 d3 ff ff       	call   80100e10 <fileclose>
      curproc->ofile[fd] = 0;
80103ac0:	c7 44 b3 2c 00 00 00 	movl   $0x0,0x2c(%ebx,%esi,4)
80103ac7:	00 

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103ac8:	83 c6 01             	add    $0x1,%esi
80103acb:	83 fe 10             	cmp    $0x10,%esi
80103ace:	75 e0                	jne    80103ab0 <exit+0x20>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103ad0:	e8 2b f0 ff ff       	call   80102b00 <begin_op>
  iput(curproc->cwd);
80103ad5:	8b 43 6c             	mov    0x6c(%ebx),%eax
80103ad8:	89 04 24             	mov    %eax,(%esp)
80103adb:	e8 e0 dc ff ff       	call   801017c0 <iput>
  end_op();
80103ae0:	e8 8b f0 ff ff       	call   80102b70 <end_op>
  curproc->cwd = 0;
80103ae5:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)

  acquire(&ptable.lock);
80103aec:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103af3:	e8 38 06 00 00       	call   80104130 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103af8:	8b 43 18             	mov    0x18(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103afb:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b00:	eb 11                	jmp    80103b13 <exit+0x83>
80103b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b08:	83 ea 80             	sub    $0xffffff80,%edx
80103b0b:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b11:	74 1d                	je     80103b30 <exit+0xa0>
    if(p->state == SLEEPING && p->chan == chan)
80103b13:	83 7a 10 02          	cmpl   $0x2,0x10(%edx)
80103b17:	75 ef                	jne    80103b08 <exit+0x78>
80103b19:	3b 42 24             	cmp    0x24(%edx),%eax
80103b1c:	75 ea                	jne    80103b08 <exit+0x78>
      p->state = RUNNABLE;
80103b1e:	c7 42 10 03 00 00 00 	movl   $0x3,0x10(%edx)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b25:	83 ea 80             	sub    $0xffffff80,%edx
80103b28:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b2e:	75 e3                	jne    80103b13 <exit+0x83>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103b30:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103b35:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103b3a:	eb 0f                	jmp    80103b4b <exit+0xbb>
80103b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b40:	83 e9 80             	sub    $0xffffff80,%ecx
80103b43:	81 f9 54 4d 11 80    	cmp    $0x80114d54,%ecx
80103b49:	74 34                	je     80103b7f <exit+0xef>
    if(p->parent == curproc){
80103b4b:	39 59 18             	cmp    %ebx,0x18(%ecx)
80103b4e:	75 f0                	jne    80103b40 <exit+0xb0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103b50:	83 79 10 05          	cmpl   $0x5,0x10(%ecx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103b54:	89 41 18             	mov    %eax,0x18(%ecx)
      if(p->state == ZOMBIE)
80103b57:	75 e7                	jne    80103b40 <exit+0xb0>
80103b59:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b5e:	eb 0b                	jmp    80103b6b <exit+0xdb>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b60:	83 ea 80             	sub    $0xffffff80,%edx
80103b63:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b69:	74 d5                	je     80103b40 <exit+0xb0>
    if(p->state == SLEEPING && p->chan == chan)
80103b6b:	83 7a 10 02          	cmpl   $0x2,0x10(%edx)
80103b6f:	75 ef                	jne    80103b60 <exit+0xd0>
80103b71:	3b 42 24             	cmp    0x24(%edx),%eax
80103b74:	75 ea                	jne    80103b60 <exit+0xd0>
      p->state = RUNNABLE;
80103b76:	c7 42 10 03 00 00 00 	movl   $0x3,0x10(%edx)
80103b7d:	eb e1                	jmp    80103b60 <exit+0xd0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103b7f:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  sched();
80103b86:	e8 65 fe ff ff       	call   801039f0 <sched>
  panic("zombie exit");
80103b8b:	c7 04 24 7d 73 10 80 	movl   $0x8010737d,(%esp)
80103b92:	e8 c9 c7 ff ff       	call   80100360 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103b97:	c7 04 24 70 73 10 80 	movl   $0x80107370,(%esp)
80103b9e:	e8 bd c7 ff ff       	call   80100360 <panic>
80103ba3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bb0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103bb6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bbd:	e8 6e 05 00 00       	call   80104130 <acquire>
  myproc()->state = RUNNABLE;
80103bc2:	e8 c9 fa ff ff       	call   80103690 <myproc>
80103bc7:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  sched();
80103bce:	e8 1d fe ff ff       	call   801039f0 <sched>
  release(&ptable.lock);
80103bd3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bda:	e8 41 06 00 00       	call   80104220 <release>
}
80103bdf:	c9                   	leave  
80103be0:	c3                   	ret    
80103be1:	eb 0d                	jmp    80103bf0 <sleep>
80103be3:	90                   	nop
80103be4:	90                   	nop
80103be5:	90                   	nop
80103be6:	90                   	nop
80103be7:	90                   	nop
80103be8:	90                   	nop
80103be9:	90                   	nop
80103bea:	90                   	nop
80103beb:	90                   	nop
80103bec:	90                   	nop
80103bed:	90                   	nop
80103bee:	90                   	nop
80103bef:	90                   	nop

80103bf0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	57                   	push   %edi
80103bf4:	56                   	push   %esi
80103bf5:	53                   	push   %ebx
80103bf6:	83 ec 1c             	sub    $0x1c,%esp
80103bf9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103bfc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103bff:	e8 8c fa ff ff       	call   80103690 <myproc>
  
  if(p == 0)
80103c04:	85 c0                	test   %eax,%eax
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
80103c06:	89 c3                	mov    %eax,%ebx
  
  if(p == 0)
80103c08:	0f 84 7c 00 00 00    	je     80103c8a <sleep+0x9a>
    panic("sleep");

  if(lk == 0)
80103c0e:	85 f6                	test   %esi,%esi
80103c10:	74 6c                	je     80103c7e <sleep+0x8e>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103c12:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103c18:	74 46                	je     80103c60 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103c1a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c21:	e8 0a 05 00 00       	call   80104130 <acquire>
    release(lk);
80103c26:	89 34 24             	mov    %esi,(%esp)
80103c29:	e8 f2 05 00 00       	call   80104220 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103c2e:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
80103c31:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)

  sched();
80103c38:	e8 b3 fd ff ff       	call   801039f0 <sched>

  // Tidy up.
  p->chan = 0;
80103c3d:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103c44:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c4b:	e8 d0 05 00 00       	call   80104220 <release>
    acquire(lk);
80103c50:	89 75 08             	mov    %esi,0x8(%ebp)
  }
}
80103c53:	83 c4 1c             	add    $0x1c,%esp
80103c56:	5b                   	pop    %ebx
80103c57:	5e                   	pop    %esi
80103c58:	5f                   	pop    %edi
80103c59:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103c5a:	e9 d1 04 00 00       	jmp    80104130 <acquire>
80103c5f:	90                   	nop
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103c60:	89 78 24             	mov    %edi,0x24(%eax)
  p->state = SLEEPING;
80103c63:	c7 40 10 02 00 00 00 	movl   $0x2,0x10(%eax)

  sched();
80103c6a:	e8 81 fd ff ff       	call   801039f0 <sched>

  // Tidy up.
  p->chan = 0;
80103c6f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103c76:	83 c4 1c             	add    $0x1c,%esp
80103c79:	5b                   	pop    %ebx
80103c7a:	5e                   	pop    %esi
80103c7b:	5f                   	pop    %edi
80103c7c:	5d                   	pop    %ebp
80103c7d:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103c7e:	c7 04 24 8f 73 10 80 	movl   $0x8010738f,(%esp)
80103c85:	e8 d6 c6 ff ff       	call   80100360 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103c8a:	c7 04 24 89 73 10 80 	movl   $0x80107389,(%esp)
80103c91:	e8 ca c6 ff ff       	call   80100360 <panic>
80103c96:	8d 76 00             	lea    0x0(%esi),%esi
80103c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ca0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	56                   	push   %esi
80103ca4:	53                   	push   %ebx
80103ca5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103ca8:	e8 e3 f9 ff ff       	call   80103690 <myproc>
  
  acquire(&ptable.lock);
80103cad:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103cb4:	89 c6                	mov    %eax,%esi
  
  acquire(&ptable.lock);
80103cb6:	e8 75 04 00 00       	call   80104130 <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103cbb:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cbd:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103cc2:	eb 0f                	jmp    80103cd3 <wait+0x33>
80103cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cc8:	83 eb 80             	sub    $0xffffff80,%ebx
80103ccb:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103cd1:	74 1d                	je     80103cf0 <wait+0x50>
      if(p->parent != curproc)
80103cd3:	39 73 18             	cmp    %esi,0x18(%ebx)
80103cd6:	75 f0                	jne    80103cc8 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103cd8:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
80103cdc:	74 2f                	je     80103d0d <wait+0x6d>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cde:	83 eb 80             	sub    $0xffffff80,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103ce1:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ce6:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103cec:	75 e5                	jne    80103cd3 <wait+0x33>
80103cee:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103cf0:	85 c0                	test   %eax,%eax
80103cf2:	74 6e                	je     80103d62 <wait+0xc2>
80103cf4:	8b 46 28             	mov    0x28(%esi),%eax
80103cf7:	85 c0                	test   %eax,%eax
80103cf9:	75 67                	jne    80103d62 <wait+0xc2>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103cfb:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103d02:	80 
80103d03:	89 34 24             	mov    %esi,(%esp)
80103d06:	e8 e5 fe ff ff       	call   80103bf0 <sleep>
  }
80103d0b:	eb ae                	jmp    80103cbb <wait+0x1b>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103d0d:	8b 43 0c             	mov    0xc(%ebx),%eax
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103d10:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
80103d13:	89 04 24             	mov    %eax,(%esp)
80103d16:	e8 c5 e5 ff ff       	call   801022e0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103d1b:	8b 43 08             	mov    0x8(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103d1e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
80103d25:	89 04 24             	mov    %eax,(%esp)
80103d28:	e8 13 2c 00 00       	call   80106940 <freevm>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
80103d2d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
80103d34:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
80103d3b:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
80103d42:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
80103d46:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
80103d4d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
80103d54:	e8 c7 04 00 00       	call   80104220 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103d59:	83 c4 10             	add    $0x10,%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103d5c:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103d5e:	5b                   	pop    %ebx
80103d5f:	5e                   	pop    %esi
80103d60:	5d                   	pop    %ebp
80103d61:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103d62:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d69:	e8 b2 04 00 00       	call   80104220 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103d6e:	83 c4 10             	add    $0x10,%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103d71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103d76:	5b                   	pop    %ebx
80103d77:	5e                   	pop    %esi
80103d78:	5d                   	pop    %ebp
80103d79:	c3                   	ret    
80103d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d80 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	53                   	push   %ebx
80103d84:	83 ec 14             	sub    $0x14,%esp
80103d87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103d8a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d91:	e8 9a 03 00 00       	call   80104130 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d96:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d9b:	eb 0d                	jmp    80103daa <wakeup+0x2a>
80103d9d:	8d 76 00             	lea    0x0(%esi),%esi
80103da0:	83 e8 80             	sub    $0xffffff80,%eax
80103da3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103da8:	74 1e                	je     80103dc8 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
80103daa:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80103dae:	75 f0                	jne    80103da0 <wakeup+0x20>
80103db0:	3b 58 24             	cmp    0x24(%eax),%ebx
80103db3:	75 eb                	jne    80103da0 <wakeup+0x20>
      p->state = RUNNABLE;
80103db5:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dbc:	83 e8 80             	sub    $0xffffff80,%eax
80103dbf:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103dc4:	75 e4                	jne    80103daa <wakeup+0x2a>
80103dc6:	66 90                	xchg   %ax,%ax
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103dc8:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103dcf:	83 c4 14             	add    $0x14,%esp
80103dd2:	5b                   	pop    %ebx
80103dd3:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103dd4:	e9 47 04 00 00       	jmp    80104220 <release>
80103dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103de0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	53                   	push   %ebx
80103de4:	83 ec 14             	sub    $0x14,%esp
80103de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103dea:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103df1:	e8 3a 03 00 00       	call   80104130 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103df6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103dfb:	eb 0d                	jmp    80103e0a <kill+0x2a>
80103dfd:	8d 76 00             	lea    0x0(%esi),%esi
80103e00:	83 e8 80             	sub    $0xffffff80,%eax
80103e03:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e08:	74 36                	je     80103e40 <kill+0x60>
    if(p->pid == pid){
80103e0a:	39 58 14             	cmp    %ebx,0x14(%eax)
80103e0d:	75 f1                	jne    80103e00 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e0f:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103e13:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e1a:	74 14                	je     80103e30 <kill+0x50>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103e1c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e23:	e8 f8 03 00 00       	call   80104220 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e28:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
80103e2b:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e2d:	5b                   	pop    %ebx
80103e2e:	5d                   	pop    %ebp
80103e2f:	c3                   	ret    
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103e30:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
80103e37:	eb e3                	jmp    80103e1c <kill+0x3c>
80103e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103e40:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e47:	e8 d4 03 00 00       	call   80104220 <release>
  return -1;
}
80103e4c:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
80103e4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e54:	5b                   	pop    %ebx
80103e55:	5d                   	pop    %ebp
80103e56:	c3                   	ret    
80103e57:	89 f6                	mov    %esi,%esi
80103e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e60 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	57                   	push   %edi
80103e64:	56                   	push   %esi
80103e65:	53                   	push   %ebx
80103e66:	bb c4 2d 11 80       	mov    $0x80112dc4,%ebx
80103e6b:	83 ec 4c             	sub    $0x4c,%esp
80103e6e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103e71:	eb 20                	jmp    80103e93 <procdump+0x33>
80103e73:	90                   	nop
80103e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103e78:	c7 04 24 87 77 10 80 	movl   $0x80107787,(%esp)
80103e7f:	e8 cc c7 ff ff       	call   80100650 <cprintf>
80103e84:	83 eb 80             	sub    $0xffffff80,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e87:	81 fb c4 4d 11 80    	cmp    $0x80114dc4,%ebx
80103e8d:	0f 84 8d 00 00 00    	je     80103f20 <procdump+0xc0>
    if(p->state == UNUSED)
80103e93:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103e96:	85 c0                	test   %eax,%eax
80103e98:	74 ea                	je     80103e84 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103e9a:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80103e9d:	ba a0 73 10 80       	mov    $0x801073a0,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103ea2:	77 11                	ja     80103eb5 <procdump+0x55>
80103ea4:	8b 14 85 00 74 10 80 	mov    -0x7fef8c00(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80103eab:	b8 a0 73 10 80       	mov    $0x801073a0,%eax
80103eb0:	85 d2                	test   %edx,%edx
80103eb2:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103eb5:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103eb8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103ebc:	89 54 24 08          	mov    %edx,0x8(%esp)
80103ec0:	c7 04 24 a4 73 10 80 	movl   $0x801073a4,(%esp)
80103ec7:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ecb:	e8 80 c7 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103ed0:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103ed4:	75 a2                	jne    80103e78 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103ed6:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103ed9:	89 44 24 04          	mov    %eax,0x4(%esp)
80103edd:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103ee0:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103ee3:	8b 40 0c             	mov    0xc(%eax),%eax
80103ee6:	83 c0 08             	add    $0x8,%eax
80103ee9:	89 04 24             	mov    %eax,(%esp)
80103eec:	e8 6f 01 00 00       	call   80104060 <getcallerpcs>
80103ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103ef8:	8b 17                	mov    (%edi),%edx
80103efa:	85 d2                	test   %edx,%edx
80103efc:	0f 84 76 ff ff ff    	je     80103e78 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103f02:	89 54 24 04          	mov    %edx,0x4(%esp)
80103f06:	83 c7 04             	add    $0x4,%edi
80103f09:	c7 04 24 e1 6d 10 80 	movl   $0x80106de1,(%esp)
80103f10:	e8 3b c7 ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80103f15:	39 f7                	cmp    %esi,%edi
80103f17:	75 df                	jne    80103ef8 <procdump+0x98>
80103f19:	e9 5a ff ff ff       	jmp    80103e78 <procdump+0x18>
80103f1e:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80103f20:	83 c4 4c             	add    $0x4c,%esp
80103f23:	5b                   	pop    %ebx
80103f24:	5e                   	pop    %esi
80103f25:	5f                   	pop    %edi
80103f26:	5d                   	pop    %ebp
80103f27:	c3                   	ret    
80103f28:	66 90                	xchg   %ax,%ax
80103f2a:	66 90                	xchg   %ax,%ax
80103f2c:	66 90                	xchg   %ax,%ax
80103f2e:	66 90                	xchg   %ax,%ax

80103f30 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	53                   	push   %ebx
80103f34:	83 ec 14             	sub    $0x14,%esp
80103f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103f3a:	c7 44 24 04 18 74 10 	movl   $0x80107418,0x4(%esp)
80103f41:	80 
80103f42:	8d 43 04             	lea    0x4(%ebx),%eax
80103f45:	89 04 24             	mov    %eax,(%esp)
80103f48:	e8 f3 00 00 00       	call   80104040 <initlock>
  lk->name = name;
80103f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80103f50:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103f56:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
80103f5d:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80103f60:	83 c4 14             	add    $0x14,%esp
80103f63:	5b                   	pop    %ebx
80103f64:	5d                   	pop    %ebp
80103f65:	c3                   	ret    
80103f66:	8d 76 00             	lea    0x0(%esi),%esi
80103f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f70 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	56                   	push   %esi
80103f74:	53                   	push   %ebx
80103f75:	83 ec 10             	sub    $0x10,%esp
80103f78:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103f7b:	8d 73 04             	lea    0x4(%ebx),%esi
80103f7e:	89 34 24             	mov    %esi,(%esp)
80103f81:	e8 aa 01 00 00       	call   80104130 <acquire>
  while (lk->locked) {
80103f86:	8b 13                	mov    (%ebx),%edx
80103f88:	85 d2                	test   %edx,%edx
80103f8a:	74 16                	je     80103fa2 <acquiresleep+0x32>
80103f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80103f90:	89 74 24 04          	mov    %esi,0x4(%esp)
80103f94:	89 1c 24             	mov    %ebx,(%esp)
80103f97:	e8 54 fc ff ff       	call   80103bf0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80103f9c:	8b 03                	mov    (%ebx),%eax
80103f9e:	85 c0                	test   %eax,%eax
80103fa0:	75 ee                	jne    80103f90 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80103fa2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103fa8:	e8 e3 f6 ff ff       	call   80103690 <myproc>
80103fad:	8b 40 14             	mov    0x14(%eax),%eax
80103fb0:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103fb3:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103fb6:	83 c4 10             	add    $0x10,%esp
80103fb9:	5b                   	pop    %ebx
80103fba:	5e                   	pop    %esi
80103fbb:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
80103fbc:	e9 5f 02 00 00       	jmp    80104220 <release>
80103fc1:	eb 0d                	jmp    80103fd0 <releasesleep>
80103fc3:	90                   	nop
80103fc4:	90                   	nop
80103fc5:	90                   	nop
80103fc6:	90                   	nop
80103fc7:	90                   	nop
80103fc8:	90                   	nop
80103fc9:	90                   	nop
80103fca:	90                   	nop
80103fcb:	90                   	nop
80103fcc:	90                   	nop
80103fcd:	90                   	nop
80103fce:	90                   	nop
80103fcf:	90                   	nop

80103fd0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	56                   	push   %esi
80103fd4:	53                   	push   %ebx
80103fd5:	83 ec 10             	sub    $0x10,%esp
80103fd8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103fdb:	8d 73 04             	lea    0x4(%ebx),%esi
80103fde:	89 34 24             	mov    %esi,(%esp)
80103fe1:	e8 4a 01 00 00       	call   80104130 <acquire>
  lk->locked = 0;
80103fe6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103fec:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103ff3:	89 1c 24             	mov    %ebx,(%esp)
80103ff6:	e8 85 fd ff ff       	call   80103d80 <wakeup>
  release(&lk->lk);
80103ffb:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103ffe:	83 c4 10             	add    $0x10,%esp
80104001:	5b                   	pop    %ebx
80104002:	5e                   	pop    %esi
80104003:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104004:	e9 17 02 00 00       	jmp    80104220 <release>
80104009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104010 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	56                   	push   %esi
80104014:	53                   	push   %ebx
80104015:	83 ec 10             	sub    $0x10,%esp
80104018:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010401b:	8d 73 04             	lea    0x4(%ebx),%esi
8010401e:	89 34 24             	mov    %esi,(%esp)
80104021:	e8 0a 01 00 00       	call   80104130 <acquire>
  r = lk->locked;
80104026:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104028:	89 34 24             	mov    %esi,(%esp)
8010402b:	e8 f0 01 00 00       	call   80104220 <release>
  return r;
}
80104030:	83 c4 10             	add    $0x10,%esp
80104033:	89 d8                	mov    %ebx,%eax
80104035:	5b                   	pop    %ebx
80104036:	5e                   	pop    %esi
80104037:	5d                   	pop    %ebp
80104038:	c3                   	ret    
80104039:	66 90                	xchg   %ax,%ax
8010403b:	66 90                	xchg   %ax,%ax
8010403d:	66 90                	xchg   %ax,%ax
8010403f:	90                   	nop

80104040 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104046:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104049:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010404f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104052:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104059:	5d                   	pop    %ebp
8010405a:	c3                   	ret    
8010405b:	90                   	nop
8010405c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104060 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104063:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104066:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104069:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010406a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010406d:	31 c0                	xor    %eax,%eax
8010406f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104070:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104076:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010407c:	77 1a                	ja     80104098 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010407e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104081:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104084:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104087:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104089:	83 f8 0a             	cmp    $0xa,%eax
8010408c:	75 e2                	jne    80104070 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010408e:	5b                   	pop    %ebx
8010408f:	5d                   	pop    %ebp
80104090:	c3                   	ret    
80104091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104098:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010409f:	83 c0 01             	add    $0x1,%eax
801040a2:	83 f8 0a             	cmp    $0xa,%eax
801040a5:	74 e7                	je     8010408e <getcallerpcs+0x2e>
    pcs[i] = 0;
801040a7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801040ae:	83 c0 01             	add    $0x1,%eax
801040b1:	83 f8 0a             	cmp    $0xa,%eax
801040b4:	75 e2                	jne    80104098 <getcallerpcs+0x38>
801040b6:	eb d6                	jmp    8010408e <getcallerpcs+0x2e>
801040b8:	90                   	nop
801040b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040c0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801040c0:	55                   	push   %ebp
  return lock->locked && lock->cpu == mycpu();
801040c1:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801040c3:	89 e5                	mov    %esp,%ebp
801040c5:	53                   	push   %ebx
801040c6:	83 ec 04             	sub    $0x4,%esp
801040c9:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801040cc:	8b 0a                	mov    (%edx),%ecx
801040ce:	85 c9                	test   %ecx,%ecx
801040d0:	74 10                	je     801040e2 <holding+0x22>
801040d2:	8b 5a 08             	mov    0x8(%edx),%ebx
801040d5:	e8 16 f5 ff ff       	call   801035f0 <mycpu>
801040da:	39 c3                	cmp    %eax,%ebx
801040dc:	0f 94 c0             	sete   %al
801040df:	0f b6 c0             	movzbl %al,%eax
}
801040e2:	83 c4 04             	add    $0x4,%esp
801040e5:	5b                   	pop    %ebx
801040e6:	5d                   	pop    %ebp
801040e7:	c3                   	ret    
801040e8:	90                   	nop
801040e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040f0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	53                   	push   %ebx
801040f4:	83 ec 04             	sub    $0x4,%esp
801040f7:	9c                   	pushf  
801040f8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
801040f9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801040fa:	e8 f1 f4 ff ff       	call   801035f0 <mycpu>
801040ff:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104105:	85 c0                	test   %eax,%eax
80104107:	75 11                	jne    8010411a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104109:	e8 e2 f4 ff ff       	call   801035f0 <mycpu>
8010410e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104114:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010411a:	e8 d1 f4 ff ff       	call   801035f0 <mycpu>
8010411f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104126:	83 c4 04             	add    $0x4,%esp
80104129:	5b                   	pop    %ebx
8010412a:	5d                   	pop    %ebp
8010412b:	c3                   	ret    
8010412c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104130 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	53                   	push   %ebx
80104134:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104137:	e8 b4 ff ff ff       	call   801040f0 <pushcli>
  if(holding(lk))
8010413c:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010413f:	8b 02                	mov    (%edx),%eax
80104141:	85 c0                	test   %eax,%eax
80104143:	75 43                	jne    80104188 <acquire+0x58>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104145:	b9 01 00 00 00       	mov    $0x1,%ecx
8010414a:	eb 07                	jmp    80104153 <acquire+0x23>
8010414c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104150:	8b 55 08             	mov    0x8(%ebp),%edx
80104153:	89 c8                	mov    %ecx,%eax
80104155:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104158:	85 c0                	test   %eax,%eax
8010415a:	75 f4                	jne    80104150 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010415c:	0f ae f0             	mfence 

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
8010415f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104162:	e8 89 f4 ff ff       	call   801035f0 <mycpu>
80104167:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010416a:	8b 45 08             	mov    0x8(%ebp),%eax
8010416d:	83 c0 0c             	add    $0xc,%eax
80104170:	89 44 24 04          	mov    %eax,0x4(%esp)
80104174:	8d 45 08             	lea    0x8(%ebp),%eax
80104177:	89 04 24             	mov    %eax,(%esp)
8010417a:	e8 e1 fe ff ff       	call   80104060 <getcallerpcs>
}
8010417f:	83 c4 14             	add    $0x14,%esp
80104182:	5b                   	pop    %ebx
80104183:	5d                   	pop    %ebp
80104184:	c3                   	ret    
80104185:	8d 76 00             	lea    0x0(%esi),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104188:	8b 5a 08             	mov    0x8(%edx),%ebx
8010418b:	e8 60 f4 ff ff       	call   801035f0 <mycpu>
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
80104190:	39 c3                	cmp    %eax,%ebx
80104192:	74 05                	je     80104199 <acquire+0x69>
80104194:	8b 55 08             	mov    0x8(%ebp),%edx
80104197:	eb ac                	jmp    80104145 <acquire+0x15>
    panic("acquire");
80104199:	c7 04 24 23 74 10 80 	movl   $0x80107423,(%esp)
801041a0:	e8 bb c1 ff ff       	call   80100360 <panic>
801041a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041b0 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041b6:	9c                   	pushf  
801041b7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041b8:	f6 c4 02             	test   $0x2,%ah
801041bb:	75 49                	jne    80104206 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801041bd:	e8 2e f4 ff ff       	call   801035f0 <mycpu>
801041c2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801041c8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801041cb:	85 d2                	test   %edx,%edx
801041cd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801041d3:	78 25                	js     801041fa <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801041d5:	e8 16 f4 ff ff       	call   801035f0 <mycpu>
801041da:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801041e0:	85 d2                	test   %edx,%edx
801041e2:	74 04                	je     801041e8 <popcli+0x38>
    sti();
}
801041e4:	c9                   	leave  
801041e5:	c3                   	ret    
801041e6:	66 90                	xchg   %ax,%ax
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801041e8:	e8 03 f4 ff ff       	call   801035f0 <mycpu>
801041ed:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801041f3:	85 c0                	test   %eax,%eax
801041f5:	74 ed                	je     801041e4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
801041f7:	fb                   	sti    
    sti();
}
801041f8:	c9                   	leave  
801041f9:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
801041fa:	c7 04 24 42 74 10 80 	movl   $0x80107442,(%esp)
80104201:	e8 5a c1 ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104206:	c7 04 24 2b 74 10 80 	movl   $0x8010742b,(%esp)
8010420d:	e8 4e c1 ff ff       	call   80100360 <panic>
80104212:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104220 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	56                   	push   %esi
80104224:	53                   	push   %ebx
80104225:	83 ec 10             	sub    $0x10,%esp
80104228:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010422b:	8b 03                	mov    (%ebx),%eax
8010422d:	85 c0                	test   %eax,%eax
8010422f:	75 0f                	jne    80104240 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104231:	c7 04 24 49 74 10 80 	movl   $0x80107449,(%esp)
80104238:	e8 23 c1 ff ff       	call   80100360 <panic>
8010423d:	8d 76 00             	lea    0x0(%esi),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104240:	8b 73 08             	mov    0x8(%ebx),%esi
80104243:	e8 a8 f3 ff ff       	call   801035f0 <mycpu>

// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
80104248:	39 c6                	cmp    %eax,%esi
8010424a:	75 e5                	jne    80104231 <release+0x11>
    panic("release");

  lk->pcs[0] = 0;
8010424c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104253:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
8010425a:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010425d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104263:	83 c4 10             	add    $0x10,%esp
80104266:	5b                   	pop    %ebx
80104267:	5e                   	pop    %esi
80104268:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104269:	e9 42 ff ff ff       	jmp    801041b0 <popcli>
8010426e:	66 90                	xchg   %ax,%ax

80104270 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	8b 55 08             	mov    0x8(%ebp),%edx
80104276:	57                   	push   %edi
80104277:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010427a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010427b:	f6 c2 03             	test   $0x3,%dl
8010427e:	75 05                	jne    80104285 <memset+0x15>
80104280:	f6 c1 03             	test   $0x3,%cl
80104283:	74 13                	je     80104298 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104285:	89 d7                	mov    %edx,%edi
80104287:	8b 45 0c             	mov    0xc(%ebp),%eax
8010428a:	fc                   	cld    
8010428b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010428d:	5b                   	pop    %ebx
8010428e:	89 d0                	mov    %edx,%eax
80104290:	5f                   	pop    %edi
80104291:	5d                   	pop    %ebp
80104292:	c3                   	ret    
80104293:	90                   	nop
80104294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104298:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010429c:	c1 e9 02             	shr    $0x2,%ecx
8010429f:	89 f8                	mov    %edi,%eax
801042a1:	89 fb                	mov    %edi,%ebx
801042a3:	c1 e0 18             	shl    $0x18,%eax
801042a6:	c1 e3 10             	shl    $0x10,%ebx
801042a9:	09 d8                	or     %ebx,%eax
801042ab:	09 f8                	or     %edi,%eax
801042ad:	c1 e7 08             	shl    $0x8,%edi
801042b0:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801042b2:	89 d7                	mov    %edx,%edi
801042b4:	fc                   	cld    
801042b5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801042b7:	5b                   	pop    %ebx
801042b8:	89 d0                	mov    %edx,%eax
801042ba:	5f                   	pop    %edi
801042bb:	5d                   	pop    %ebp
801042bc:	c3                   	ret    
801042bd:	8d 76 00             	lea    0x0(%esi),%esi

801042c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	8b 45 10             	mov    0x10(%ebp),%eax
801042c6:	57                   	push   %edi
801042c7:	56                   	push   %esi
801042c8:	8b 75 0c             	mov    0xc(%ebp),%esi
801042cb:	53                   	push   %ebx
801042cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801042cf:	85 c0                	test   %eax,%eax
801042d1:	8d 78 ff             	lea    -0x1(%eax),%edi
801042d4:	74 26                	je     801042fc <memcmp+0x3c>
    if(*s1 != *s2)
801042d6:	0f b6 03             	movzbl (%ebx),%eax
801042d9:	31 d2                	xor    %edx,%edx
801042db:	0f b6 0e             	movzbl (%esi),%ecx
801042de:	38 c8                	cmp    %cl,%al
801042e0:	74 16                	je     801042f8 <memcmp+0x38>
801042e2:	eb 24                	jmp    80104308 <memcmp+0x48>
801042e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042e8:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
801042ed:	83 c2 01             	add    $0x1,%edx
801042f0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801042f4:	38 c8                	cmp    %cl,%al
801042f6:	75 10                	jne    80104308 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801042f8:	39 fa                	cmp    %edi,%edx
801042fa:	75 ec                	jne    801042e8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801042fc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801042fd:	31 c0                	xor    %eax,%eax
}
801042ff:	5e                   	pop    %esi
80104300:	5f                   	pop    %edi
80104301:	5d                   	pop    %ebp
80104302:	c3                   	ret    
80104303:	90                   	nop
80104304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104308:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104309:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010430b:	5e                   	pop    %esi
8010430c:	5f                   	pop    %edi
8010430d:	5d                   	pop    %ebp
8010430e:	c3                   	ret    
8010430f:	90                   	nop

80104310 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	57                   	push   %edi
80104314:	8b 45 08             	mov    0x8(%ebp),%eax
80104317:	56                   	push   %esi
80104318:	8b 75 0c             	mov    0xc(%ebp),%esi
8010431b:	53                   	push   %ebx
8010431c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010431f:	39 c6                	cmp    %eax,%esi
80104321:	73 35                	jae    80104358 <memmove+0x48>
80104323:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104326:	39 c8                	cmp    %ecx,%eax
80104328:	73 2e                	jae    80104358 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010432a:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
8010432c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010432f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104332:	74 1b                	je     8010434f <memmove+0x3f>
80104334:	f7 db                	neg    %ebx
80104336:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104339:	01 fb                	add    %edi,%ebx
8010433b:	90                   	nop
8010433c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104340:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104344:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104347:	83 ea 01             	sub    $0x1,%edx
8010434a:	83 fa ff             	cmp    $0xffffffff,%edx
8010434d:	75 f1                	jne    80104340 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010434f:	5b                   	pop    %ebx
80104350:	5e                   	pop    %esi
80104351:	5f                   	pop    %edi
80104352:	5d                   	pop    %ebp
80104353:	c3                   	ret    
80104354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104358:	31 d2                	xor    %edx,%edx
8010435a:	85 db                	test   %ebx,%ebx
8010435c:	74 f1                	je     8010434f <memmove+0x3f>
8010435e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104360:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104364:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104367:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010436a:	39 da                	cmp    %ebx,%edx
8010436c:	75 f2                	jne    80104360 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010436e:	5b                   	pop    %ebx
8010436f:	5e                   	pop    %esi
80104370:	5f                   	pop    %edi
80104371:	5d                   	pop    %ebp
80104372:	c3                   	ret    
80104373:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104380 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104383:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104384:	e9 87 ff ff ff       	jmp    80104310 <memmove>
80104389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104390 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	56                   	push   %esi
80104394:	8b 75 10             	mov    0x10(%ebp),%esi
80104397:	53                   	push   %ebx
80104398:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010439b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
8010439e:	85 f6                	test   %esi,%esi
801043a0:	74 30                	je     801043d2 <strncmp+0x42>
801043a2:	0f b6 01             	movzbl (%ecx),%eax
801043a5:	84 c0                	test   %al,%al
801043a7:	74 2f                	je     801043d8 <strncmp+0x48>
801043a9:	0f b6 13             	movzbl (%ebx),%edx
801043ac:	38 d0                	cmp    %dl,%al
801043ae:	75 46                	jne    801043f6 <strncmp+0x66>
801043b0:	8d 51 01             	lea    0x1(%ecx),%edx
801043b3:	01 ce                	add    %ecx,%esi
801043b5:	eb 14                	jmp    801043cb <strncmp+0x3b>
801043b7:	90                   	nop
801043b8:	0f b6 02             	movzbl (%edx),%eax
801043bb:	84 c0                	test   %al,%al
801043bd:	74 31                	je     801043f0 <strncmp+0x60>
801043bf:	0f b6 19             	movzbl (%ecx),%ebx
801043c2:	83 c2 01             	add    $0x1,%edx
801043c5:	38 d8                	cmp    %bl,%al
801043c7:	75 17                	jne    801043e0 <strncmp+0x50>
    n--, p++, q++;
801043c9:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801043cb:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801043cd:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801043d0:	75 e6                	jne    801043b8 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801043d2:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
801043d3:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
801043d5:	5e                   	pop    %esi
801043d6:	5d                   	pop    %ebp
801043d7:	c3                   	ret    
801043d8:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801043db:	31 c0                	xor    %eax,%eax
801043dd:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801043e0:	0f b6 d3             	movzbl %bl,%edx
801043e3:	29 d0                	sub    %edx,%eax
}
801043e5:	5b                   	pop    %ebx
801043e6:	5e                   	pop    %esi
801043e7:	5d                   	pop    %ebp
801043e8:	c3                   	ret    
801043e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043f0:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
801043f4:	eb ea                	jmp    801043e0 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801043f6:	89 d3                	mov    %edx,%ebx
801043f8:	eb e6                	jmp    801043e0 <strncmp+0x50>
801043fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104400 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	8b 45 08             	mov    0x8(%ebp),%eax
80104406:	56                   	push   %esi
80104407:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010440a:	53                   	push   %ebx
8010440b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010440e:	89 c2                	mov    %eax,%edx
80104410:	eb 19                	jmp    8010442b <strncpy+0x2b>
80104412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104418:	83 c3 01             	add    $0x1,%ebx
8010441b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010441f:	83 c2 01             	add    $0x1,%edx
80104422:	84 c9                	test   %cl,%cl
80104424:	88 4a ff             	mov    %cl,-0x1(%edx)
80104427:	74 09                	je     80104432 <strncpy+0x32>
80104429:	89 f1                	mov    %esi,%ecx
8010442b:	85 c9                	test   %ecx,%ecx
8010442d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104430:	7f e6                	jg     80104418 <strncpy+0x18>
    ;
  while(n-- > 0)
80104432:	31 c9                	xor    %ecx,%ecx
80104434:	85 f6                	test   %esi,%esi
80104436:	7e 0f                	jle    80104447 <strncpy+0x47>
    *s++ = 0;
80104438:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010443c:	89 f3                	mov    %esi,%ebx
8010443e:	83 c1 01             	add    $0x1,%ecx
80104441:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104443:	85 db                	test   %ebx,%ebx
80104445:	7f f1                	jg     80104438 <strncpy+0x38>
    *s++ = 0;
  return os;
}
80104447:	5b                   	pop    %ebx
80104448:	5e                   	pop    %esi
80104449:	5d                   	pop    %ebp
8010444a:	c3                   	ret    
8010444b:	90                   	nop
8010444c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104450 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104456:	56                   	push   %esi
80104457:	8b 45 08             	mov    0x8(%ebp),%eax
8010445a:	53                   	push   %ebx
8010445b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010445e:	85 c9                	test   %ecx,%ecx
80104460:	7e 26                	jle    80104488 <safestrcpy+0x38>
80104462:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104466:	89 c1                	mov    %eax,%ecx
80104468:	eb 17                	jmp    80104481 <safestrcpy+0x31>
8010446a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104470:	83 c2 01             	add    $0x1,%edx
80104473:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104477:	83 c1 01             	add    $0x1,%ecx
8010447a:	84 db                	test   %bl,%bl
8010447c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010447f:	74 04                	je     80104485 <safestrcpy+0x35>
80104481:	39 f2                	cmp    %esi,%edx
80104483:	75 eb                	jne    80104470 <safestrcpy+0x20>
    ;
  *s = 0;
80104485:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104488:	5b                   	pop    %ebx
80104489:	5e                   	pop    %esi
8010448a:	5d                   	pop    %ebp
8010448b:	c3                   	ret    
8010448c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104490 <strlen>:

int
strlen(const char *s)
{
80104490:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104491:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104493:	89 e5                	mov    %esp,%ebp
80104495:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104498:	80 3a 00             	cmpb   $0x0,(%edx)
8010449b:	74 0c                	je     801044a9 <strlen+0x19>
8010449d:	8d 76 00             	lea    0x0(%esi),%esi
801044a0:	83 c0 01             	add    $0x1,%eax
801044a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801044a7:	75 f7                	jne    801044a0 <strlen+0x10>
    ;
  return n;
}
801044a9:	5d                   	pop    %ebp
801044aa:	c3                   	ret    

801044ab <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801044ab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801044af:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801044b3:	55                   	push   %ebp
  pushl %ebx
801044b4:	53                   	push   %ebx
  pushl %esi
801044b5:	56                   	push   %esi
  pushl %edi
801044b6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801044b7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801044b9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801044bb:	5f                   	pop    %edi
  popl %esi
801044bc:	5e                   	pop    %esi
  popl %ebx
801044bd:	5b                   	pop    %ebx
  popl %ebp
801044be:	5d                   	pop    %ebp
  ret
801044bf:	c3                   	ret    

801044c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
 // struct proc *curproc = myproc();

  //if(addr >= (KERNBASE + 4)) || addr+4 > (curproc->sz + PGSIZE - 1))
   //  return -1;
  *ip = *(int*)(addr);
801044c3:	8b 45 08             	mov    0x8(%ebp),%eax
801044c6:	8b 10                	mov    (%eax),%edx
801044c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801044cb:	89 10                	mov    %edx,(%eax)
  return 0;
}
801044cd:	31 c0                	xor    %eax,%eax
801044cf:	5d                   	pop    %ebp
801044d0:	c3                   	ret    
801044d1:	eb 0d                	jmp    801044e0 <fetchstr>
801044d3:	90                   	nop
801044d4:	90                   	nop
801044d5:	90                   	nop
801044d6:	90                   	nop
801044d7:	90                   	nop
801044d8:	90                   	nop
801044d9:	90                   	nop
801044da:	90                   	nop
801044db:	90                   	nop
801044dc:	90                   	nop
801044dd:	90                   	nop
801044de:	90                   	nop
801044df:	90                   	nop

801044e0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	8b 55 08             	mov    0x8(%ebp),%edx
  char *s, *ep;
//  struct proc *curproc = myproc();
  //panic("hei");
  if(addr >= (KERNBASE + 4))
801044e6:	81 fa 03 00 00 80    	cmp    $0x80000003,%edx
801044ec:	77 2e                	ja     8010451c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801044ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ep = (char*)KERNBASE;//curproc->sz;
  for(s = *pp; s < ep; s++){
801044f1:	81 fa ff ff ff 7f    	cmp    $0x7fffffff,%edx
  char *s, *ep;
//  struct proc *curproc = myproc();
  //panic("hei");
  if(addr >= (KERNBASE + 4))
    return -1;
  *pp = (char*)addr;
801044f7:	89 d0                	mov    %edx,%eax
801044f9:	89 11                	mov    %edx,(%ecx)
  ep = (char*)KERNBASE;//curproc->sz;
  for(s = *pp; s < ep; s++){
801044fb:	77 1f                	ja     8010451c <fetchstr+0x3c>
    if(*s == 0)
801044fd:	80 3a 00             	cmpb   $0x0,(%edx)
80104500:	75 10                	jne    80104512 <fetchstr+0x32>
80104502:	eb 24                	jmp    80104528 <fetchstr+0x48>
80104504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104508:	80 38 00             	cmpb   $0x0,(%eax)
8010450b:	90                   	nop
8010450c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104510:	74 16                	je     80104528 <fetchstr+0x48>
  //panic("hei");
  if(addr >= (KERNBASE + 4))
    return -1;
  *pp = (char*)addr;
  ep = (char*)KERNBASE;//curproc->sz;
  for(s = *pp; s < ep; s++){
80104512:	83 c0 01             	add    $0x1,%eax
80104515:	3d 00 00 00 80       	cmp    $0x80000000,%eax
8010451a:	75 ec                	jne    80104508 <fetchstr+0x28>
{
  char *s, *ep;
//  struct proc *curproc = myproc();
  //panic("hei");
  if(addr >= (KERNBASE + 4))
    return -1;
8010451c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104521:	5d                   	pop    %ebp
80104522:	c3                   	ret    
80104523:	90                   	nop
80104524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  *pp = (char*)addr;
  ep = (char*)KERNBASE;//curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104528:	29 d0                	sub    %edx,%eax
  }
  return -1;
}
8010452a:	5d                   	pop    %ebp
8010452b:	c3                   	ret    
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104530 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104536:	e8 55 f1 ff ff       	call   80103690 <myproc>
{
 // struct proc *curproc = myproc();

  //if(addr >= (KERNBASE + 4)) || addr+4 > (curproc->sz + PGSIZE - 1))
   //  return -1;
  *ip = *(int*)(addr);
8010453b:	8b 55 08             	mov    0x8(%ebp),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010453e:	8b 40 1c             	mov    0x1c(%eax),%eax
{
 // struct proc *curproc = myproc();

  //if(addr >= (KERNBASE + 4)) || addr+4 > (curproc->sz + PGSIZE - 1))
   //  return -1;
  *ip = *(int*)(addr);
80104541:	8b 40 44             	mov    0x44(%eax),%eax
80104544:	8b 54 90 04          	mov    0x4(%eax,%edx,4),%edx
80104548:	8b 45 0c             	mov    0xc(%ebp),%eax
8010454b:	89 10                	mov    %edx,(%eax)
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
8010454d:	31 c0                	xor    %eax,%eax
8010454f:	c9                   	leave  
80104550:	c3                   	ret    
80104551:	eb 0d                	jmp    80104560 <argptr>
80104553:	90                   	nop
80104554:	90                   	nop
80104555:	90                   	nop
80104556:	90                   	nop
80104557:	90                   	nop
80104558:	90                   	nop
80104559:	90                   	nop
8010455a:	90                   	nop
8010455b:	90                   	nop
8010455c:	90                   	nop
8010455d:	90                   	nop
8010455e:	90                   	nop
8010455f:	90                   	nop

80104560 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	83 ec 08             	sub    $0x8,%esp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104566:	e8 25 f1 ff ff       	call   80103690 <myproc>
 
  if(argint(n, &i) < 0)
    return -1;
//  if(size < 0 || (uint)i >= (KERNBASE + 4)) || (uint)i+size > (curproc->sz + PGSIZE - 1))
   // return -1;
  *pp = (char*)i;
8010456b:	8b 55 08             	mov    0x8(%ebp),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010456e:	8b 40 1c             	mov    0x1c(%eax),%eax
{
 // struct proc *curproc = myproc();

  //if(addr >= (KERNBASE + 4)) || addr+4 > (curproc->sz + PGSIZE - 1))
   //  return -1;
  *ip = *(int*)(addr);
80104571:	8b 40 44             	mov    0x44(%eax),%eax
 
  if(argint(n, &i) < 0)
    return -1;
//  if(size < 0 || (uint)i >= (KERNBASE + 4)) || (uint)i+size > (curproc->sz + PGSIZE - 1))
   // return -1;
  *pp = (char*)i;
80104574:	8b 54 90 04          	mov    0x4(%eax,%edx,4),%edx
80104578:	8b 45 0c             	mov    0xc(%ebp),%eax
8010457b:	89 10                	mov    %edx,(%eax)
  return 0;
}
8010457d:	31 c0                	xor    %eax,%eax
8010457f:	c9                   	leave  
80104580:	c3                   	ret    
80104581:	eb 0d                	jmp    80104590 <argstr>
80104583:	90                   	nop
80104584:	90                   	nop
80104585:	90                   	nop
80104586:	90                   	nop
80104587:	90                   	nop
80104588:	90                   	nop
80104589:	90                   	nop
8010458a:	90                   	nop
8010458b:	90                   	nop
8010458c:	90                   	nop
8010458d:	90                   	nop
8010458e:	90                   	nop
8010458f:	90                   	nop

80104590 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	83 ec 08             	sub    $0x8,%esp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104596:	e8 f5 f0 ff ff       	call   80103690 <myproc>
{
 // struct proc *curproc = myproc();

  //if(addr >= (KERNBASE + 4)) || addr+4 > (curproc->sz + PGSIZE - 1))
   //  return -1;
  *ip = *(int*)(addr);
8010459b:	8b 55 08             	mov    0x8(%ebp),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010459e:	8b 40 1c             	mov    0x1c(%eax),%eax
{
 // struct proc *curproc = myproc();

  //if(addr >= (KERNBASE + 4)) || addr+4 > (curproc->sz + PGSIZE - 1))
   //  return -1;
  *ip = *(int*)(addr);
801045a1:	8b 40 44             	mov    0x44(%eax),%eax
801045a4:	8b 54 90 04          	mov    0x4(%eax,%edx,4),%edx
fetchstr(uint addr, char **pp)
{
  char *s, *ep;
//  struct proc *curproc = myproc();
  //panic("hei");
  if(addr >= (KERNBASE + 4))
801045a8:	81 fa 03 00 00 80    	cmp    $0x80000003,%edx
801045ae:	77 27                	ja     801045d7 <argstr+0x47>
    return -1;
  *pp = (char*)addr;
801045b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ep = (char*)KERNBASE;//curproc->sz;
  for(s = *pp; s < ep; s++){
801045b3:	81 fa ff ff ff 7f    	cmp    $0x7fffffff,%edx
  char *s, *ep;
//  struct proc *curproc = myproc();
  //panic("hei");
  if(addr >= (KERNBASE + 4))
    return -1;
  *pp = (char*)addr;
801045b9:	89 d0                	mov    %edx,%eax
801045bb:	89 11                	mov    %edx,(%ecx)
  ep = (char*)KERNBASE;//curproc->sz;
  for(s = *pp; s < ep; s++){
801045bd:	77 18                	ja     801045d7 <argstr+0x47>
    if(*s == 0)
801045bf:	80 3a 00             	cmpb   $0x0,(%edx)
801045c2:	75 0e                	jne    801045d2 <argstr+0x42>
801045c4:	eb 1a                	jmp    801045e0 <argstr+0x50>
801045c6:	66 90                	xchg   %ax,%ax
801045c8:	80 38 00             	cmpb   $0x0,(%eax)
801045cb:	90                   	nop
801045cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045d0:	74 0e                	je     801045e0 <argstr+0x50>
  //panic("hei");
  if(addr >= (KERNBASE + 4))
    return -1;
  *pp = (char*)addr;
  ep = (char*)KERNBASE;//curproc->sz;
  for(s = *pp; s < ep; s++){
801045d2:	83 c0 01             	add    $0x1,%eax
801045d5:	79 f1                	jns    801045c8 <argstr+0x38>
{
  char *s, *ep;
//  struct proc *curproc = myproc();
  //panic("hei");
  if(addr >= (KERNBASE + 4))
    return -1;
801045d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801045dc:	c9                   	leave  
801045dd:	c3                   	ret    
801045de:	66 90                	xchg   %ax,%ax
    return -1;
  *pp = (char*)addr;
  ep = (char*)KERNBASE;//curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
801045e0:	29 d0                	sub    %edx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801045e2:	c9                   	leave  
801045e3:	c3                   	ret    
801045e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801045f0 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
801045f5:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
801045f8:	e8 93 f0 ff ff       	call   80103690 <myproc>

  num = curproc->tf->eax;
801045fd:	8b 70 1c             	mov    0x1c(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104600:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104602:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104605:	8d 50 ff             	lea    -0x1(%eax),%edx
80104608:	83 fa 16             	cmp    $0x16,%edx
8010460b:	77 1b                	ja     80104628 <syscall+0x38>
8010460d:	8b 14 85 80 74 10 80 	mov    -0x7fef8b80(,%eax,4),%edx
80104614:	85 d2                	test   %edx,%edx
80104616:	74 10                	je     80104628 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104618:	ff d2                	call   *%edx
8010461a:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010461d:	83 c4 10             	add    $0x10,%esp
80104620:	5b                   	pop    %ebx
80104621:	5e                   	pop    %esi
80104622:	5d                   	pop    %ebp
80104623:	c3                   	ret    
80104624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104628:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
8010462c:	8d 43 70             	lea    0x70(%ebx),%eax
8010462f:	89 44 24 08          	mov    %eax,0x8(%esp)

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104633:	8b 43 14             	mov    0x14(%ebx),%eax
80104636:	c7 04 24 51 74 10 80 	movl   $0x80107451,(%esp)
8010463d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104641:	e8 0a c0 ff ff       	call   80100650 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80104646:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104649:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104650:	83 c4 10             	add    $0x10,%esp
80104653:	5b                   	pop    %ebx
80104654:	5e                   	pop    %esi
80104655:	5d                   	pop    %ebp
80104656:	c3                   	ret    
80104657:	66 90                	xchg   %ax,%ax
80104659:	66 90                	xchg   %ax,%ax
8010465b:	66 90                	xchg   %ax,%ax
8010465d:	66 90                	xchg   %ax,%ax
8010465f:	90                   	nop

80104660 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	53                   	push   %ebx
80104664:	89 c3                	mov    %eax,%ebx
80104666:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
80104669:	e8 22 f0 ff ff       	call   80103690 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
8010466e:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80104670:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
80104674:	85 c9                	test   %ecx,%ecx
80104676:	74 18                	je     80104690 <fdalloc+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104678:	83 c2 01             	add    $0x1,%edx
8010467b:	83 fa 10             	cmp    $0x10,%edx
8010467e:	75 f0                	jne    80104670 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
80104680:	83 c4 04             	add    $0x4,%esp
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80104683:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104688:	5b                   	pop    %ebx
80104689:	5d                   	pop    %ebp
8010468a:	c3                   	ret    
8010468b:	90                   	nop
8010468c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104690:	89 5c 90 2c          	mov    %ebx,0x2c(%eax,%edx,4)
      return fd;
    }
  }
  return -1;
}
80104694:	83 c4 04             	add    $0x4,%esp
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
80104697:	89 d0                	mov    %edx,%eax
    }
  }
  return -1;
}
80104699:	5b                   	pop    %ebx
8010469a:	5d                   	pop    %ebp
8010469b:	c3                   	ret    
8010469c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046a0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	57                   	push   %edi
801046a4:	56                   	push   %esi
801046a5:	53                   	push   %ebx
801046a6:	83 ec 4c             	sub    $0x4c,%esp
801046a9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801046ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801046af:	8d 5d da             	lea    -0x26(%ebp),%ebx
801046b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801046b6:	89 04 24             	mov    %eax,(%esp)
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801046b9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801046bc:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801046bf:	e8 4c d8 ff ff       	call   80101f10 <nameiparent>
801046c4:	85 c0                	test   %eax,%eax
801046c6:	89 c7                	mov    %eax,%edi
801046c8:	0f 84 da 00 00 00    	je     801047a8 <create+0x108>
    return 0;
  ilock(dp);
801046ce:	89 04 24             	mov    %eax,(%esp)
801046d1:	e8 ca cf ff ff       	call   801016a0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801046d6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801046d9:	89 44 24 08          	mov    %eax,0x8(%esp)
801046dd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801046e1:	89 3c 24             	mov    %edi,(%esp)
801046e4:	e8 c7 d4 ff ff       	call   80101bb0 <dirlookup>
801046e9:	85 c0                	test   %eax,%eax
801046eb:	89 c6                	mov    %eax,%esi
801046ed:	74 41                	je     80104730 <create+0x90>
    iunlockput(dp);
801046ef:	89 3c 24             	mov    %edi,(%esp)
801046f2:	e8 09 d2 ff ff       	call   80101900 <iunlockput>
    ilock(ip);
801046f7:	89 34 24             	mov    %esi,(%esp)
801046fa:	e8 a1 cf ff ff       	call   801016a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801046ff:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104704:	75 12                	jne    80104718 <create+0x78>
80104706:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010470b:	89 f0                	mov    %esi,%eax
8010470d:	75 09                	jne    80104718 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010470f:	83 c4 4c             	add    $0x4c,%esp
80104712:	5b                   	pop    %ebx
80104713:	5e                   	pop    %esi
80104714:	5f                   	pop    %edi
80104715:	5d                   	pop    %ebp
80104716:	c3                   	ret    
80104717:	90                   	nop
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104718:	89 34 24             	mov    %esi,(%esp)
8010471b:	e8 e0 d1 ff ff       	call   80101900 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104720:	83 c4 4c             	add    $0x4c,%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104723:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104725:	5b                   	pop    %ebx
80104726:	5e                   	pop    %esi
80104727:	5f                   	pop    %edi
80104728:	5d                   	pop    %ebp
80104729:	c3                   	ret    
8010472a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104730:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104734:	89 44 24 04          	mov    %eax,0x4(%esp)
80104738:	8b 07                	mov    (%edi),%eax
8010473a:	89 04 24             	mov    %eax,(%esp)
8010473d:	e8 ce cd ff ff       	call   80101510 <ialloc>
80104742:	85 c0                	test   %eax,%eax
80104744:	89 c6                	mov    %eax,%esi
80104746:	0f 84 bf 00 00 00    	je     8010480b <create+0x16b>
    panic("create: ialloc");

  ilock(ip);
8010474c:	89 04 24             	mov    %eax,(%esp)
8010474f:	e8 4c cf ff ff       	call   801016a0 <ilock>
  ip->major = major;
80104754:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104758:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010475c:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104760:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104764:	b8 01 00 00 00       	mov    $0x1,%eax
80104769:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010476d:	89 34 24             	mov    %esi,(%esp)
80104770:	e8 6b ce ff ff       	call   801015e0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104775:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010477a:	74 34                	je     801047b0 <create+0x110>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010477c:	8b 46 04             	mov    0x4(%esi),%eax
8010477f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104783:	89 3c 24             	mov    %edi,(%esp)
80104786:	89 44 24 08          	mov    %eax,0x8(%esp)
8010478a:	e8 81 d6 ff ff       	call   80101e10 <dirlink>
8010478f:	85 c0                	test   %eax,%eax
80104791:	78 6c                	js     801047ff <create+0x15f>
    panic("create: dirlink");

  iunlockput(dp);
80104793:	89 3c 24             	mov    %edi,(%esp)
80104796:	e8 65 d1 ff ff       	call   80101900 <iunlockput>

  return ip;
}
8010479b:	83 c4 4c             	add    $0x4c,%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
8010479e:	89 f0                	mov    %esi,%eax
}
801047a0:	5b                   	pop    %ebx
801047a1:	5e                   	pop    %esi
801047a2:	5f                   	pop    %edi
801047a3:	5d                   	pop    %ebp
801047a4:	c3                   	ret    
801047a5:	8d 76 00             	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
801047a8:	31 c0                	xor    %eax,%eax
801047aa:	e9 60 ff ff ff       	jmp    8010470f <create+0x6f>
801047af:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
801047b0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801047b5:	89 3c 24             	mov    %edi,(%esp)
801047b8:	e8 23 ce ff ff       	call   801015e0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801047bd:	8b 46 04             	mov    0x4(%esi),%eax
801047c0:	c7 44 24 04 fc 74 10 	movl   $0x801074fc,0x4(%esp)
801047c7:	80 
801047c8:	89 34 24             	mov    %esi,(%esp)
801047cb:	89 44 24 08          	mov    %eax,0x8(%esp)
801047cf:	e8 3c d6 ff ff       	call   80101e10 <dirlink>
801047d4:	85 c0                	test   %eax,%eax
801047d6:	78 1b                	js     801047f3 <create+0x153>
801047d8:	8b 47 04             	mov    0x4(%edi),%eax
801047db:	c7 44 24 04 fb 74 10 	movl   $0x801074fb,0x4(%esp)
801047e2:	80 
801047e3:	89 34 24             	mov    %esi,(%esp)
801047e6:	89 44 24 08          	mov    %eax,0x8(%esp)
801047ea:	e8 21 d6 ff ff       	call   80101e10 <dirlink>
801047ef:	85 c0                	test   %eax,%eax
801047f1:	79 89                	jns    8010477c <create+0xdc>
      panic("create dots");
801047f3:	c7 04 24 ef 74 10 80 	movl   $0x801074ef,(%esp)
801047fa:	e8 61 bb ff ff       	call   80100360 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
801047ff:	c7 04 24 fe 74 10 80 	movl   $0x801074fe,(%esp)
80104806:	e8 55 bb ff ff       	call   80100360 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
8010480b:	c7 04 24 e0 74 10 80 	movl   $0x801074e0,(%esp)
80104812:	e8 49 bb ff ff       	call   80100360 <panic>
80104817:	89 f6                	mov    %esi,%esi
80104819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104820 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	56                   	push   %esi
80104824:	89 c6                	mov    %eax,%esi
80104826:	53                   	push   %ebx
80104827:	89 d3                	mov    %edx,%ebx
80104829:	83 ec 20             	sub    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010482c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010482f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104833:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010483a:	e8 f1 fc ff ff       	call   80104530 <argint>
8010483f:	85 c0                	test   %eax,%eax
80104841:	78 2d                	js     80104870 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104843:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104847:	77 27                	ja     80104870 <argfd.constprop.0+0x50>
80104849:	e8 42 ee ff ff       	call   80103690 <myproc>
8010484e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104851:	8b 44 90 2c          	mov    0x2c(%eax,%edx,4),%eax
80104855:	85 c0                	test   %eax,%eax
80104857:	74 17                	je     80104870 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104859:	85 f6                	test   %esi,%esi
8010485b:	74 02                	je     8010485f <argfd.constprop.0+0x3f>
    *pfd = fd;
8010485d:	89 16                	mov    %edx,(%esi)
  if(pf)
8010485f:	85 db                	test   %ebx,%ebx
80104861:	74 1d                	je     80104880 <argfd.constprop.0+0x60>
    *pf = f;
80104863:	89 03                	mov    %eax,(%ebx)
  return 0;
80104865:	31 c0                	xor    %eax,%eax
}
80104867:	83 c4 20             	add    $0x20,%esp
8010486a:	5b                   	pop    %ebx
8010486b:	5e                   	pop    %esi
8010486c:	5d                   	pop    %ebp
8010486d:	c3                   	ret    
8010486e:	66 90                	xchg   %ax,%ax
80104870:	83 c4 20             	add    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104873:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104878:	5b                   	pop    %ebx
80104879:	5e                   	pop    %esi
8010487a:	5d                   	pop    %ebp
8010487b:	c3                   	ret    
8010487c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104880:	31 c0                	xor    %eax,%eax
80104882:	eb e3                	jmp    80104867 <argfd.constprop.0+0x47>
80104884:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010488a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104890 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104890:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104891:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104893:	89 e5                	mov    %esp,%ebp
80104895:	53                   	push   %ebx
80104896:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104899:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010489c:	e8 7f ff ff ff       	call   80104820 <argfd.constprop.0>
801048a1:	85 c0                	test   %eax,%eax
801048a3:	78 23                	js     801048c8 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
801048a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048a8:	e8 b3 fd ff ff       	call   80104660 <fdalloc>
801048ad:	85 c0                	test   %eax,%eax
801048af:	89 c3                	mov    %eax,%ebx
801048b1:	78 15                	js     801048c8 <sys_dup+0x38>
    return -1;
  filedup(f);
801048b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b6:	89 04 24             	mov    %eax,(%esp)
801048b9:	e8 02 c5 ff ff       	call   80100dc0 <filedup>
  return fd;
801048be:	89 d8                	mov    %ebx,%eax
}
801048c0:	83 c4 24             	add    $0x24,%esp
801048c3:	5b                   	pop    %ebx
801048c4:	5d                   	pop    %ebp
801048c5:	c3                   	ret    
801048c6:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
801048c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048cd:	eb f1                	jmp    801048c0 <sys_dup+0x30>
801048cf:	90                   	nop

801048d0 <sys_read>:
  return fd;
}

int
sys_read(void)
{
801048d0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801048d1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
801048d3:	89 e5                	mov    %esp,%ebp
801048d5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801048d8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801048db:	e8 40 ff ff ff       	call   80104820 <argfd.constprop.0>
801048e0:	85 c0                	test   %eax,%eax
801048e2:	78 54                	js     80104938 <sys_read+0x68>
801048e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801048e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801048eb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801048f2:	e8 39 fc ff ff       	call   80104530 <argint>
801048f7:	85 c0                	test   %eax,%eax
801048f9:	78 3d                	js     80104938 <sys_read+0x68>
801048fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104905:	89 44 24 08          	mov    %eax,0x8(%esp)
80104909:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010490c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104910:	e8 4b fc ff ff       	call   80104560 <argptr>
80104915:	85 c0                	test   %eax,%eax
80104917:	78 1f                	js     80104938 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
80104919:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010491c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104920:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104923:	89 44 24 04          	mov    %eax,0x4(%esp)
80104927:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010492a:	89 04 24             	mov    %eax,(%esp)
8010492d:	e8 ee c5 ff ff       	call   80100f20 <fileread>
}
80104932:	c9                   	leave  
80104933:	c3                   	ret    
80104934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104938:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
8010493d:	c9                   	leave  
8010493e:	c3                   	ret    
8010493f:	90                   	nop

80104940 <sys_write>:

int
sys_write(void)
{
80104940:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104941:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104943:	89 e5                	mov    %esp,%ebp
80104945:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104948:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010494b:	e8 d0 fe ff ff       	call   80104820 <argfd.constprop.0>
80104950:	85 c0                	test   %eax,%eax
80104952:	78 54                	js     801049a8 <sys_write+0x68>
80104954:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104957:	89 44 24 04          	mov    %eax,0x4(%esp)
8010495b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104962:	e8 c9 fb ff ff       	call   80104530 <argint>
80104967:	85 c0                	test   %eax,%eax
80104969:	78 3d                	js     801049a8 <sys_write+0x68>
8010496b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010496e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104975:	89 44 24 08          	mov    %eax,0x8(%esp)
80104979:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010497c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104980:	e8 db fb ff ff       	call   80104560 <argptr>
80104985:	85 c0                	test   %eax,%eax
80104987:	78 1f                	js     801049a8 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
80104989:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010498c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104990:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104993:	89 44 24 04          	mov    %eax,0x4(%esp)
80104997:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010499a:	89 04 24             	mov    %eax,(%esp)
8010499d:	e8 1e c6 ff ff       	call   80100fc0 <filewrite>
}
801049a2:	c9                   	leave  
801049a3:	c3                   	ret    
801049a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801049a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
801049ad:	c9                   	leave  
801049ae:	c3                   	ret    
801049af:	90                   	nop

801049b0 <sys_close>:

int
sys_close(void)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801049b6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801049b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049bc:	e8 5f fe ff ff       	call   80104820 <argfd.constprop.0>
801049c1:	85 c0                	test   %eax,%eax
801049c3:	78 23                	js     801049e8 <sys_close+0x38>
    return -1;
  myproc()->ofile[fd] = 0;
801049c5:	e8 c6 ec ff ff       	call   80103690 <myproc>
801049ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049cd:	c7 44 90 2c 00 00 00 	movl   $0x0,0x2c(%eax,%edx,4)
801049d4:	00 
  fileclose(f);
801049d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d8:	89 04 24             	mov    %eax,(%esp)
801049db:	e8 30 c4 ff ff       	call   80100e10 <fileclose>
  return 0;
801049e0:	31 c0                	xor    %eax,%eax
}
801049e2:	c9                   	leave  
801049e3:	c3                   	ret    
801049e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
801049e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
801049ed:	c9                   	leave  
801049ee:	c3                   	ret    
801049ef:	90                   	nop

801049f0 <sys_fstat>:

int
sys_fstat(void)
{
801049f0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801049f1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
801049f3:	89 e5                	mov    %esp,%ebp
801049f5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801049f8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801049fb:	e8 20 fe ff ff       	call   80104820 <argfd.constprop.0>
80104a00:	85 c0                	test   %eax,%eax
80104a02:	78 34                	js     80104a38 <sys_fstat+0x48>
80104a04:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a07:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104a0e:	00 
80104a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a13:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a1a:	e8 41 fb ff ff       	call   80104560 <argptr>
80104a1f:	85 c0                	test   %eax,%eax
80104a21:	78 15                	js     80104a38 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80104a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a26:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a2d:	89 04 24             	mov    %eax,(%esp)
80104a30:	e8 9b c4 ff ff       	call   80100ed0 <filestat>
}
80104a35:	c9                   	leave  
80104a36:	c3                   	ret    
80104a37:	90                   	nop
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104a3d:	c9                   	leave  
80104a3e:	c3                   	ret    
80104a3f:	90                   	nop

80104a40 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	57                   	push   %edi
80104a44:	56                   	push   %esi
80104a45:	53                   	push   %ebx
80104a46:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104a49:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a50:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104a57:	e8 34 fb ff ff       	call   80104590 <argstr>
80104a5c:	85 c0                	test   %eax,%eax
80104a5e:	0f 88 e6 00 00 00    	js     80104b4a <sys_link+0x10a>
80104a64:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104a67:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a72:	e8 19 fb ff ff       	call   80104590 <argstr>
80104a77:	85 c0                	test   %eax,%eax
80104a79:	0f 88 cb 00 00 00    	js     80104b4a <sys_link+0x10a>
    return -1;

  begin_op();
80104a7f:	e8 7c e0 ff ff       	call   80102b00 <begin_op>
  if((ip = namei(old)) == 0){
80104a84:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104a87:	89 04 24             	mov    %eax,(%esp)
80104a8a:	e8 61 d4 ff ff       	call   80101ef0 <namei>
80104a8f:	85 c0                	test   %eax,%eax
80104a91:	89 c3                	mov    %eax,%ebx
80104a93:	0f 84 ac 00 00 00    	je     80104b45 <sys_link+0x105>
    end_op();
    return -1;
  }

  ilock(ip);
80104a99:	89 04 24             	mov    %eax,(%esp)
80104a9c:	e8 ff cb ff ff       	call   801016a0 <ilock>
  if(ip->type == T_DIR){
80104aa1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104aa6:	0f 84 91 00 00 00    	je     80104b3d <sys_link+0xfd>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104aac:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104ab1:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104ab4:	89 1c 24             	mov    %ebx,(%esp)
80104ab7:	e8 24 cb ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
80104abc:	89 1c 24             	mov    %ebx,(%esp)
80104abf:	e8 bc cc ff ff       	call   80101780 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104ac4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104ac7:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104acb:	89 04 24             	mov    %eax,(%esp)
80104ace:	e8 3d d4 ff ff       	call   80101f10 <nameiparent>
80104ad3:	85 c0                	test   %eax,%eax
80104ad5:	89 c6                	mov    %eax,%esi
80104ad7:	74 4f                	je     80104b28 <sys_link+0xe8>
    goto bad;
  ilock(dp);
80104ad9:	89 04 24             	mov    %eax,(%esp)
80104adc:	e8 bf cb ff ff       	call   801016a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104ae1:	8b 03                	mov    (%ebx),%eax
80104ae3:	39 06                	cmp    %eax,(%esi)
80104ae5:	75 39                	jne    80104b20 <sys_link+0xe0>
80104ae7:	8b 43 04             	mov    0x4(%ebx),%eax
80104aea:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104aee:	89 34 24             	mov    %esi,(%esp)
80104af1:	89 44 24 08          	mov    %eax,0x8(%esp)
80104af5:	e8 16 d3 ff ff       	call   80101e10 <dirlink>
80104afa:	85 c0                	test   %eax,%eax
80104afc:	78 22                	js     80104b20 <sys_link+0xe0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104afe:	89 34 24             	mov    %esi,(%esp)
80104b01:	e8 fa cd ff ff       	call   80101900 <iunlockput>
  iput(ip);
80104b06:	89 1c 24             	mov    %ebx,(%esp)
80104b09:	e8 b2 cc ff ff       	call   801017c0 <iput>

  end_op();
80104b0e:	e8 5d e0 ff ff       	call   80102b70 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104b13:	83 c4 3c             	add    $0x3c,%esp
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;
80104b16:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104b18:	5b                   	pop    %ebx
80104b19:	5e                   	pop    %esi
80104b1a:	5f                   	pop    %edi
80104b1b:	5d                   	pop    %ebp
80104b1c:	c3                   	ret    
80104b1d:	8d 76 00             	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104b20:	89 34 24             	mov    %esi,(%esp)
80104b23:	e8 d8 cd ff ff       	call   80101900 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80104b28:	89 1c 24             	mov    %ebx,(%esp)
80104b2b:	e8 70 cb ff ff       	call   801016a0 <ilock>
  ip->nlink--;
80104b30:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104b35:	89 1c 24             	mov    %ebx,(%esp)
80104b38:	e8 a3 ca ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
80104b3d:	89 1c 24             	mov    %ebx,(%esp)
80104b40:	e8 bb cd ff ff       	call   80101900 <iunlockput>
  end_op();
80104b45:	e8 26 e0 ff ff       	call   80102b70 <end_op>
  return -1;
}
80104b4a:	83 c4 3c             	add    $0x3c,%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104b4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b52:	5b                   	pop    %ebx
80104b53:	5e                   	pop    %esi
80104b54:	5f                   	pop    %edi
80104b55:	5d                   	pop    %ebp
80104b56:	c3                   	ret    
80104b57:	89 f6                	mov    %esi,%esi
80104b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b60 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	57                   	push   %edi
80104b64:	56                   	push   %esi
80104b65:	53                   	push   %ebx
80104b66:	83 ec 5c             	sub    $0x5c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104b69:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104b77:	e8 14 fa ff ff       	call   80104590 <argstr>
80104b7c:	85 c0                	test   %eax,%eax
80104b7e:	0f 88 76 01 00 00    	js     80104cfa <sys_unlink+0x19a>
    return -1;

  begin_op();
80104b84:	e8 77 df ff ff       	call   80102b00 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104b89:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104b8c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104b8f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104b93:	89 04 24             	mov    %eax,(%esp)
80104b96:	e8 75 d3 ff ff       	call   80101f10 <nameiparent>
80104b9b:	85 c0                	test   %eax,%eax
80104b9d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104ba0:	0f 84 4f 01 00 00    	je     80104cf5 <sys_unlink+0x195>
    end_op();
    return -1;
  }

  ilock(dp);
80104ba6:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104ba9:	89 34 24             	mov    %esi,(%esp)
80104bac:	e8 ef ca ff ff       	call   801016a0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104bb1:	c7 44 24 04 fc 74 10 	movl   $0x801074fc,0x4(%esp)
80104bb8:	80 
80104bb9:	89 1c 24             	mov    %ebx,(%esp)
80104bbc:	e8 bf cf ff ff       	call   80101b80 <namecmp>
80104bc1:	85 c0                	test   %eax,%eax
80104bc3:	0f 84 21 01 00 00    	je     80104cea <sys_unlink+0x18a>
80104bc9:	c7 44 24 04 fb 74 10 	movl   $0x801074fb,0x4(%esp)
80104bd0:	80 
80104bd1:	89 1c 24             	mov    %ebx,(%esp)
80104bd4:	e8 a7 cf ff ff       	call   80101b80 <namecmp>
80104bd9:	85 c0                	test   %eax,%eax
80104bdb:	0f 84 09 01 00 00    	je     80104cea <sys_unlink+0x18a>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104be1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104be4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104be8:	89 44 24 08          	mov    %eax,0x8(%esp)
80104bec:	89 34 24             	mov    %esi,(%esp)
80104bef:	e8 bc cf ff ff       	call   80101bb0 <dirlookup>
80104bf4:	85 c0                	test   %eax,%eax
80104bf6:	89 c3                	mov    %eax,%ebx
80104bf8:	0f 84 ec 00 00 00    	je     80104cea <sys_unlink+0x18a>
    goto bad;
  ilock(ip);
80104bfe:	89 04 24             	mov    %eax,(%esp)
80104c01:	e8 9a ca ff ff       	call   801016a0 <ilock>

  if(ip->nlink < 1)
80104c06:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104c0b:	0f 8e 24 01 00 00    	jle    80104d35 <sys_unlink+0x1d5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104c11:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c16:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104c19:	74 7d                	je     80104c98 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104c1b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104c22:	00 
80104c23:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104c2a:	00 
80104c2b:	89 34 24             	mov    %esi,(%esp)
80104c2e:	e8 3d f6 ff ff       	call   80104270 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104c33:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104c36:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104c3d:	00 
80104c3e:	89 74 24 04          	mov    %esi,0x4(%esp)
80104c42:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c46:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104c49:	89 04 24             	mov    %eax,(%esp)
80104c4c:	e8 ff cd ff ff       	call   80101a50 <writei>
80104c51:	83 f8 10             	cmp    $0x10,%eax
80104c54:	0f 85 cf 00 00 00    	jne    80104d29 <sys_unlink+0x1c9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104c5a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c5f:	0f 84 a3 00 00 00    	je     80104d08 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104c65:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104c68:	89 04 24             	mov    %eax,(%esp)
80104c6b:	e8 90 cc ff ff       	call   80101900 <iunlockput>

  ip->nlink--;
80104c70:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104c75:	89 1c 24             	mov    %ebx,(%esp)
80104c78:	e8 63 c9 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
80104c7d:	89 1c 24             	mov    %ebx,(%esp)
80104c80:	e8 7b cc ff ff       	call   80101900 <iunlockput>

  end_op();
80104c85:	e8 e6 de ff ff       	call   80102b70 <end_op>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104c8a:	83 c4 5c             	add    $0x5c,%esp
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;
80104c8d:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104c8f:	5b                   	pop    %ebx
80104c90:	5e                   	pop    %esi
80104c91:	5f                   	pop    %edi
80104c92:	5d                   	pop    %ebp
80104c93:	c3                   	ret    
80104c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104c98:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104c9c:	0f 86 79 ff ff ff    	jbe    80104c1b <sys_unlink+0xbb>
80104ca2:	bf 20 00 00 00       	mov    $0x20,%edi
80104ca7:	eb 15                	jmp    80104cbe <sys_unlink+0x15e>
80104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cb0:	8d 57 10             	lea    0x10(%edi),%edx
80104cb3:	3b 53 58             	cmp    0x58(%ebx),%edx
80104cb6:	0f 83 5f ff ff ff    	jae    80104c1b <sys_unlink+0xbb>
80104cbc:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104cbe:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104cc5:	00 
80104cc6:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104cca:	89 74 24 04          	mov    %esi,0x4(%esp)
80104cce:	89 1c 24             	mov    %ebx,(%esp)
80104cd1:	e8 7a cc ff ff       	call   80101950 <readi>
80104cd6:	83 f8 10             	cmp    $0x10,%eax
80104cd9:	75 42                	jne    80104d1d <sys_unlink+0x1bd>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104cdb:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104ce0:	74 ce                	je     80104cb0 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104ce2:	89 1c 24             	mov    %ebx,(%esp)
80104ce5:	e8 16 cc ff ff       	call   80101900 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104cea:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104ced:	89 04 24             	mov    %eax,(%esp)
80104cf0:	e8 0b cc ff ff       	call   80101900 <iunlockput>
  end_op();
80104cf5:	e8 76 de ff ff       	call   80102b70 <end_op>
  return -1;
}
80104cfa:	83 c4 5c             	add    $0x5c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104cfd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d02:	5b                   	pop    %ebx
80104d03:	5e                   	pop    %esi
80104d04:	5f                   	pop    %edi
80104d05:	5d                   	pop    %ebp
80104d06:	c3                   	ret    
80104d07:	90                   	nop

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104d08:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d0b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104d10:	89 04 24             	mov    %eax,(%esp)
80104d13:	e8 c8 c8 ff ff       	call   801015e0 <iupdate>
80104d18:	e9 48 ff ff ff       	jmp    80104c65 <sys_unlink+0x105>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104d1d:	c7 04 24 20 75 10 80 	movl   $0x80107520,(%esp)
80104d24:	e8 37 b6 ff ff       	call   80100360 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104d29:	c7 04 24 32 75 10 80 	movl   $0x80107532,(%esp)
80104d30:	e8 2b b6 ff ff       	call   80100360 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104d35:	c7 04 24 0e 75 10 80 	movl   $0x8010750e,(%esp)
80104d3c:	e8 1f b6 ff ff       	call   80100360 <panic>
80104d41:	eb 0d                	jmp    80104d50 <sys_open>
80104d43:	90                   	nop
80104d44:	90                   	nop
80104d45:	90                   	nop
80104d46:	90                   	nop
80104d47:	90                   	nop
80104d48:	90                   	nop
80104d49:	90                   	nop
80104d4a:	90                   	nop
80104d4b:	90                   	nop
80104d4c:	90                   	nop
80104d4d:	90                   	nop
80104d4e:	90                   	nop
80104d4f:	90                   	nop

80104d50 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	57                   	push   %edi
80104d54:	56                   	push   %esi
80104d55:	53                   	push   %ebx
80104d56:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104d59:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104d5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d67:	e8 24 f8 ff ff       	call   80104590 <argstr>
80104d6c:	85 c0                	test   %eax,%eax
80104d6e:	0f 88 d1 00 00 00    	js     80104e45 <sys_open+0xf5>
80104d74:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104d77:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d7b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104d82:	e8 a9 f7 ff ff       	call   80104530 <argint>
80104d87:	85 c0                	test   %eax,%eax
80104d89:	0f 88 b6 00 00 00    	js     80104e45 <sys_open+0xf5>
    return -1;

  begin_op();
80104d8f:	e8 6c dd ff ff       	call   80102b00 <begin_op>

  if(omode & O_CREATE){
80104d94:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104d98:	0f 85 82 00 00 00    	jne    80104e20 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104d9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104da1:	89 04 24             	mov    %eax,(%esp)
80104da4:	e8 47 d1 ff ff       	call   80101ef0 <namei>
80104da9:	85 c0                	test   %eax,%eax
80104dab:	89 c6                	mov    %eax,%esi
80104dad:	0f 84 8d 00 00 00    	je     80104e40 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104db3:	89 04 24             	mov    %eax,(%esp)
80104db6:	e8 e5 c8 ff ff       	call   801016a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104dbb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104dc0:	0f 84 92 00 00 00    	je     80104e58 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104dc6:	e8 85 bf ff ff       	call   80100d50 <filealloc>
80104dcb:	85 c0                	test   %eax,%eax
80104dcd:	89 c3                	mov    %eax,%ebx
80104dcf:	0f 84 93 00 00 00    	je     80104e68 <sys_open+0x118>
80104dd5:	e8 86 f8 ff ff       	call   80104660 <fdalloc>
80104dda:	85 c0                	test   %eax,%eax
80104ddc:	89 c7                	mov    %eax,%edi
80104dde:	0f 88 94 00 00 00    	js     80104e78 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104de4:	89 34 24             	mov    %esi,(%esp)
80104de7:	e8 94 c9 ff ff       	call   80101780 <iunlock>
  end_op();
80104dec:	e8 7f dd ff ff       	call   80102b70 <end_op>

  f->type = FD_INODE;
80104df1:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104df7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80104dfa:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104dfd:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104e04:	89 c2                	mov    %eax,%edx
80104e06:	83 e2 01             	and    $0x1,%edx
80104e09:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e0c:	a8 03                	test   $0x3,%al
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104e0e:	88 53 08             	mov    %dl,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
80104e11:	89 f8                	mov    %edi,%eax

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e13:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104e17:	83 c4 2c             	add    $0x2c,%esp
80104e1a:	5b                   	pop    %ebx
80104e1b:	5e                   	pop    %esi
80104e1c:	5f                   	pop    %edi
80104e1d:	5d                   	pop    %ebp
80104e1e:	c3                   	ret    
80104e1f:	90                   	nop
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104e20:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e23:	31 c9                	xor    %ecx,%ecx
80104e25:	ba 02 00 00 00       	mov    $0x2,%edx
80104e2a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104e31:	e8 6a f8 ff ff       	call   801046a0 <create>
    if(ip == 0){
80104e36:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104e38:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104e3a:	75 8a                	jne    80104dc6 <sys_open+0x76>
80104e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
80104e40:	e8 2b dd ff ff       	call   80102b70 <end_op>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104e45:	83 c4 2c             	add    $0x2c,%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80104e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104e4d:	5b                   	pop    %ebx
80104e4e:	5e                   	pop    %esi
80104e4f:	5f                   	pop    %edi
80104e50:	5d                   	pop    %ebp
80104e51:	c3                   	ret    
80104e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80104e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104e5b:	85 c0                	test   %eax,%eax
80104e5d:	0f 84 63 ff ff ff    	je     80104dc6 <sys_open+0x76>
80104e63:	90                   	nop
80104e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
80104e68:	89 34 24             	mov    %esi,(%esp)
80104e6b:	e8 90 ca ff ff       	call   80101900 <iunlockput>
80104e70:	eb ce                	jmp    80104e40 <sys_open+0xf0>
80104e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80104e78:	89 1c 24             	mov    %ebx,(%esp)
80104e7b:	e8 90 bf ff ff       	call   80100e10 <fileclose>
80104e80:	eb e6                	jmp    80104e68 <sys_open+0x118>
80104e82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e90 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104e96:	e8 65 dc ff ff       	call   80102b00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104e9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e9e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ea2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ea9:	e8 e2 f6 ff ff       	call   80104590 <argstr>
80104eae:	85 c0                	test   %eax,%eax
80104eb0:	78 2e                	js     80104ee0 <sys_mkdir+0x50>
80104eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eb5:	31 c9                	xor    %ecx,%ecx
80104eb7:	ba 01 00 00 00       	mov    $0x1,%edx
80104ebc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ec3:	e8 d8 f7 ff ff       	call   801046a0 <create>
80104ec8:	85 c0                	test   %eax,%eax
80104eca:	74 14                	je     80104ee0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104ecc:	89 04 24             	mov    %eax,(%esp)
80104ecf:	e8 2c ca ff ff       	call   80101900 <iunlockput>
  end_op();
80104ed4:	e8 97 dc ff ff       	call   80102b70 <end_op>
  return 0;
80104ed9:	31 c0                	xor    %eax,%eax
}
80104edb:	c9                   	leave  
80104edc:	c3                   	ret    
80104edd:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80104ee0:	e8 8b dc ff ff       	call   80102b70 <end_op>
    return -1;
80104ee5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80104eea:	c9                   	leave  
80104eeb:	c3                   	ret    
80104eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ef0 <sys_mknod>:

int
sys_mknod(void)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104ef6:	e8 05 dc ff ff       	call   80102b00 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104efb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104efe:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f02:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f09:	e8 82 f6 ff ff       	call   80104590 <argstr>
80104f0e:	85 c0                	test   %eax,%eax
80104f10:	78 5e                	js     80104f70 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104f12:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f15:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f19:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f20:	e8 0b f6 ff ff       	call   80104530 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80104f25:	85 c0                	test   %eax,%eax
80104f27:	78 47                	js     80104f70 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80104f29:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f30:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104f37:	e8 f4 f5 ff ff       	call   80104530 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80104f3c:	85 c0                	test   %eax,%eax
80104f3e:	78 30                	js     80104f70 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80104f40:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80104f44:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80104f49:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104f4d:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80104f50:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f53:	e8 48 f7 ff ff       	call   801046a0 <create>
80104f58:	85 c0                	test   %eax,%eax
80104f5a:	74 14                	je     80104f70 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
80104f5c:	89 04 24             	mov    %eax,(%esp)
80104f5f:	e8 9c c9 ff ff       	call   80101900 <iunlockput>
  end_op();
80104f64:	e8 07 dc ff ff       	call   80102b70 <end_op>
  return 0;
80104f69:	31 c0                	xor    %eax,%eax
}
80104f6b:	c9                   	leave  
80104f6c:	c3                   	ret    
80104f6d:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80104f70:	e8 fb db ff ff       	call   80102b70 <end_op>
    return -1;
80104f75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80104f7a:	c9                   	leave  
80104f7b:	c3                   	ret    
80104f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f80 <sys_chdir>:

int
sys_chdir(void)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	56                   	push   %esi
80104f84:	53                   	push   %ebx
80104f85:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104f88:	e8 03 e7 ff ff       	call   80103690 <myproc>
80104f8d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104f8f:	e8 6c db ff ff       	call   80102b00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104f94:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f97:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f9b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fa2:	e8 e9 f5 ff ff       	call   80104590 <argstr>
80104fa7:	85 c0                	test   %eax,%eax
80104fa9:	78 4a                	js     80104ff5 <sys_chdir+0x75>
80104fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fae:	89 04 24             	mov    %eax,(%esp)
80104fb1:	e8 3a cf ff ff       	call   80101ef0 <namei>
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	89 c3                	mov    %eax,%ebx
80104fba:	74 39                	je     80104ff5 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
80104fbc:	89 04 24             	mov    %eax,(%esp)
80104fbf:	e8 dc c6 ff ff       	call   801016a0 <ilock>
  if(ip->type != T_DIR){
80104fc4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80104fc9:	89 1c 24             	mov    %ebx,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
80104fcc:	75 22                	jne    80104ff0 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104fce:	e8 ad c7 ff ff       	call   80101780 <iunlock>
  iput(curproc->cwd);
80104fd3:	8b 46 6c             	mov    0x6c(%esi),%eax
80104fd6:	89 04 24             	mov    %eax,(%esp)
80104fd9:	e8 e2 c7 ff ff       	call   801017c0 <iput>
  end_op();
80104fde:	e8 8d db ff ff       	call   80102b70 <end_op>
  curproc->cwd = ip;
  return 0;
80104fe3:	31 c0                	xor    %eax,%eax
    return -1;
  }
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
80104fe5:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
}
80104fe8:	83 c4 20             	add    $0x20,%esp
80104feb:	5b                   	pop    %ebx
80104fec:	5e                   	pop    %esi
80104fed:	5d                   	pop    %ebp
80104fee:	c3                   	ret    
80104fef:	90                   	nop
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80104ff0:	e8 0b c9 ff ff       	call   80101900 <iunlockput>
    end_op();
80104ff5:	e8 76 db ff ff       	call   80102b70 <end_op>
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
80104ffa:	83 c4 20             	add    $0x20,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
80104ffd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
80105002:	5b                   	pop    %ebx
80105003:	5e                   	pop    %esi
80105004:	5d                   	pop    %ebp
80105005:	c3                   	ret    
80105006:	8d 76 00             	lea    0x0(%esi),%esi
80105009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105010 <sys_exec>:

int
sys_exec(void)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	57                   	push   %edi
80105014:	56                   	push   %esi
80105015:	53                   	push   %ebx
80105016:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010501c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105022:	89 44 24 04          	mov    %eax,0x4(%esp)
80105026:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010502d:	e8 5e f5 ff ff       	call   80104590 <argstr>
80105032:	85 c0                	test   %eax,%eax
80105034:	0f 88 84 00 00 00    	js     801050be <sys_exec+0xae>
8010503a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105040:	89 44 24 04          	mov    %eax,0x4(%esp)
80105044:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010504b:	e8 e0 f4 ff ff       	call   80104530 <argint>
80105050:	85 c0                	test   %eax,%eax
80105052:	78 6a                	js     801050be <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105054:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010505a:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010505c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105063:	00 
80105064:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010506a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105071:	00 
80105072:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105078:	89 04 24             	mov    %eax,(%esp)
8010507b:	e8 f0 f1 ff ff       	call   80104270 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105080:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105086:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010508a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010508d:	89 04 24             	mov    %eax,(%esp)
80105090:	e8 2b f4 ff ff       	call   801044c0 <fetchint>
80105095:	85 c0                	test   %eax,%eax
80105097:	78 25                	js     801050be <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105099:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010509f:	85 c0                	test   %eax,%eax
801050a1:	74 2d                	je     801050d0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801050a3:	89 74 24 04          	mov    %esi,0x4(%esp)
801050a7:	89 04 24             	mov    %eax,(%esp)
801050aa:	e8 31 f4 ff ff       	call   801044e0 <fetchstr>
801050af:	85 c0                	test   %eax,%eax
801050b1:	78 0b                	js     801050be <sys_exec+0xae>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801050b3:	83 c3 01             	add    $0x1,%ebx
801050b6:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801050b9:	83 fb 20             	cmp    $0x20,%ebx
801050bc:	75 c2                	jne    80105080 <sys_exec+0x70>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801050be:	81 c4 ac 00 00 00    	add    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801050c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801050c9:	5b                   	pop    %ebx
801050ca:	5e                   	pop    %esi
801050cb:	5f                   	pop    %edi
801050cc:	5d                   	pop    %ebp
801050cd:	c3                   	ret    
801050ce:	66 90                	xchg   %ax,%ax
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801050d0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801050d6:	89 44 24 04          	mov    %eax,0x4(%esp)
801050da:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801050e0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801050e7:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801050eb:	89 04 24             	mov    %eax,(%esp)
801050ee:	e8 ad b8 ff ff       	call   801009a0 <exec>
}
801050f3:	81 c4 ac 00 00 00    	add    $0xac,%esp
801050f9:	5b                   	pop    %ebx
801050fa:	5e                   	pop    %esi
801050fb:	5f                   	pop    %edi
801050fc:	5d                   	pop    %ebp
801050fd:	c3                   	ret    
801050fe:	66 90                	xchg   %ax,%ax

80105100 <sys_pipe>:

int
sys_pipe(void)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	53                   	push   %ebx
80105104:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105107:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010510a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105111:	00 
80105112:	89 44 24 04          	mov    %eax,0x4(%esp)
80105116:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010511d:	e8 3e f4 ff ff       	call   80104560 <argptr>
80105122:	85 c0                	test   %eax,%eax
80105124:	78 6d                	js     80105193 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105126:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105129:	89 44 24 04          	mov    %eax,0x4(%esp)
8010512d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105130:	89 04 24             	mov    %eax,(%esp)
80105133:	e8 28 e0 ff ff       	call   80103160 <pipealloc>
80105138:	85 c0                	test   %eax,%eax
8010513a:	78 57                	js     80105193 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010513c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010513f:	e8 1c f5 ff ff       	call   80104660 <fdalloc>
80105144:	85 c0                	test   %eax,%eax
80105146:	89 c3                	mov    %eax,%ebx
80105148:	78 33                	js     8010517d <sys_pipe+0x7d>
8010514a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010514d:	e8 0e f5 ff ff       	call   80104660 <fdalloc>
80105152:	85 c0                	test   %eax,%eax
80105154:	78 1a                	js     80105170 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105156:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105159:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
8010515b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010515e:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
80105161:	83 c4 24             	add    $0x24,%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105164:	31 c0                	xor    %eax,%eax
}
80105166:	5b                   	pop    %ebx
80105167:	5d                   	pop    %ebp
80105168:	c3                   	ret    
80105169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105170:	e8 1b e5 ff ff       	call   80103690 <myproc>
80105175:	c7 44 98 2c 00 00 00 	movl   $0x0,0x2c(%eax,%ebx,4)
8010517c:	00 
    fileclose(rf);
8010517d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105180:	89 04 24             	mov    %eax,(%esp)
80105183:	e8 88 bc ff ff       	call   80100e10 <fileclose>
    fileclose(wf);
80105188:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010518b:	89 04 24             	mov    %eax,(%esp)
8010518e:	e8 7d bc ff ff       	call   80100e10 <fileclose>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105193:	83 c4 24             	add    $0x24,%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105196:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010519b:	5b                   	pop    %ebx
8010519c:	5d                   	pop    %ebp
8010519d:	c3                   	ret    
8010519e:	66 90                	xchg   %ax,%ax

801051a0 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	83 ec 28             	sub    $0x28,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
801051a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801051ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051b4:	e8 77 f3 ff ff       	call   80104530 <argint>
801051b9:	85 c0                	test   %eax,%eax
801051bb:	78 33                	js     801051f0 <sys_shm_open+0x50>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
801051bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051c0:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801051c7:	00 
801051c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801051cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801051d3:	e8 88 f3 ff ff       	call   80104560 <argptr>
801051d8:	85 c0                	test   %eax,%eax
801051da:	78 14                	js     801051f0 <sys_shm_open+0x50>
    return -1;
  return shm_open(id, pointer);
801051dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051df:	89 44 24 04          	mov    %eax,0x4(%esp)
801051e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051e6:	89 04 24             	mov    %eax,(%esp)
801051e9:	e8 92 1b 00 00       	call   80106d80 <shm_open>
}
801051ee:	c9                   	leave  
801051ef:	c3                   	ret    
int sys_shm_open(void) {
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
    return -1;
801051f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  if(argptr(1, (char **) (&pointer),4)<0)
    return -1;
  return shm_open(id, pointer);
}
801051f5:	c9                   	leave  
801051f6:	c3                   	ret    
801051f7:	89 f6                	mov    %esi,%esi
801051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105200 <sys_shm_close>:

int sys_shm_close(void) {
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	83 ec 28             	sub    $0x28,%esp
  int id;

  if(argint(0, &id) < 0)
80105206:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105209:	89 44 24 04          	mov    %eax,0x4(%esp)
8010520d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105214:	e8 17 f3 ff ff       	call   80104530 <argint>
80105219:	85 c0                	test   %eax,%eax
8010521b:	78 13                	js     80105230 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
8010521d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105220:	89 04 24             	mov    %eax,(%esp)
80105223:	e8 68 1b 00 00       	call   80106d90 <shm_close>
}
80105228:	c9                   	leave  
80105229:	c3                   	ret    
8010522a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

int sys_shm_close(void) {
  int id;

  if(argint(0, &id) < 0)
    return -1;
80105230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  
  return shm_close(id);
}
80105235:	c9                   	leave  
80105236:	c3                   	ret    
80105237:	89 f6                	mov    %esi,%esi
80105239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105240 <sys_fork>:

int
sys_fork(void)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105243:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
80105244:	e9 f7 e5 ff ff       	jmp    80103840 <fork>
80105249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105250 <sys_exit>:
}

int
sys_exit(void)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	83 ec 08             	sub    $0x8,%esp
  exit();
80105256:	e8 35 e8 ff ff       	call   80103a90 <exit>
  return 0;  // not reached
}
8010525b:	31 c0                	xor    %eax,%eax
8010525d:	c9                   	leave  
8010525e:	c3                   	ret    
8010525f:	90                   	nop

80105260 <sys_wait>:

int
sys_wait(void)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105263:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105264:	e9 37 ea ff ff       	jmp    80103ca0 <wait>
80105269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105270 <sys_kill>:
}

int
sys_kill(void)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105276:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105279:	89 44 24 04          	mov    %eax,0x4(%esp)
8010527d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105284:	e8 a7 f2 ff ff       	call   80104530 <argint>
80105289:	85 c0                	test   %eax,%eax
8010528b:	78 13                	js     801052a0 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010528d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105290:	89 04 24             	mov    %eax,(%esp)
80105293:	e8 48 eb ff ff       	call   80103de0 <kill>
}
80105298:	c9                   	leave  
80105299:	c3                   	ret    
8010529a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
801052a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
801052a5:	c9                   	leave  
801052a6:	c3                   	ret    
801052a7:	89 f6                	mov    %esi,%esi
801052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052b0 <sys_getpid>:

int
sys_getpid(void)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801052b6:	e8 d5 e3 ff ff       	call   80103690 <myproc>
801052bb:	8b 40 14             	mov    0x14(%eax),%eax
}
801052be:	c9                   	leave  
801052bf:	c3                   	ret    

801052c0 <sys_sbrk>:

int
sys_sbrk(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	53                   	push   %ebx
801052c4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801052c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052d5:	e8 56 f2 ff ff       	call   80104530 <argint>
801052da:	85 c0                	test   %eax,%eax
801052dc:	78 22                	js     80105300 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801052de:	e8 ad e3 ff ff       	call   80103690 <myproc>
  if(growproc(n) < 0)
801052e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
801052e6:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801052e8:	89 14 24             	mov    %edx,(%esp)
801052eb:	e8 e0 e4 ff ff       	call   801037d0 <growproc>
801052f0:	85 c0                	test   %eax,%eax
801052f2:	78 0c                	js     80105300 <sys_sbrk+0x40>
    return -1;
  return addr;
801052f4:	89 d8                	mov    %ebx,%eax
}
801052f6:	83 c4 24             	add    $0x24,%esp
801052f9:	5b                   	pop    %ebx
801052fa:	5d                   	pop    %ebp
801052fb:	c3                   	ret    
801052fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105305:	eb ef                	jmp    801052f6 <sys_sbrk+0x36>
80105307:	89 f6                	mov    %esi,%esi
80105309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105310 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	53                   	push   %ebx
80105314:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105317:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010531a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010531e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105325:	e8 06 f2 ff ff       	call   80104530 <argint>
8010532a:	85 c0                	test   %eax,%eax
8010532c:	78 7e                	js     801053ac <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010532e:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105335:	e8 f6 ed ff ff       	call   80104130 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010533a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
8010533d:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
80105343:	85 d2                	test   %edx,%edx
80105345:	75 29                	jne    80105370 <sys_sleep+0x60>
80105347:	eb 4f                	jmp    80105398 <sys_sleep+0x88>
80105349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105350:	c7 44 24 04 60 4d 11 	movl   $0x80114d60,0x4(%esp)
80105357:	80 
80105358:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
8010535f:	e8 8c e8 ff ff       	call   80103bf0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105364:	a1 a0 55 11 80       	mov    0x801155a0,%eax
80105369:	29 d8                	sub    %ebx,%eax
8010536b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010536e:	73 28                	jae    80105398 <sys_sleep+0x88>
    if(myproc()->killed){
80105370:	e8 1b e3 ff ff       	call   80103690 <myproc>
80105375:	8b 40 28             	mov    0x28(%eax),%eax
80105378:	85 c0                	test   %eax,%eax
8010537a:	74 d4                	je     80105350 <sys_sleep+0x40>
      release(&tickslock);
8010537c:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105383:	e8 98 ee ff ff       	call   80104220 <release>
      return -1;
80105388:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
8010538d:	83 c4 24             	add    $0x24,%esp
80105390:	5b                   	pop    %ebx
80105391:	5d                   	pop    %ebp
80105392:	c3                   	ret    
80105393:	90                   	nop
80105394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105398:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
8010539f:	e8 7c ee ff ff       	call   80104220 <release>
  return 0;
}
801053a4:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
801053a7:	31 c0                	xor    %eax,%eax
}
801053a9:	5b                   	pop    %ebx
801053aa:	5d                   	pop    %ebp
801053ab:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
801053ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053b1:	eb da                	jmp    8010538d <sys_sleep+0x7d>
801053b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053c0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	53                   	push   %ebx
801053c4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801053c7:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801053ce:	e8 5d ed ff ff       	call   80104130 <acquire>
  xticks = ticks;
801053d3:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
801053d9:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801053e0:	e8 3b ee ff ff       	call   80104220 <release>
  return xticks;
}
801053e5:	83 c4 14             	add    $0x14,%esp
801053e8:	89 d8                	mov    %ebx,%eax
801053ea:	5b                   	pop    %ebx
801053eb:	5d                   	pop    %ebp
801053ec:	c3                   	ret    

801053ed <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801053ed:	1e                   	push   %ds
  pushl %es
801053ee:	06                   	push   %es
  pushl %fs
801053ef:	0f a0                	push   %fs
  pushl %gs
801053f1:	0f a8                	push   %gs
  pushal
801053f3:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801053f4:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801053f8:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801053fa:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801053fc:	54                   	push   %esp
  call trap
801053fd:	e8 de 00 00 00       	call   801054e0 <trap>
  addl $4, %esp
80105402:	83 c4 04             	add    $0x4,%esp

80105405 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105405:	61                   	popa   
  popl %gs
80105406:	0f a9                	pop    %gs
  popl %fs
80105408:	0f a1                	pop    %fs
  popl %es
8010540a:	07                   	pop    %es
  popl %ds
8010540b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010540c:	83 c4 08             	add    $0x8,%esp
  iret
8010540f:	cf                   	iret   

80105410 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105410:	31 c0                	xor    %eax,%eax
80105412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105418:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010541f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105424:	66 89 0c c5 a2 4d 11 	mov    %cx,-0x7feeb25e(,%eax,8)
8010542b:	80 
8010542c:	c6 04 c5 a4 4d 11 80 	movb   $0x0,-0x7feeb25c(,%eax,8)
80105433:	00 
80105434:	c6 04 c5 a5 4d 11 80 	movb   $0x8e,-0x7feeb25b(,%eax,8)
8010543b:	8e 
8010543c:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
80105443:	80 
80105444:	c1 ea 10             	shr    $0x10,%edx
80105447:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
8010544e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010544f:	83 c0 01             	add    $0x1,%eax
80105452:	3d 00 01 00 00       	cmp    $0x100,%eax
80105457:	75 bf                	jne    80105418 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105459:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010545a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010545f:	89 e5                	mov    %esp,%ebp
80105461:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105464:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105469:	c7 44 24 04 41 75 10 	movl   $0x80107541,0x4(%esp)
80105470:	80 
80105471:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105478:	66 89 15 a2 4f 11 80 	mov    %dx,0x80114fa2
8010547f:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
80105485:	c1 e8 10             	shr    $0x10,%eax
80105488:	c6 05 a4 4f 11 80 00 	movb   $0x0,0x80114fa4
8010548f:	c6 05 a5 4f 11 80 ef 	movb   $0xef,0x80114fa5
80105496:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6

  initlock(&tickslock, "time");
8010549c:	e8 9f eb ff ff       	call   80104040 <initlock>
}
801054a1:	c9                   	leave  
801054a2:	c3                   	ret    
801054a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054b0 <idtinit>:

void
idtinit(void)
{
801054b0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801054b1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801054b6:	89 e5                	mov    %esp,%ebp
801054b8:	83 ec 10             	sub    $0x10,%esp
801054bb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801054bf:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
801054c4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801054c8:	c1 e8 10             	shr    $0x10,%eax
801054cb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801054cf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801054d2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801054d5:	c9                   	leave  
801054d6:	c3                   	ret    
801054d7:	89 f6                	mov    %esi,%esi
801054d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	57                   	push   %edi
801054e4:	56                   	push   %esi
801054e5:	53                   	push   %ebx
801054e6:	83 ec 3c             	sub    $0x3c,%esp
801054e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801054ec:	8b 43 30             	mov    0x30(%ebx),%eax
801054ef:	83 f8 40             	cmp    $0x40,%eax
801054f2:	0f 84 c0 01 00 00    	je     801056b8 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801054f8:	83 e8 0e             	sub    $0xe,%eax
801054fb:	83 f8 31             	cmp    $0x31,%eax
801054fe:	77 26                	ja     80105526 <trap+0x46>
80105500:	ff 24 85 08 76 10 80 	jmp    *-0x7fef89f8(,%eax,4)
80105507:	90                   	nop

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105508:	0f 20 d6             	mov    %cr2,%esi
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;
  case T_PGFLT:
    //panic("PAGE FAULT");
    if(PGROUNDDOWN(rcr2()) == myproc()->sb - PGSIZE)
8010550b:	e8 80 e1 ff ff       	call   80103690 <myproc>
80105510:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80105516:	8b 40 04             	mov    0x4(%eax),%eax
80105519:	2d 00 10 00 00       	sub    $0x1000,%eax
8010551e:	39 c6                	cmp    %eax,%esi
80105520:	0f 84 40 02 00 00    	je     80105766 <trap+0x286>
	break;
    }
 
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105526:	e8 65 e1 ff ff       	call   80103690 <myproc>
8010552b:	85 c0                	test   %eax,%eax
8010552d:	0f 84 fd 01 00 00    	je     80105730 <trap+0x250>
80105533:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105537:	0f 84 f3 01 00 00    	je     80105730 <trap+0x250>
8010553d:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105540:	8b 53 38             	mov    0x38(%ebx),%edx
80105543:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105546:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105549:	e8 22 e1 ff ff       	call   80103670 <cpuid>
8010554e:	8b 73 30             	mov    0x30(%ebx),%esi
80105551:	89 c7                	mov    %eax,%edi
80105553:	8b 43 34             	mov    0x34(%ebx),%eax
80105556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105559:	e8 32 e1 ff ff       	call   80103690 <myproc>
8010555e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105561:	e8 2a e1 ff ff       	call   80103690 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105566:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105569:	89 74 24 0c          	mov    %esi,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010556d:	8b 75 e0             	mov    -0x20(%ebp),%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105570:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105573:	89 7c 24 14          	mov    %edi,0x14(%esp)
80105577:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010557a:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010557e:	83 c6 70             	add    $0x70,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105581:	89 54 24 18          	mov    %edx,0x18(%esp)
80105585:	89 7c 24 10          	mov    %edi,0x10(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105589:	89 74 24 08          	mov    %esi,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010558d:	8b 40 14             	mov    0x14(%eax),%eax
80105590:	c7 04 24 c4 75 10 80 	movl   $0x801075c4,(%esp)
80105597:	89 44 24 04          	mov    %eax,0x4(%esp)
8010559b:	e8 b0 b0 ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801055a0:	e8 eb e0 ff ff       	call   80103690 <myproc>
801055a5:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801055ac:	e8 df e0 ff ff       	call   80103690 <myproc>
801055b1:	85 c0                	test   %eax,%eax
801055b3:	74 0c                	je     801055c1 <trap+0xe1>
801055b5:	e8 d6 e0 ff ff       	call   80103690 <myproc>
801055ba:	8b 50 28             	mov    0x28(%eax),%edx
801055bd:	85 d2                	test   %edx,%edx
801055bf:	75 4f                	jne    80105610 <trap+0x130>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801055c1:	e8 ca e0 ff ff       	call   80103690 <myproc>
801055c6:	85 c0                	test   %eax,%eax
801055c8:	74 11                	je     801055db <trap+0xfb>
801055ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055d0:	e8 bb e0 ff ff       	call   80103690 <myproc>
801055d5:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
801055d9:	74 4d                	je     80105628 <trap+0x148>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801055db:	e8 b0 e0 ff ff       	call   80103690 <myproc>
801055e0:	85 c0                	test   %eax,%eax
801055e2:	74 1d                	je     80105601 <trap+0x121>
801055e4:	e8 a7 e0 ff ff       	call   80103690 <myproc>
801055e9:	8b 40 28             	mov    0x28(%eax),%eax
801055ec:	85 c0                	test   %eax,%eax
801055ee:	74 11                	je     80105601 <trap+0x121>
801055f0:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801055f4:	83 e0 03             	and    $0x3,%eax
801055f7:	66 83 f8 03          	cmp    $0x3,%ax
801055fb:	0f 84 e8 00 00 00    	je     801056e9 <trap+0x209>
    exit();
}
80105601:	83 c4 3c             	add    $0x3c,%esp
80105604:	5b                   	pop    %ebx
80105605:	5e                   	pop    %esi
80105606:	5f                   	pop    %edi
80105607:	5d                   	pop    %ebp
80105608:	c3                   	ret    
80105609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105610:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105614:	83 e0 03             	and    $0x3,%eax
80105617:	66 83 f8 03          	cmp    $0x3,%ax
8010561b:	75 a4                	jne    801055c1 <trap+0xe1>
    exit();
8010561d:	e8 6e e4 ff ff       	call   80103a90 <exit>
80105622:	eb 9d                	jmp    801055c1 <trap+0xe1>
80105624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105628:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010562c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105630:	75 a9                	jne    801055db <trap+0xfb>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80105632:	e8 79 e5 ff ff       	call   80103bb0 <yield>
80105637:	eb a2                	jmp    801055db <trap+0xfb>
80105639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }

  switch(tf->trapno){
 case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105640:	e8 2b e0 ff ff       	call   80103670 <cpuid>
80105645:	85 c0                	test   %eax,%eax
80105647:	0f 84 b3 00 00 00    	je     80105700 <trap+0x220>
8010564d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105650:	e8 1b d1 ff ff       	call   80102770 <lapiceoi>
    break;
80105655:	e9 52 ff ff ff       	jmp    801055ac <trap+0xcc>
8010565a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105660:	e8 5b cf ff ff       	call   801025c0 <kbdintr>
    lapiceoi();
80105665:	e8 06 d1 ff ff       	call   80102770 <lapiceoi>
    break;
8010566a:	e9 3d ff ff ff       	jmp    801055ac <trap+0xcc>
8010566f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105670:	e8 2b 02 00 00       	call   801058a0 <uartintr>
    lapiceoi();
80105675:	e8 f6 d0 ff ff       	call   80102770 <lapiceoi>
    break;
8010567a:	e9 2d ff ff ff       	jmp    801055ac <trap+0xcc>
8010567f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105680:	8b 7b 38             	mov    0x38(%ebx),%edi
80105683:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105687:	e8 e4 df ff ff       	call   80103670 <cpuid>
8010568c:	c7 04 24 6c 75 10 80 	movl   $0x8010756c,(%esp)
80105693:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105697:	89 74 24 08          	mov    %esi,0x8(%esp)
8010569b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010569f:	e8 ac af ff ff       	call   80100650 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
801056a4:	e8 c7 d0 ff ff       	call   80102770 <lapiceoi>
    break;
801056a9:	e9 fe fe ff ff       	jmp    801055ac <trap+0xcc>
801056ae:	66 90                	xchg   %ax,%ax
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801056b0:	e8 bb c9 ff ff       	call   80102070 <ideintr>
801056b5:	eb 96                	jmp    8010564d <trap+0x16d>
801056b7:	90                   	nop
801056b8:	90                   	nop
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
801056c0:	e8 cb df ff ff       	call   80103690 <myproc>
801056c5:	8b 70 28             	mov    0x28(%eax),%esi
801056c8:	85 f6                	test   %esi,%esi
801056ca:	75 2c                	jne    801056f8 <trap+0x218>
      exit();
    myproc()->tf = tf;
801056cc:	e8 bf df ff ff       	call   80103690 <myproc>
801056d1:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
801056d4:	e8 17 ef ff ff       	call   801045f0 <syscall>
    if(myproc()->killed)
801056d9:	e8 b2 df ff ff       	call   80103690 <myproc>
801056de:	8b 48 28             	mov    0x28(%eax),%ecx
801056e1:	85 c9                	test   %ecx,%ecx
801056e3:	0f 84 18 ff ff ff    	je     80105601 <trap+0x121>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801056e9:	83 c4 3c             	add    $0x3c,%esp
801056ec:	5b                   	pop    %ebx
801056ed:	5e                   	pop    %esi
801056ee:	5f                   	pop    %edi
801056ef:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
801056f0:	e9 9b e3 ff ff       	jmp    80103a90 <exit>
801056f5:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
801056f8:	e8 93 e3 ff ff       	call   80103a90 <exit>
801056fd:	eb cd                	jmp    801056cc <trap+0x1ec>
801056ff:	90                   	nop
  }

  switch(tf->trapno){
 case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105700:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105707:	e8 24 ea ff ff       	call   80104130 <acquire>
      ticks++;
      wakeup(&ticks);
8010570c:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)

  switch(tf->trapno){
 case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80105713:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
      wakeup(&ticks);
8010571a:	e8 61 e6 ff ff       	call   80103d80 <wakeup>
      release(&tickslock);
8010571f:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105726:	e8 f5 ea ff ff       	call   80104220 <release>
8010572b:	e9 1d ff ff ff       	jmp    8010564d <trap+0x16d>
80105730:	0f 20 d7             	mov    %cr2,%edi
 
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105733:	8b 73 38             	mov    0x38(%ebx),%esi
80105736:	e8 35 df ff ff       	call   80103670 <cpuid>
8010573b:	89 7c 24 10          	mov    %edi,0x10(%esp)
8010573f:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105743:	89 44 24 08          	mov    %eax,0x8(%esp)
80105747:	8b 43 30             	mov    0x30(%ebx),%eax
8010574a:	c7 04 24 90 75 10 80 	movl   $0x80107590,(%esp)
80105751:	89 44 24 04          	mov    %eax,0x4(%esp)
80105755:	e8 f6 ae ff ff       	call   80100650 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
8010575a:	c7 04 24 64 75 10 80 	movl   $0x80107564,(%esp)
80105761:	e8 fa ab ff ff       	call   80100360 <panic>
    break;
  case T_PGFLT:
    //panic("PAGE FAULT");
    if(PGROUNDDOWN(rcr2()) == myproc()->sb - PGSIZE)
    {
	panic("WE FOUND AN ACTUAL PAGE FAULT");
80105766:	c7 04 24 46 75 10 80 	movl   $0x80107546,(%esp)
8010576d:	e8 ee ab ff ff       	call   80100360 <panic>
80105772:	66 90                	xchg   %ax,%ax
80105774:	66 90                	xchg   %ax,%ax
80105776:	66 90                	xchg   %ax,%ax
80105778:	66 90                	xchg   %ax,%ax
8010577a:	66 90                	xchg   %ax,%ax
8010577c:	66 90                	xchg   %ax,%ax
8010577e:	66 90                	xchg   %ax,%ax

80105780 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105780:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105785:	55                   	push   %ebp
80105786:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105788:	85 c0                	test   %eax,%eax
8010578a:	74 14                	je     801057a0 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010578c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105791:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105792:	a8 01                	test   $0x1,%al
80105794:	74 0a                	je     801057a0 <uartgetc+0x20>
80105796:	b2 f8                	mov    $0xf8,%dl
80105798:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105799:	0f b6 c0             	movzbl %al,%eax
}
8010579c:	5d                   	pop    %ebp
8010579d:	c3                   	ret    
8010579e:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
801057a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
801057a5:	5d                   	pop    %ebp
801057a6:	c3                   	ret    
801057a7:	89 f6                	mov    %esi,%esi
801057a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057b0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
801057b0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
801057b5:	85 c0                	test   %eax,%eax
801057b7:	74 3f                	je     801057f8 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
801057b9:	55                   	push   %ebp
801057ba:	89 e5                	mov    %esp,%ebp
801057bc:	56                   	push   %esi
801057bd:	be fd 03 00 00       	mov    $0x3fd,%esi
801057c2:	53                   	push   %ebx
  int i;

  if(!uart)
801057c3:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
801057c8:	83 ec 10             	sub    $0x10,%esp
801057cb:	eb 14                	jmp    801057e1 <uartputc+0x31>
801057cd:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
801057d0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801057d7:	e8 b4 cf ff ff       	call   80102790 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801057dc:	83 eb 01             	sub    $0x1,%ebx
801057df:	74 07                	je     801057e8 <uartputc+0x38>
801057e1:	89 f2                	mov    %esi,%edx
801057e3:	ec                   	in     (%dx),%al
801057e4:	a8 20                	test   $0x20,%al
801057e6:	74 e8                	je     801057d0 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
801057e8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801057ec:	ba f8 03 00 00       	mov    $0x3f8,%edx
801057f1:	ee                   	out    %al,(%dx)
}
801057f2:	83 c4 10             	add    $0x10,%esp
801057f5:	5b                   	pop    %ebx
801057f6:	5e                   	pop    %esi
801057f7:	5d                   	pop    %ebp
801057f8:	f3 c3                	repz ret 
801057fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105800 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105800:	55                   	push   %ebp
80105801:	31 c9                	xor    %ecx,%ecx
80105803:	89 e5                	mov    %esp,%ebp
80105805:	89 c8                	mov    %ecx,%eax
80105807:	57                   	push   %edi
80105808:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010580d:	56                   	push   %esi
8010580e:	89 fa                	mov    %edi,%edx
80105810:	53                   	push   %ebx
80105811:	83 ec 1c             	sub    $0x1c,%esp
80105814:	ee                   	out    %al,(%dx)
80105815:	be fb 03 00 00       	mov    $0x3fb,%esi
8010581a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010581f:	89 f2                	mov    %esi,%edx
80105821:	ee                   	out    %al,(%dx)
80105822:	b8 0c 00 00 00       	mov    $0xc,%eax
80105827:	b2 f8                	mov    $0xf8,%dl
80105829:	ee                   	out    %al,(%dx)
8010582a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
8010582f:	89 c8                	mov    %ecx,%eax
80105831:	89 da                	mov    %ebx,%edx
80105833:	ee                   	out    %al,(%dx)
80105834:	b8 03 00 00 00       	mov    $0x3,%eax
80105839:	89 f2                	mov    %esi,%edx
8010583b:	ee                   	out    %al,(%dx)
8010583c:	b2 fc                	mov    $0xfc,%dl
8010583e:	89 c8                	mov    %ecx,%eax
80105840:	ee                   	out    %al,(%dx)
80105841:	b8 01 00 00 00       	mov    $0x1,%eax
80105846:	89 da                	mov    %ebx,%edx
80105848:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105849:	b2 fd                	mov    $0xfd,%dl
8010584b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010584c:	3c ff                	cmp    $0xff,%al
8010584e:	74 42                	je     80105892 <uartinit+0x92>
    return;
  uart = 1;
80105850:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105857:	00 00 00 
8010585a:	89 fa                	mov    %edi,%edx
8010585c:	ec                   	in     (%dx),%al
8010585d:	b2 f8                	mov    $0xf8,%dl
8010585f:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105860:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105867:	00 

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105868:	bb d0 76 10 80       	mov    $0x801076d0,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
8010586d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105874:	e8 27 ca ff ff       	call   801022a0 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105879:	b8 78 00 00 00       	mov    $0x78,%eax
8010587e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105880:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105883:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105886:	e8 25 ff ff ff       	call   801057b0 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010588b:	0f be 03             	movsbl (%ebx),%eax
8010588e:	84 c0                	test   %al,%al
80105890:	75 ee                	jne    80105880 <uartinit+0x80>
    uartputc(*p);
}
80105892:	83 c4 1c             	add    $0x1c,%esp
80105895:	5b                   	pop    %ebx
80105896:	5e                   	pop    %esi
80105897:	5f                   	pop    %edi
80105898:	5d                   	pop    %ebp
80105899:	c3                   	ret    
8010589a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058a0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801058a6:	c7 04 24 80 57 10 80 	movl   $0x80105780,(%esp)
801058ad:	e8 fe ae ff ff       	call   801007b0 <consoleintr>
}
801058b2:	c9                   	leave  
801058b3:	c3                   	ret    

801058b4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801058b4:	6a 00                	push   $0x0
  pushl $0
801058b6:	6a 00                	push   $0x0
  jmp alltraps
801058b8:	e9 30 fb ff ff       	jmp    801053ed <alltraps>

801058bd <vector1>:
.globl vector1
vector1:
  pushl $0
801058bd:	6a 00                	push   $0x0
  pushl $1
801058bf:	6a 01                	push   $0x1
  jmp alltraps
801058c1:	e9 27 fb ff ff       	jmp    801053ed <alltraps>

801058c6 <vector2>:
.globl vector2
vector2:
  pushl $0
801058c6:	6a 00                	push   $0x0
  pushl $2
801058c8:	6a 02                	push   $0x2
  jmp alltraps
801058ca:	e9 1e fb ff ff       	jmp    801053ed <alltraps>

801058cf <vector3>:
.globl vector3
vector3:
  pushl $0
801058cf:	6a 00                	push   $0x0
  pushl $3
801058d1:	6a 03                	push   $0x3
  jmp alltraps
801058d3:	e9 15 fb ff ff       	jmp    801053ed <alltraps>

801058d8 <vector4>:
.globl vector4
vector4:
  pushl $0
801058d8:	6a 00                	push   $0x0
  pushl $4
801058da:	6a 04                	push   $0x4
  jmp alltraps
801058dc:	e9 0c fb ff ff       	jmp    801053ed <alltraps>

801058e1 <vector5>:
.globl vector5
vector5:
  pushl $0
801058e1:	6a 00                	push   $0x0
  pushl $5
801058e3:	6a 05                	push   $0x5
  jmp alltraps
801058e5:	e9 03 fb ff ff       	jmp    801053ed <alltraps>

801058ea <vector6>:
.globl vector6
vector6:
  pushl $0
801058ea:	6a 00                	push   $0x0
  pushl $6
801058ec:	6a 06                	push   $0x6
  jmp alltraps
801058ee:	e9 fa fa ff ff       	jmp    801053ed <alltraps>

801058f3 <vector7>:
.globl vector7
vector7:
  pushl $0
801058f3:	6a 00                	push   $0x0
  pushl $7
801058f5:	6a 07                	push   $0x7
  jmp alltraps
801058f7:	e9 f1 fa ff ff       	jmp    801053ed <alltraps>

801058fc <vector8>:
.globl vector8
vector8:
  pushl $8
801058fc:	6a 08                	push   $0x8
  jmp alltraps
801058fe:	e9 ea fa ff ff       	jmp    801053ed <alltraps>

80105903 <vector9>:
.globl vector9
vector9:
  pushl $0
80105903:	6a 00                	push   $0x0
  pushl $9
80105905:	6a 09                	push   $0x9
  jmp alltraps
80105907:	e9 e1 fa ff ff       	jmp    801053ed <alltraps>

8010590c <vector10>:
.globl vector10
vector10:
  pushl $10
8010590c:	6a 0a                	push   $0xa
  jmp alltraps
8010590e:	e9 da fa ff ff       	jmp    801053ed <alltraps>

80105913 <vector11>:
.globl vector11
vector11:
  pushl $11
80105913:	6a 0b                	push   $0xb
  jmp alltraps
80105915:	e9 d3 fa ff ff       	jmp    801053ed <alltraps>

8010591a <vector12>:
.globl vector12
vector12:
  pushl $12
8010591a:	6a 0c                	push   $0xc
  jmp alltraps
8010591c:	e9 cc fa ff ff       	jmp    801053ed <alltraps>

80105921 <vector13>:
.globl vector13
vector13:
  pushl $13
80105921:	6a 0d                	push   $0xd
  jmp alltraps
80105923:	e9 c5 fa ff ff       	jmp    801053ed <alltraps>

80105928 <vector14>:
.globl vector14
vector14:
  pushl $14
80105928:	6a 0e                	push   $0xe
  jmp alltraps
8010592a:	e9 be fa ff ff       	jmp    801053ed <alltraps>

8010592f <vector15>:
.globl vector15
vector15:
  pushl $0
8010592f:	6a 00                	push   $0x0
  pushl $15
80105931:	6a 0f                	push   $0xf
  jmp alltraps
80105933:	e9 b5 fa ff ff       	jmp    801053ed <alltraps>

80105938 <vector16>:
.globl vector16
vector16:
  pushl $0
80105938:	6a 00                	push   $0x0
  pushl $16
8010593a:	6a 10                	push   $0x10
  jmp alltraps
8010593c:	e9 ac fa ff ff       	jmp    801053ed <alltraps>

80105941 <vector17>:
.globl vector17
vector17:
  pushl $17
80105941:	6a 11                	push   $0x11
  jmp alltraps
80105943:	e9 a5 fa ff ff       	jmp    801053ed <alltraps>

80105948 <vector18>:
.globl vector18
vector18:
  pushl $0
80105948:	6a 00                	push   $0x0
  pushl $18
8010594a:	6a 12                	push   $0x12
  jmp alltraps
8010594c:	e9 9c fa ff ff       	jmp    801053ed <alltraps>

80105951 <vector19>:
.globl vector19
vector19:
  pushl $0
80105951:	6a 00                	push   $0x0
  pushl $19
80105953:	6a 13                	push   $0x13
  jmp alltraps
80105955:	e9 93 fa ff ff       	jmp    801053ed <alltraps>

8010595a <vector20>:
.globl vector20
vector20:
  pushl $0
8010595a:	6a 00                	push   $0x0
  pushl $20
8010595c:	6a 14                	push   $0x14
  jmp alltraps
8010595e:	e9 8a fa ff ff       	jmp    801053ed <alltraps>

80105963 <vector21>:
.globl vector21
vector21:
  pushl $0
80105963:	6a 00                	push   $0x0
  pushl $21
80105965:	6a 15                	push   $0x15
  jmp alltraps
80105967:	e9 81 fa ff ff       	jmp    801053ed <alltraps>

8010596c <vector22>:
.globl vector22
vector22:
  pushl $0
8010596c:	6a 00                	push   $0x0
  pushl $22
8010596e:	6a 16                	push   $0x16
  jmp alltraps
80105970:	e9 78 fa ff ff       	jmp    801053ed <alltraps>

80105975 <vector23>:
.globl vector23
vector23:
  pushl $0
80105975:	6a 00                	push   $0x0
  pushl $23
80105977:	6a 17                	push   $0x17
  jmp alltraps
80105979:	e9 6f fa ff ff       	jmp    801053ed <alltraps>

8010597e <vector24>:
.globl vector24
vector24:
  pushl $0
8010597e:	6a 00                	push   $0x0
  pushl $24
80105980:	6a 18                	push   $0x18
  jmp alltraps
80105982:	e9 66 fa ff ff       	jmp    801053ed <alltraps>

80105987 <vector25>:
.globl vector25
vector25:
  pushl $0
80105987:	6a 00                	push   $0x0
  pushl $25
80105989:	6a 19                	push   $0x19
  jmp alltraps
8010598b:	e9 5d fa ff ff       	jmp    801053ed <alltraps>

80105990 <vector26>:
.globl vector26
vector26:
  pushl $0
80105990:	6a 00                	push   $0x0
  pushl $26
80105992:	6a 1a                	push   $0x1a
  jmp alltraps
80105994:	e9 54 fa ff ff       	jmp    801053ed <alltraps>

80105999 <vector27>:
.globl vector27
vector27:
  pushl $0
80105999:	6a 00                	push   $0x0
  pushl $27
8010599b:	6a 1b                	push   $0x1b
  jmp alltraps
8010599d:	e9 4b fa ff ff       	jmp    801053ed <alltraps>

801059a2 <vector28>:
.globl vector28
vector28:
  pushl $0
801059a2:	6a 00                	push   $0x0
  pushl $28
801059a4:	6a 1c                	push   $0x1c
  jmp alltraps
801059a6:	e9 42 fa ff ff       	jmp    801053ed <alltraps>

801059ab <vector29>:
.globl vector29
vector29:
  pushl $0
801059ab:	6a 00                	push   $0x0
  pushl $29
801059ad:	6a 1d                	push   $0x1d
  jmp alltraps
801059af:	e9 39 fa ff ff       	jmp    801053ed <alltraps>

801059b4 <vector30>:
.globl vector30
vector30:
  pushl $0
801059b4:	6a 00                	push   $0x0
  pushl $30
801059b6:	6a 1e                	push   $0x1e
  jmp alltraps
801059b8:	e9 30 fa ff ff       	jmp    801053ed <alltraps>

801059bd <vector31>:
.globl vector31
vector31:
  pushl $0
801059bd:	6a 00                	push   $0x0
  pushl $31
801059bf:	6a 1f                	push   $0x1f
  jmp alltraps
801059c1:	e9 27 fa ff ff       	jmp    801053ed <alltraps>

801059c6 <vector32>:
.globl vector32
vector32:
  pushl $0
801059c6:	6a 00                	push   $0x0
  pushl $32
801059c8:	6a 20                	push   $0x20
  jmp alltraps
801059ca:	e9 1e fa ff ff       	jmp    801053ed <alltraps>

801059cf <vector33>:
.globl vector33
vector33:
  pushl $0
801059cf:	6a 00                	push   $0x0
  pushl $33
801059d1:	6a 21                	push   $0x21
  jmp alltraps
801059d3:	e9 15 fa ff ff       	jmp    801053ed <alltraps>

801059d8 <vector34>:
.globl vector34
vector34:
  pushl $0
801059d8:	6a 00                	push   $0x0
  pushl $34
801059da:	6a 22                	push   $0x22
  jmp alltraps
801059dc:	e9 0c fa ff ff       	jmp    801053ed <alltraps>

801059e1 <vector35>:
.globl vector35
vector35:
  pushl $0
801059e1:	6a 00                	push   $0x0
  pushl $35
801059e3:	6a 23                	push   $0x23
  jmp alltraps
801059e5:	e9 03 fa ff ff       	jmp    801053ed <alltraps>

801059ea <vector36>:
.globl vector36
vector36:
  pushl $0
801059ea:	6a 00                	push   $0x0
  pushl $36
801059ec:	6a 24                	push   $0x24
  jmp alltraps
801059ee:	e9 fa f9 ff ff       	jmp    801053ed <alltraps>

801059f3 <vector37>:
.globl vector37
vector37:
  pushl $0
801059f3:	6a 00                	push   $0x0
  pushl $37
801059f5:	6a 25                	push   $0x25
  jmp alltraps
801059f7:	e9 f1 f9 ff ff       	jmp    801053ed <alltraps>

801059fc <vector38>:
.globl vector38
vector38:
  pushl $0
801059fc:	6a 00                	push   $0x0
  pushl $38
801059fe:	6a 26                	push   $0x26
  jmp alltraps
80105a00:	e9 e8 f9 ff ff       	jmp    801053ed <alltraps>

80105a05 <vector39>:
.globl vector39
vector39:
  pushl $0
80105a05:	6a 00                	push   $0x0
  pushl $39
80105a07:	6a 27                	push   $0x27
  jmp alltraps
80105a09:	e9 df f9 ff ff       	jmp    801053ed <alltraps>

80105a0e <vector40>:
.globl vector40
vector40:
  pushl $0
80105a0e:	6a 00                	push   $0x0
  pushl $40
80105a10:	6a 28                	push   $0x28
  jmp alltraps
80105a12:	e9 d6 f9 ff ff       	jmp    801053ed <alltraps>

80105a17 <vector41>:
.globl vector41
vector41:
  pushl $0
80105a17:	6a 00                	push   $0x0
  pushl $41
80105a19:	6a 29                	push   $0x29
  jmp alltraps
80105a1b:	e9 cd f9 ff ff       	jmp    801053ed <alltraps>

80105a20 <vector42>:
.globl vector42
vector42:
  pushl $0
80105a20:	6a 00                	push   $0x0
  pushl $42
80105a22:	6a 2a                	push   $0x2a
  jmp alltraps
80105a24:	e9 c4 f9 ff ff       	jmp    801053ed <alltraps>

80105a29 <vector43>:
.globl vector43
vector43:
  pushl $0
80105a29:	6a 00                	push   $0x0
  pushl $43
80105a2b:	6a 2b                	push   $0x2b
  jmp alltraps
80105a2d:	e9 bb f9 ff ff       	jmp    801053ed <alltraps>

80105a32 <vector44>:
.globl vector44
vector44:
  pushl $0
80105a32:	6a 00                	push   $0x0
  pushl $44
80105a34:	6a 2c                	push   $0x2c
  jmp alltraps
80105a36:	e9 b2 f9 ff ff       	jmp    801053ed <alltraps>

80105a3b <vector45>:
.globl vector45
vector45:
  pushl $0
80105a3b:	6a 00                	push   $0x0
  pushl $45
80105a3d:	6a 2d                	push   $0x2d
  jmp alltraps
80105a3f:	e9 a9 f9 ff ff       	jmp    801053ed <alltraps>

80105a44 <vector46>:
.globl vector46
vector46:
  pushl $0
80105a44:	6a 00                	push   $0x0
  pushl $46
80105a46:	6a 2e                	push   $0x2e
  jmp alltraps
80105a48:	e9 a0 f9 ff ff       	jmp    801053ed <alltraps>

80105a4d <vector47>:
.globl vector47
vector47:
  pushl $0
80105a4d:	6a 00                	push   $0x0
  pushl $47
80105a4f:	6a 2f                	push   $0x2f
  jmp alltraps
80105a51:	e9 97 f9 ff ff       	jmp    801053ed <alltraps>

80105a56 <vector48>:
.globl vector48
vector48:
  pushl $0
80105a56:	6a 00                	push   $0x0
  pushl $48
80105a58:	6a 30                	push   $0x30
  jmp alltraps
80105a5a:	e9 8e f9 ff ff       	jmp    801053ed <alltraps>

80105a5f <vector49>:
.globl vector49
vector49:
  pushl $0
80105a5f:	6a 00                	push   $0x0
  pushl $49
80105a61:	6a 31                	push   $0x31
  jmp alltraps
80105a63:	e9 85 f9 ff ff       	jmp    801053ed <alltraps>

80105a68 <vector50>:
.globl vector50
vector50:
  pushl $0
80105a68:	6a 00                	push   $0x0
  pushl $50
80105a6a:	6a 32                	push   $0x32
  jmp alltraps
80105a6c:	e9 7c f9 ff ff       	jmp    801053ed <alltraps>

80105a71 <vector51>:
.globl vector51
vector51:
  pushl $0
80105a71:	6a 00                	push   $0x0
  pushl $51
80105a73:	6a 33                	push   $0x33
  jmp alltraps
80105a75:	e9 73 f9 ff ff       	jmp    801053ed <alltraps>

80105a7a <vector52>:
.globl vector52
vector52:
  pushl $0
80105a7a:	6a 00                	push   $0x0
  pushl $52
80105a7c:	6a 34                	push   $0x34
  jmp alltraps
80105a7e:	e9 6a f9 ff ff       	jmp    801053ed <alltraps>

80105a83 <vector53>:
.globl vector53
vector53:
  pushl $0
80105a83:	6a 00                	push   $0x0
  pushl $53
80105a85:	6a 35                	push   $0x35
  jmp alltraps
80105a87:	e9 61 f9 ff ff       	jmp    801053ed <alltraps>

80105a8c <vector54>:
.globl vector54
vector54:
  pushl $0
80105a8c:	6a 00                	push   $0x0
  pushl $54
80105a8e:	6a 36                	push   $0x36
  jmp alltraps
80105a90:	e9 58 f9 ff ff       	jmp    801053ed <alltraps>

80105a95 <vector55>:
.globl vector55
vector55:
  pushl $0
80105a95:	6a 00                	push   $0x0
  pushl $55
80105a97:	6a 37                	push   $0x37
  jmp alltraps
80105a99:	e9 4f f9 ff ff       	jmp    801053ed <alltraps>

80105a9e <vector56>:
.globl vector56
vector56:
  pushl $0
80105a9e:	6a 00                	push   $0x0
  pushl $56
80105aa0:	6a 38                	push   $0x38
  jmp alltraps
80105aa2:	e9 46 f9 ff ff       	jmp    801053ed <alltraps>

80105aa7 <vector57>:
.globl vector57
vector57:
  pushl $0
80105aa7:	6a 00                	push   $0x0
  pushl $57
80105aa9:	6a 39                	push   $0x39
  jmp alltraps
80105aab:	e9 3d f9 ff ff       	jmp    801053ed <alltraps>

80105ab0 <vector58>:
.globl vector58
vector58:
  pushl $0
80105ab0:	6a 00                	push   $0x0
  pushl $58
80105ab2:	6a 3a                	push   $0x3a
  jmp alltraps
80105ab4:	e9 34 f9 ff ff       	jmp    801053ed <alltraps>

80105ab9 <vector59>:
.globl vector59
vector59:
  pushl $0
80105ab9:	6a 00                	push   $0x0
  pushl $59
80105abb:	6a 3b                	push   $0x3b
  jmp alltraps
80105abd:	e9 2b f9 ff ff       	jmp    801053ed <alltraps>

80105ac2 <vector60>:
.globl vector60
vector60:
  pushl $0
80105ac2:	6a 00                	push   $0x0
  pushl $60
80105ac4:	6a 3c                	push   $0x3c
  jmp alltraps
80105ac6:	e9 22 f9 ff ff       	jmp    801053ed <alltraps>

80105acb <vector61>:
.globl vector61
vector61:
  pushl $0
80105acb:	6a 00                	push   $0x0
  pushl $61
80105acd:	6a 3d                	push   $0x3d
  jmp alltraps
80105acf:	e9 19 f9 ff ff       	jmp    801053ed <alltraps>

80105ad4 <vector62>:
.globl vector62
vector62:
  pushl $0
80105ad4:	6a 00                	push   $0x0
  pushl $62
80105ad6:	6a 3e                	push   $0x3e
  jmp alltraps
80105ad8:	e9 10 f9 ff ff       	jmp    801053ed <alltraps>

80105add <vector63>:
.globl vector63
vector63:
  pushl $0
80105add:	6a 00                	push   $0x0
  pushl $63
80105adf:	6a 3f                	push   $0x3f
  jmp alltraps
80105ae1:	e9 07 f9 ff ff       	jmp    801053ed <alltraps>

80105ae6 <vector64>:
.globl vector64
vector64:
  pushl $0
80105ae6:	6a 00                	push   $0x0
  pushl $64
80105ae8:	6a 40                	push   $0x40
  jmp alltraps
80105aea:	e9 fe f8 ff ff       	jmp    801053ed <alltraps>

80105aef <vector65>:
.globl vector65
vector65:
  pushl $0
80105aef:	6a 00                	push   $0x0
  pushl $65
80105af1:	6a 41                	push   $0x41
  jmp alltraps
80105af3:	e9 f5 f8 ff ff       	jmp    801053ed <alltraps>

80105af8 <vector66>:
.globl vector66
vector66:
  pushl $0
80105af8:	6a 00                	push   $0x0
  pushl $66
80105afa:	6a 42                	push   $0x42
  jmp alltraps
80105afc:	e9 ec f8 ff ff       	jmp    801053ed <alltraps>

80105b01 <vector67>:
.globl vector67
vector67:
  pushl $0
80105b01:	6a 00                	push   $0x0
  pushl $67
80105b03:	6a 43                	push   $0x43
  jmp alltraps
80105b05:	e9 e3 f8 ff ff       	jmp    801053ed <alltraps>

80105b0a <vector68>:
.globl vector68
vector68:
  pushl $0
80105b0a:	6a 00                	push   $0x0
  pushl $68
80105b0c:	6a 44                	push   $0x44
  jmp alltraps
80105b0e:	e9 da f8 ff ff       	jmp    801053ed <alltraps>

80105b13 <vector69>:
.globl vector69
vector69:
  pushl $0
80105b13:	6a 00                	push   $0x0
  pushl $69
80105b15:	6a 45                	push   $0x45
  jmp alltraps
80105b17:	e9 d1 f8 ff ff       	jmp    801053ed <alltraps>

80105b1c <vector70>:
.globl vector70
vector70:
  pushl $0
80105b1c:	6a 00                	push   $0x0
  pushl $70
80105b1e:	6a 46                	push   $0x46
  jmp alltraps
80105b20:	e9 c8 f8 ff ff       	jmp    801053ed <alltraps>

80105b25 <vector71>:
.globl vector71
vector71:
  pushl $0
80105b25:	6a 00                	push   $0x0
  pushl $71
80105b27:	6a 47                	push   $0x47
  jmp alltraps
80105b29:	e9 bf f8 ff ff       	jmp    801053ed <alltraps>

80105b2e <vector72>:
.globl vector72
vector72:
  pushl $0
80105b2e:	6a 00                	push   $0x0
  pushl $72
80105b30:	6a 48                	push   $0x48
  jmp alltraps
80105b32:	e9 b6 f8 ff ff       	jmp    801053ed <alltraps>

80105b37 <vector73>:
.globl vector73
vector73:
  pushl $0
80105b37:	6a 00                	push   $0x0
  pushl $73
80105b39:	6a 49                	push   $0x49
  jmp alltraps
80105b3b:	e9 ad f8 ff ff       	jmp    801053ed <alltraps>

80105b40 <vector74>:
.globl vector74
vector74:
  pushl $0
80105b40:	6a 00                	push   $0x0
  pushl $74
80105b42:	6a 4a                	push   $0x4a
  jmp alltraps
80105b44:	e9 a4 f8 ff ff       	jmp    801053ed <alltraps>

80105b49 <vector75>:
.globl vector75
vector75:
  pushl $0
80105b49:	6a 00                	push   $0x0
  pushl $75
80105b4b:	6a 4b                	push   $0x4b
  jmp alltraps
80105b4d:	e9 9b f8 ff ff       	jmp    801053ed <alltraps>

80105b52 <vector76>:
.globl vector76
vector76:
  pushl $0
80105b52:	6a 00                	push   $0x0
  pushl $76
80105b54:	6a 4c                	push   $0x4c
  jmp alltraps
80105b56:	e9 92 f8 ff ff       	jmp    801053ed <alltraps>

80105b5b <vector77>:
.globl vector77
vector77:
  pushl $0
80105b5b:	6a 00                	push   $0x0
  pushl $77
80105b5d:	6a 4d                	push   $0x4d
  jmp alltraps
80105b5f:	e9 89 f8 ff ff       	jmp    801053ed <alltraps>

80105b64 <vector78>:
.globl vector78
vector78:
  pushl $0
80105b64:	6a 00                	push   $0x0
  pushl $78
80105b66:	6a 4e                	push   $0x4e
  jmp alltraps
80105b68:	e9 80 f8 ff ff       	jmp    801053ed <alltraps>

80105b6d <vector79>:
.globl vector79
vector79:
  pushl $0
80105b6d:	6a 00                	push   $0x0
  pushl $79
80105b6f:	6a 4f                	push   $0x4f
  jmp alltraps
80105b71:	e9 77 f8 ff ff       	jmp    801053ed <alltraps>

80105b76 <vector80>:
.globl vector80
vector80:
  pushl $0
80105b76:	6a 00                	push   $0x0
  pushl $80
80105b78:	6a 50                	push   $0x50
  jmp alltraps
80105b7a:	e9 6e f8 ff ff       	jmp    801053ed <alltraps>

80105b7f <vector81>:
.globl vector81
vector81:
  pushl $0
80105b7f:	6a 00                	push   $0x0
  pushl $81
80105b81:	6a 51                	push   $0x51
  jmp alltraps
80105b83:	e9 65 f8 ff ff       	jmp    801053ed <alltraps>

80105b88 <vector82>:
.globl vector82
vector82:
  pushl $0
80105b88:	6a 00                	push   $0x0
  pushl $82
80105b8a:	6a 52                	push   $0x52
  jmp alltraps
80105b8c:	e9 5c f8 ff ff       	jmp    801053ed <alltraps>

80105b91 <vector83>:
.globl vector83
vector83:
  pushl $0
80105b91:	6a 00                	push   $0x0
  pushl $83
80105b93:	6a 53                	push   $0x53
  jmp alltraps
80105b95:	e9 53 f8 ff ff       	jmp    801053ed <alltraps>

80105b9a <vector84>:
.globl vector84
vector84:
  pushl $0
80105b9a:	6a 00                	push   $0x0
  pushl $84
80105b9c:	6a 54                	push   $0x54
  jmp alltraps
80105b9e:	e9 4a f8 ff ff       	jmp    801053ed <alltraps>

80105ba3 <vector85>:
.globl vector85
vector85:
  pushl $0
80105ba3:	6a 00                	push   $0x0
  pushl $85
80105ba5:	6a 55                	push   $0x55
  jmp alltraps
80105ba7:	e9 41 f8 ff ff       	jmp    801053ed <alltraps>

80105bac <vector86>:
.globl vector86
vector86:
  pushl $0
80105bac:	6a 00                	push   $0x0
  pushl $86
80105bae:	6a 56                	push   $0x56
  jmp alltraps
80105bb0:	e9 38 f8 ff ff       	jmp    801053ed <alltraps>

80105bb5 <vector87>:
.globl vector87
vector87:
  pushl $0
80105bb5:	6a 00                	push   $0x0
  pushl $87
80105bb7:	6a 57                	push   $0x57
  jmp alltraps
80105bb9:	e9 2f f8 ff ff       	jmp    801053ed <alltraps>

80105bbe <vector88>:
.globl vector88
vector88:
  pushl $0
80105bbe:	6a 00                	push   $0x0
  pushl $88
80105bc0:	6a 58                	push   $0x58
  jmp alltraps
80105bc2:	e9 26 f8 ff ff       	jmp    801053ed <alltraps>

80105bc7 <vector89>:
.globl vector89
vector89:
  pushl $0
80105bc7:	6a 00                	push   $0x0
  pushl $89
80105bc9:	6a 59                	push   $0x59
  jmp alltraps
80105bcb:	e9 1d f8 ff ff       	jmp    801053ed <alltraps>

80105bd0 <vector90>:
.globl vector90
vector90:
  pushl $0
80105bd0:	6a 00                	push   $0x0
  pushl $90
80105bd2:	6a 5a                	push   $0x5a
  jmp alltraps
80105bd4:	e9 14 f8 ff ff       	jmp    801053ed <alltraps>

80105bd9 <vector91>:
.globl vector91
vector91:
  pushl $0
80105bd9:	6a 00                	push   $0x0
  pushl $91
80105bdb:	6a 5b                	push   $0x5b
  jmp alltraps
80105bdd:	e9 0b f8 ff ff       	jmp    801053ed <alltraps>

80105be2 <vector92>:
.globl vector92
vector92:
  pushl $0
80105be2:	6a 00                	push   $0x0
  pushl $92
80105be4:	6a 5c                	push   $0x5c
  jmp alltraps
80105be6:	e9 02 f8 ff ff       	jmp    801053ed <alltraps>

80105beb <vector93>:
.globl vector93
vector93:
  pushl $0
80105beb:	6a 00                	push   $0x0
  pushl $93
80105bed:	6a 5d                	push   $0x5d
  jmp alltraps
80105bef:	e9 f9 f7 ff ff       	jmp    801053ed <alltraps>

80105bf4 <vector94>:
.globl vector94
vector94:
  pushl $0
80105bf4:	6a 00                	push   $0x0
  pushl $94
80105bf6:	6a 5e                	push   $0x5e
  jmp alltraps
80105bf8:	e9 f0 f7 ff ff       	jmp    801053ed <alltraps>

80105bfd <vector95>:
.globl vector95
vector95:
  pushl $0
80105bfd:	6a 00                	push   $0x0
  pushl $95
80105bff:	6a 5f                	push   $0x5f
  jmp alltraps
80105c01:	e9 e7 f7 ff ff       	jmp    801053ed <alltraps>

80105c06 <vector96>:
.globl vector96
vector96:
  pushl $0
80105c06:	6a 00                	push   $0x0
  pushl $96
80105c08:	6a 60                	push   $0x60
  jmp alltraps
80105c0a:	e9 de f7 ff ff       	jmp    801053ed <alltraps>

80105c0f <vector97>:
.globl vector97
vector97:
  pushl $0
80105c0f:	6a 00                	push   $0x0
  pushl $97
80105c11:	6a 61                	push   $0x61
  jmp alltraps
80105c13:	e9 d5 f7 ff ff       	jmp    801053ed <alltraps>

80105c18 <vector98>:
.globl vector98
vector98:
  pushl $0
80105c18:	6a 00                	push   $0x0
  pushl $98
80105c1a:	6a 62                	push   $0x62
  jmp alltraps
80105c1c:	e9 cc f7 ff ff       	jmp    801053ed <alltraps>

80105c21 <vector99>:
.globl vector99
vector99:
  pushl $0
80105c21:	6a 00                	push   $0x0
  pushl $99
80105c23:	6a 63                	push   $0x63
  jmp alltraps
80105c25:	e9 c3 f7 ff ff       	jmp    801053ed <alltraps>

80105c2a <vector100>:
.globl vector100
vector100:
  pushl $0
80105c2a:	6a 00                	push   $0x0
  pushl $100
80105c2c:	6a 64                	push   $0x64
  jmp alltraps
80105c2e:	e9 ba f7 ff ff       	jmp    801053ed <alltraps>

80105c33 <vector101>:
.globl vector101
vector101:
  pushl $0
80105c33:	6a 00                	push   $0x0
  pushl $101
80105c35:	6a 65                	push   $0x65
  jmp alltraps
80105c37:	e9 b1 f7 ff ff       	jmp    801053ed <alltraps>

80105c3c <vector102>:
.globl vector102
vector102:
  pushl $0
80105c3c:	6a 00                	push   $0x0
  pushl $102
80105c3e:	6a 66                	push   $0x66
  jmp alltraps
80105c40:	e9 a8 f7 ff ff       	jmp    801053ed <alltraps>

80105c45 <vector103>:
.globl vector103
vector103:
  pushl $0
80105c45:	6a 00                	push   $0x0
  pushl $103
80105c47:	6a 67                	push   $0x67
  jmp alltraps
80105c49:	e9 9f f7 ff ff       	jmp    801053ed <alltraps>

80105c4e <vector104>:
.globl vector104
vector104:
  pushl $0
80105c4e:	6a 00                	push   $0x0
  pushl $104
80105c50:	6a 68                	push   $0x68
  jmp alltraps
80105c52:	e9 96 f7 ff ff       	jmp    801053ed <alltraps>

80105c57 <vector105>:
.globl vector105
vector105:
  pushl $0
80105c57:	6a 00                	push   $0x0
  pushl $105
80105c59:	6a 69                	push   $0x69
  jmp alltraps
80105c5b:	e9 8d f7 ff ff       	jmp    801053ed <alltraps>

80105c60 <vector106>:
.globl vector106
vector106:
  pushl $0
80105c60:	6a 00                	push   $0x0
  pushl $106
80105c62:	6a 6a                	push   $0x6a
  jmp alltraps
80105c64:	e9 84 f7 ff ff       	jmp    801053ed <alltraps>

80105c69 <vector107>:
.globl vector107
vector107:
  pushl $0
80105c69:	6a 00                	push   $0x0
  pushl $107
80105c6b:	6a 6b                	push   $0x6b
  jmp alltraps
80105c6d:	e9 7b f7 ff ff       	jmp    801053ed <alltraps>

80105c72 <vector108>:
.globl vector108
vector108:
  pushl $0
80105c72:	6a 00                	push   $0x0
  pushl $108
80105c74:	6a 6c                	push   $0x6c
  jmp alltraps
80105c76:	e9 72 f7 ff ff       	jmp    801053ed <alltraps>

80105c7b <vector109>:
.globl vector109
vector109:
  pushl $0
80105c7b:	6a 00                	push   $0x0
  pushl $109
80105c7d:	6a 6d                	push   $0x6d
  jmp alltraps
80105c7f:	e9 69 f7 ff ff       	jmp    801053ed <alltraps>

80105c84 <vector110>:
.globl vector110
vector110:
  pushl $0
80105c84:	6a 00                	push   $0x0
  pushl $110
80105c86:	6a 6e                	push   $0x6e
  jmp alltraps
80105c88:	e9 60 f7 ff ff       	jmp    801053ed <alltraps>

80105c8d <vector111>:
.globl vector111
vector111:
  pushl $0
80105c8d:	6a 00                	push   $0x0
  pushl $111
80105c8f:	6a 6f                	push   $0x6f
  jmp alltraps
80105c91:	e9 57 f7 ff ff       	jmp    801053ed <alltraps>

80105c96 <vector112>:
.globl vector112
vector112:
  pushl $0
80105c96:	6a 00                	push   $0x0
  pushl $112
80105c98:	6a 70                	push   $0x70
  jmp alltraps
80105c9a:	e9 4e f7 ff ff       	jmp    801053ed <alltraps>

80105c9f <vector113>:
.globl vector113
vector113:
  pushl $0
80105c9f:	6a 00                	push   $0x0
  pushl $113
80105ca1:	6a 71                	push   $0x71
  jmp alltraps
80105ca3:	e9 45 f7 ff ff       	jmp    801053ed <alltraps>

80105ca8 <vector114>:
.globl vector114
vector114:
  pushl $0
80105ca8:	6a 00                	push   $0x0
  pushl $114
80105caa:	6a 72                	push   $0x72
  jmp alltraps
80105cac:	e9 3c f7 ff ff       	jmp    801053ed <alltraps>

80105cb1 <vector115>:
.globl vector115
vector115:
  pushl $0
80105cb1:	6a 00                	push   $0x0
  pushl $115
80105cb3:	6a 73                	push   $0x73
  jmp alltraps
80105cb5:	e9 33 f7 ff ff       	jmp    801053ed <alltraps>

80105cba <vector116>:
.globl vector116
vector116:
  pushl $0
80105cba:	6a 00                	push   $0x0
  pushl $116
80105cbc:	6a 74                	push   $0x74
  jmp alltraps
80105cbe:	e9 2a f7 ff ff       	jmp    801053ed <alltraps>

80105cc3 <vector117>:
.globl vector117
vector117:
  pushl $0
80105cc3:	6a 00                	push   $0x0
  pushl $117
80105cc5:	6a 75                	push   $0x75
  jmp alltraps
80105cc7:	e9 21 f7 ff ff       	jmp    801053ed <alltraps>

80105ccc <vector118>:
.globl vector118
vector118:
  pushl $0
80105ccc:	6a 00                	push   $0x0
  pushl $118
80105cce:	6a 76                	push   $0x76
  jmp alltraps
80105cd0:	e9 18 f7 ff ff       	jmp    801053ed <alltraps>

80105cd5 <vector119>:
.globl vector119
vector119:
  pushl $0
80105cd5:	6a 00                	push   $0x0
  pushl $119
80105cd7:	6a 77                	push   $0x77
  jmp alltraps
80105cd9:	e9 0f f7 ff ff       	jmp    801053ed <alltraps>

80105cde <vector120>:
.globl vector120
vector120:
  pushl $0
80105cde:	6a 00                	push   $0x0
  pushl $120
80105ce0:	6a 78                	push   $0x78
  jmp alltraps
80105ce2:	e9 06 f7 ff ff       	jmp    801053ed <alltraps>

80105ce7 <vector121>:
.globl vector121
vector121:
  pushl $0
80105ce7:	6a 00                	push   $0x0
  pushl $121
80105ce9:	6a 79                	push   $0x79
  jmp alltraps
80105ceb:	e9 fd f6 ff ff       	jmp    801053ed <alltraps>

80105cf0 <vector122>:
.globl vector122
vector122:
  pushl $0
80105cf0:	6a 00                	push   $0x0
  pushl $122
80105cf2:	6a 7a                	push   $0x7a
  jmp alltraps
80105cf4:	e9 f4 f6 ff ff       	jmp    801053ed <alltraps>

80105cf9 <vector123>:
.globl vector123
vector123:
  pushl $0
80105cf9:	6a 00                	push   $0x0
  pushl $123
80105cfb:	6a 7b                	push   $0x7b
  jmp alltraps
80105cfd:	e9 eb f6 ff ff       	jmp    801053ed <alltraps>

80105d02 <vector124>:
.globl vector124
vector124:
  pushl $0
80105d02:	6a 00                	push   $0x0
  pushl $124
80105d04:	6a 7c                	push   $0x7c
  jmp alltraps
80105d06:	e9 e2 f6 ff ff       	jmp    801053ed <alltraps>

80105d0b <vector125>:
.globl vector125
vector125:
  pushl $0
80105d0b:	6a 00                	push   $0x0
  pushl $125
80105d0d:	6a 7d                	push   $0x7d
  jmp alltraps
80105d0f:	e9 d9 f6 ff ff       	jmp    801053ed <alltraps>

80105d14 <vector126>:
.globl vector126
vector126:
  pushl $0
80105d14:	6a 00                	push   $0x0
  pushl $126
80105d16:	6a 7e                	push   $0x7e
  jmp alltraps
80105d18:	e9 d0 f6 ff ff       	jmp    801053ed <alltraps>

80105d1d <vector127>:
.globl vector127
vector127:
  pushl $0
80105d1d:	6a 00                	push   $0x0
  pushl $127
80105d1f:	6a 7f                	push   $0x7f
  jmp alltraps
80105d21:	e9 c7 f6 ff ff       	jmp    801053ed <alltraps>

80105d26 <vector128>:
.globl vector128
vector128:
  pushl $0
80105d26:	6a 00                	push   $0x0
  pushl $128
80105d28:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105d2d:	e9 bb f6 ff ff       	jmp    801053ed <alltraps>

80105d32 <vector129>:
.globl vector129
vector129:
  pushl $0
80105d32:	6a 00                	push   $0x0
  pushl $129
80105d34:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105d39:	e9 af f6 ff ff       	jmp    801053ed <alltraps>

80105d3e <vector130>:
.globl vector130
vector130:
  pushl $0
80105d3e:	6a 00                	push   $0x0
  pushl $130
80105d40:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105d45:	e9 a3 f6 ff ff       	jmp    801053ed <alltraps>

80105d4a <vector131>:
.globl vector131
vector131:
  pushl $0
80105d4a:	6a 00                	push   $0x0
  pushl $131
80105d4c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105d51:	e9 97 f6 ff ff       	jmp    801053ed <alltraps>

80105d56 <vector132>:
.globl vector132
vector132:
  pushl $0
80105d56:	6a 00                	push   $0x0
  pushl $132
80105d58:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105d5d:	e9 8b f6 ff ff       	jmp    801053ed <alltraps>

80105d62 <vector133>:
.globl vector133
vector133:
  pushl $0
80105d62:	6a 00                	push   $0x0
  pushl $133
80105d64:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105d69:	e9 7f f6 ff ff       	jmp    801053ed <alltraps>

80105d6e <vector134>:
.globl vector134
vector134:
  pushl $0
80105d6e:	6a 00                	push   $0x0
  pushl $134
80105d70:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105d75:	e9 73 f6 ff ff       	jmp    801053ed <alltraps>

80105d7a <vector135>:
.globl vector135
vector135:
  pushl $0
80105d7a:	6a 00                	push   $0x0
  pushl $135
80105d7c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105d81:	e9 67 f6 ff ff       	jmp    801053ed <alltraps>

80105d86 <vector136>:
.globl vector136
vector136:
  pushl $0
80105d86:	6a 00                	push   $0x0
  pushl $136
80105d88:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105d8d:	e9 5b f6 ff ff       	jmp    801053ed <alltraps>

80105d92 <vector137>:
.globl vector137
vector137:
  pushl $0
80105d92:	6a 00                	push   $0x0
  pushl $137
80105d94:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105d99:	e9 4f f6 ff ff       	jmp    801053ed <alltraps>

80105d9e <vector138>:
.globl vector138
vector138:
  pushl $0
80105d9e:	6a 00                	push   $0x0
  pushl $138
80105da0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105da5:	e9 43 f6 ff ff       	jmp    801053ed <alltraps>

80105daa <vector139>:
.globl vector139
vector139:
  pushl $0
80105daa:	6a 00                	push   $0x0
  pushl $139
80105dac:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105db1:	e9 37 f6 ff ff       	jmp    801053ed <alltraps>

80105db6 <vector140>:
.globl vector140
vector140:
  pushl $0
80105db6:	6a 00                	push   $0x0
  pushl $140
80105db8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105dbd:	e9 2b f6 ff ff       	jmp    801053ed <alltraps>

80105dc2 <vector141>:
.globl vector141
vector141:
  pushl $0
80105dc2:	6a 00                	push   $0x0
  pushl $141
80105dc4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105dc9:	e9 1f f6 ff ff       	jmp    801053ed <alltraps>

80105dce <vector142>:
.globl vector142
vector142:
  pushl $0
80105dce:	6a 00                	push   $0x0
  pushl $142
80105dd0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105dd5:	e9 13 f6 ff ff       	jmp    801053ed <alltraps>

80105dda <vector143>:
.globl vector143
vector143:
  pushl $0
80105dda:	6a 00                	push   $0x0
  pushl $143
80105ddc:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105de1:	e9 07 f6 ff ff       	jmp    801053ed <alltraps>

80105de6 <vector144>:
.globl vector144
vector144:
  pushl $0
80105de6:	6a 00                	push   $0x0
  pushl $144
80105de8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105ded:	e9 fb f5 ff ff       	jmp    801053ed <alltraps>

80105df2 <vector145>:
.globl vector145
vector145:
  pushl $0
80105df2:	6a 00                	push   $0x0
  pushl $145
80105df4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105df9:	e9 ef f5 ff ff       	jmp    801053ed <alltraps>

80105dfe <vector146>:
.globl vector146
vector146:
  pushl $0
80105dfe:	6a 00                	push   $0x0
  pushl $146
80105e00:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105e05:	e9 e3 f5 ff ff       	jmp    801053ed <alltraps>

80105e0a <vector147>:
.globl vector147
vector147:
  pushl $0
80105e0a:	6a 00                	push   $0x0
  pushl $147
80105e0c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105e11:	e9 d7 f5 ff ff       	jmp    801053ed <alltraps>

80105e16 <vector148>:
.globl vector148
vector148:
  pushl $0
80105e16:	6a 00                	push   $0x0
  pushl $148
80105e18:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105e1d:	e9 cb f5 ff ff       	jmp    801053ed <alltraps>

80105e22 <vector149>:
.globl vector149
vector149:
  pushl $0
80105e22:	6a 00                	push   $0x0
  pushl $149
80105e24:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105e29:	e9 bf f5 ff ff       	jmp    801053ed <alltraps>

80105e2e <vector150>:
.globl vector150
vector150:
  pushl $0
80105e2e:	6a 00                	push   $0x0
  pushl $150
80105e30:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105e35:	e9 b3 f5 ff ff       	jmp    801053ed <alltraps>

80105e3a <vector151>:
.globl vector151
vector151:
  pushl $0
80105e3a:	6a 00                	push   $0x0
  pushl $151
80105e3c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105e41:	e9 a7 f5 ff ff       	jmp    801053ed <alltraps>

80105e46 <vector152>:
.globl vector152
vector152:
  pushl $0
80105e46:	6a 00                	push   $0x0
  pushl $152
80105e48:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105e4d:	e9 9b f5 ff ff       	jmp    801053ed <alltraps>

80105e52 <vector153>:
.globl vector153
vector153:
  pushl $0
80105e52:	6a 00                	push   $0x0
  pushl $153
80105e54:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105e59:	e9 8f f5 ff ff       	jmp    801053ed <alltraps>

80105e5e <vector154>:
.globl vector154
vector154:
  pushl $0
80105e5e:	6a 00                	push   $0x0
  pushl $154
80105e60:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105e65:	e9 83 f5 ff ff       	jmp    801053ed <alltraps>

80105e6a <vector155>:
.globl vector155
vector155:
  pushl $0
80105e6a:	6a 00                	push   $0x0
  pushl $155
80105e6c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105e71:	e9 77 f5 ff ff       	jmp    801053ed <alltraps>

80105e76 <vector156>:
.globl vector156
vector156:
  pushl $0
80105e76:	6a 00                	push   $0x0
  pushl $156
80105e78:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105e7d:	e9 6b f5 ff ff       	jmp    801053ed <alltraps>

80105e82 <vector157>:
.globl vector157
vector157:
  pushl $0
80105e82:	6a 00                	push   $0x0
  pushl $157
80105e84:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105e89:	e9 5f f5 ff ff       	jmp    801053ed <alltraps>

80105e8e <vector158>:
.globl vector158
vector158:
  pushl $0
80105e8e:	6a 00                	push   $0x0
  pushl $158
80105e90:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105e95:	e9 53 f5 ff ff       	jmp    801053ed <alltraps>

80105e9a <vector159>:
.globl vector159
vector159:
  pushl $0
80105e9a:	6a 00                	push   $0x0
  pushl $159
80105e9c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105ea1:	e9 47 f5 ff ff       	jmp    801053ed <alltraps>

80105ea6 <vector160>:
.globl vector160
vector160:
  pushl $0
80105ea6:	6a 00                	push   $0x0
  pushl $160
80105ea8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105ead:	e9 3b f5 ff ff       	jmp    801053ed <alltraps>

80105eb2 <vector161>:
.globl vector161
vector161:
  pushl $0
80105eb2:	6a 00                	push   $0x0
  pushl $161
80105eb4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105eb9:	e9 2f f5 ff ff       	jmp    801053ed <alltraps>

80105ebe <vector162>:
.globl vector162
vector162:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $162
80105ec0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105ec5:	e9 23 f5 ff ff       	jmp    801053ed <alltraps>

80105eca <vector163>:
.globl vector163
vector163:
  pushl $0
80105eca:	6a 00                	push   $0x0
  pushl $163
80105ecc:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105ed1:	e9 17 f5 ff ff       	jmp    801053ed <alltraps>

80105ed6 <vector164>:
.globl vector164
vector164:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $164
80105ed8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105edd:	e9 0b f5 ff ff       	jmp    801053ed <alltraps>

80105ee2 <vector165>:
.globl vector165
vector165:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $165
80105ee4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105ee9:	e9 ff f4 ff ff       	jmp    801053ed <alltraps>

80105eee <vector166>:
.globl vector166
vector166:
  pushl $0
80105eee:	6a 00                	push   $0x0
  pushl $166
80105ef0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105ef5:	e9 f3 f4 ff ff       	jmp    801053ed <alltraps>

80105efa <vector167>:
.globl vector167
vector167:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $167
80105efc:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105f01:	e9 e7 f4 ff ff       	jmp    801053ed <alltraps>

80105f06 <vector168>:
.globl vector168
vector168:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $168
80105f08:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105f0d:	e9 db f4 ff ff       	jmp    801053ed <alltraps>

80105f12 <vector169>:
.globl vector169
vector169:
  pushl $0
80105f12:	6a 00                	push   $0x0
  pushl $169
80105f14:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105f19:	e9 cf f4 ff ff       	jmp    801053ed <alltraps>

80105f1e <vector170>:
.globl vector170
vector170:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $170
80105f20:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105f25:	e9 c3 f4 ff ff       	jmp    801053ed <alltraps>

80105f2a <vector171>:
.globl vector171
vector171:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $171
80105f2c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105f31:	e9 b7 f4 ff ff       	jmp    801053ed <alltraps>

80105f36 <vector172>:
.globl vector172
vector172:
  pushl $0
80105f36:	6a 00                	push   $0x0
  pushl $172
80105f38:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105f3d:	e9 ab f4 ff ff       	jmp    801053ed <alltraps>

80105f42 <vector173>:
.globl vector173
vector173:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $173
80105f44:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105f49:	e9 9f f4 ff ff       	jmp    801053ed <alltraps>

80105f4e <vector174>:
.globl vector174
vector174:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $174
80105f50:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105f55:	e9 93 f4 ff ff       	jmp    801053ed <alltraps>

80105f5a <vector175>:
.globl vector175
vector175:
  pushl $0
80105f5a:	6a 00                	push   $0x0
  pushl $175
80105f5c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105f61:	e9 87 f4 ff ff       	jmp    801053ed <alltraps>

80105f66 <vector176>:
.globl vector176
vector176:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $176
80105f68:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105f6d:	e9 7b f4 ff ff       	jmp    801053ed <alltraps>

80105f72 <vector177>:
.globl vector177
vector177:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $177
80105f74:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105f79:	e9 6f f4 ff ff       	jmp    801053ed <alltraps>

80105f7e <vector178>:
.globl vector178
vector178:
  pushl $0
80105f7e:	6a 00                	push   $0x0
  pushl $178
80105f80:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105f85:	e9 63 f4 ff ff       	jmp    801053ed <alltraps>

80105f8a <vector179>:
.globl vector179
vector179:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $179
80105f8c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105f91:	e9 57 f4 ff ff       	jmp    801053ed <alltraps>

80105f96 <vector180>:
.globl vector180
vector180:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $180
80105f98:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105f9d:	e9 4b f4 ff ff       	jmp    801053ed <alltraps>

80105fa2 <vector181>:
.globl vector181
vector181:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $181
80105fa4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105fa9:	e9 3f f4 ff ff       	jmp    801053ed <alltraps>

80105fae <vector182>:
.globl vector182
vector182:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $182
80105fb0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105fb5:	e9 33 f4 ff ff       	jmp    801053ed <alltraps>

80105fba <vector183>:
.globl vector183
vector183:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $183
80105fbc:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105fc1:	e9 27 f4 ff ff       	jmp    801053ed <alltraps>

80105fc6 <vector184>:
.globl vector184
vector184:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $184
80105fc8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105fcd:	e9 1b f4 ff ff       	jmp    801053ed <alltraps>

80105fd2 <vector185>:
.globl vector185
vector185:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $185
80105fd4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105fd9:	e9 0f f4 ff ff       	jmp    801053ed <alltraps>

80105fde <vector186>:
.globl vector186
vector186:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $186
80105fe0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105fe5:	e9 03 f4 ff ff       	jmp    801053ed <alltraps>

80105fea <vector187>:
.globl vector187
vector187:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $187
80105fec:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105ff1:	e9 f7 f3 ff ff       	jmp    801053ed <alltraps>

80105ff6 <vector188>:
.globl vector188
vector188:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $188
80105ff8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105ffd:	e9 eb f3 ff ff       	jmp    801053ed <alltraps>

80106002 <vector189>:
.globl vector189
vector189:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $189
80106004:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106009:	e9 df f3 ff ff       	jmp    801053ed <alltraps>

8010600e <vector190>:
.globl vector190
vector190:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $190
80106010:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106015:	e9 d3 f3 ff ff       	jmp    801053ed <alltraps>

8010601a <vector191>:
.globl vector191
vector191:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $191
8010601c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106021:	e9 c7 f3 ff ff       	jmp    801053ed <alltraps>

80106026 <vector192>:
.globl vector192
vector192:
  pushl $0
80106026:	6a 00                	push   $0x0
  pushl $192
80106028:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010602d:	e9 bb f3 ff ff       	jmp    801053ed <alltraps>

80106032 <vector193>:
.globl vector193
vector193:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $193
80106034:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106039:	e9 af f3 ff ff       	jmp    801053ed <alltraps>

8010603e <vector194>:
.globl vector194
vector194:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $194
80106040:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106045:	e9 a3 f3 ff ff       	jmp    801053ed <alltraps>

8010604a <vector195>:
.globl vector195
vector195:
  pushl $0
8010604a:	6a 00                	push   $0x0
  pushl $195
8010604c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106051:	e9 97 f3 ff ff       	jmp    801053ed <alltraps>

80106056 <vector196>:
.globl vector196
vector196:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $196
80106058:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010605d:	e9 8b f3 ff ff       	jmp    801053ed <alltraps>

80106062 <vector197>:
.globl vector197
vector197:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $197
80106064:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106069:	e9 7f f3 ff ff       	jmp    801053ed <alltraps>

8010606e <vector198>:
.globl vector198
vector198:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $198
80106070:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106075:	e9 73 f3 ff ff       	jmp    801053ed <alltraps>

8010607a <vector199>:
.globl vector199
vector199:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $199
8010607c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106081:	e9 67 f3 ff ff       	jmp    801053ed <alltraps>

80106086 <vector200>:
.globl vector200
vector200:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $200
80106088:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010608d:	e9 5b f3 ff ff       	jmp    801053ed <alltraps>

80106092 <vector201>:
.globl vector201
vector201:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $201
80106094:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106099:	e9 4f f3 ff ff       	jmp    801053ed <alltraps>

8010609e <vector202>:
.globl vector202
vector202:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $202
801060a0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801060a5:	e9 43 f3 ff ff       	jmp    801053ed <alltraps>

801060aa <vector203>:
.globl vector203
vector203:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $203
801060ac:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801060b1:	e9 37 f3 ff ff       	jmp    801053ed <alltraps>

801060b6 <vector204>:
.globl vector204
vector204:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $204
801060b8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801060bd:	e9 2b f3 ff ff       	jmp    801053ed <alltraps>

801060c2 <vector205>:
.globl vector205
vector205:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $205
801060c4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801060c9:	e9 1f f3 ff ff       	jmp    801053ed <alltraps>

801060ce <vector206>:
.globl vector206
vector206:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $206
801060d0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801060d5:	e9 13 f3 ff ff       	jmp    801053ed <alltraps>

801060da <vector207>:
.globl vector207
vector207:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $207
801060dc:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801060e1:	e9 07 f3 ff ff       	jmp    801053ed <alltraps>

801060e6 <vector208>:
.globl vector208
vector208:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $208
801060e8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801060ed:	e9 fb f2 ff ff       	jmp    801053ed <alltraps>

801060f2 <vector209>:
.globl vector209
vector209:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $209
801060f4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801060f9:	e9 ef f2 ff ff       	jmp    801053ed <alltraps>

801060fe <vector210>:
.globl vector210
vector210:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $210
80106100:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106105:	e9 e3 f2 ff ff       	jmp    801053ed <alltraps>

8010610a <vector211>:
.globl vector211
vector211:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $211
8010610c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106111:	e9 d7 f2 ff ff       	jmp    801053ed <alltraps>

80106116 <vector212>:
.globl vector212
vector212:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $212
80106118:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010611d:	e9 cb f2 ff ff       	jmp    801053ed <alltraps>

80106122 <vector213>:
.globl vector213
vector213:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $213
80106124:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106129:	e9 bf f2 ff ff       	jmp    801053ed <alltraps>

8010612e <vector214>:
.globl vector214
vector214:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $214
80106130:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106135:	e9 b3 f2 ff ff       	jmp    801053ed <alltraps>

8010613a <vector215>:
.globl vector215
vector215:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $215
8010613c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106141:	e9 a7 f2 ff ff       	jmp    801053ed <alltraps>

80106146 <vector216>:
.globl vector216
vector216:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $216
80106148:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010614d:	e9 9b f2 ff ff       	jmp    801053ed <alltraps>

80106152 <vector217>:
.globl vector217
vector217:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $217
80106154:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106159:	e9 8f f2 ff ff       	jmp    801053ed <alltraps>

8010615e <vector218>:
.globl vector218
vector218:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $218
80106160:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106165:	e9 83 f2 ff ff       	jmp    801053ed <alltraps>

8010616a <vector219>:
.globl vector219
vector219:
  pushl $0
8010616a:	6a 00                	push   $0x0
  pushl $219
8010616c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106171:	e9 77 f2 ff ff       	jmp    801053ed <alltraps>

80106176 <vector220>:
.globl vector220
vector220:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $220
80106178:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010617d:	e9 6b f2 ff ff       	jmp    801053ed <alltraps>

80106182 <vector221>:
.globl vector221
vector221:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $221
80106184:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106189:	e9 5f f2 ff ff       	jmp    801053ed <alltraps>

8010618e <vector222>:
.globl vector222
vector222:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $222
80106190:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106195:	e9 53 f2 ff ff       	jmp    801053ed <alltraps>

8010619a <vector223>:
.globl vector223
vector223:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $223
8010619c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801061a1:	e9 47 f2 ff ff       	jmp    801053ed <alltraps>

801061a6 <vector224>:
.globl vector224
vector224:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $224
801061a8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801061ad:	e9 3b f2 ff ff       	jmp    801053ed <alltraps>

801061b2 <vector225>:
.globl vector225
vector225:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $225
801061b4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801061b9:	e9 2f f2 ff ff       	jmp    801053ed <alltraps>

801061be <vector226>:
.globl vector226
vector226:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $226
801061c0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801061c5:	e9 23 f2 ff ff       	jmp    801053ed <alltraps>

801061ca <vector227>:
.globl vector227
vector227:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $227
801061cc:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801061d1:	e9 17 f2 ff ff       	jmp    801053ed <alltraps>

801061d6 <vector228>:
.globl vector228
vector228:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $228
801061d8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801061dd:	e9 0b f2 ff ff       	jmp    801053ed <alltraps>

801061e2 <vector229>:
.globl vector229
vector229:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $229
801061e4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801061e9:	e9 ff f1 ff ff       	jmp    801053ed <alltraps>

801061ee <vector230>:
.globl vector230
vector230:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $230
801061f0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801061f5:	e9 f3 f1 ff ff       	jmp    801053ed <alltraps>

801061fa <vector231>:
.globl vector231
vector231:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $231
801061fc:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106201:	e9 e7 f1 ff ff       	jmp    801053ed <alltraps>

80106206 <vector232>:
.globl vector232
vector232:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $232
80106208:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010620d:	e9 db f1 ff ff       	jmp    801053ed <alltraps>

80106212 <vector233>:
.globl vector233
vector233:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $233
80106214:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106219:	e9 cf f1 ff ff       	jmp    801053ed <alltraps>

8010621e <vector234>:
.globl vector234
vector234:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $234
80106220:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106225:	e9 c3 f1 ff ff       	jmp    801053ed <alltraps>

8010622a <vector235>:
.globl vector235
vector235:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $235
8010622c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106231:	e9 b7 f1 ff ff       	jmp    801053ed <alltraps>

80106236 <vector236>:
.globl vector236
vector236:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $236
80106238:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010623d:	e9 ab f1 ff ff       	jmp    801053ed <alltraps>

80106242 <vector237>:
.globl vector237
vector237:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $237
80106244:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106249:	e9 9f f1 ff ff       	jmp    801053ed <alltraps>

8010624e <vector238>:
.globl vector238
vector238:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $238
80106250:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106255:	e9 93 f1 ff ff       	jmp    801053ed <alltraps>

8010625a <vector239>:
.globl vector239
vector239:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $239
8010625c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106261:	e9 87 f1 ff ff       	jmp    801053ed <alltraps>

80106266 <vector240>:
.globl vector240
vector240:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $240
80106268:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010626d:	e9 7b f1 ff ff       	jmp    801053ed <alltraps>

80106272 <vector241>:
.globl vector241
vector241:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $241
80106274:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106279:	e9 6f f1 ff ff       	jmp    801053ed <alltraps>

8010627e <vector242>:
.globl vector242
vector242:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $242
80106280:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106285:	e9 63 f1 ff ff       	jmp    801053ed <alltraps>

8010628a <vector243>:
.globl vector243
vector243:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $243
8010628c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106291:	e9 57 f1 ff ff       	jmp    801053ed <alltraps>

80106296 <vector244>:
.globl vector244
vector244:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $244
80106298:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010629d:	e9 4b f1 ff ff       	jmp    801053ed <alltraps>

801062a2 <vector245>:
.globl vector245
vector245:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $245
801062a4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801062a9:	e9 3f f1 ff ff       	jmp    801053ed <alltraps>

801062ae <vector246>:
.globl vector246
vector246:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $246
801062b0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801062b5:	e9 33 f1 ff ff       	jmp    801053ed <alltraps>

801062ba <vector247>:
.globl vector247
vector247:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $247
801062bc:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801062c1:	e9 27 f1 ff ff       	jmp    801053ed <alltraps>

801062c6 <vector248>:
.globl vector248
vector248:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $248
801062c8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801062cd:	e9 1b f1 ff ff       	jmp    801053ed <alltraps>

801062d2 <vector249>:
.globl vector249
vector249:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $249
801062d4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801062d9:	e9 0f f1 ff ff       	jmp    801053ed <alltraps>

801062de <vector250>:
.globl vector250
vector250:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $250
801062e0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801062e5:	e9 03 f1 ff ff       	jmp    801053ed <alltraps>

801062ea <vector251>:
.globl vector251
vector251:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $251
801062ec:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801062f1:	e9 f7 f0 ff ff       	jmp    801053ed <alltraps>

801062f6 <vector252>:
.globl vector252
vector252:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $252
801062f8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801062fd:	e9 eb f0 ff ff       	jmp    801053ed <alltraps>

80106302 <vector253>:
.globl vector253
vector253:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $253
80106304:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106309:	e9 df f0 ff ff       	jmp    801053ed <alltraps>

8010630e <vector254>:
.globl vector254
vector254:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $254
80106310:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106315:	e9 d3 f0 ff ff       	jmp    801053ed <alltraps>

8010631a <vector255>:
.globl vector255
vector255:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $255
8010631c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106321:	e9 c7 f0 ff ff       	jmp    801053ed <alltraps>
80106326:	66 90                	xchg   %ax,%ax
80106328:	66 90                	xchg   %ax,%ax
8010632a:	66 90                	xchg   %ax,%ax
8010632c:	66 90                	xchg   %ax,%ax
8010632e:	66 90                	xchg   %ax,%ax

80106330 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106330:	55                   	push   %ebp
80106331:	89 e5                	mov    %esp,%ebp
80106333:	57                   	push   %edi
80106334:	56                   	push   %esi
80106335:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106337:	c1 ea 16             	shr    $0x16,%edx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010633a:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010633b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010633e:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106341:	8b 1f                	mov    (%edi),%ebx
80106343:	f6 c3 01             	test   $0x1,%bl
80106346:	74 28                	je     80106370 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106348:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010634e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106354:	c1 ee 0a             	shr    $0xa,%esi
}
80106357:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010635a:	89 f2                	mov    %esi,%edx
8010635c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106362:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106365:	5b                   	pop    %ebx
80106366:	5e                   	pop    %esi
80106367:	5f                   	pop    %edi
80106368:	5d                   	pop    %ebp
80106369:	c3                   	ret    
8010636a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106370:	85 c9                	test   %ecx,%ecx
80106372:	74 34                	je     801063a8 <walkpgdir+0x78>
80106374:	e8 17 c1 ff ff       	call   80102490 <kalloc>
80106379:	85 c0                	test   %eax,%eax
8010637b:	89 c3                	mov    %eax,%ebx
8010637d:	74 29                	je     801063a8 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010637f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106386:	00 
80106387:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010638e:	00 
8010638f:	89 04 24             	mov    %eax,(%esp)
80106392:	e8 d9 de ff ff       	call   80104270 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106397:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010639d:	83 c8 07             	or     $0x7,%eax
801063a0:	89 07                	mov    %eax,(%edi)
801063a2:	eb b0                	jmp    80106354 <walkpgdir+0x24>
801063a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  return &pgtab[PTX(va)];
}
801063a8:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
801063ab:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801063ad:	5b                   	pop    %ebx
801063ae:	5e                   	pop    %esi
801063af:	5f                   	pop    %edi
801063b0:	5d                   	pop    %ebp
801063b1:	c3                   	ret    
801063b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
801063c3:	57                   	push   %edi
801063c4:	89 c7                	mov    %eax,%edi
801063c6:	56                   	push   %esi
801063c7:	89 d6                	mov    %edx,%esi
801063c9:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801063ca:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801063d0:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801063d3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801063d9:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801063db:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801063de:	72 3b                	jb     8010641b <deallocuvm.part.0+0x5b>
801063e0:	eb 5e                	jmp    80106440 <deallocuvm.part.0+0x80>
801063e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801063e8:	8b 10                	mov    (%eax),%edx
801063ea:	f6 c2 01             	test   $0x1,%dl
801063ed:	74 22                	je     80106411 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801063ef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801063f5:	74 54                	je     8010644b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
801063f7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801063fd:	89 14 24             	mov    %edx,(%esp)
80106400:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106403:	e8 d8 be ff ff       	call   801022e0 <kfree>
      *pte = 0;
80106408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010640b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106411:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106417:	39 f3                	cmp    %esi,%ebx
80106419:	73 25                	jae    80106440 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010641b:	31 c9                	xor    %ecx,%ecx
8010641d:	89 da                	mov    %ebx,%edx
8010641f:	89 f8                	mov    %edi,%eax
80106421:	e8 0a ff ff ff       	call   80106330 <walkpgdir>
    if(!pte)
80106426:	85 c0                	test   %eax,%eax
80106428:	75 be                	jne    801063e8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010642a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106430:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106436:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010643c:	39 f3                	cmp    %esi,%ebx
8010643e:	72 db                	jb     8010641b <deallocuvm.part.0+0x5b>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106440:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106443:	83 c4 1c             	add    $0x1c,%esp
80106446:	5b                   	pop    %ebx
80106447:	5e                   	pop    %esi
80106448:	5f                   	pop    %edi
80106449:	5d                   	pop    %ebp
8010644a:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010644b:	c7 04 24 06 70 10 80 	movl   $0x80107006,(%esp)
80106452:	e8 09 9f ff ff       	call   80100360 <panic>
80106457:	89 f6                	mov    %esi,%esi
80106459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106460 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106460:	55                   	push   %ebp
80106461:	89 e5                	mov    %esp,%ebp
80106463:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106466:	e8 05 d2 ff ff       	call   80103670 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010646b:	31 c9                	xor    %ecx,%ecx
8010646d:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106472:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106478:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010647d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106481:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
80106486:	83 c0 70             	add    $0x70,%eax
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106489:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010648d:	31 c9                	xor    %ecx,%ecx
8010648f:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106493:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106498:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010649c:	31 c9                	xor    %ecx,%ecx
8010649e:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064a2:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064a7:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064ab:	31 c9                	xor    %ecx,%ecx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064ad:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
801064b1:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064b5:	c6 40 15 92          	movb   $0x92,0x15(%eax)
801064b9:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064bd:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
801064c1:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064c5:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
801064c9:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
801064cd:	66 89 50 20          	mov    %dx,0x20(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801064d1:	ba 2f 00 00 00       	mov    $0x2f,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064d6:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
801064da:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064de:	c6 40 14 00          	movb   $0x0,0x14(%eax)
801064e2:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064e6:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
801064ea:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064ee:	66 89 48 22          	mov    %cx,0x22(%eax)
801064f2:	c6 40 24 00          	movb   $0x0,0x24(%eax)
801064f6:	c6 40 27 00          	movb   $0x0,0x27(%eax)
801064fa:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801064fe:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106502:	c1 e8 10             	shr    $0x10,%eax
80106505:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106509:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010650c:	0f 01 10             	lgdtl  (%eax)
  lgdt(c->gdt, sizeof(c->gdt));
}
8010650f:	c9                   	leave  
80106510:	c3                   	ret    
80106511:	eb 0d                	jmp    80106520 <mappages>
80106513:	90                   	nop
80106514:	90                   	nop
80106515:	90                   	nop
80106516:	90                   	nop
80106517:	90                   	nop
80106518:	90                   	nop
80106519:	90                   	nop
8010651a:	90                   	nop
8010651b:	90                   	nop
8010651c:	90                   	nop
8010651d:	90                   	nop
8010651e:	90                   	nop
8010651f:	90                   	nop

80106520 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106520:	55                   	push   %ebp
80106521:	89 e5                	mov    %esp,%ebp
80106523:	57                   	push   %edi
80106524:	56                   	push   %esi
80106525:	53                   	push   %ebx
80106526:	83 ec 1c             	sub    $0x1c,%esp
80106529:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010652c:	8b 55 10             	mov    0x10(%ebp),%edx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010652f:	8b 7d 14             	mov    0x14(%ebp),%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106532:	83 4d 18 01          	orl    $0x1,0x18(%ebp)
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106536:	89 c3                	mov    %eax,%ebx
80106538:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010653e:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
80106542:	29 df                	sub    %ebx,%edi
80106544:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106547:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
8010654e:	eb 15                	jmp    80106565 <mappages+0x45>
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106550:	f6 00 01             	testb  $0x1,(%eax)
80106553:	75 3d                	jne    80106592 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106555:	0b 75 18             	or     0x18(%ebp),%esi
    if(a == last)
80106558:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010655b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010655d:	74 29                	je     80106588 <mappages+0x68>
      break;
    a += PGSIZE;
8010655f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106565:	8b 45 08             	mov    0x8(%ebp),%eax
80106568:	b9 01 00 00 00       	mov    $0x1,%ecx
8010656d:	89 da                	mov    %ebx,%edx
8010656f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106572:	e8 b9 fd ff ff       	call   80106330 <walkpgdir>
80106577:	85 c0                	test   %eax,%eax
80106579:	75 d5                	jne    80106550 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010657b:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010657e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106583:	5b                   	pop    %ebx
80106584:	5e                   	pop    %esi
80106585:	5f                   	pop    %edi
80106586:	5d                   	pop    %ebp
80106587:	c3                   	ret    
80106588:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010658b:	31 c0                	xor    %eax,%eax
}
8010658d:	5b                   	pop    %ebx
8010658e:	5e                   	pop    %esi
8010658f:	5f                   	pop    %edi
80106590:	5d                   	pop    %ebp
80106591:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106592:	c7 04 24 d8 76 10 80 	movl   $0x801076d8,(%esp)
80106599:	e8 c2 9d ff ff       	call   80100360 <panic>
8010659e:	66 90                	xchg   %ax,%ax

801065a0 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801065a0:	a1 a4 55 11 80       	mov    0x801155a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801065a5:	55                   	push   %ebp
801065a6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801065a8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801065ad:	0f 22 d8             	mov    %eax,%cr3
}
801065b0:	5d                   	pop    %ebp
801065b1:	c3                   	ret    
801065b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065c0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801065c0:	55                   	push   %ebp
801065c1:	89 e5                	mov    %esp,%ebp
801065c3:	57                   	push   %edi
801065c4:	56                   	push   %esi
801065c5:	53                   	push   %ebx
801065c6:	83 ec 1c             	sub    $0x1c,%esp
801065c9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801065cc:	85 f6                	test   %esi,%esi
801065ce:	0f 84 cd 00 00 00    	je     801066a1 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801065d4:	8b 46 0c             	mov    0xc(%esi),%eax
801065d7:	85 c0                	test   %eax,%eax
801065d9:	0f 84 da 00 00 00    	je     801066b9 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801065df:	8b 7e 08             	mov    0x8(%esi),%edi
801065e2:	85 ff                	test   %edi,%edi
801065e4:	0f 84 c3 00 00 00    	je     801066ad <switchuvm+0xed>
    panic("switchuvm: no pgdir");

  pushcli();
801065ea:	e8 01 db ff ff       	call   801040f0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801065ef:	e8 fc cf ff ff       	call   801035f0 <mycpu>
801065f4:	89 c3                	mov    %eax,%ebx
801065f6:	e8 f5 cf ff ff       	call   801035f0 <mycpu>
801065fb:	89 c7                	mov    %eax,%edi
801065fd:	e8 ee cf ff ff       	call   801035f0 <mycpu>
80106602:	83 c7 08             	add    $0x8,%edi
80106605:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106608:	e8 e3 cf ff ff       	call   801035f0 <mycpu>
8010660d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106610:	ba 67 00 00 00       	mov    $0x67,%edx
80106615:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
8010661c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106623:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010662a:	83 c1 08             	add    $0x8,%ecx
8010662d:	c1 e9 10             	shr    $0x10,%ecx
80106630:	83 c0 08             	add    $0x8,%eax
80106633:	c1 e8 18             	shr    $0x18,%eax
80106636:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010663c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106643:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106649:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010664e:	e8 9d cf ff ff       	call   801035f0 <mycpu>
80106653:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010665a:	e8 91 cf ff ff       	call   801035f0 <mycpu>
8010665f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106664:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106668:	e8 83 cf ff ff       	call   801035f0 <mycpu>
8010666d:	8b 56 0c             	mov    0xc(%esi),%edx
80106670:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106676:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106679:	e8 72 cf ff ff       	call   801035f0 <mycpu>
8010667e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106682:	b8 28 00 00 00       	mov    $0x28,%eax
80106687:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010668a:	8b 46 08             	mov    0x8(%esi),%eax
8010668d:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106692:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80106695:	83 c4 1c             	add    $0x1c,%esp
80106698:	5b                   	pop    %ebx
80106699:	5e                   	pop    %esi
8010669a:	5f                   	pop    %edi
8010669b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010669c:	e9 0f db ff ff       	jmp    801041b0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
801066a1:	c7 04 24 de 76 10 80 	movl   $0x801076de,(%esp)
801066a8:	e8 b3 9c ff ff       	call   80100360 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
801066ad:	c7 04 24 09 77 10 80 	movl   $0x80107709,(%esp)
801066b4:	e8 a7 9c ff ff       	call   80100360 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
801066b9:	c7 04 24 f4 76 10 80 	movl   $0x801076f4,(%esp)
801066c0:	e8 9b 9c ff ff       	call   80100360 <panic>
801066c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801066c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066d0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801066d0:	55                   	push   %ebp
801066d1:	89 e5                	mov    %esp,%ebp
801066d3:	57                   	push   %edi
801066d4:	56                   	push   %esi
801066d5:	53                   	push   %ebx
801066d6:	83 ec 2c             	sub    $0x2c,%esp
801066d9:	8b 75 10             	mov    0x10(%ebp),%esi
801066dc:	8b 55 08             	mov    0x8(%ebp),%edx
801066df:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801066e2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801066e8:	77 64                	ja     8010674e <inituvm+0x7e>
801066ea:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    panic("inituvm: more than a page");
  mem = kalloc();
801066ed:	e8 9e bd ff ff       	call   80102490 <kalloc>
  memset(mem, 0, PGSIZE);
801066f2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801066f9:	00 
801066fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106701:	00 
80106702:	89 04 24             	mov    %eax,(%esp)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106705:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106707:	e8 64 db ff ff       	call   80104270 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010670c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010670f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106715:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010671c:	00 
8010671d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106721:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106728:	00 
80106729:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106730:	00 
80106731:	89 14 24             	mov    %edx,(%esp)
80106734:	e8 e7 fd ff ff       	call   80106520 <mappages>
  memmove(mem, init, sz);
80106739:	89 75 10             	mov    %esi,0x10(%ebp)
8010673c:	89 7d 0c             	mov    %edi,0xc(%ebp)
8010673f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106742:	83 c4 2c             	add    $0x2c,%esp
80106745:	5b                   	pop    %ebx
80106746:	5e                   	pop    %esi
80106747:	5f                   	pop    %edi
80106748:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106749:	e9 c2 db ff ff       	jmp    80104310 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
8010674e:	c7 04 24 1d 77 10 80 	movl   $0x8010771d,(%esp)
80106755:	e8 06 9c ff ff       	call   80100360 <panic>
8010675a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106760 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106760:	55                   	push   %ebp
80106761:	89 e5                	mov    %esp,%ebp
80106763:	57                   	push   %edi
80106764:	56                   	push   %esi
80106765:	53                   	push   %ebx
80106766:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106769:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106770:	0f 85 98 00 00 00    	jne    8010680e <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106776:	8b 75 18             	mov    0x18(%ebp),%esi
80106779:	31 db                	xor    %ebx,%ebx
8010677b:	85 f6                	test   %esi,%esi
8010677d:	75 1a                	jne    80106799 <loaduvm+0x39>
8010677f:	eb 77                	jmp    801067f8 <loaduvm+0x98>
80106781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106788:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010678e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106794:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106797:	76 5f                	jbe    801067f8 <loaduvm+0x98>
80106799:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010679c:	31 c9                	xor    %ecx,%ecx
8010679e:	8b 45 08             	mov    0x8(%ebp),%eax
801067a1:	01 da                	add    %ebx,%edx
801067a3:	e8 88 fb ff ff       	call   80106330 <walkpgdir>
801067a8:	85 c0                	test   %eax,%eax
801067aa:	74 56                	je     80106802 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801067ac:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
801067ae:	bf 00 10 00 00       	mov    $0x1000,%edi
801067b3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801067b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
801067bb:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
801067c1:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801067c4:	05 00 00 00 80       	add    $0x80000000,%eax
801067c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801067cd:	8b 45 10             	mov    0x10(%ebp),%eax
801067d0:	01 d9                	add    %ebx,%ecx
801067d2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801067d6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801067da:	89 04 24             	mov    %eax,(%esp)
801067dd:	e8 6e b1 ff ff       	call   80101950 <readi>
801067e2:	39 f8                	cmp    %edi,%eax
801067e4:	74 a2                	je     80106788 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801067e6:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
801067e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
801067ee:	5b                   	pop    %ebx
801067ef:	5e                   	pop    %esi
801067f0:	5f                   	pop    %edi
801067f1:	5d                   	pop    %ebp
801067f2:	c3                   	ret    
801067f3:	90                   	nop
801067f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801067f8:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801067fb:	31 c0                	xor    %eax,%eax
}
801067fd:	5b                   	pop    %ebx
801067fe:	5e                   	pop    %esi
801067ff:	5f                   	pop    %edi
80106800:	5d                   	pop    %ebp
80106801:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106802:	c7 04 24 37 77 10 80 	movl   $0x80107737,(%esp)
80106809:	e8 52 9b ff ff       	call   80100360 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
8010680e:	c7 04 24 d8 77 10 80 	movl   $0x801077d8,(%esp)
80106815:	e8 46 9b ff ff       	call   80100360 <panic>
8010681a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106820 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106820:	55                   	push   %ebp
80106821:	89 e5                	mov    %esp,%ebp
80106823:	57                   	push   %edi
80106824:	56                   	push   %esi
80106825:	53                   	push   %ebx
80106826:	83 ec 2c             	sub    $0x2c,%esp
80106829:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010682c:	85 ff                	test   %edi,%edi
8010682e:	0f 88 8f 00 00 00    	js     801068c3 <allocuvm+0xa3>
    return 0;
  if(newsz < oldsz)
80106834:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106837:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
8010683a:	0f 82 85 00 00 00    	jb     801068c5 <allocuvm+0xa5>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106840:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106846:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010684c:	39 df                	cmp    %ebx,%edi
8010684e:	77 57                	ja     801068a7 <allocuvm+0x87>
80106850:	eb 7e                	jmp    801068d0 <allocuvm+0xb0>
80106852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106858:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010685f:	00 
80106860:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106867:	00 
80106868:	89 04 24             	mov    %eax,(%esp)
8010686b:	e8 00 da ff ff       	call   80104270 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106870:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106876:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010687a:	8b 45 08             	mov    0x8(%ebp),%eax
8010687d:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80106884:	00 
80106885:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010688c:	00 
8010688d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106891:	89 04 24             	mov    %eax,(%esp)
80106894:	e8 87 fc ff ff       	call   80106520 <mappages>
80106899:	85 c0                	test   %eax,%eax
8010689b:	78 43                	js     801068e0 <allocuvm+0xc0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010689d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068a3:	39 df                	cmp    %ebx,%edi
801068a5:	76 29                	jbe    801068d0 <allocuvm+0xb0>
    mem = kalloc();
801068a7:	e8 e4 bb ff ff       	call   80102490 <kalloc>
    if(mem == 0){
801068ac:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
801068ae:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801068b0:	75 a6                	jne    80106858 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
801068b2:	c7 04 24 55 77 10 80 	movl   $0x80107755,(%esp)
801068b9:	e8 92 9d ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801068be:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801068c1:	77 47                	ja     8010690a <allocuvm+0xea>
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
801068c3:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
801068c5:	83 c4 2c             	add    $0x2c,%esp
801068c8:	5b                   	pop    %ebx
801068c9:	5e                   	pop    %esi
801068ca:	5f                   	pop    %edi
801068cb:	5d                   	pop    %ebp
801068cc:	c3                   	ret    
801068cd:	8d 76 00             	lea    0x0(%esi),%esi
801068d0:	83 c4 2c             	add    $0x2c,%esp
801068d3:	89 f8                	mov    %edi,%eax
801068d5:	5b                   	pop    %ebx
801068d6:	5e                   	pop    %esi
801068d7:	5f                   	pop    %edi
801068d8:	5d                   	pop    %ebp
801068d9:	c3                   	ret    
801068da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
801068e0:	c7 04 24 6d 77 10 80 	movl   $0x8010776d,(%esp)
801068e7:	e8 64 9d ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801068ec:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801068ef:	76 0d                	jbe    801068fe <allocuvm+0xde>
801068f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801068f4:	89 fa                	mov    %edi,%edx
801068f6:	8b 45 08             	mov    0x8(%ebp),%eax
801068f9:	e8 c2 fa ff ff       	call   801063c0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
801068fe:	89 34 24             	mov    %esi,(%esp)
80106901:	e8 da b9 ff ff       	call   801022e0 <kfree>
      return 0;
80106906:	31 c0                	xor    %eax,%eax
80106908:	eb bb                	jmp    801068c5 <allocuvm+0xa5>
8010690a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010690d:	89 fa                	mov    %edi,%edx
8010690f:	8b 45 08             	mov    0x8(%ebp),%eax
80106912:	e8 a9 fa ff ff       	call   801063c0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106917:	31 c0                	xor    %eax,%eax
80106919:	eb aa                	jmp    801068c5 <allocuvm+0xa5>
8010691b:	90                   	nop
8010691c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106920 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106920:	55                   	push   %ebp
80106921:	89 e5                	mov    %esp,%ebp
80106923:	8b 55 0c             	mov    0xc(%ebp),%edx
80106926:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106929:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010692c:	39 d1                	cmp    %edx,%ecx
8010692e:	73 08                	jae    80106938 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106930:	5d                   	pop    %ebp
80106931:	e9 8a fa ff ff       	jmp    801063c0 <deallocuvm.part.0>
80106936:	66 90                	xchg   %ax,%ax
80106938:	89 d0                	mov    %edx,%eax
8010693a:	5d                   	pop    %ebp
8010693b:	c3                   	ret    
8010693c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106940 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	56                   	push   %esi
80106944:	53                   	push   %ebx
80106945:	83 ec 10             	sub    $0x10,%esp
80106948:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010694b:	85 f6                	test   %esi,%esi
8010694d:	74 59                	je     801069a8 <freevm+0x68>
8010694f:	31 c9                	xor    %ecx,%ecx
80106951:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106956:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106958:	31 db                	xor    %ebx,%ebx
8010695a:	e8 61 fa ff ff       	call   801063c0 <deallocuvm.part.0>
8010695f:	eb 12                	jmp    80106973 <freevm+0x33>
80106961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106968:	83 c3 01             	add    $0x1,%ebx
8010696b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106971:	74 27                	je     8010699a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106973:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106976:	f6 c2 01             	test   $0x1,%dl
80106979:	74 ed                	je     80106968 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010697b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106981:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106984:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010698a:	89 14 24             	mov    %edx,(%esp)
8010698d:	e8 4e b9 ff ff       	call   801022e0 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106992:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106998:	75 d9                	jne    80106973 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010699a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010699d:	83 c4 10             	add    $0x10,%esp
801069a0:	5b                   	pop    %ebx
801069a1:	5e                   	pop    %esi
801069a2:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801069a3:	e9 38 b9 ff ff       	jmp    801022e0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
801069a8:	c7 04 24 89 77 10 80 	movl   $0x80107789,(%esp)
801069af:	e8 ac 99 ff ff       	call   80100360 <panic>
801069b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801069ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801069c0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	56                   	push   %esi
801069c4:	53                   	push   %ebx
801069c5:	83 ec 20             	sub    $0x20,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801069c8:	e8 c3 ba ff ff       	call   80102490 <kalloc>
801069cd:	85 c0                	test   %eax,%eax
801069cf:	89 c6                	mov    %eax,%esi
801069d1:	74 75                	je     80106a48 <setupkvm+0x88>
    return 0;
  memset(pgdir, 0, PGSIZE);
801069d3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801069da:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801069db:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
801069e0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069e7:	00 
801069e8:	89 04 24             	mov    %eax,(%esp)
801069eb:	e8 80 d8 ff ff       	call   80104270 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801069f0:	8b 53 0c             	mov    0xc(%ebx),%edx
801069f3:	8b 43 04             	mov    0x4(%ebx),%eax
801069f6:	89 34 24             	mov    %esi,(%esp)
801069f9:	89 54 24 10          	mov    %edx,0x10(%esp)
801069fd:	8b 53 08             	mov    0x8(%ebx),%edx
80106a00:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106a04:	29 c2                	sub    %eax,%edx
80106a06:	8b 03                	mov    (%ebx),%eax
80106a08:	89 54 24 08          	mov    %edx,0x8(%esp)
80106a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a10:	e8 0b fb ff ff       	call   80106520 <mappages>
80106a15:	85 c0                	test   %eax,%eax
80106a17:	78 17                	js     80106a30 <setupkvm+0x70>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a19:	83 c3 10             	add    $0x10,%ebx
80106a1c:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106a22:	72 cc                	jb     801069f0 <setupkvm+0x30>
80106a24:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106a26:	83 c4 20             	add    $0x20,%esp
80106a29:	5b                   	pop    %ebx
80106a2a:	5e                   	pop    %esi
80106a2b:	5d                   	pop    %ebp
80106a2c:	c3                   	ret    
80106a2d:	8d 76 00             	lea    0x0(%esi),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106a30:	89 34 24             	mov    %esi,(%esp)
80106a33:	e8 08 ff ff ff       	call   80106940 <freevm>
      return 0;
    }
  return pgdir;
}
80106a38:	83 c4 20             	add    $0x20,%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106a3b:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106a3d:	5b                   	pop    %ebx
80106a3e:	5e                   	pop    %esi
80106a3f:	5d                   	pop    %ebp
80106a40:	c3                   	ret    
80106a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106a48:	31 c0                	xor    %eax,%eax
80106a4a:	eb da                	jmp    80106a26 <setupkvm+0x66>
80106a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a50 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106a56:	e8 65 ff ff ff       	call   801069c0 <setupkvm>
80106a5b:	a3 a4 55 11 80       	mov    %eax,0x801155a4
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a60:	05 00 00 00 80       	add    $0x80000000,%eax
80106a65:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
80106a68:	c9                   	leave  
80106a69:	c3                   	ret    
80106a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a70 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106a70:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106a71:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106a73:	89 e5                	mov    %esp,%ebp
80106a75:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106a78:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a7b:	8b 45 08             	mov    0x8(%ebp),%eax
80106a7e:	e8 ad f8 ff ff       	call   80106330 <walkpgdir>
  if(pte == 0)
80106a83:	85 c0                	test   %eax,%eax
80106a85:	74 05                	je     80106a8c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106a87:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106a8a:	c9                   	leave  
80106a8b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106a8c:	c7 04 24 9a 77 10 80 	movl   $0x8010779a,(%esp)
80106a93:	e8 c8 98 ff ff       	call   80100360 <panic>
80106a98:	90                   	nop
80106a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106aa0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz, uint sb)
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	57                   	push   %edi
80106aa4:	56                   	push   %esi
80106aa5:	53                   	push   %ebx
80106aa6:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106aa9:	e8 12 ff ff ff       	call   801069c0 <setupkvm>
80106aae:	85 c0                	test   %eax,%eax
80106ab0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ab3:	0f 84 6d 01 00 00    	je     80106c26 <copyuvm+0x186>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106abc:	85 c0                	test   %eax,%eax
80106abe:	0f 84 ac 00 00 00    	je     80106b70 <copyuvm+0xd0>
80106ac4:	31 db                	xor    %ebx,%ebx
80106ac6:	eb 51                	jmp    80106b19 <copyuvm+0x79>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106ac8:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106ace:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106ad5:	00 
80106ad6:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106ada:	89 04 24             	mov    %eax,(%esp)
80106add:	e8 2e d8 ff ff       	call   80104310 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106ae2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ae5:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106aeb:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106aef:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106af6:	00 
80106af7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106afb:	89 44 24 10          	mov    %eax,0x10(%esp)
80106aff:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b02:	89 04 24             	mov    %eax,(%esp)
80106b05:	e8 16 fa ff ff       	call   80106520 <mappages>
80106b0a:	85 c0                	test   %eax,%eax
80106b0c:	78 4d                	js     80106b5b <copyuvm+0xbb>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106b0e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b14:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106b17:	76 57                	jbe    80106b70 <copyuvm+0xd0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106b19:	8b 45 08             	mov    0x8(%ebp),%eax
80106b1c:	31 c9                	xor    %ecx,%ecx
80106b1e:	89 da                	mov    %ebx,%edx
80106b20:	e8 0b f8 ff ff       	call   80106330 <walkpgdir>
80106b25:	85 c0                	test   %eax,%eax
80106b27:	0f 84 0c 01 00 00    	je     80106c39 <copyuvm+0x199>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106b2d:	8b 30                	mov    (%eax),%esi
80106b2f:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106b35:	0f 84 f2 00 00 00    	je     80106c2d <copyuvm+0x18d>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106b3b:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106b3d:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106b43:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106b46:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106b4c:	e8 3f b9 ff ff       	call   80102490 <kalloc>
80106b51:	85 c0                	test   %eax,%eax
80106b53:	89 c6                	mov    %eax,%esi
80106b55:	0f 85 6d ff ff ff    	jne    80106ac8 <copyuvm+0x28>
      goto bad;
  } 
  return d;

bad:
  freevm(d);
80106b5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b5e:	89 04 24             	mov    %eax,(%esp)
80106b61:	e8 da fd ff ff       	call   80106940 <freevm>
  return 0;
80106b66:	31 c0                	xor    %eax,%eax
}
80106b68:	83 c4 2c             	add    $0x2c,%esp
80106b6b:	5b                   	pop    %ebx
80106b6c:	5e                   	pop    %esi
80106b6d:	5f                   	pop    %edi
80106b6e:	5d                   	pop    %ebp
80106b6f:	c3                   	ret    
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
  for(i = sb; i < (KERNBASE - 4); i += PGSIZE){
80106b70:	81 7d 10 fb ff ff 7f 	cmpl   $0x7ffffffb,0x10(%ebp)
80106b77:	0f 87 9e 00 00 00    	ja     80106c1b <copyuvm+0x17b>
80106b7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
80106b80:	eb 5a                	jmp    80106bdc <copyuvm+0x13c>
80106b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106b88:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106b8e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b95:	00 
80106b96:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106b9a:	89 04 24             	mov    %eax,(%esp)
80106b9d:	e8 6e d7 ff ff       	call   80104310 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106ba2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ba5:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106bab:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106baf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106bb6:	00 
80106bb7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106bbb:	89 44 24 10          	mov    %eax,0x10(%esp)
80106bbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106bc2:	89 04 24             	mov    %eax,(%esp)
80106bc5:	e8 56 f9 ff ff       	call   80106520 <mappages>
80106bca:	85 c0                	test   %eax,%eax
80106bcc:	78 8d                	js     80106b5b <copyuvm+0xbb>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
  for(i = sb; i < (KERNBASE - 4); i += PGSIZE){
80106bce:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bd4:	81 fb fb ff ff 7f    	cmp    $0x7ffffffb,%ebx
80106bda:	77 3f                	ja     80106c1b <copyuvm+0x17b>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106bdc:	8b 45 08             	mov    0x8(%ebp),%eax
80106bdf:	31 c9                	xor    %ecx,%ecx
80106be1:	89 da                	mov    %ebx,%edx
80106be3:	e8 48 f7 ff ff       	call   80106330 <walkpgdir>
80106be8:	85 c0                	test   %eax,%eax
80106bea:	74 4d                	je     80106c39 <copyuvm+0x199>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106bec:	8b 30                	mov    (%eax),%esi
80106bee:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106bf4:	74 37                	je     80106c2d <copyuvm+0x18d>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106bf6:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106bf8:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106bfe:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = sb; i < (KERNBASE - 4); i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106c01:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106c07:	e8 84 b8 ff ff       	call   80102490 <kalloc>
80106c0c:	85 c0                	test   %eax,%eax
80106c0e:	89 c6                	mov    %eax,%esi
80106c10:	0f 85 72 ff ff ff    	jne    80106b88 <copyuvm+0xe8>
80106c16:	e9 40 ff ff ff       	jmp    80106b5b <copyuvm+0xbb>
80106c1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80106c1e:	83 c4 2c             	add    $0x2c,%esp
80106c21:	5b                   	pop    %ebx
80106c22:	5e                   	pop    %esi
80106c23:	5f                   	pop    %edi
80106c24:	5d                   	pop    %ebp
80106c25:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106c26:	31 c0                	xor    %eax,%eax
80106c28:	e9 3b ff ff ff       	jmp    80106b68 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106c2d:	c7 04 24 be 77 10 80 	movl   $0x801077be,(%esp)
80106c34:	e8 27 97 ff ff       	call   80100360 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106c39:	c7 04 24 a4 77 10 80 	movl   $0x801077a4,(%esp)
80106c40:	e8 1b 97 ff ff       	call   80100360 <panic>
80106c45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c50 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106c50:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c51:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106c53:	89 e5                	mov    %esp,%ebp
80106c55:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c58:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c5b:	8b 45 08             	mov    0x8(%ebp),%eax
80106c5e:	e8 cd f6 ff ff       	call   80106330 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106c63:	8b 00                	mov    (%eax),%eax
80106c65:	89 c2                	mov    %eax,%edx
80106c67:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106c6a:	83 fa 05             	cmp    $0x5,%edx
80106c6d:	75 11                	jne    80106c80 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106c6f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c74:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106c79:	c9                   	leave  
80106c7a:	c3                   	ret    
80106c7b:	90                   	nop
80106c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106c80:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106c82:	c9                   	leave  
80106c83:	c3                   	ret    
80106c84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c90 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	57                   	push   %edi
80106c94:	56                   	push   %esi
80106c95:	53                   	push   %ebx
80106c96:	83 ec 1c             	sub    $0x1c,%esp
80106c99:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106c9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c9f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106ca2:	85 db                	test   %ebx,%ebx
80106ca4:	75 3a                	jne    80106ce0 <copyout+0x50>
80106ca6:	eb 68                	jmp    80106d10 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106ca8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106cab:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106cad:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106cb1:	29 ca                	sub    %ecx,%edx
80106cb3:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106cb9:	39 da                	cmp    %ebx,%edx
80106cbb:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106cbe:	29 f1                	sub    %esi,%ecx
80106cc0:	01 c8                	add    %ecx,%eax
80106cc2:	89 54 24 08          	mov    %edx,0x8(%esp)
80106cc6:	89 04 24             	mov    %eax,(%esp)
80106cc9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106ccc:	e8 3f d6 ff ff       	call   80104310 <memmove>
    len -= n;
    buf += n;
80106cd1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106cd4:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106cda:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106cdc:	29 d3                	sub    %edx,%ebx
80106cde:	74 30                	je     80106d10 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
80106ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106ce3:	89 ce                	mov    %ecx,%esi
80106ce5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106ceb:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106cef:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106cf2:	89 04 24             	mov    %eax,(%esp)
80106cf5:	e8 56 ff ff ff       	call   80106c50 <uva2ka>
    if(pa0 == 0)
80106cfa:	85 c0                	test   %eax,%eax
80106cfc:	75 aa                	jne    80106ca8 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106cfe:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106d01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106d06:	5b                   	pop    %ebx
80106d07:	5e                   	pop    %esi
80106d08:	5f                   	pop    %edi
80106d09:	5d                   	pop    %ebp
80106d0a:	c3                   	ret    
80106d0b:	90                   	nop
80106d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d10:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106d13:	31 c0                	xor    %eax,%eax
}
80106d15:	5b                   	pop    %ebx
80106d16:	5e                   	pop    %esi
80106d17:	5f                   	pop    %edi
80106d18:	5d                   	pop    %ebp
80106d19:	c3                   	ret    
80106d1a:	66 90                	xchg   %ax,%ax
80106d1c:	66 90                	xchg   %ax,%ax
80106d1e:	66 90                	xchg   %ax,%ax

80106d20 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	83 ec 18             	sub    $0x18,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
80106d26:	c7 44 24 04 fc 77 10 	movl   $0x801077fc,0x4(%esp)
80106d2d:	80 
80106d2e:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
80106d35:	e8 06 d3 ff ff       	call   80104040 <initlock>
  acquire(&(shm_table.lock));
80106d3a:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
80106d41:	e8 ea d3 ff ff       	call   80104130 <acquire>
80106d46:	b8 f4 55 11 80       	mov    $0x801155f4,%eax
80106d4b:	90                   	nop
80106d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
80106d50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106d56:	83 c0 0c             	add    $0xc,%eax
    shm_table.shm_pages[i].frame =0;
80106d59:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    shm_table.shm_pages[i].refcnt =0;
80106d60:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)

void shminit() {
  int i;
  initlock(&(shm_table.lock), "SHM lock");
  acquire(&(shm_table.lock));
  for (i = 0; i< 64; i++) {
80106d67:	3d f4 58 11 80       	cmp    $0x801158f4,%eax
80106d6c:	75 e2                	jne    80106d50 <shminit+0x30>
    shm_table.shm_pages[i].id =0;
    shm_table.shm_pages[i].frame =0;
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
80106d6e:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
80106d75:	e8 a6 d4 ff ff       	call   80104220 <release>
}
80106d7a:	c9                   	leave  
80106d7b:	c3                   	ret    
80106d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d80 <shm_open>:

int shm_open(int id, char **pointer) {
80106d80:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106d81:	31 c0                	xor    %eax,%eax
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
}

int shm_open(int id, char **pointer) {
80106d83:	89 e5                	mov    %esp,%ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106d85:	5d                   	pop    %ebp
80106d86:	c3                   	ret    
80106d87:	89 f6                	mov    %esi,%esi
80106d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d90 <shm_close>:


int shm_close(int id) {
80106d90:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106d91:	31 c0                	xor    %eax,%eax

return 0; //added to remove compiler warning -- you should decide what to return
}


int shm_close(int id) {
80106d93:	89 e5                	mov    %esp,%ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106d95:	5d                   	pop    %ebp
80106d96:	c3                   	ret    
