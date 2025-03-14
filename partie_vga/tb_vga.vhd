library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_vga is
end tb_vga;

architecture Behavioral of tb_vga is
    -- Déclaration des signaux de test
    signal Vsync_tb    : STD_LOGIC;
    signal Hsync_tb    : STD_LOGIC;
    signal Data_tb     : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal PixelClock_tb : STD_LOGIC := '0';
    signal pixel_r_tb  : STD_LOGIC_VECTOR(3 downto 0);
    signal pixel_g_tb  : STD_LOGIC_VECTOR(3 downto 0);
    signal pixel_b_tb  : STD_LOGIC_VECTOR(3 downto 0);

    -- Fréquence de l'horloge simulée (40 MHz)
    constant ClockPeriod : time := 25 ns;

    -- Instanciation du module à tester
    component DisplayController
        Port ( Vsync : out STD_LOGIC;
               Hsync : out STD_LOGIC;
               Data  : in STD_LOGIC_VECTOR(31 downto 0);
               PixelClock : in STD_LOGIC;
               pixel_r : out STD_LOGIC_VECTOR(3 downto 0);
               pixel_g : out STD_LOGIC_VECTOR(3 downto 0);
               pixel_b : out STD_LOGIC_VECTOR(3 downto 0));
    end component;

begin
    -- Instanciation du module sous test
    UUT: DisplayController
        port map (
            Vsync => Vsync_tb,
            Hsync => Hsync_tb,
            Data => Data_tb,
            PixelClock => PixelClock_tb,
            pixel_r => pixel_r_tb,
            pixel_g => pixel_g_tb,
            pixel_b => pixel_b_tb
        );

    -- Processus de génération de l'horloge
    process
    begin
        while now < 200 ms loop -- Simulation sur 10 ms
            PixelClock_tb <= '0';
            wait for ClockPeriod / 2;
            PixelClock_tb <= '1';
            wait for ClockPeriod / 2;
        end loop;
        wait;
    end process;

    -- Processus de test des données d'entrée
    process
    begin
        wait for 50 ns;
        
        -- Test de plusieurs valeurs de Data
        Data_tb <= x"FFFFFFFF";  -- Blanc maximal
        wait for 1 us;
        
        Data_tb <= x"000000FF";
        wait for 1 us;
        
        Data_tb <= x"0000000F";  
        wait for 1 us;
        
        Data_tb <= x"00000000";  -- Bleu maximal
        wait for 1 us;
        
        Data_tb <= x"0000000F";  -- Noir
        wait for 1 us;
        
        wait;
    end process;
end Behavioral;
