library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of pattern_gen1 is

begin

  p_process : process(v_px_i)
  begin
    -- Calculate horizontal lines: Red-Green-Blue-Black x4 (for 640 px)
    -- TODO: Check if this calculation takes too many resources. Maybe a if
    -- switch works better.
    case to_integer((unsigned(v_px_i) mod 160) / 40) is
      when 0 =>
        red_o   <= "1111";
        green_o <= "0000";
        blue_o  <= "0000";
      when 1 =>
        red_o   <= "0000";
        green_o <= "1111";
        blue_o  <= "0000";
      when 2 =>
        red_o   <= "0000";
        green_o <= "0000";
        blue_o  <= "1111";
      when 3 =>
        red_o   <= "1111";
        green_o <= "1111";
        blue_o  <= "1111";
      when others =>
        red_o   <= "0000";
        green_o <= "0000";
        blue_o  <= "0000";
    end case;
  end process p_process;

end architecture rtl;
