vlib work

vcom -93 fifo.vhd
vcom -93 fifo_tb.vhd

# Lancement de la simulation
vsim -t 1ns work.tb_fifo

# Ajout des signaux à la fenêtre de simulation
add wave -noupdate /tb_fifo/DMAClk_tb
add wave -noupdate /tb_fifo/MClk_tb
add wave -noupdate /tb_fifo/U1/done
add wave -noupdate /tb_fifo/DataIn_tb
add wave -noupdate /tb_fifo/DataOut_tb

# Démarrage de la simulation pour 21 ms
run 350 ns

# Zoomer pour voir tous les signaux
wave zoom full
