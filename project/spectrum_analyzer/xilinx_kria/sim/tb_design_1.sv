`timescale 1 ps / 1 ps

`define STOP_DELAY 100000
`define INIT_DELAY  2000

`define C_SLV_AWIDTH     32
`define C_SLV_DWIDTH     32

//Response type defines
`define RESPONSE_OKAY   2'b00

//AMBA 4 defines
`define RESP_BUS_WIDTH   2
`define MAX_BURST_LENGTH 8'b1111_1111
`define SINGLE_BURST_LENGTH 8'b0000_0000

// Burst Size Defines
`define BURST_SIZE_1_BYTE    3'b000
`define BURST_SIZE_2_BYTES   3'b001
`define BURST_SIZE_4_BYTES   3'b010
`define BURST_SIZE_8_BYTES   3'b011
`define BURST_SIZE_16_BYTES  3'b100
`define BURST_SIZE_32_BYTES  3'b101
`define BURST_SIZE_64_BYTES  3'b110
`define BURST_SIZE_128_BYTES 3'b111

// Lock Type Defines
`define LOCK_TYPE_NORMAL    1'b0

// Burst Type Defines
`define BURST_TYPE_INCR  2'b01

`define ZYNQ_INST tb_design_1.bd_wrapper.design_1_i.zynq_ps.inst

`uselib lib=unisims_ver


module tb_design_1;
  reg        r_ps_clk;
  reg  [0:0] r_ps_aresetn;
  wire       w_ps_clk    ;
  wire       w_ps_aresetn;

  logic fan_en_b;

  design_1_wrapper bd_wrapper(
    .fan_en_b(fan_en_b)
  );

  initial begin
    r_ps_clk = 1'b0;
    `ZYNQ_INST.set_function_level_info("ALL", 0);
    `ZYNQ_INST.set_channel_level_info("ALL", 0);
    forever #10 r_ps_clk = !r_ps_clk;
  end
  assign w_ps_clk = r_ps_clk;
  assign w_ps_aresetn = r_ps_aresetn;

  initial begin
    r_ps_aresetn = 1'b1;
    $display("#######################################");
    $display("### Block design simulation started ###");
    $display("#######################################");
    repeat(32)@(posedge r_ps_clk);
    $display("### INFO: Holding hard reset ###");
    r_ps_aresetn = 1'b0;
    repeat(32)@(posedge r_ps_clk);
    $display("### INFO: Hard reset is released ###");
    r_ps_aresetn = 1'b1;
    repeat(32)@(posedge r_ps_clk);
    $display("### INFO: Holding soft reset ###");
    `ZYNQ_INST.fpga_soft_reset(32'h1);
    repeat(32)@(posedge r_ps_clk);
    $display("### INFO: Soft reset is released ###");
    `ZYNQ_INST.fpga_soft_reset(32'h0);
    repeat(32)@(posedge r_ps_clk);
    repeat(`INIT_DELAY)@(posedge r_ps_clk);
    repeat(`STOP_DELAY)@(posedge r_ps_clk);
    $display("### SIMULATION FINISHED SUCCESSFULLY ###");
		$stop;
    #10000;
  end

endmodule
