
#include "axi_dma_api.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int axi_dma_channel_open(struct axi_dma_chan *chan, const char *path)
{
  int rc;
  memset(chan, 0, sizeof(struct axi_dma_chan));
  rc = open(path, O_RDWR);
  if(rc < 0)
  {
    fprintf(stderr, "Unable to open dma channel %s\n", path);
    return rc;
  }
  chan->fd = rc;
  return 0;
}

void axi_dma_channel_close(struct axi_dma_chan *chan)
{
  close(chan->fd);
}

int axi_dma_channel_init( struct axi_dma_chan *chan
                         , size_t num_bd
                         , size_t bd_per_sg
                         , int flags)
{
  int rc;
  size_t page_size = sysconf(_SC_PAGE_SIZE);
  chan->access_size = bd_per_sg * page_size;
  struct axi_dma_buf_info info = { .num_bd    = num_bd
                                 , .bd_per_sg = bd_per_sg
                                 , .buf_size  = page_size
                                 , .flag      = flags };
  rc = ioctl(chan->fd, AXI_DMA_INIT, &info);
  if(rc < 0)
  {
    fprintf(stderr, "Unable to initialize dma channel\n");
    return rc;
  }
  return 0;
}

int axi_dma_channel_start(struct axi_dma_chan *chan)
{
  int rc;
  rc = ioctl(chan->fd, AXI_DMA_START, 0);
  if(rc < 0)
  {
    fprintf(stderr, "Unable to start dma transactions\n");
    return rc;
  }
  return 0;
}

int axi_dma_channel_stop(struct axi_dma_chan *chan)
{
  int rc;
  rc = ioctl(chan->fd, AXI_DMA_STOP, 0);
  if(rc < 0)
  {
    fprintf(stderr, "Unable to stop dma transactions\n");
    return rc;
  }
  return 0;
}

int axi_dma_channel_wait(struct axi_dma_chan *chan)
{
  int rc;
  rc = ioctl(chan->fd, AXI_DMA_WAIT, 0);
  if(rc < 0)
  {
    fprintf(stderr, "Unable to wait for dma interrupt\n");
    return rc;
  }
  return 0;
}

int axi_dma_channel_swap(struct axi_dma_chan *chan)
{
  int rc;
  rc = ioctl(chan->fd, AXI_DMA_SWAP, 0);
  if(rc < 0)
  {
    fprintf(stderr, "Unable to swap dma buffers\n");
    return rc;
  }
  return 0;
}

void *axi_dma_channel_mmap(struct axi_dma_chan *chan)
{
  intptr_t rc;
  void *ptr;
  ptr = mmap( 0, chan->access_size
            , PROT_READ | PROT_WRITE, MAP_PRIVATE, chan->fd, 0);
  rc = (intptr_t)ptr;
  if(rc < 0)
  {
    fprintf(stderr, "Unable to remap buffer for user access\n");
    return NULL;
  }
  return ptr;
}

void axi_dma_channel_munmap(struct axi_dma_chan *chan, void *ptr)
{
  munmap(ptr, chan->access_size);
}
