library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.simple_axis_adder_pkg.all;
use work.string_format_pkg.all;

entity tb_simple_axis_adder is
  generic(P_DATA_WIDTH : integer := 32;
				  P_SAMPLE_NUM : integer := 32;
          P_BW_DIV_NUM : integer := 4);
end entity;

architecture testbench of tb_simple_axis_adder is

  procedure rand_data( s : out std_logic_vector;
                       seed1, seed2 : inout integer) is
    variable fval : real;
  begin
    for i in s'range loop
      uniform(seed1, seed2, fval);
      if(fval > 0.5) then
        s(i) := '1';
      else
        s(i) := '0';
      end if;
    end loop;
  end procedure;

  type test_samples     is array(0 to P_SAMPLE_NUM - 1) of std_logic_vector(P_DATA_WIDTH - 1 downto 0);
  type out_bw_samples   is array(0 to P_BW_DIV_NUM - 1) of test_samples;
  type in1_bw_samples   is array(0 to P_BW_DIV_NUM - 1) of out_bw_samples;
  type tests_bw_samples is array(0 to P_BW_DIV_NUM - 1) of in1_bw_samples;

  procedure rand_samples( signal s : out tests_bw_samples;
                          seed1, seed2 : inout integer) is
    variable slv : std_logic_vector(P_DATA_WIDTH - 1 downto 0);
  begin
    for i in 0 to P_BW_DIV_NUM - 1 loop
      for j in 0 to P_BW_DIV_NUM - 1 loop
        for k in 0 to P_BW_DIV_NUM - 1 loop
          for samples in 0 to P_SAMPLE_NUM - 1 loop
            rand_data(slv, seed1, seed2);
            s(i)(j)(k)(samples) <= slv;
          end loop;
        end loop;
      end loop;
    end loop;
  end procedure;

  procedure model( signal s : out tests_bw_samples;
                   signal i0 : in tests_bw_samples;
                   signal i1 : in tests_bw_samples) is
  begin
    for i in 0 to P_BW_DIV_NUM - 1 loop
      for j in 0 to P_BW_DIV_NUM - 1 loop
        for k in 0 to P_BW_DIV_NUM - 1 loop
          for sample in 0 to P_SAMPLE_NUM - 1 loop
            s(i)(j)(k)(sample) <= std_logic_vector( unsigned(i0(i)(j)(k)(sample))
                                                  + unsigned(i1(i)(j)(k)(sample)));
          end loop;
        end loop;
      end loop;
    end loop;
  end procedure;

  signal in0_samples  : tests_bw_samples;
  signal in1_samples  : tests_bw_samples;
  signal gold_samples : tests_bw_samples;
  signal out_samples  : tests_bw_samples;

  signal finished                    : boolean := false;
  signal stimulus_in0_finished       : boolean := false;
  signal stimulus_in1_finished       : boolean := false;
  signal stimulus_out_ready_finished : boolean := false;

  signal clk        : std_logic;
  signal resetn     : std_logic;
  signal in0_tdata  : std_logic_vector(P_DATA_WIDTH - 1 downto 0);
  signal in0_tvalid : std_logic;
  signal in0_tready : std_logic;
  signal in1_tdata  : std_logic_vector(P_DATA_WIDTH - 1 downto 0);
  signal in1_tvalid : std_logic;
  signal in1_tready : std_logic;
  signal out_tdata  : std_logic_vector(P_DATA_WIDTH - 1 downto 0);
  signal out_tvalid : std_logic;
  signal out_tready : std_logic;
begin
  finished <= stimulus_in0_finished and stimulus_in1_finished and stimulus_out_ready_finished;

  -----------------------
  -- Device Under Test --
  -----------------------
  dut: simple_axis_adder
    generic map(P_DATA_WIDTH => P_DATA_WIDTH)
    port map( clk    => clk
            , resetn => resetn
            , in0_tdata  => in0_tdata
            , in0_tvalid => in0_tvalid
            , in0_tready => in0_tready
            , in1_tdata  => in1_tdata
            , in1_tvalid => in1_tvalid
            , in1_tready => in1_tready
            , out_tdata  => out_tdata
            , out_tvalid => out_tvalid
            , out_tready => out_tready);

  ---------------------
  -- Clock generator --
  ---------------------
  clk_gen: process begin
    clk <= '1';
    wait for 5 ns;
    clk <= '0';
    wait for 5 ns;
    if(finished) then
      wait;
    end if;
  end process;

  ---------------------
  -- Reset generator --
  ---------------------
  rst_gen: process begin
    print_info("Holding reset for 10 cycles");
    resetn <= '0';
    for i in 0 to 9 loop
       wait until(rising_edge(clk));
    end loop;
    print_info("Desasserting reset");
    resetn <= '1';
    wait;
  end process;

  stimulus_in0: process
    variable in0_seed1 : integer := 999;
    variable in0_seed2 : integer := 999;
  begin
    rand_samples(in0_samples, in0_seed1, in0_seed2);
    wait until resetn = '1' and rising_edge(clk);
    wait until rising_edge(clk);
    for i in 0 to P_BW_DIV_NUM - 1 loop
      print_info("Setting BW input0 to 1/" & integer'image(i+1));
      for j in 0 to P_BW_DIV_NUM -1 loop
        for k in 0 to P_BW_DIV_NUM - 1 loop
          for samples in 0 to P_SAMPLE_NUM - 1 loop
            in0_tdata <= in0_samples(i)(j)(k)(samples);
            in0_tvalid <= '1';
            wait until in0_tready = '1' and rising_edge(clk);
            for delay in 0 to i - 1 loop
              in0_tvalid <= '0';
              wait until(rising_edge(clk));
            end loop;
          end loop;
        end loop;
      end loop;
    end loop;
    in0_tvalid <= '0';
    wait until rising_edge(clk);
    stimulus_in0_finished <= true;
    wait;
  end process;

  stimulus_in1: process
    variable in1_seed1 : integer := 19;
    variable in1_seed2 : integer := 799;
  begin
    rand_samples(in1_samples, in1_seed1, in1_seed2);
    wait until resetn = '1' and rising_edge(clk);
    wait until rising_edge(clk);
    for i in 0 to P_BW_DIV_NUM - 1 loop
      for j in 0 to P_BW_DIV_NUM - 1 loop
        print_info("Setting BW input1 to 1/" & integer'image(j+1));
        for k in 0 to P_BW_DIV_NUM - 1 loop
          for samples in 0 to P_SAMPLE_NUM - 1 loop
            in1_tdata <= in1_samples(i)(j)(k)(samples);
            in1_tvalid <= '1';
            wait until in1_tready = '1' and rising_edge(clk);
            for delay in 0 to j - 1 loop
              in1_tvalid <= '0';
              wait until(rising_edge(clk));
            end loop;
          end loop;
        end loop;
      end loop;
    end loop;
    in1_tvalid <= '0';
    wait until rising_edge(clk);
    stimulus_in1_finished <= true;
    wait;
  end process;

  stimulus_out_ready: process begin
    wait until resetn = '1' and rising_edge(clk);
    wait until rising_edge(clk);
    for i in 0 to P_BW_DIV_NUM - 1 loop
      for j in 0 to P_BW_DIV_NUM - 1 loop
        for k in 0 to P_BW_DIV_NUM - 1 loop
          print_info("Setting BW output to 1/" & integer'image(k + 1));
          for samples in 0 to P_SAMPLE_NUM - 1 loop
            out_tready <= '1';
            wait until out_tvalid = '1' and rising_edge(clk);
            out_samples(i)(j)(k)(samples) <= out_tdata;
            for delay in 0 to k - 1 loop
              out_tready <= '0';
              wait until(rising_edge(clk));
            end loop;
          end loop;
        end loop;
      end loop;
    end loop;
    wait until rising_edge(clk);
    stimulus_out_ready_finished <= true;
    wait;
  end process;


  verif: process
    variable errors : integer := 0;
  begin
    wait until(rising_edge(clk));
    model(gold_samples, in0_samples, in1_samples);
    wait until finished;
    print_info("Simulation finished: verifying data");
    for i in 0 to P_BW_DIV_NUM - 1 loop
      for j in 0 to P_BW_DIV_NUM - 1 loop
        for k in 0 to P_BW_DIV_NUM - 1 loop
          for samples in 0 to P_SAMPLE_NUM - 1 loop
            if(gold_samples(i)(j)(k)(samples) /= out_samples(i)(j)(k)(samples)) then
              print_error("Mismatch detected (gold != out):" & to_dec(unsigned(gold_samples(i)(j)(k)(samples)))
                   & " != "               & to_dec(unsigned(out_samples(i)(j)(k)(samples))));
              errors := errors + 1;
            end if;
          end loop;
        end loop;
      end loop;
    end loop;
    if(errors /= 0) then
      print_error("Simulation failed: " & integer'image(errors) & " errors");
    end if;
    assert errors = 0 severity failure;
    print_success("Simulation successfully finished!");
    wait;
  end process;

end architecture;
