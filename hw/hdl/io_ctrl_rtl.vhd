--------------------------------------------------------------------------------
-- Title : IO Control RTL Architecture
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : io_ctrl_rtl.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 30.03.2020
-- Platform : ModelSim - Starter Edition 10.5b
--------------------------------------------------------------------------------
-- Description: IO Control Unit
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 30.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of io_ctrl is

  constant C_COUNTER_PRELOAD : std_logic_vector (14 downto 0) := std_logic_vector(to_unsigned(24999, 15));

  signal s_en : std_logic;

begin

  p_en: process(rst_i, clk_i)

    variable v_counter : std_logic_vector (14 downto 0);

  begin

    if rst_i = '1' then

      s_en <= '0';
      v_counter := (others => '0');

    elsif clk_i'event and (clk_i = '1') then

      if v_counter = std_logic_vector(to_unsigned(0, v_counter'length)) then
        v_counter := C_COUNTER_PRELOAD;
        s_en <= '1';
      else
        v_counter := std_logic_vector(unsigned(v_counter) - 1);
        s_en <= '0';
      end if;

    end if;

  end process p_en;

  p_debounce: process(rst_i, clk_i)

    variable v_ff0   : std_logic_vector (5 downto 0);
    variable v_ff1   : std_logic_vector (5 downto 0);
    variable v_set   : std_logic_vector (5 downto 0);
    variable v_clear : std_logic_vector (5 downto 0);
    variable v_sync  : std_logic_vector (5 downto 0);

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
        v_ff0 (1 downto 0) := sw_i;
        v_ff0 (5 downto 2) := pb_i;

        v_set := v_ff0 and v_ff1;
        v_clear := (not v_ff0) and (not v_ff1);

        v_sync := (v_sync and (not v_clear)) or v_set;

        sw_sync_o <= v_sync (1 downto 0);
        pb_sync_o <= v_sync (5 downto 2);

      end if;

    end if;

  end process p_debounce;

end architecture rtl;
