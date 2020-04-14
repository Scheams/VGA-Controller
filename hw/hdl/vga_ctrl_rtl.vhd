--------------------------------------------------------------------------------
-- Title :      VGA Control (RTL Architecture)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       vga_ctrl_rtl.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 14.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b, Vivado 2019.2
-- Language:    VHDL 1076-2008
--------------------------------------------------------------------------------
-- Description: The "VGA Control" unit controlls the hardware operation that
--              is transfered through the VGA cable to the monitor. It takes
--              input signals like the colour information and monitor
--              specifications to perform this action.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 30.03.2020   v1.0.0   Christoph Amon   Initial stage
-- 04.04.2020   v1.1.0   Christoph Amon   Add enable signal
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.vga_ctrl_pkg.all;
use work.vga_specs_pkg.all;

architecture rtl of vga_ctrl is

  ------------------------------------------------------------------------------
  -- SIGNALS
  ------------------------------------------------------------------------------

  -- s_v_counter: Counter for vertical timing
  -- s_h_counter: Counter for horizontal timing
  signal s_v_counter : unsigned (g_specs.addr.n_v-1 downto 0);
  signal s_h_counter : unsigned (g_specs.addr.n_h-1 downto 0);

  -- s_h_state: State for each line
  -- s_v_state: State for each frame
  signal s_h_state : t_state;
  signal s_v_state : t_state;

begin

  ------------------------------------------------------------------------------
  -- Go through all horizontal and vertical VGA control stages according to
  -- monitor specs.
  ------------------------------------------------------------------------------
  p_horizontal: process (rst_i, clk_i)
    -- v_v_counter: Vertical counter which gets assigned to outer signal
    -- v_h_counter: Horizontal counter which gets assigned to outer signal
    variable v_v_counter : unsigned (g_specs.addr.n_v-1 downto 0);
    variable v_h_counter : unsigned (g_specs.addr.n_h-1 downto 0);
  begin

    -- Reset internal states
    if rst_i = '1' then

      s_h_state <= S_IDLE;
      s_v_state <= S_IDLE;

      s_v_counter <= (others => '0');
      s_h_counter <= (others => '0');

      v_v_counter := (others => '0');
      v_h_counter := (others => '0');

    elsif clk_i'event and (clk_i = '1') then

      -- Only process if controller is enabled
      if enable_i = '1' then

        -- Increase counter every clock cycle
        v_h_counter := v_h_counter + 1;

        -- Go through all horizontal stages according to sepcs
        case s_h_state is

          when S_SYNC =>
            if v_h_counter = g_specs.px_h.sync_pulse then
              s_h_state <= S_BACKPORCH;
              v_h_counter := (others => '0');
            end if;

          when S_BACKPORCH =>
            if v_h_counter = g_specs.px_h.back_porch then
              s_h_state <= S_DATA;
              v_h_counter := (others => '0');
            end if;

          when S_DATA =>
            if v_h_counter = g_specs.px_h.visible_area then
              s_h_state <= S_FRONTPORCH;
              v_h_counter := (others => '0');
            end if;

          when S_FRONTPORCH =>
            if v_h_counter = g_specs.px_h.front_porch then
              s_h_state <= S_SYNC;
              v_h_counter := (others => '0');
              -- Increase vertical counter
              v_v_counter := v_v_counter + 1;
            end if;

          when others =>
            s_h_state <= S_SYNC;
            v_h_counter := (others => '0');

        end case;

        -- Go through all vertical stages according to specs
        case s_v_state is

          when S_SYNC =>
            if v_v_counter = g_specs.ln_v.sync_pulse then
              s_v_state <= S_BACKPORCH;
              v_v_counter := (others => '0');
            end if;

          when S_BACKPORCH =>
            if v_v_counter = g_specs.ln_v.back_porch then
              s_v_state <= S_DATA;
              v_v_counter := (others => '0');
            end if;

          when S_DATA =>
            if v_v_counter = g_specs.ln_v.visible_area then
              s_v_state <= S_FRONTPORCH;
              v_v_counter := (others => '0');
            end if;

          when S_FRONTPORCH =>
            if v_v_counter = g_specs.ln_v.front_porch then
              s_v_state <= S_SYNC;
              v_v_counter := (others => '0');
            end if;

          when others =>
            s_v_state <= S_SYNC;
            v_v_counter := (others => '0');

        end case;

        -- Assign process variables to architecture signals
        s_v_counter <= v_v_counter;
        s_h_counter <= v_h_counter;

      else
        -- Reset values if controller not enabled
        s_h_state <= S_IDLE;
        s_v_state <= S_IDLE;

        s_v_counter <= (others => '0');
        s_h_counter <= (others => '0');

        v_v_counter := (others => '0');
        v_h_counter := (others => '0');
      end if;
    end if;

  end process p_horizontal;

  ------------------------------------------------------------------------------
  -- Control output signals according to current states of horizontal and
  -- vertical stages
  ------------------------------------------------------------------------------
  p_rgb: process (s_h_state, s_h_counter, s_v_state, s_v_counter, red_i, green_i, blue_i)
  begin

    -- Create H sync pulse
    if s_h_state = S_SYNC then
      h_sync_o <= '1';
    else
      h_sync_o <= '0';
    end if;

    -- Create V sync pulse
    if s_v_state = S_SYNC then
      v_sync_o <= '1';
    else
      v_sync_o <= '0';
    end if;

    -- Output vertical pixel index during data stage
    if s_v_state = S_DATA then
      px_v_o <= std_logic_vector(s_v_counter);
    else
      px_v_o <= (others => '0');
    end if;

    -- Output horizontal pixel index and RGB data during visible area
    if s_h_state = S_DATA and s_v_state = S_DATA then
      red_o <= red_i;
      green_o <= green_i;
      blue_o <= blue_i;
      px_h_o <= std_logic_vector(s_h_counter);
    else
      red_o <= (others => '0');
      green_o <= (others => '0');
      blue_o <= (others => '0');
      px_h_o <= (others => '0');
    end if;

  end process p_rgb;

end architecture rtl;
