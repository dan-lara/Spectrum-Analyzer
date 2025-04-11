#include <stdio.h>
#include "xparameters.h"
#include "xil_io.h"

#define VGA_BASE_ADDR XPAR_VGA_CONTROLLER_0_S00_AXI_BASEADDR

void draw_chessboard() {
    for (int y = 0; y < 480; y++) {
        for (int x = 0; x < 640; x++) {
            uint32_t color = ((x / 80) % 2 == (y / 60) % 2) ? 0xFFFFFFFF : 0x00000000;
            Xil_Out32(VGA_BASE_ADDR + (y * 640 + x) * 4, color);
        }
    }
}

int main() {
    Xil_Out32(VGA_BASE_ADDR + 0x00, 0x00000001); // Enable VGA output
    draw_color_bar();
    while (1);
    return 0;
}
