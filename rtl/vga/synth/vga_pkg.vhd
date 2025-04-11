library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TopDisplaySystem is
    Port (
        PixelClock : in STD_LOGIC;
        vga_valid  : in STD_LOGIC;
        vga_last   : in STD_LOGIC;
        vga_tdata  : in STD_LOGIC_VECTOR(31 downto 0);
        vga_ready  : out STD_LOGIC;
        Vsync      : out STD_LOGIC;
        Hsync      : out STD_LOGIC;
        pixel_r    : out STD_LOGIC_VECTOR(3 downto 0);
        pixel_g    : out STD_LOGIC_VECTOR(3 downto 0);
        pixel_b    : out STD_LOGIC_VECTOR(3 downto 0)
    );
end TopDisplaySystem;

architecture Structural of TopDisplaySystem is

    signal Data_inout : STD_LOGIC_VECTOR(31 downto 0); -- Internal signal for data connection
    signal reset_tb : STD_LOGIC := '0'; -- Asynchronous reset

begin

    -- Instantiation of the IP controller (VGA data reading)
    IP_Display : entity work.IPDisplayController
        port map (
            PixelClock => PixelClock,
            vga_valid  => vga_valid,
            vga_last   => vga_last,
            vga_tdata  => vga_tdata,
            vga_ready  => vga_ready,
            Data       => Data_inout,
            reset      => reset_tb
        );

    -- Instantiation of the VGA display controller
    VGA_Display : entity work.DisplayController
        port map (
            Vsync      => Vsync,
            Hsync      => Hsync,
            Data       => Data_inout,
            PixelClock => PixelClock,
            pixel_r    => pixel_r,
            pixel_g    => pixel_g,
            pixel_b    => pixel_b,
            reset      => reset_tb
        );

end Structural;
