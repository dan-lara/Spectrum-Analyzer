#ifndef AXI_DMA_API_H_INCLUDED
#define AXI_DMA_API_H_INCLUDED

#include "axi_dma_ioctl.h"

struct axi_dma_chan
{
  int fd;
  size_t access_size;
};

int axi_dma_channel_open( struct axi_dma_chan *chan
                        , const char *path);
void axi_dma_channel_close(struct axi_dma_chan *chan);

int axi_dma_channel_init( struct axi_dma_chan *chan
                        , size_t num_bd
                        , size_t bd_per_sg
                        , int flags);

int axi_dma_channel_start(struct axi_dma_chan *chan);

int axi_dma_channel_stop(struct axi_dma_chan *chan);

int axi_dma_channel_wait(struct axi_dma_chan *chan);

int axi_dma_channel_swap(struct axi_dma_chan *chan);

void *axi_dma_channel_mmap(struct axi_dma_chan *chan);

void axi_dma_channel_munmap( struct axi_dma_chan *chan
                           , void *ptr);

#endif
