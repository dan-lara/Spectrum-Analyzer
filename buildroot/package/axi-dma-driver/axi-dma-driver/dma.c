#include "dev.h"
#include <linux/delay.h>

// TODO: allocation et initialisation des buffers cohérents
// fonctions utiles: dma_alloc_coherent()/dma_free_coherent()
// chainage des descripteurs en fonction de la config (simple_sg, cyclique ou double buffer)
static int axi_dma_coherent_init(struct axi_dma_channel *chan)
{
  return 0;
}

// TODO: libération des buffers cohérents
// fonctions utiles: dma_free_coherent()
static void axi_dma_coherent_release(struct axi_dma_channel *chan)
{
}

//initialisation des buffers et de leurs vecteurs de pointeurs
int axi_dma_buffers_init(struct axi_dma_channel *chan, struct axi_dma_buf_info *info)
{
  int ret;
  chan->num_handles = info->num_bd;
  chan->buf_size = info->buf_size;
  chan->flags = info->flag;
  chan->num_buf_per_sg = info->bd_per_sg;
  if(chan->flags & AXI_DMA_FLAG_DOUBLE_BUFFER)
    chan->num_handles = info->bd_per_sg * 2;
  chan->handles = kzalloc(chan->num_handles * sizeof(dma_addr_t), GFP_KERNEL);
  if(!chan->handles)
  {
    dev_err( &chan->parent->pdev->dev
           , "Unable to allocate array of handles\n");
    return -ENOMEM;
  }
  chan->sg_handles = kzalloc(chan->num_handles * sizeof(dma_addr_t), GFP_KERNEL);
  if(!chan->sg_handles)
  {
    dev_err( &chan->parent->pdev->dev
           , "Unable to allocate array of scatter gather handles\n");
    ret = -ENOMEM;
    goto release_handles;
  }
  ret = axi_dma_coherent_init(chan);
  if(ret < 0)
    goto release_sg_handles;
  return 0;
release_sg_handles:
  kfree(chan->sg_handles);
release_handles:
  kfree(chan->handles);
  return ret;
}

//libération des buffers et de leurs vecteurs de pointeurs
void axi_dma_buffer_release(struct axi_dma_channel *chan)
{
  axi_dma_coherent_release(chan);
  kfree(chan->sg_handles);
  kfree(chan->handles);
}

// TODO: Configure le canal DMA et démarre les transactions
// fonctions utiles: ioread32()/iowrite32()
void axi_dma_start(struct axi_dma_channel *chan)
{
}

// TODO: Stoppe toute transaction DMA sur le canal et libère les buffers
// fonction utile: ioread32()/iowrite32()
void axi_dma_stop(struct axi_dma_channel *chan)
{
}

// TODO: Attend une interruption avant de mettre à jour le pointeur "completed" et de rendre la main
// fonction utile: wait_for_completion_interruptible()
void axi_dma_wait_irq(struct axi_dma_channel *chan)
{
}

// TODO: Remappe les buffers accessibles dans l'espace user
// fonction utile: remap_pfn_range()
int axi_dma_remap(struct axi_dma_channel *chan, struct vm_area_struct *vma)
{
  vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot); // on désactive le cache
  return 0;
}

u32 axi_dma_get_register_value(struct axi_dma_channel *chan, int offset)
{
  void *reg_space;
  reg_space = chan->parent->register_space;
  if(chan->direction == DMA_FROM_DEVICE) reg_space += 0x30; // on décale l'adresse pour les canaux S2MM
  return ioread32(reg_space + offset);
}

void axi_dma_swap_buffers(struct axi_dma_channel *chan)
{
  u32 *vlast;
  if(chan->first == chan->sg_handles[0])
  {
    chan->completed = chan->handles[0];
    chan->completed_id = 0;
    chan->first = chan->sg_handles[chan->num_buf_per_sg];
    chan->vfirst = chan->sg_mem + (chan->num_buf_per_sg * AXI_DMA_BD_SIZE);
    vlast = chan->sg_mem + (chan->num_handles - 1) * AXI_DMA_BD_SIZE;
  }else
  {
    chan->completed = chan->handles[chan->num_buf_per_sg];
    chan->completed_id = chan->num_buf_per_sg;
    chan->first = chan->sg_handles[0];
    chan->vfirst = chan->sg_mem;
    vlast = chan->sg_mem + (chan->num_buf_per_sg - 1) * AXI_DMA_BD_SIZE;
  }
  vlast[AXI_DMA_BD_NEXTDESC >> 2] = chan->first; // on chaine le prochain dernier avec le prochain premier
  chan->vlast[AXI_DMA_BD_NEXTDESC >> 2] = chan->first; // on chaine le dernier courant avec le prochain premier
  axi_dma_wait_irq(chan); // on attend une interruption avant de redonner la main à l'utilisateur
  chan->vlast = vlast;
}

