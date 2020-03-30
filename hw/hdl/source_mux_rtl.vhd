--------------------------------------------------------------------------------
-- Title : Source MUX RTL Architecture
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : source_mux_rtl.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 30.03.2020
-- Platform : ModelSim - Starter Edition 10.5b
--------------------------------------------------------------------------------
-- Description: Source MUX Unit
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 30.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of source_mux is

begin

  p_mux: process (sw_sync_i)
  begin
    if sw_sync_i(2) = '1' then
      rgb_vga_o <= rgb_mem2_i;
    else
      case sw_sync_i (1 downto 0) is
        when "00" =>   rgb_vga_o <= rgb_pg1_i;
        when "01" =>   rgb_vga_o <= rgb_pg2_i;
        when others => rgb_vga_o <= rgb_mem1_i;
      end case;
    end if;
  end process p_mux;

end architecture rtl;
