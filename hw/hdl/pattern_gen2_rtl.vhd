--------------------------------------------------------------------------------
-- Title :      Pattern Generator 2 (RTL Architecture)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       pattern_gen2_rtl.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 02.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2008
--------------------------------------------------------------------------------
-- Description: The "Pattern Generator 2" unit creates a chess-like format with
--              the colours Red-Green-Blue. Over the whole frame there are
--              10 x 10 tiles.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 29.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of pattern_gen2 is

  ------------------------------------------------------------------------------
  -- CONSTANTS
  ------------------------------------------------------------------------------

  -- C_TILE_WIDTH: Pixel width of each tile
  -- C_TILE_HEIGHT: Pixel width of each tile
  constant C_TILE_WIDTH  : natural := i_h_res / 10;
  constant C_TILE_HEIGHT : natural := i_v_res / 10;

  ------------------------------------------------------------------------------
  -- SIGNALS
  ------------------------------------------------------------------------------

  -- s_h_px_prev: Storage for previous horizontal pixel information
  -- s_colour: Colour information in one-hot encoding
  --           (001 -> Red, 010 -> Green, 100 -> Blue)
  -- s_start_colour: Start colour for each line
  signal s_h_px_prev    : std_logic_vector (n_px-1 downto 0);
  signal s_colour       : unsigned (2 downto 0);
  signal s_start_colour : unsigned (2 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Two counters work together to create a chess-like image. Counters only
  -- proceed when horizontal pixel information has changed.
  ------------------------------------------------------------------------------
  p_process: process (rst_i, clk_i)

    -- v_h_cnt: Counter for horizontal pixels
    -- v_v_cnt: Counter for vertical pixels
    variable v_h_cnt : natural range 0 to i_h_res;
    variable v_v_cnt : natural range 0 to i_v_res;

  begin

    -- Reset counters and colours
    if rst_i = '1' then
      v_v_cnt := 0;
      v_h_cnt := 0;
      s_h_px_prev <= (others => '1');
      s_colour <= "001";
      s_start_colour <= "001";

    elsif clk_i'event and (clk_i = '1') then

      -- Increase counter only if pixel changed
      if s_h_px_prev /= h_px_i then
        v_h_cnt := v_h_cnt + 1;

        -- Horizontal counter wraps over at tile width, colour switches
        if v_h_cnt = C_TILE_WIDTH then
          v_h_cnt := 0;
          s_colour <= rotate_left(s_colour, 1);
        end if;

        -- Horizontal pixel is at 0
        if unsigned(h_px_i) = 0 then
          -- Increment vertical counter by 1, reset horizontal counter
          v_v_cnt := v_v_cnt + 1;
          v_h_cnt := 0;

          -- Vertical counter wraps over at tile height, start colour changes
          if v_v_cnt = C_TILE_HEIGHT then
            v_v_cnt := 0;
            s_start_colour <= rotate_left(s_start_colour, 1);
            s_colour <= rotate_left(s_start_colour, 1);
          else
            -- Set start colour
            s_colour <= s_start_colour;
          end if;
        end if;
      end if;

      -- Reset all states at begin of frame
      if unsigned(v_px_i) = 0 and unsigned(h_px_i) = 0 then
        v_h_cnt := 0;
        v_v_cnt := 0;
        s_colour <= "001";
        s_start_colour <= "001";
      end if;

      -- Set previous pixel info
      s_h_px_prev <= h_px_i;
    end if;
  end process p_process;

  ------------------------------------------------------------------------------
  -- Map colour variable to a viable output: Red, Green or Blue. Black
  -- shouldn't occur.
  ------------------------------------------------------------------------------
  p_map: process (s_colour)
  begin
    case s_colour is
      when "001" =>      -- Red
        red_o   <= (others => '1');
        green_o <= (others => '0');
        blue_o  <= (others => '0');
      when "010" =>      -- Green
        red_o   <= (others => '0');
        green_o <= (others => '1');
        blue_o  <= (others => '0');
      when "100" =>      -- Blue
        red_o   <= (others => '0');
        green_o <= (others => '0');
        blue_o  <= (others => '1');
      when others =>      -- Black
        red_o   <= (others => '0');
        green_o <= (others => '0');
        blue_o  <= (others => '0');
    end case;
  end process p_map;

end architecture rtl;
