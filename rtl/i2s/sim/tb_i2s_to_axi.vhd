library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity testbench_i2s_to_axi is
end testbench_i2s_to_axi;

architecture Behavioral of testbench_i2s_to_axi is
    -- Component Declaration
    component i2s_to_axi
        Port (
            MCLK     : in  std_logic;
            DIN      : in  std_logic;
            AXI_READY: in  std_logic;
            
            LRCLK    : out std_logic;
            SCLK     : out std_logic;

            AXI_TDATA  : out std_logic_vector(31 downto 0);
            AXI_TVALID : out std_logic;
            AXI_TLAST  : out std_logic
        );
    end component;

    -- Signals
    signal MCLK      : std_logic := '0';
    signal DIN       : std_logic := '0';
    signal AXI_READY : std_logic := '1';

    signal LRCLK     : std_logic;
    signal SCLK      : std_logic;

    signal AXI_TDATA  : std_logic_vector(31 downto 0);
    signal AXI_TVALID : std_logic;
    signal AXI_TLAST  : std_logic;

    -- Clock Periods
    constant MCLK_PERIOD : time := 44.2 ns;  -- 22.58 MHz clock
    constant SCLK_PERIOD : time := 354 ns;   -- Approximate for 2.82 MHz clock
    constant LRCLK_PERIOD : time := SCLK_PERIOD * 32;  -- Assume 32 SCLK cycles per LRCLK toggle

begin
    -- Instantiate DUT (Device Under Test)
    uut: i2s_to_axi
        port map (
            MCLK      => MCLK,
            DIN       => DIN,
            AXI_READY => AXI_READY,
            LRCLK     => LRCLK,
            SCLK      => SCLK,
            AXI_TDATA  => AXI_TDATA,
            AXI_TVALID => AXI_TVALID,
            AXI_TLAST  => AXI_TLAST
        );

    -- Generate MCLK (22.58 MHz)
    process
    begin
        while now < 5 ms loop
            MCLK <= '0';
            wait for MCLK_PERIOD / 2;
            MCLK <= '1';
            wait for MCLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Simulate DIN Data Transmission
    process
    begin
        -- Wait for LRCLK transition before sending data
        wait until rising_edge(LRCLK);
		-- ÇA C'EST PAS 100% PRÉCIS donc ça peut foutre la merde notamment pour le shift reg...
        wait until rising_edge(SCLK);  -- **Ensure alignment after LRCLK shift**


        -- Left Channel Data (First Transmission)
        for i in 0 to 23 loop
                DIN <= '1';
				if i = 23 then
					DIN <= '0';
				end if;
            wait for SCLK_PERIOD;
        end loop;

        -- Wait for LRCLK transition before switching to Right Channel
        wait until falling_edge(LRCLK);
        wait for SCLK_PERIOD;  -- **Ensure alignment after LRCLK shift**



        -- Right Channel Data (Second Transmission)
        for i in 0 to 23 loop
                DIN <= '1';
				if i = 23 then
					DIN <= '0';
				end if;
            wait for SCLK_PERIOD;
        end loop;

        wait;
    end process;
end Behavioral;

