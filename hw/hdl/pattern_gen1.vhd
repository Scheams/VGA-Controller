library ieee;
use ieee.std_logic_1164.all;

entity pattern_gen1 is
  port (
    v_px_i  : in  std_logic_vector (9 downto 0);
    h_px_i  : in  std_logic_vector (9 downto 0);
    out_i   : in  std_logic;

    red_o   : out std_logic_vector (3 downto 0);
    green_o : out std_logic_vector (3 downto 0);
    blue_o  : out std_logic_vector (3 downto 0)
  );
end entity pattern_gen1;
