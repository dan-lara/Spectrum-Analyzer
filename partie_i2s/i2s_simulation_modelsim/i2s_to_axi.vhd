library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity i2s_to_axi is
    Port (
		RST		 : in  std_logic;
        MCLK     : in  std_logic;
        DIN      : in  std_logic;
        AXI_READY: in  std_logic;

        LRCLK    : out std_logic;
        SCLK     : out std_logic;
        
        AXI_TDATA  : out std_logic_vector(31 downto 0);
        AXI_TVALID : out std_logic;
        AXI_TLAST  : out std_logic
    );
end i2s_to_axi;

architecture Behavioral of i2s_to_axi is
    -- Clock Division Counters
    signal mclk_counter  : integer range 0 to 511 := 0;
    signal sclk_counter  : integer range 0 to 7 := 0;
    signal lrclk_reg     : std_logic := '0';
    signal sclk_internal : std_logic := '0';
    signal lrck_prev     : std_logic := '0';  

    -- Data Capture
    signal shift_reg  : std_logic_vector(23 downto 0) := (others => '0');
    signal bit_counter: integer range 0 to 24 := 0;
    -- signal left_data, right_data : std_logic_vector(23 downto 0) := (others => '0');
	-- signal start_count : std_logic := '0';
    signal valid_reg    : std_logic := '0';

	
	type etat_I2S is (wait_r_chan, wait_l_chan, listen_r_chan, listen_l_chan);
	signal mae_i2s: etat_i2s;

    -- AXI-Stream Data
    signal axi_data_reg : std_logic_vector(31 downto 0) := (others => '0');
    -- signal valid_axi    : std_logic := '0';
    -- signal last_reg     : std_logic := '0';
	
	type etat_AXIs is (wait_for_valid, wait_for_ready, last);
	signal mae_axis		: etat_AXIs;


begin
    -- Clock Division Process
    process(MCLK)
    begin
        if rising_edge(MCLK) then
            -- LRCLK division (MCLK / 512)
            if mclk_counter = 511 then
                mclk_counter <= 0;
                lrclk_reg <= not lrclk_reg;
            else
                mclk_counter <= mclk_counter + 1;
            end if;

            -- SCLK division (MCLK / 8)
            if sclk_counter = 7 then
                sclk_counter <= 0;
                sclk_internal <= not sclk_internal;
            else
                sclk_counter <= sclk_counter + 1;
            end if;
        end if;
    end process;

    -- Assign LRCLK and SCLK outputs
    LRCLK <= lrclk_reg;
    SCLK <= sclk_internal;








    -- Data Reception Process (Shifting 24-bit words)
    process(sclk_internal, rst)
    begin

---------------------------------------------

        -- if rising_edge(sclk_internal) then
        --     -- Check for LRCLK transition **before** shifting data
        --     if lrclk_reg /= lrck_prev then
        --         if lrclk_reg = '0' then
        --             left_data <= shift_reg;   -- Store left channel data
        --         else
        --             right_data <= shift_reg;  -- Store right channel data
        --         end if;

        --         -- Set AXI-Stream signals **only on LRCLK transition**
        --         axi_data_reg(31 downto 25) <= (others => '0'); -- Padding
        --         axi_data_reg(24)           <= lrclk_reg;        -- 0 = left, 1 = right
        --         axi_data_reg(23 downto 0)  <= shift_reg;        -- Actual 24-bit data

        --         valid_reg <= '1';   -- Mark data as valid
        --         last_reg  <= lrclk_reg;  -- TLAST high only when LRCLK = 1
		-- 		start_count <= '1'; -- Reset bit counter so that it's syncd w/ arriving data
        --     else
        --         valid_reg <= '0';
        --     end if;

        --     -- Shift in new data
		-- 	if start_count = '1' then
		-- 		if bit_counter < 24 then
		-- 			shift_reg <= shift_reg(22 downto 0) & DIN;
		-- 			bit_counter <= bit_counter + 1;
		-- 		else
		-- 			bit_counter <= 0; -- Reset counter after 24 bits
		-- 			start_count <= '0';
		-- 		end if;
		-- 	end if;

        --     lrck_prev <= lrclk_reg; -- Store previous LRCLK state
        -- end if;
		-- end process;

---------------------------------------------
--note : 	both above and below are working solutions;
--			i have a personal preference for the one below as i believe it's more reliable.
---------------------------------------------
		if rst = '0' then
			mae_i2s <= wait_r_chan;
			AXI_TDATA <= (others => '0');
			axi_tvalid <= '0';
			axi_tlast <= '0';
			bit_counter <= 0;
			valid_reg <= '0';
			axi_data_reg <= (others => '0');
			shift_reg <= (others => '0');
			mae_axis <= wait_for_valid;

        elsif rising_edge(sclk_internal) then


			-- end if;

			-- I2S state machine
			case MAE_I2S is
				when wait_r_chan =>
					if LRCLK_reg = '1' then
						valid_reg <= '0';
						MAE_I2S <= listen_r_chan;
					end if;

				when wait_l_chan =>
					if LRCLK_reg = '0' then
						valid_reg <= '0';
						MAE_I2S <= listen_l_chan;
					end if;

				when listen_r_chan =>
					-- bit_counter : 23:0
					if bit_counter = 23 then
						bit_counter <= 0;
						MAE_I2S <= wait_l_chan;
						valid_reg <= '1';
						axi_data_reg(31 downto 25) <= (others => '0');	-- Padding
						axi_data_reg(24)           <= '1';		        -- 0 = left, 1 = right
						axi_data_reg(23 downto 0)  <= shift_reg;        -- Actual 24-bit data
					else
						if bit_counter = 0 then
							shift_reg <= (others => '0');
						end if;
						bit_counter <= bit_counter + 1;
						shift_reg <= shift_reg(22 downto 0) & DIN;
						valid_reg <= '0';
					end if;

				when listen_l_chan =>
					if bit_counter = 23 then
						bit_counter <= 0;
						MAE_I2S <= wait_r_chan;
						--SEND TO FIFO NOW
						valid_reg <= '1';
						axi_data_reg(31 downto 25) <= (others => '0'); 	-- Padding
						axi_data_reg(24)           <= '0';		        -- 0 = left, 1 = right
						axi_data_reg(23 downto 0)  <= shift_reg;        -- Actual 24-bit data
					else
						if bit_counter = 0 then
							shift_reg <= (others => '0');
						end if;
						bit_counter <= bit_counter + 1;
						shift_reg <= shift_reg(22 downto 0) & DIN;
						valid_reg <= '0';
					end if;
			end case;

			-- AXI Handshake (AXI-Stream Transmission)
			case mae_axis is
				when wait_for_valid =>
					if valid_reg = '1' then
						mae_axis <= wait_for_ready;
						AXI_TDATA  <= axi_data_reg;
					else
						AXI_TVALID <= '0';
						AXI_TLAST <= '0';
					end if;

				when wait_for_ready =>
					if axi_ready = '1' then
						axi_tvalid <= '1';
						axi_tlast <= '1';
						mae_axis <= last;
					end if;

				when last =>
					AXI_TLAST <= '0';
					valid_reg <= '0';
					AXI_TVALID <= '0';
					mae_axis <= wait_for_valid;
			end case;


		end if;
    end process;
end Behavioral;
