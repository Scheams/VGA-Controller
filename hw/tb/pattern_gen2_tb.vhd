--------------------------------------------------------------------------------
-- Title : Pattern Generator 2 Testbench
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : pattern_gen2_tb.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 29.03.2020
-- Platform : ModelSim - Starter Edition 10.5b
--------------------------------------------------------------------------------
-- Description: Testbench for Pattern Generator 2
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 29.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pattern_gen2_tb is
end entity pattern_gen2_tb;

architecture sim of pattern_gen2_tb is

  -- Define pattern generator 2 component
  component pattern_gen2 is
    port (
      clk_i   : in  std_logic;
      rst_i   : in  std_logic;
      v_px_i  : in  std_logic_vector (9 downto 0);
      h_px_i  : in  std_logic_vector (9 downto 0);

      red_o   : out std_logic_vector (3 downto 0);
      green_o : out std_logic_vector (3 downto 0);
      blue_o  : out std_logic_vector (3 downto 0)
    );
  end component pattern_gen2;

  -- Define a typedef for better readablity during debugging
  type t_colour is (RED, GREEN, BLUE, UNKOWN);

  -- All signals to the device under test
  signal s_clk_i   : std_logic := '1';
  signal s_rst_i   : std_logic := '1';
  signal s_v_px_i  : std_logic_vector (9 downto 0) := (others => '1');
  signal s_h_px_i  : std_logic_vector (9 downto 0) := (others => '1');
  signal s_red_o   : std_logic_vector (3 downto 0);
  signal s_green_o : std_logic_vector (3 downto 0);
  signal s_blue_o  : std_logic_vector (3 downto 0);

  -- Signal for colour information
  signal s_colour  : t_colour;

  signal s_v_back_porch  : std_logic := '0';
  signal s_v_front_porch : std_logic := '0';
  signal s_h_back_porch  : std_logic := '0';
  signal s_h_front_porch : std_logic := '0';

begin

  -- Initialize device under test
  u_dut : pattern_gen2
  port map (
    clk_i   => s_clk_i,
    rst_i   => s_rst_i,
    v_px_i  => s_v_px_i,
    h_px_i  => s_h_px_i,
    red_o   => s_red_o,
    green_o => s_green_o,
    blue_o  => s_blue_o
  );

  s_rst_i <= '0' after 20 ns;
  s_clk_i <= not s_clk_i after 20 ns;

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
    else
      report "Colour is in undefined state (not Red, Green or Blue)!"
        severity warning;
      s_colour <= UNKOWN;
    end if;
  end process p_map_colour;

  p_sim: process
  begin

    wait for 40 ns;

    loop

      -- V Back Porch
      s_v_back_porch <= '1';
      for i in 1 to 26400 loop
        wait for 40 ns;
      end loop;
      s_v_back_porch <= '0';

      -- Lines
      for y in 1 to 480 loop

        -- H Sync + Back Porch
        s_h_back_porch <= '1';
        for i in 1 to 144 loop
          wait for 40 ns;
        end loop;
        s_h_back_porch <= '0';

        s_v_px_i <= std_logic_vector(to_signed(y, s_v_px_i'length));

        -- RGB Data
        for x in 1 to 640 loop
          s_h_px_i <= std_logic_vector(to_signed(x, s_h_px_i'length));
          wait for 40 ns;
        end loop;

        -- H Front Porch
        s_h_front_porch <= '1';
        for i in 1 to 16 loop
          wait for 40 ns;
        end loop;
        s_h_front_porch <= '0';

      end loop;

      -- V Front Porch
      s_v_front_porch <= '1';
      for i in 1 to 8000 loop
        wait for 40 ns;
      end loop;
      s_v_front_porch <= '0';

    end loop;

  end process p_sim;

end architecture sim;
