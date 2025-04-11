-- Copyright Raphaël Bresson 2021

-- Reference file for bd wrapper: build/vivado/build/hdl/<bd_name>_wrapper.vhd or
-- build/vivado/build/hdl/<bd_name>_wrapper.v (depending which language is preferred in Makefile and after generating it:
-- make build/vivado/import_synth.done

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg_led_blink.all;

entity spectrum_analyzer_top is
  port( DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
        DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
        DDR_cas_n : inout STD_LOGIC;
        DDR_ck_n : inout STD_LOGIC;
        DDR_ck_p : inout STD_LOGIC;
        DDR_cke : inout STD_LOGIC;
        DDR_cs_n : inout STD_LOGIC;
        DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
        DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
        DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
        DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
        DDR_odt : inout STD_LOGIC;
        DDR_ras_n : inout STD_LOGIC;
        DDR_reset_n : inout STD_LOGIC;
        DDR_we_n : inout STD_LOGIC;
        FIXED_IO_ddr_vrn : inout STD_LOGIC;
        FIXED_IO_ddr_vrp : inout STD_LOGIC;
        FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
        FIXED_IO_ps_clk : inout STD_LOGIC;
        FIXED_IO_ps_porb : inout STD_LOGIC;
        FIXED_IO_ps_srstb : inout STD_LOGIC;
        led : out std_logic_vector(3 downto 0);
        vga_data       : out std_logic_vector(31 downto 0);
        vga_ready      : in std_logic;
        vga_valid      : out std_logic;
        vga_tlast      : out std_logic;
        
      );
end entity;

architecture top_arch of spectrum_analyzer_top is
  signal aclk_0 : std_logic;
  signal aresetn_0 : std_logic_vector(0 downto 0);
  signal vga_clk : std_logic;
  signal i2s_clk : std_logic;
  signal pixel_r : std_logic_vector(3 downto 0);
  signal pixel_g : std_logic_vector(3 downto 0);
  signal pixel_b : std_logic_vector(3 downto 0);
  signal Hsync : std_logic;
  signal Vsync : std_logic;
begin
------ l'instanciation suivante doit être actualisée en fonction du fichier build/vivado/build/hdl/design_1_wrapper.vhd (qui représente le block design)
bd_inst: entity work.design_1_wrapper
  port map( DDR_addr(14 downto 0) => DDR_addr(14 downto 0),
            DDR_ba(2 downto 0) => DDR_ba(2 downto 0),
            DDR_cas_n => DDR_cas_n,
            DDR_ck_n => DDR_ck_n,
            DDR_ck_p => DDR_ck_p,
            DDR_cke => DDR_cke,
            DDR_cs_n => DDR_cs_n,
            DDR_dm(3 downto 0) => DDR_dm(3 downto 0),
            DDR_dq(31 downto 0) => DDR_dq(31 downto 0),
            DDR_dqs_n(3 downto 0) => DDR_dqs_n(3 downto 0),
            DDR_dqs_p(3 downto 0) => DDR_dqs_p(3 downto 0),
            DDR_odt => DDR_odt,
            DDR_ras_n => DDR_ras_n,
            DDR_reset_n => DDR_reset_n,
            DDR_we_n => DDR_we_n,
            FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
            FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
            FIXED_IO_mio(53 downto 0) => FIXED_IO_mio(53 downto 0),
            FIXED_IO_ps_clk => FIXED_IO_ps_clk,
            FIXED_IO_ps_porb => FIXED_IO_ps_porb,
            FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
            aclk_0 => aclk_0,

            aresetn_0 => aresetn_0,
            led(3 downto 0) => led(3 downto 0),
            vga_valid        => vga_valid_i,
            vga_last         => vga_last,
            vga_data         => vga_tdata,
            vga_ready        => vga_ready
          );

          vga_data  <= vga_tdata;
          vga_valid <= vga_valid_i;
          vga_tlast <= vga_last;

-- Vos entités doivent être instanciées ici
-- ici par exemple un compteur sortant sur des leds
-- simple_led_example: led_blink
--   port map ( clk => aclk_0
--            , rsn => aresetn_0(0)
--            , led => led);
-- end architecture;

TopDisplaySystem_inst: entity work.TopDisplaySystem
  port map(
    PixelClock => vga_clk,
    vga_valid  => vga_valid_i,
    vga_last   => vga_last,
    vga_tdata  => vga_tdata,
    vga_ready  => vga_ready,
    Vsync      => Vsync,
    Hsync      => Hsync,
    pixel_r    => pixel_r,
    pixel_g    => pixel_g,
    pixel_b    => pixel_b
  );

i2s_to_axi_inst: entity work.i2s_to_axi
  port map(
    MCLK      => i2s_clk,       -- Using vga_clk as the master clock
    DIN       => '0',           -- Placeholder for serial data input
    AXI_READY => i2s_ready,     -- Connecting AXI ready signal

    LRCLK     => open,          -- Left/Right clock not connected
    SCLK      => open,          -- Serial clock not connected

    AXI_TDATA => vga_data,     -- Connecting AXI data output
    AXI_TVALID=> i2s_valid,   -- Connecting AXI valid signal
    AXI_TLAST => vga_tlast       -- Connecting AXI last signal
  );
