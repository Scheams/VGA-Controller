--------------------------------------------------------------------------------
-- Title :      Pattern Generator 1 (RTL Architecture)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       pattern_gen1_rtl.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 14.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b, Vivado 2019.2
-- Language:    VHDL 1076-2002
--------------------------------------------------------------------------------
-- Description: The "Pattern Generator 1" unit creates a defined pattern for
--              the VGA controller. The generator creates horizontal stripes
--              with Red-Green-Blue-Black order.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 09.03.2020   v1.0.0   Christoph Amon   Initial stage
-- 01.04.2020   v1.0.1   Christoph Amon   Swap horizontal-vertical
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of pattern_gen1 is

  ------------------------------------------------------------------------------
  -- CONSTANTS
  ------------------------------------------------------------------------------

  -- C_STRIPE_WIDTH: Width in pixel of each horizontal stripe
  constant C_STRIPE_WIDTH : integer := g_specs.px_h.visible_area / 16;

  ------------------------------------------------------------------------------
  -- SIGNALS
  ------------------------------------------------------------------------------

  -- s_prev_px: Storage for previous pixel information
  -- s_counter: Step-down counter for stripe width
  -- s_colour: Maps colours with one-hot encoding
  --           0001 -> Red, 0010 -> Green, 0100 -> Blue, 1000 -> Black
  signal s_prev_px : std_logic_vector (g_specs.addr.n_h-1 downto 0);
  signal s_counter : natural range 0 to C_STRIPE_WIDTH;
  signal s_colour  : unsigned (3 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Step-down counter which ticks every time the horizontal pixel information
  -- changes. After a defined width it changes the colour via a variable.
  -- Each new line the counter gets reset in case 16 * C_STRIPE_WIDTH is not
  -- equal to i_h_res.
  ------------------------------------------------------------------------------
  p_counter: process (rst_i, clk_i)
  begin
    -- Preload counter, set colour to red and set previous pixel to invalid
    if rst_i = '1' then
      s_counter <= C_STRIPE_WIDTH - 1;
      s_colour <= "0001";
      s_prev_px <= (others => '1');

    elsif clk_i'event and (clk_i = '1') then
      -- Only process counter if pixel information changed
      if h_px_i /= s_prev_px then

        -- Always reset at first column
        if h_px_i = std_logic_vector(to_unsigned(0, h_px_i'length)) then
          s_counter <= C_STRIPE_WIDTH - 1;
          s_colour <= "0001";

        -- Reload counter and shift rotate colour mapper variable
        elsif s_counter = 0 then
          s_counter <= C_STRIPE_WIDTH - 1;
          s_colour <= rotate_left(s_colour, 1);

        -- Decrease counter
        else
          s_counter <= s_counter - 1;
        end if;
      end if;

      -- Store previous value
      s_prev_px <= h_px_i;
    end if;
  end process p_counter;

  ------------------------------------------------------------------------------
  -- Maps a output colour depending on the colour variable
  ------------------------------------------------------------------------------
  p_colour : process (s_colour)
  begin
    -- Map Red, Green, Blue and Black (White should never occur)
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
