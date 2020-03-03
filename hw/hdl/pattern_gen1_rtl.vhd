library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of pattern_gen1 is

begin

  p_process : process(out_i, v_px_i)
  begin
    red_o   <= "0000";
    green_o <= "0000";
    blue_o  <= "0000";

    if out_i = '1' then
      case to_integer((unsigned(v_px_i) mod 160) / 40) is
        when 0 => red_o   <= "1111";
        when 1 => green_o <= "1111";
        when 2 => blue_o  <= "1111";
        when 3 =>
          red_o   <= "1111";
          green_o <= "1111";
          blue_o  <= "1111";
        when others =>
          red_o   <= "0000";
          green_o <= "0000";
          blue_o  <= "0000";
      end case;
    end if;
  end process p_process;

end architecture rtl;
