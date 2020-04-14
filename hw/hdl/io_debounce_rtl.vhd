--------------------------------------------------------------------------------
-- Title :      IO Debounce (RTL Architecture)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       io_debounce_rtl.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 14.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b, Vivado 2019.2
-- Language:    VHDL 1076-2002
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

  ------------------------------------------------------------------------------
  -- CONSTANTS
  ------------------------------------------------------------------------------

  -- C_PRELOAD: Preload value for counter
  constant C_PRELOAD : natural := (f_sys / f_debounce) - 1;

  ------------------------------------------------------------------------------
  -- SIGNALS
  ------------------------------------------------------------------------------

  -- s_en: Enable signal for debouncing
  -- s_counter: Counter for enable signal
  signal s_en       : std_logic;
  signal s_counter  : natural range 0 to C_PRELOAD;

begin

  ------------------------------------------------------------------------------
  -- This process creates a enable signal with a smaller frequency for the
  -- debouncing process. It uses a step down counter.
  ------------------------------------------------------------------------------
  p_en: process(rst_i, clk_i)
  begin
    -- Reset counter
    if rst_i = '1' then
      s_en <= '0';
      s_counter <= 0;

    elsif clk_i'event and (clk_i = '1') then
      -- Set enable signal for one clock cycle and reload counter
      if s_counter = 0 then
        s_counter <= C_PRELOAD;
        s_en <= '1';

      -- Decrease counter
      else
        s_counter <= s_counter - 1;
        s_en <= '0';
      end if;
    end if;
  end process p_en;

  ------------------------------------------------------------------------------
  -- Debounce the input signals. The process uses a 2-stage flip-flop and
  -- sets or clears the bits for the output signals
  ------------------------------------------------------------------------------
  p_debounce: process(rst_i, clk_i)

    variable v_ff0   : std_logic_vector (n_sw+n_pb-1 downto 0);
    variable v_ff1   : std_logic_vector (n_sw+n_pb-1 downto 0);
    variable v_set   : std_logic_vector (n_sw+n_pb-1 downto 0);
    variable v_clear : std_logic_vector (n_sw+n_pb-1 downto 0);
    variable v_sync  : std_logic_vector (n_sw+n_pb-1 downto 0);

  begin
    -- Reset all variables
    if rst_i = '1' then
      sw_sync_o <= (others => '0');
      pb_sync_o <= (others => '0');

      v_ff0   := (others => '0');
      v_ff1   := (others => '0');
      v_set   := (others => '0');
      v_clear := (others => '0');
      v_sync  := (others => '0');

    elsif clk_i'event and (clk_i = '1') then
      -- Only process if enable signal active
      if s_en = '1' then
        -- Go through a 2-stage FF (push-buttons and switches get combined)
        v_ff1 := v_ff0;
        v_ff0 (n_pb-1 downto 0) := pb_i;
        v_ff0 (n_pb+n_sw-1 downto n_pb) := sw_i;

        -- Create a set and clear mask
        v_set := v_ff0 and v_ff1;
        v_clear := (not v_ff0) and (not v_ff1);

        -- Create output bits
        v_sync := (v_sync and (not v_clear)) or v_set;

        -- Split up into push-buttons and switches
        pb_sync_o <= v_sync (n_pb-1 downto 0);
        sw_sync_o <= v_sync (n_pb+n_sw-1 downto n_pb);
      end if;
    end if;
  end process p_debounce;

end architecture rtl;
