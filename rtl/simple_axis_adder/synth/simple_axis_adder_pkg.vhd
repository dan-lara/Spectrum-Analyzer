library ieee;
use ieee.std_logic_1164.all;

package simple_axis_adder_pkg is

  component simple_axis_adder is
  	generic(P_DATA_WIDTH : integer := 32);
    port( clk    : in std_logic;
          resetn : in std_logic;

          in0_tdata  : in  std_logic_vector(P_DATA_WIDTH - 1 downto 0);
          in0_tvalid : in  std_logic;
          in0_tready : out std_logic;

          in1_tdata  : in  std_logic_vector(P_DATA_WIDTH - 1 downto 0);
          in1_tvalid : in  std_logic;
          in1_tready : out std_logic;

          out_tdata  : out std_logic_vector(P_DATA_WIDTH - 1 downto 0);
          out_tvalid : out std_logic;
          out_tready : in  std_logic);
  end component;

end package;
