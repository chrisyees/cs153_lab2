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
	acquire(&(shm_table.lock));
	for(int i = 0; i < 64; i++)
	{
		if(shm_table.shm_pages[i].id == id)
		{
			mappages(myproc()->pgdir, PGROUNDUP(myproc()->sz), PGSIZE, V2P(shm_table.shm_pages[i].frame), PTE_W|PTE_U);
			shm_table.shm_pages[i].refcnt++;
			*pointer = (char *)PGROUNDUP(myproc()->sz);
			myproc()->sz++;
			release(&(shm_table.lock));
			return 0; //0 means it found id we're opening already exists
		}
	}
	release(&(shm_table.lock));

	//didn't find shared memory segment. first to allocate
	acquire(&(shm_table.lock));
	for(int i = 0; i < 64; i++)
	{
		if(shm_table.shm_pages[i].refcnt == 0)
		{
			shm_table.shm_pages[i].id = id;
			shm_pages[i].frame = kalloc();
			shm_table.shm_pages[i].refcnt = 1;
			mappages(myproc()->pgdir, PGROUNDUP(myproc()->sz), PGSIZE, V2P(shm_table.shm_pages[i].frame), PTE_W|PTE_U);
			*pointer = (char *)PGROUNDUP(myproc()->sz);
			myproc()->sz++;	
		}
	}
	release(&(shm_table.lock));

	return 1; //I made 1 mean it didnt find shared memory segment so it's first to allocate
}


int shm_close(int id) {
//you write this too!




return 0; //added to remove compiler warning -- you should decide what to return
}
