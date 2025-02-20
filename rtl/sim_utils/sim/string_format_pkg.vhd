library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

package string_format_pkg is

  function to_hex_char(val : std_logic_vector(3 downto 0)) return character;
  function to_hex(val : std_logic_vector) return string;

  function from_hex_val(c   : in character) return std_logic_vector;
  function from_hex(str : in string) return std_logic_vector;

  function to_dec(val : unsigned) return string;
  function to_dec(val : signed) return string;

  procedure print_line(str : string);
  procedure print_info(str : string);
  procedure print_error(str : string);
  procedure print_success(str : string);
end package;

package body string_format_pkg is

  constant C_HEXA_CHARS: string(1 to 16) := "0123456789ABCDEF";

  function to_hex_char(val : std_logic_vector(3 downto 0)) return character is
    variable index : integer;
    variable undef : boolean;
  begin
    for i in val'range loop
      if(val(i) = '1') then
        index := index + 2**i;
      elsif(val(i) /= '0') then
        return '?';
      end if;
    end loop;
    return C_HEXA_CHARS(index + 1);
  end function;

  function to_hex(val : std_logic_vector) return string is
    constant nc  : integer := (val'length + 3) / 4;
    variable ext : std_logic_vector(nc * 4 - 1 downto 0) := (others=>'0');
    variable str : string(nc downto 1);
  begin
    ext(val'length - 1 downto 0) := val;
    for i in str'range loop
      str(i) := to_hex_char(ext(i * 4 - 1 downto i * 4 - 4));
    end loop;
  end function;


  function from_hex_val(c: in  character) return std_logic_vector is
  begin
    for i in C_HEXA_CHARS'range loop
      if(C_HEXA_CHARS(i) = c) then
        return std_logic_vector(to_unsigned(i-1, 4));
      end if;
    end loop;
    return "XXXX";
  end function;

  function from_hex(str : in string) return std_logic_vector is
    variable slv : std_logic_vector(str'length * 4 - 1 downto 0) := (others=>'0');
  begin
    for i in str'range loop
      slv(i * 4 - 1 downto i * 4 - 4) := from_hex_val(str(i));
    end loop;
    return slv;
  end function;

  function to_dec(val : unsigned) return string is
  begin
    for i in val'range loop
      if(val(i) /= '1' and val(i) /= '0') then
        return "?";
      end if;
    end loop;
    return integer'image(to_integer(val));
  end function;

  function to_dec(val : signed) return string is
  begin
    for i in val'range loop
      if(val(i) /= '1' and val(i) /= '0') then
        return "?";
      end if;
    end loop;
    return integer'image(to_integer(val));
  end function;

  procedure print_line(str : string) is
    variable l : line;
  begin
    write(l, '[' & time'image(now) & "] " & str);
    writeline(output, l);
  end procedure;

  procedure print_info(str : string) is
  begin
    print_line("[INFO] " & str);
  end procedure;

  procedure print_error(str : string) is
  begin
    print_line("[ERROR] " & str);
  end procedure;

  procedure print_success(str : string) is
  begin
    print_line("[SUCCESS] " & str);
  end procedure;
end package body;
