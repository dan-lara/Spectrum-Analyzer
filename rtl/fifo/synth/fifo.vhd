library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FIFO is
    Port ( 
            DMAclk : in STD_LOGIC;
            Mclk : in STD_LOGIC;
            DataIn : in STD_LOGIC_VECTOR(31 downto 0);
            DataOut : out STD_LOGIC_VECTOR(31 downto 0)
        );
end entity;

architecture Behavioral of FIFO is
    signal Data_Keep : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal done : STD_LOGIC := '0';

begin
    process (Mclk, DMAclk)
    begin
        if rising_edge(Mclk) then
            Data_Keep <= DataIn;
            done <= '0';
            end if;
        if rising_edge(DMAclk) and done = '0' then
            DataOut <= Data_Keep;
            done <= '1';
        end if;
    end process;
end Behavioral;
