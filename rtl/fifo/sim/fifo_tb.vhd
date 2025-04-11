library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_fifo is
end tb_fifo;

architecture Behavioral of tb_fifo is
    -- Déclaration des signaux de test
    signal DMAclk_tb    : STD_LOGIC; --100 Mhz
    signal Mclk_tb    : STD_LOGIC; --22,58 Mhz
    signal DataIn_tb     : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal DataOut_tb     : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

    -- Fréquence de l'horloge simulée (100 MHz)
    constant DMAClockPeriod : time := 10 ns;

    -- Fréquence de l'horloge simulée (100 MHz)
    constant MClockPeriod : time := 44.287 ns;

    -- Instanciation du module à tester
    component FIFO
        Port (
            signal DMAclk    : in STD_LOGIC;
            signal Mclk    : in STD_LOGIC;
            signal DataIn     : in STD_LOGIC_VECTOR(31 downto 0);
            signal DataOut     : out STD_LOGIC_VECTOR(31 downto 0));
    end component;

begin
    -- Instanciation du module sous test
    U1: FIFO
        port map (
            DMAclk => DMAclk_tb,
            Mclk => Mclk_tb,
            DataIn => DataIn_tb,
            DataOut => DataOut_tb
        );

    -- Processus de génération de l'horloge
    process
    begin
        while now < 200 ms loop -- Simulation sur 10 ms
            DMAclk_tb <= '0';
            wait for DMAClockPeriod / 2;
            DMAclk_tb <= '1';
            wait for DMAClockPeriod / 2;
        end loop;
        wait;
    end process;

    -- Processus de génération de l'horloge
    process
    begin
        while now < 200 ms loop -- Simulation sur 10 ms
            Mclk_tb <= '0';
            wait for MClockPeriod / 2;
            Mclk_tb <= '1';
            wait for MClockPeriod / 2;
        end loop;
        wait;
    end process;
    
    -- Processus de test des données d'entrée
    process
    begin
        wait for 50 ns;
        
        -- Test de plusieurs valeurs de DataIn
        DataIn_tb <= x"00000000"; 
        wait for 50 ns;

        DataIn_tb <= x"FFFFFFFF";
        wait for 50 ns;
        
        DataIn_tb <= x"000000FF";
        wait for 50 ns;
        
        DataIn_tb <= x"0000000F";  
        wait for 50 ns;
        
        DataIn_tb <= x"00000000"; 
        wait for 50 ns;
        
        DataIn_tb <= x"0000000F"; 
        wait for 50 ns;
        
        wait;
    end process;
end Behavioral;