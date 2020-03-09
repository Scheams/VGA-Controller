--------------------------------------------------------------------------------
-- Title : Pattern Generator 1 Testbench
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : pattern_gen1_tb.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 09.03.2020
-- Platform : ModelSim - Starter Edition 10.5b
--------------------------------------------------------------------------------
-- Description: Testbench for Pattern Generator 1
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 09.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pattern_gen1_tb is
end entity pattern_gen1_tb;

architecture sim of pattern_gen1_tb is

  -- Define pattern generator 1 component
  component pattern_gen1 is
    port (
      v_px_i  : in  std_logic_vector (9 downto 0);
      h_px_i  : in  std_logic_vector (9 downto 0);

      red_o   : out std_logic_vector (3 downto 0);
      green_o : out std_logic_vector (3 downto 0);
      blue_o  : out std_logic_vector (3 downto 0)
    );
  end component pattern_gen1;

  -- Define a typedef for better readablity during debugging
  type t_colour is (RED, GREEN, BLUE, BLACK, WHITE, UNKOWN);

  -- All signals to the device under test
  signal s_v_px_i  : std_logic_vector (9 downto 0) := (others => '0');
  signal s_h_px_i  : std_logic_vector (9 downto 0) := (others => '0');
  signal s_red_o   : std_logic_vector (3 downto 0);
  signal s_green_o : std_logic_vector (3 downto 0);
  signal s_blue_o  : std_logic_vector (3 downto 0);

  -- Signal for colour information
  signal s_colour  : t_colour;

begin

  -- Initialize device under test
  u_dut : pattern_gen1
  port map (
    v_px_i  => s_v_px_i,
    h_px_i  => s_h_px_i,
    red_o   => s_red_o,
    green_o => s_green_o,
    blue_o  => s_blue_o
  );

  ------------------------------------------------------------------------------
  -- Map the RGB outputs of DUT to a readable enum
  ------------------------------------------------------------------------------
  p_map_colour : process (s_red_o, s_green_o, s_blue_o)
  begin
    if (s_red_o = "1111") and (s_green_o = "0000") and (s_blue_o = "0000") then
      s_colour <= RED;
    elsif (s_red_o = "0000") and (s_green_o = "1111") and (s_blue_o="0000") then
      s_colour <= GREEN;
    elsif (s_red_o = "0000") and (s_green_o = "0000") and (s_blue_o="1111") then
      s_colour <= BLUE;
    elsif (s_red_o = "1111") and (s_green_o = "1111") and (s_blue_o="1111") then
        s_colour <= WHITE;
    elsif (s_red_o = "0000") and (s_green_o = "0000") and (s_blue_o="0000") then
      s_colour <= BLACK;
    else
      report "Colour is in undefined state (not Red, Green, Blue or Black)!"
        severity warning;
      s_colour <= UNKOWN;
    end if;
  end process p_map_colour;

  ------------------------------------------------------------------------------
  -- Increase vertical and horizontal pixel index
  ------------------------------------------------------------------------------
  p_sim : process
  begin
    -- Increment vertical px index
    s_v_px_i <= std_logic_vector(unsigned(s_v_px_i) + to_unsigned(1, 10));
    wait for 1 ns;

    -- Vertical px overflow
    if (s_v_px_i = std_logic_vector(to_unsigned(639, 10))) then

      -- Reset vertical px, increment horizontal px
      s_v_px_i <= (others => '0');
      s_h_px_i <= std_logic_vector(unsigned(s_h_px_i) + to_unsigned(1, 10));
      wait for 1 ns;

      -- Horizontal px overflow, reset
      if (s_h_px_i = std_logic_vector(to_unsigned(479, 10))) then
        s_h_px_i <= (others => '0');
      end if;
    end if;

  end process p_sim;

end architecture sim;
