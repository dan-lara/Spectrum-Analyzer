library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DisplayController is
    Port ( Vsync : out STD_LOGIC;
            reset : in STD_LOGIC; -- Reset asynchrone
           Hsync : out STD_LOGIC;
           Data  : in STD_LOGIC_VECTOR(31 downto 0);
           PixelClock : in STD_LOGIC; -- Horloge de pixel (1 pixel chaque cycle)
           pixel_r    : out STD_LOGIC_VECTOR(3 downto 0); -- Signaux RGB pour l'affichage
           pixel_g    : out STD_LOGIC_VECTOR(3 downto 0);
           pixel_b    : out STD_LOGIC_VECTOR(3 downto 0)
        );
end DisplayController;

architecture Behavioral of DisplayController is
    signal line_count : integer range 0 to 1024 := 0; -- Compteur pour les lignes
    signal pixel_count : integer range -2048 to 2048 := -2; -- Compteur pour les pixels par ligne

begin
    process (PixelClock, reset)
    begin
        if reset = '1' then
            line_count <= 0;
            pixel_count <= -2;

        elsif rising_edge(PixelClock) then
            if (pixel_count < 1056) then
                pixel_count <= pixel_count + 1;
            else
                pixel_count <= 0;
                line_count <= line_count + 1;
            end if;

            if (line_count > 628) then
                line_count <= 0;
            end if;
            
            if (pixel_count >= 0 and pixel_count < 840) then
                hsync <= '1';
            elsif (pixel_count >= 840 and pixel_count < 968) then
                hsync <= '0';
            else 
                hsync <= '1';
            end if;

            if (line_count >= 0 and line_count < 602) then
                vsync <= '1';
            elsif (line_count >= 601 and line_count < 606) then
                vsync <= '0';
            else 
                vsync <= '1';
            end if;

            -- Gestion de l'affichage
            if (pixel_count < 800) and (line_count < 600) then
                -- Assigner les données à l'affichage
                pixel_r <= Data(11 downto 8);
                pixel_g <= Data(7 downto 4);
                pixel_b <= Data(3 downto 0);
            else
                pixel_r <= (others => '0');
                pixel_g <= (others => '0');
                pixel_b <= (others => '0');
            end if;
        end if;
    end process;
end Behavioral;
