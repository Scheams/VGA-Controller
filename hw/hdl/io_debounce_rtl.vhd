--------------------------------------------------------------------------------
-- Title :      IO Debounce (RTL Architecture)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       io_debounce_rtl.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 01.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2008
--------------------------------------------------------------------------------
-- Description: The "IO Debounce" Unit is able to debounce switches and
--              pushbuttons. The debounce frequency can be set, the default
--              frequency is 1kHz. With this frequency the switches and buttons
--              go through a 2-stage-FF and therefore the synchronized outputs
--              get set or cleared.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 30.03.2020   v1.0.0   Christoph Amon   Initial stage
-- 01.04.2020   v2.0.0   Christoph Amon   From IO Control to IO Debounce Unit
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of io_debounce is

  constant C_PRELOAD : natural := (f_sys / f_debounce) - 1;

  signal s_counter : natural range 0 to C_PRELOAD;
  signal s_en : std_logic;

begin

  p_en: process(rst_i, clk_i)
  begin

    if rst_i = '1' then
      s_en <= '0';
      s_counter <= 0;

    elsif clk_i'event and (clk_i = '1') then
      if s_counter = 0 then
        s_counter <= C_PRELOAD;
        s_en <= '1';
      else
        s_counter <= s_counter - 1;
        s_en <= '0';
      end if;
    end if;

  end process p_en;

  p_debounce: process(rst_i, clk_i)

    variable v_ff0   : std_logic_vector (n_sw+n_pb-1 downto 0);
    variable v_ff1   : std_logic_vector (n_sw+n_pb-1 downto 0);
    variable v_set   : std_logic_vector (n_sw+n_pb-1 downto 0);
    variable v_clear : std_logic_vector (n_sw+n_pb-1 downto 0);
    variable v_sync  : std_logic_vector (n_sw+n_pb-1 downto 0);

  begin

    if rst_i = '1' then

      sw_sync_o <= (others => '0');
      pb_sync_o <= (others => '0');

      v_ff0   := (others => '0');
      v_ff1   := (others => '0');
      v_set   := (others => '0');
      v_clear := (others => '0');
      v_sync  := (others => '0');

    elsif clk_i'event and (clk_i = '1') then

      if s_en = '1' then

        v_ff1 := v_ff0;
        v_ff0 := (pb_i, sw_i);

        v_set := v_ff0 and v_ff1;
        v_clear := (not v_ff0) and (not v_ff1);

        v_sync := (v_sync and (not v_clear)) or v_set;

        (pb_sync_o, sw_sync_o) <= v_sync;

      end if;

    end if;

  end process p_debounce;

end architecture rtl;
