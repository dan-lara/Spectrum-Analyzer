#ifndef IMPL_AXI_DMA_IOCTL_H_INCLUDED
#define IMPL_AXI_DMA_IOCTL_H_INCLUDED

#include <sys/ioctl.h>
#include <stdlib.h>
#include <stdint.h>

#define AXI_DMA_FLAG_SIMPLE_SG     0
#define AXI_DMA_FLAG_CYCLIC        1
#define AXI_DMA_FLAG_DOUBLE_BUFFER 2

// information de configuration pour l'allocation des buffers
struct axi_dma_buf_info
{
  size_t num_bd;    // nombre total de descripteurs(ignoré pour le mode double buffer où num_handles = num_bd_per_sg * 2)
  size_t bd_per_sg; // nombre de descripteurs par transaction scatter-gather
  size_t buf_size;  // taille des buffers: taille recommandée = PAGE_SIZE (4096 octets)
  int    flag;      // flag (combinaison de AXI_DMA_FLAG_*)
};


#define NUM_MAJOR 100
#define AXI_DMA_INIT                _IOW (NUM_MAJOR, 0, struct axi_dma_buf_info *)
#define AXI_DMA_START               _IO  (NUM_MAJOR, 1)
#define AXI_DMA_STOP                _IO  (NUM_MAJOR, 2)
#define AXI_DMA_WAIT                _IO  (NUM_MAJOR, 3)
#define AXI_DMA_SWAP                _IO  (NUM_MAJOR, 4)
#define AXI_DMA_GET_REGISTER_VALUE  _IOWR(NUM_MAJOR, 5, uint32_t *)

#endif
