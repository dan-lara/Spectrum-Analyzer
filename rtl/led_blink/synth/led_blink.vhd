library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_blink is
  generic( NUM_LEDS : integer := 4);
  port( clk : in std_logic;
        rsn : in std_logic;
        led : out std_logic_vector(3 downto 0)
      );
end entity;

architecture behav of led_blink is
  signal count : unsigned(26 downto 0) := (others=>'0');
begin
  led <= std_logic_vector(count(26 downto 23));
  simple_led_process: process(clk) begin
    if(rising_edge(clk)) then
      if(rsn = '0') then
        count <= (others=>'0');
      else
        count <= count + 1;
      end if;
    end if;
  end process;

end architecture;
