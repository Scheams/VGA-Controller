--------------------------------------------------------------------------------
-- Title : VGA Control RTL Architecture
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : vga_ctrl_rtl.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 31.03.2020
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

  constant C_H_SYNC_CMP_VAL : std_logic_vector (n_px-1 downto 0) :=
    std_logic_vector(to_unsigned(h_px_sync_pulse, n_px));
  constant C_H_BACKPORCH_CMP_VAL : std_logic_vector (n_px-1 downto 0) :=
    std_logic_vector(to_unsigned(h_px_back_porch, n_px));
  constant C_H_DATA_CMP_VAL : std_logic_vector (n_px-1 downto 0) :=
    std_logic_vector(to_unsigned(h_px_visible_area, n_px));
  constant C_H_FRONTPORCH_CMP_VAL : std_logic_vector (n_px-1 downto 0) :=
    std_logic_vector(to_unsigned(h_px_front_porch, n_px));

  constant C_V_SYNC_CMP_VAL : std_logic_vector (n_px-1 downto 0) :=
    std_logic_vector(to_unsigned(v_ln_sync_pulse, n_px));
  constant C_V_BACKPORCH_CMP_VAL : std_logic_vector (n_px-1 downto 0) :=
    std_logic_vector(to_unsigned(v_ln_back_porch, n_px));
  constant C_V_DATA_CMP_VAL : std_logic_vector (n_px-1 downto 0) :=
    std_logic_vector(to_unsigned(v_ln_visible_area, n_px));
  constant C_V_FRONTPORCH_CMP_VAL : std_logic_vector (n_px-1 downto 0) :=
    std_logic_vector(to_unsigned(v_ln_front_porch, n_px));

  signal s_v_counter : std_logic_vector (n_px-1 downto 0);
  signal s_h_counter : std_logic_vector (n_px-1 downto 0);

  signal s_h_state : t_state;
  signal s_v_state : t_state;

begin

  p_horizontal: process (rst_i, clk_i)
    variable v_v_counter : std_logic_vector (n_px-1 downto 0);
    variable v_h_counter : std_logic_vector (n_px-1 downto 0);
  begin

    if rst_i = '1' then

      h_sync_o <= '0';
      v_sync_o <= '0';

      s_h_state <= S_IDLE;
      s_v_state <= S_IDLE;

      s_v_counter <= (others => '0');
      s_h_counter <= (others => '0');

      v_v_counter := (others => '0');
      v_h_counter := (others => '0');

    elsif clk_i'event and (clk_i = '1') then

      h_sync_o <= '0';
      v_sync_o <= '0';

      v_h_counter := std_logic_vector(unsigned(v_h_counter) + 1);

      case s_h_state is

        when S_SYNC =>
          if v_h_counter = C_H_SYNC_CMP_VAL then
            s_h_state <= S_BACKPORCH;
            v_h_counter := (others => '0');
          end if;

        when S_BACKPORCH =>
          if v_h_counter = C_H_BACKPORCH_CMP_VAL then
            s_h_state <= S_DATA;
            v_h_counter := (others => '0');
          end if;

        when S_DATA =>
          if v_h_counter = C_H_DATA_CMP_VAL then
            s_h_state <= S_FRONTPORCH;
            v_h_counter := (others => '0');
          end if;

        when S_FRONTPORCH =>
          if v_h_counter = C_H_FRONTPORCH_CMP_VAL then
            s_h_state <= S_SYNC;
            v_h_counter := (others => '0');
            v_v_counter := std_logic_vector(unsigned(v_v_counter) + 1);
          end if;

        when others =>
          s_h_state <= S_SYNC;
          v_h_counter := (others => '0');

      end case;

      case s_v_state is

        when S_SYNC =>
          if v_v_counter = C_V_SYNC_CMP_VAL then
            s_v_state <= S_BACKPORCH;
            v_v_counter := (others => '0');
          end if;

        when S_BACKPORCH =>
          if v_v_counter = C_V_BACKPORCH_CMP_VAL then
            s_v_state <= S_DATA;
            v_v_counter := (others => '0');
          end if;

        when S_DATA =>
          if v_v_counter = C_V_DATA_CMP_VAL then
            s_v_state <= S_FRONTPORCH;
            v_v_counter := (others => '0');
          end if;

        when S_FRONTPORCH =>
          if v_v_counter = C_V_FRONTPORCH_CMP_VAL then
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

    if s_h_state = S_DATA and s_v_state = S_DATA then
      red_o <= red_i;
      green_o <= green_i;
      blue_o <= blue_i;
      px_x_o <= s_h_counter;
      px_y_o <= s_v_counter;
    else
      red_o <= (others => '0');
      green_o <= (others => '0');
      blue_o <= (others => '0');
      px_x_o <= (others => '0');
      px_y_o <= (others => '0');
    end if;

  end process p_rgb;

end architecture rtl;
