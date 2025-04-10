library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_TopDisplaySystem is
end tb_TopDisplaySystem;

architecture Behavioral of tb_TopDisplaySystem is

    -- Composants du test
    signal PixelClock : STD_LOGIC := '0';
    signal vga_valid  : STD_LOGIC := '0';
    signal vga_last   : STD_LOGIC := '0';
    signal vga_tdata  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal vga_ready  : STD_LOGIC;

    signal Vsync   : STD_LOGIC;
    signal Hsync   : STD_LOGIC;
    signal pixel_r : STD_LOGIC_VECTOR(3 downto 0);
    signal pixel_g : STD_LOGIC_VECTOR(3 downto 0);
    signal pixel_b : STD_LOGIC_VECTOR(3 downto 0);

    -- Clock period
    constant clk_period : time := 25 ns;

begin

    -- Instanciation du design à tester
    UUT: entity work.TopDisplaySystem
        port map (
            PixelClock => PixelClock,
            vga_valid  => vga_valid,
            vga_last   => vga_last,
            vga_tdata  => vga_tdata,
            vga_ready  => vga_ready,
            Vsync      => Vsync,
            Hsync      => Hsync,
            pixel_r    => pixel_r,
            pixel_g    => pixel_g,
            pixel_b    => pixel_b
        );

    -- Génération de l'horloge à 40 MHz
    clk_process : process
    begin
        while now < 200 ms loop
            PixelClock <= '0';
            wait for clk_period / 2;
            PixelClock <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Stimuli
    stim_proc: process
    begin
        wait for 50 ns;

        -- Envoi de données précises
        vga_valid <= '1';
        
        vga_tdata <= x"FFFFFFFF";
        wait for 20 ms;

        vga_tdata <= x"000000FF";
        wait for 20 ms;

        vga_tdata <= x"0000000F";
        wait for 20 ms;

        vga_tdata <= x"00000000";
        wait for 20 ms;

        vga_tdata <= x"0000000F";
        wait for 10 ms;

        vga_valid <= '0';
        vga_last <= '1'; 
        wait for 25 ns;

        vga_last <= '0';

        -- Attente de fin de simulation
        wait for 1 ms;
        wait;
    end process;
end Behavioral;
