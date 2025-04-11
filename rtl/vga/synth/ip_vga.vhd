library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IPDisplayController is
    Port (  PixelClock : in STD_LOGIC; -- Horloge de pixel (1 pixel chaque cycle)
            vga_valid : in STD_LOGIC;
            vga_last : in STD_LOGIC;
            vga_tdata : in STD_LOGIC_VECTOR(31 downto 0);
            vga_ready : out STD_LOGIC;
            Data  : out STD_LOGIC_VECTOR(31 downto 0);
            reset : out STD_LOGIC -- Reset asynchrone
        );
end IPDisplayController;

architecture Behavioral of IPDisplayController is
    signal ready : STD_LOGIC := '0';


begin
    process (PixelClock, vga_valid)
    begin
        if rising_edge(vga_valid) then
                reset <= '1';
            else 
                reset <= '0';
        end if;
        if rising_edge(PixelClock) then
            if ready = '1' then
                Data <= vga_tdata;
            else 
                Data <= (others => '0');
            end if;
            if vga_valid = '1' then
                vga_ready <= '1';
                ready <= '1';
            end if;
            if vga_last = '1' then
                vga_ready <= '0';
                ready <= '0';
            end if;
        end if;
    end process;
end Behavioral;
