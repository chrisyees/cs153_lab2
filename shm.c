#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct shm_page {
    uint id;
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
  int i;
  initlock(&(shm_table.lock), "SHM lock");
  acquire(&(shm_table.lock));
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
    shm_table.shm_pages[i].frame =0;
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
}

int shm_open(int id, char **pointer) {

//you write this
	
	int i;
	int x;
	acquire(&(shm_table.lock));
	for(i = 0; i < 64; i++)
	{
		if(shm_table.shm_pages[i].id == id)
		{
			//panic("not first to enter");
			shm_table.shm_pages[i].refcnt++;
			x = mappages(myproc()->pgdir, (char*)PGROUNDUP(myproc()->sz), PGSIZE, V2P(shm_table.shm_pages[i].frame), PTE_W|PTE_U);
			*pointer = (char*)PGROUNDUP(myproc()->sz);
			myproc()->sz++;
			release(&(shm_table.lock));
			return x;	
		}
	}

	//didn't find shared memory segment. first to allocate
	for(i = 0; i < 64; i++)
	{
		if(shm_table.shm_pages[i].refcnt == 0) //find empty entry
		{
		//	panic("first to enter");
			shm_table.shm_pages[i].id = id;
			shm_table.shm_pages[i].frame = kalloc();
			shm_table.shm_pages[i].refcnt = 1;
			x = mappages(myproc()->pgdir, (char*)PGROUNDUP(myproc()->sz), PGSIZE, V2P(shm_table.shm_pages[i].frame), PTE_W|PTE_U);
			*pointer = (char*)PGROUNDUP(myproc()->sz);
			myproc()->sz++;
			release(&(shm_table.lock));
			return x;
		}
	}		

release(&(shm_table.lock));
panic("Help shm failed");
return 1; //error
}


int shm_close(int id) {
//you write this too!
	int i;
	acquire(&(shm_table.lock));
	for(i = 0; i < 64; i++)
	{
		if(shm_table.shm_pages[i].id == id)
		{
			shm_table.shm_pages[i].refcnt--;
			if(shm_table.shm_pages[i].refcnt == 0)
			{
				release(&(shm_table.lock));
				shminit();	
			}
			return 0;
		}
	}


release(&(shm_table.lock));
return 1 ; //added to remove compiler warning -- you should decide what to return
}
