/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"

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

int main()
{
    init_platform();
    static uint8_t src[512] __attribute__((aligned(4))) = {1, 2, 3, 4};
    static uint8_t dst[512] __attribute__((aligned(4)));

    dma_s2mm_transfer((uint32_t)dst, 512);
    dma_mm2s_transfer((uint32_t)src, 512);

    while (!(Xil_In32(S2MM_0_DMASR) & 0x1000));  // Wait for S2MM done
    while (!(Xil_In32(MM2S_1_DMASR) & 0x1000));  // Wait for MM2S done
    
    cleanup_platform();
    return 0;
}
