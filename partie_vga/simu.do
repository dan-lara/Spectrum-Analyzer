vlib work

vcom -93 vga.vhd
vcom -93 tb_vga.vhd

# Lancement de la simulation
vsim -t 1ns work.tb_vga

# Ajout des signaux à la fenêtre de simulation
add wave -noupdate /tb_vga/PixelClock_tb
add wave -noupdate /tb_vga/Data_tb
add wave -noupdate /tb_vga/Hsync_tb
add wave -noupdate /tb_vga/Vsync_tb
add wave -noupdate /tb_vga/pixel_r_tb
add wave -noupdate /tb_vga/pixel_g_tb
add wave -noupdate /tb_vga/pixel_b_tb
add wave -noupdate /tb_vga/UUT/pixel_count
add wave -noupdate /tb_vga/UUT/line_count

# Démarrage de la simulation pour 21 ms
run 200ms

# Zoomer pour voir tous les signaux
wave zoom full
