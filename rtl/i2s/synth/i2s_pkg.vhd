library ieee;
use ieee.std_logic_1164.all;

package i2s_pkg is

    component i2s_to_axi is
        port (
            MCLK      : in  std_logic; -- Master clock
            DIN       : in  std_logic; -- Serial data input
            AXI_READY : in  std_logic; -- AXI ready signal

            LRCLK     : out std_logic; -- Left/Right clock
            SCLK      : out std_logic; -- Serial clock

            AXI_TDATA : out std_logic_vector(31 downto 0); -- AXI data output
            AXI_TVALID: out std_logic; -- AXI valid signal
            AXI_TLAST : out std_logic  -- AXI last signal
        );
    end component;

end package;
