--------------------------------------------------------------------------------
-- Title :      Pattern Generator 1 (RTL Architecture)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       pattern_gen1_rtl.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 01.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2008
--------------------------------------------------------------------------------
-- Description: The "Pattern Generator 1" unit creates a defined pattern for
--              the VGA controller. The generator creates horizontal stripes
--              with Red-Green-Blue-Black order.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 09.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of pattern_gen1 is

  constant C_STRIPE_WIDTH : integer := monitor_width / 16;

  signal s_prev_px : std_logic_vector (n_px-1 downto 0);
  signal s_counter : natural;
  signal s_colour  : unsigned (3 downto 0);

begin

  p_counter: process (rst_i, clk_i)
  begin
    if rst_i = '1' then
      s_counter <= C_STRIPE_WIDTH - 1;
      s_colour <= "0001";
      s_prev_px <= (others => '1');

    elsif clk_i'event and (clk_i = '1') then

      if v_px_i /= s_prev_px then
        if v_px_i = std_logic_vector(to_unsigned(0, v_px_i'length)) then
          s_counter <= C_STRIPE_WIDTH - 1;
          s_colour <= "0001";
        elsif s_counter = 0 then
          s_counter <= C_STRIPE_WIDTH - 1;
          s_colour <= rotate_left(s_colour, 1);
        else
          s_counter <= s_counter - 1;
        end if;
      end if;

      s_prev_px <= v_px_i;

    end if;

  end process p_counter;

  p_colour : process(v_px_i)
  begin
    case s_colour is
      when "0001" =>      -- Red
        red_o   <= (others => '1');
        green_o <= (others => '0');
        blue_o  <= (others => '0');
      when "0010" =>      -- Green
        red_o   <= (others => '0');
        green_o <= (others => '1');
        blue_o  <= (others => '0');
      when "0100" =>      -- Blue
        red_o   <= (others => '0');
        green_o <= (others => '0');
        blue_o  <= (others => '1');
      when "1000" =>      -- Black
        red_o   <= (others => '0');
        green_o <= (others => '0');
        blue_o  <= (others => '0');
      when others =>      -- White
        red_o   <= (others => '1');
        green_o <= (others => '1');
        blue_o  <= (others => '1');
    end case;
  end process p_colour;

end architecture rtl;
