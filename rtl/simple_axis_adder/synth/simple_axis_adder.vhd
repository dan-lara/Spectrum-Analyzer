library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simple_axis_adder is
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
end entity;

architecture behav of simple_axis_adder is
  signal w_ready : std_logic;
  signal r_valid : std_logic := '0';
  signal r_data  : std_logic_vector(P_DATA_WIDTH - 1 downto 0);
begin

  w_ready <= (out_tready or not r_valid) and in0_tvalid and in1_tvalid and resetn;
	process(clk) begin
    if(rising_edge(clk)) then
      if(w_ready = '1') then
        r_data <= std_logic_vector(unsigned(in0_tdata) + unsigned(in1_tdata));
        r_valid <= in0_tvalid and in1_tvalid;
      elsif(out_tready = '1' and r_valid = '1') then
        r_valid <= '0';
      end if;
    end if;
  end process;

  out_tvalid <= r_valid;
  out_tdata  <= r_data;
	in0_tready <= w_ready;
	in1_tready <= w_ready;
end architecture;

