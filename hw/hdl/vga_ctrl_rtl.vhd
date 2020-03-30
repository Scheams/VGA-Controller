--------------------------------------------------------------------------------
-- Title : VGA Control RTL Architecture
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : vga_ctrl_rtl.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 30.03.2020
-- Platform : ModelSim - Starter Edition 10.5b
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

architecture rtl of vga_ctrl is

  signal s_line_cnt   : std_logic_vector (9 downto 0);
  signal s_px_cnt     : std_logic_vector (9 downto 0);
  signal s_px_y       : std_logic_vector (9 downto 0);
  signal s_px_x       : std_logic_vector (9 downto 0);

  type t_h_stage is (S_H_IDLE, S_H_SYNC, S_H_BACKPORCH, S_H_DATA, S_H_FRONTPORCH);
  type t_v_stage is (S_V_IDLE, S_V_SYNC, S_V_BACKPORCH, S_V_VISIBLE, S_VFRONTPORCH);

  signal s_h_state : t_h_stage;
  signal s_v_state : t_v_stage;

begin

  p_v_sync: process (rst_i, clk_i)
  begin

    if rst_i = '1' then

      s_line_cnt <= (others => '0');
      s_px_cnt <= (others => '0');
      px_y_o <= (others => '0');
      px_x_o <= (others => '0');

    elsif clk_i'event and (clk_i = '1') then

      h_sync_o <= '0';
      v_sync_o <= '0';

      red_o <= (others => '0');
      green_o <= (others => '0');
      blue_o <= (others => '0');

      s_h_state <= S_H_IDLE;
      s_v_state <= S_V_IDLE;

      s_px_cnt <= std_logic_vector(unsigned(s_px_cnt) + 1);

      if unsigned(s_px_cnt) < to_unsigned(96, s_px_cnt'length) then
        -- H Sync Pulse
        h_sync_o <= '1';
        s_h_state <= S_H_SYNC;

      elsif unsigned(s_px_cnt) < to_unsigned(96 + 48, s_px_cnt'length) then
        -- H Back Porch
        s_h_state <= S_H_BACKPORCH;

      elsif unsigned(s_px_cnt) < to_unsigned(96 + 48 + 640, s_px_cnt'length) then
        -- Data
        px_x_o <= std_logic_vector(unsigned(s_px_cnt) - (96 + 48));
        s_h_state <= S_H_DATA;
        if s_v_state = S_V_VISIBLE then
          red_o <= rgb_i (3 downto 0);
          green_o <= rgb_i (7 downto 4);
          blue_o <= rgb_i (11 downto 8);
        end if;

      elsif unsigned(s_px_cnt) < to_unsigned(96 + 48 + 640 + 16, s_px_cnt'length) then
        -- H Front Porch
        s_h_state <= S_H_FRONTPORCH;

        if s_px_cnt = std_logic_vector(to_unsigned(96 + 48 + 640 + 16 - 1, s_px_cnt'length)) then
          s_px_cnt <= (others => '0');
          s_line_cnt <= std_logic_vector(unsigned(s_line_cnt) + 1);
        end if;

      else
        s_px_cnt <= (others => '0');
        s_line_cnt <= std_logic_vector(unsigned(s_line_cnt) + 1);
      end if;

      if unsigned(s_line_cnt) < to_unsigned(2, s_line_cnt'length) then
        -- V Sync Pulse
        v_sync_o <= '1';
        s_v_state <= S_V_SYNC;

      elsif unsigned(s_line_cnt) < to_unsigned(2 + 33, s_line_cnt'length) then
        -- V Back Porch
        s_v_state <= S_V_BACKPORCH;

      elsif unsigned(s_line_cnt) < to_unsigned(2 + 33 + 480, s_line_cnt'length) then
        -- Visible Area
        px_y_o <= std_logic_vector(unsigned(s_line_cnt) - (2 + 33));
        s_v_state <= S_V_VISIBLE;

      elsif unsigned(s_line_cnt) < to_unsigned(2 + 33 + 480 + 10, s_line_cnt'length) then
        -- V Front Porch
        s_v_state <= S_VFRONTPORCH;

        if s_line_cnt = std_logic_vector(to_unsigned(2 + 33 + 480 + 10 - 1, s_line_cnt'length)) and
           s_px_cnt = std_logic_vector(to_unsigned(96 + 48 + 640 + 16 - 1, s_px_cnt'length)) then
          s_line_cnt <= (others => '0');
        end if;
      else
        s_line_cnt <= (others => '0');
      end if;

    end if;

  end process p_v_sync;

end architecture rtl;
