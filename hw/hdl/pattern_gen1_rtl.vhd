--------------------------------------------------------------------------------
-- Title : Pattern Generator 1 RTL Architecture
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : pattern_gen1_rtl.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 09.03.2020
-- Platform : ModelSim - Starter Edition 10.5b
--------------------------------------------------------------------------------
-- Description: RTL architecture for Pattern Generator 1
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 09.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of pattern_gen1 is
begin

  ------------------------------------------------------------------------------
  -- Process to assign the currently selected pixel to a colour.
  -- For a 640 px wide display the PG1 outputs 40 px wide, horizontal lines with
  -- changing colours in this order: red-green-blue-black (4 times)
  ------------------------------------------------------------------------------
  p_process : process(v_px_i)
  begin
    -- Calculate horizontal lines: Red-Green-Blue-Black x4 (for 640 px)
    -- TODO: Check if this calculation takes too many resources. Maybe a
    -- if-switch works more reliable.
    case to_integer((unsigned(v_px_i) mod 160) / 40) is
      when 0 =>           -- Red
        red_o   <= "1111";
        green_o <= "0000";
        blue_o  <= "0000";
      when 1 =>           -- Green
        red_o   <= "0000";
        green_o <= "1111";
        blue_o  <= "0000";
      when 2 =>           -- Blue
        red_o   <= "0000";
        green_o <= "0000";
        blue_o  <= "1111";
      when 3 =>           -- Black
        red_o   <= "1111";
        green_o <= "1111";
        blue_o  <= "1111";
      when others =>      -- White
        red_o   <= "0000";
        green_o <= "0000";
        blue_o  <= "0000";
    end case;
  end process p_process;

end architecture rtl;
