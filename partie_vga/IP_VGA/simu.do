vlib work

vcom -93 IP_vga.vhd
vcom -93 vga.vhd
vcom -93 TopDisplaySystem.vhd
vcom -93 TopDisplaySystem_tb.vhd

# Lancement de la simulation
vsim -t 1ns work.tb_TopDisplaySystem

# Ajout des signaux à la fenêtre de simulation
add wave -noupdate /tb_TopDisplaySystem/PixelClock
add wave -noupdate /tb_TopDisplaySystem/vga_valid
add wave -noupdate /tb_TopDisplaySystem/vga_last
add wave -hex -noupdate /tb_TopDisplaySystem/vga_tdata
add wave -noupdate /tb_TopDisplaySystem/vga_ready

add wave -hex -noupdate /tb_TopDisplaySystem/UUT/Data_inout
add wave -noupdate /tb_TopDisplaySystem/UUT/reset_tb

add wave -noupdate /tb_TopDisplaySystem/Vsync
add wave -noupdate /tb_TopDisplaySystem/Hsync
add wave -noupdate /tb_TopDisplaySystem/pixel_r
add wave -noupdate /tb_TopDisplaySystem/pixel_g
add wave -noupdate /tb_TopDisplaySystem/pixel_b

# Compteurs internes (optionnel mais utile)
add wave -noupdate /tb_TopDisplaySystem/UUT/VGA_Display/pixel_count
add wave -noupdate /tb_TopDisplaySystem/UUT/VGA_Display/line_count

# Démarrage de la simulation pour 200 ms (ou ce que tu veux)
run 100ms

# Zoomer pour voir tous les signaux
wave zoom full
