# Create the work library (if not already created)
vlib work

# Compile the design files
vcom -work work i2s_to_axi.vhd
vcom -work work tb_i2s_to_axi.vhd

# Load the simulation
vsim -gui work.tb_i2s_to_axi

# Add signals to waveform for debugging
add wave -format Logic MCLK
add wave -format Logic SCLK
add wave -format Logic LRCLK
add wave -format Logic DIN
add wave -format Literal AXI_TDATA
add wave -format Logic AXI_TVALID
add wave -format Logic AXI_TLAST
add wave -format Logic AXI_READY
add wave {sim:/tb_i2s_to_axi/uut/axi_data_reg } 
add wave {sim:/tb_i2s_to_axi/uut/bit_counter } 
add wave {sim:/tb_i2s_to_axi/uut/shift_reg } 
add wave {sim:/tb_i2s_to_axi/uut/start_count } 
add wave {sim:/tb_i2s_to_axi/uut/mae_i2s } 


# Run simulation for 5ms
run 5ms
