-- Copyright Raphaël Bresson 2021

-- Reference file for bd wrapper: build/vivado/build/hdl/<bd_name>_wrapper.vhd or
-- build/vivado/build/hdl/<bd_name>_wrapper.v (depending which language is preferred in Makefile and after generating it:
-- make build/vivado/import_synth.done

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spectrum_analyzer_top is
  port( fan_en_b             : out STD_LOGIC_VECTOR ( 0 to 0 )
      );
end entity;

architecture top_arch of spectrum_analyzer_top is
begin
------ l'instanciation suivante doit être actualisée en fonction du fichier build/vivado/build/hdl/design_1_wrapper.vhd (qui représente le block design)
bd_inst: entity work.design_1_wrapper
  port map( fan_en_b             => fan_en_b
          );

end architecture;
