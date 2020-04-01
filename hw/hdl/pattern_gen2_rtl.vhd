--------------------------------------------------------------------------------
-- Title : Pattern Generator 2 RTL Architecture
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : pattern_gen2_rtl.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 29.03.2020
-- Platform : ModelSim - Starter Edition 10.5b
--------------------------------------------------------------------------------
-- Description: RTL architecture for Pattern Generator 2
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 29.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of pattern_gen2 is

  signal s_h_px_prev : std_logic_vector (9 downto 0);

  signal s_colour : std_logic_vector (2 downto 0);
  signal s_start_colour : std_logic_vector (2 downto 0);

begin

  p_ticker: process(rst_i, clk_i)

    variable v_v_cnt : std_logic_vector (9 downto 0);
    variable v_h_cnt : std_logic_vector (9 downto 0);

  begin
    if rst_i = '1' then

      v_v_cnt := (others => '0');
      v_h_cnt := (others => '0');
      s_h_px_prev <= (others => '1');
      s_colour <= "001";
      s_start_colour <= "001";

    elsif clk_i'event and (clk_i = '1') then

      if s_h_px_prev /= h_px_i then
        -- Every tick increase horizontal counter
        v_h_cnt := std_logic_vector(unsigned(v_h_cnt) + 1);

        -- Horizontal counter wraps over after 64 pixel, colour switches
        if v_h_cnt = std_logic_vector(to_unsigned(64, v_h_cnt'length)) then
          v_h_cnt := (others => '0');
          s_colour <= std_logic_vector(rotate_left(unsigned(s_colour), 1));
        end if;

        -- Horizontal pixel is at 1
        if h_px_i = std_logic_vector(to_unsigned(0, h_px_i'length)) then
          -- Increment vertical counter by 1
          v_v_cnt := std_logic_vector(unsigned(v_v_cnt) + 1);

          -- Vertical counter wraps over after 48 lines
          if v_v_cnt = std_logic_vector(to_unsigned(48, v_h_cnt'length)) then
            v_v_cnt := (others => '0');
            s_start_colour <= std_logic_vector(rotate_left(unsigned(s_start_colour), 1));
            s_colour <= std_logic_vector(rotate_left(unsigned(s_start_colour), 1));
          else
            -- Set start colour
            s_colour <= s_start_colour;
          end if;
        end if;
      end if;

      if v_px_i = std_logic_vector(to_unsigned(0, v_px_i'length))
          and h_px_i = std_logic_vector(to_unsigned(0, h_px_i'length)) then
        v_h_cnt := (others => '0');
        v_v_cnt := (others => '0');
        s_colour <= "001";
        s_start_colour <= "001";
      end if;

      s_h_px_prev <= h_px_i;

    end if;
  end process p_ticker;

  p_map: process(s_colour)
  begin
    case s_colour is
      when "001" =>
        red_o <= "1111";
        green_o <= "0000";
        blue_o <= "0000";

      when "010" =>
        red_o <= "0000";
        green_o <= "1111";
        blue_o <= "0000";

      when "100" =>
        red_o <= "0000";
        green_o <= "0000";
        blue_o <= "1111";

      when others =>
        red_o <= "0000";
        green_o <= "0000";
        blue_o <= "0000";

    end case;
  end process p_map;


end architecture rtl;
