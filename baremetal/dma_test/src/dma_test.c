#include "xil_io.h"
#include "xparameters.h"
#include <stdint.h>

#define DMA_0_BASEADDR XPAR_AXI_DMA_0_BASEADDR
#define DMA_1_BASEADDR XPAR_AXI_DMA_1_BASEADDR

#define MM2S_0_DMACR    (DMA_0_BASEADDR + 0x00)
#define MM2S_0_DMASR    (DMA_0_BASEADDR + 0x04)
#define MM2S_0_SA       (DMA_0_BASEADDR + 0x18)
#define MM2S_0_LENGTH   (DMA_0_BASEADDR + 0x28)

#define S2MM_0_DMACR    (DMA_0_BASEADDR + 0x30)
#define S2MM_0_DMASR    (DMA_0_BASEADDR + 0x34)
#define S2MM_0_DA       (DMA_0_BASEADDR + 0x48)
#define S2MM_0_LENGTH   (DMA_0_BASEADDR + 0x58)

#define MM2S_1_DMACR    (DMA_1_BASEADDR + 0x00)
#define MM2S_1_DMASR    (DMA_1_BASEADDR + 0x04)
#define MM2S_1_SA       (DMA_1_BASEADDR + 0x18)
#define MM2S_1_LENGTH   (DMA_1_BASEADDR + 0x28)

#define S2MM_1_DMACR    (DMA_1_BASEADDR + 0x30)
#define S2MM_1_DMASR    (DMA_1_BASEADDR + 0x34)
#define S2MM_1_DA       (DMA_1_BASEADDR + 0x48)
#define S2MM_1_LENGTH   (DMA_1_BASEADDR + 0x58)

void dma_0_mm2s_transfer(uint32_t src_addr, uint32_t length) {
    Xil_Out32(MM2S_0_DMACR, 0x1);            // Start MM2S
    Xil_Out32(MM2S_0_SA, src_addr);          // Source address
    Xil_Out32(MM2S_0_LENGTH, length);        // Length in bytes (write last)
}

void dma_0_s2mm_transfer(uint32_t dst_addr, uint32_t length) {
    Xil_Out32(S2MM_0_DMACR, 0x1);            // Start S2MM
    Xil_Out32(S2MM_0_DA, dst_addr);          // Destination address
    Xil_Out32(S2MM_0_LENGTH, length);        // Length in bytes (write last)
}

void dma_1_mm2s_transfer(uint32_t src_addr, uint32_t length) {
    Xil_Out32(MM2S_1_DMACR, 0x1);            // Start MM2S
    Xil_Out32(MM2S_1_SA, src_addr);          // Source address
    Xil_Out32(MM2S_1_LENGTH, length);        // Length in bytes (write last)
}

void dma_1_s2mm_transfer(uint32_t dst_addr, uint32_t length) {
    Xil_Out32(S2MM_1_DMACR, 0x1);            // Start S2MM
    Xil_Out32(S2MM_1_DA, dst_addr);          // Destination address
    Xil_Out32(S2MM_1_LENGTH, length);        // Length in bytes (write last)
}

uint32_t dma_0_mm2s_status() {
    return Xil_In32(MM2S_0_DMASR);           // Read MM2S status register
}

uint32_t dma_0_s2mm_status() {
    return Xil_In32(S2MM_0_DMASR);           // Read S2MM status register
}

uint32_t dma_1_mm2s_status() {
    return Xil_In32(MM2S_1_DMASR);           // Read MM2S status register
}

uint32_t dma_1_s2mm_status() {
    return Xil_In32(S2MM_1_DMASR);           // Read S2MM status register
}

int main() {
    static uint32_t src[200] __attribute__((aligned(4))) = {1, 2, 3, 4};
    static uint32_t dst[200] __attribute__((aligned(4)));

    dma_s2mm_transfer((uint32_t)dst, 200);
    dma_mm2s_transfer((uint32_t)src, 200);

    while (!(Xil_In32(S2MM_0_DMASR) & 0x1000));  // Wait for S2MM done
    while (!(Xil_In32(MM2S_0_DMASR) & 0x1000));  // Wait for MM2S done

    return 0;
}
