--------------------------------------------------------------------------------
-- Title : VGA Control RTL Architecture
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : vga_ctrl_rtl.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 1.4.2020
-- Platform : ModelSim - Starter Edition 10.5b
-- Language: VHDL 1076-2008
--------------------------------------------------------------------------------
-- Description: VGA Control Unit
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 30.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.vga_ctrl_pkg.all;

architecture rtl of vga_ctrl is

  signal s_v_counter : unsigned (n_px-1 downto 0);
  signal s_h_counter : unsigned (n_px-1 downto 0);

  signal s_h_state : t_state;
  signal s_v_state : t_state;

begin

  p_horizontal: process (rst_i, clk_i)
    variable v_v_counter : unsigned (n_px-1 downto 0);
    variable v_h_counter : unsigned (n_px-1 downto 0);
  begin

    if rst_i = '1' then

      s_h_state <= S_IDLE;
      s_v_state <= S_IDLE;

      s_v_counter <= (others => '0');
      s_h_counter <= (others => '0');

      v_v_counter := (others => '0');
      v_h_counter := (others => '0');

    elsif clk_i'event and (clk_i = '1') then

      v_h_counter := v_h_counter + 1;

      case s_h_state is

        when S_SYNC =>
          if v_h_counter = to_unsigned(h_px_sync_pulse, n_px) then
            s_h_state <= S_BACKPORCH;
            v_h_counter := (others => '0');
          end if;

        when S_BACKPORCH =>
          if v_h_counter = to_unsigned(h_px_back_porch, n_px) then
            s_h_state <= S_DATA;
            v_h_counter := (others => '0');
          end if;

        when S_DATA =>
          if v_h_counter = to_unsigned(h_px_visible_area, n_px) then
            s_h_state <= S_FRONTPORCH;
            v_h_counter := (others => '0');
          end if;

        when S_FRONTPORCH =>
          if v_h_counter = to_unsigned(h_px_front_porch, n_px) then
            s_h_state <= S_SYNC;
            v_h_counter := (others => '0');
            v_v_counter := v_v_counter + 1;
          end if;

        when others =>
          s_h_state <= S_SYNC;
          v_h_counter := (others => '0');

      end case;

      case s_v_state is

        when S_SYNC =>
          if v_v_counter = to_unsigned(v_ln_sync_pulse, n_px) then
            s_v_state <= S_BACKPORCH;
            v_v_counter := (others => '0');
          end if;

        when S_BACKPORCH =>
          if v_v_counter = to_unsigned(v_ln_back_porch, n_px) then
            s_v_state <= S_DATA;
            v_v_counter := (others => '0');
          end if;

        when S_DATA =>
          if v_v_counter = to_unsigned(v_ln_visible_area, n_px) then
            s_v_state <= S_FRONTPORCH;
            v_v_counter := (others => '0');
          end if;

        when S_FRONTPORCH =>
          if v_v_counter = to_unsigned(v_ln_front_porch, n_px) then
            s_v_state <= S_SYNC;
            v_v_counter := (others => '0');
          end if;

        when others =>
          s_v_state <= S_SYNC;
          v_v_counter := (others => '0');

      end case;

      s_v_counter <= v_v_counter;
      s_h_counter <= v_h_counter;

    end if;

  end process p_horizontal;

  p_rgb: process (s_h_state, s_h_counter, s_v_state, s_v_counter)
  begin

    if s_h_state = S_SYNC then
      h_sync_o <= '1';
    else
      h_sync_o <= '0';
    end if;

    if s_v_state = S_SYNC then
      v_sync_o <= '1';
    else
      v_sync_o <= '0';
    end if;

    if s_v_state = S_DATA then
      px_y_o <= std_logic_vector(s_v_counter);
    else
      px_y_o <= (others => '0');
    end if;

    if s_h_state = S_DATA and s_v_state = S_DATA then
      red_o <= red_i;
      green_o <= green_i;
      blue_o <= blue_i;
      px_x_o <= std_logic_vector(s_h_counter);
    else
      red_o <= (others => '0');
      green_o <= (others => '0');
      blue_o <= (others => '0');
      px_x_o <= (others => '0');
    end if;

  end process p_rgb;

end architecture rtl;
