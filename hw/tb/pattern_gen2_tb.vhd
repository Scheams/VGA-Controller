--------------------------------------------------------------------------------
-- Title :      Pattern Generator 2 (Testbench)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       pattern_gen2_tb.vhd
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

entity pattern_gen2_tb is
end entity pattern_gen2_tb;

architecture sim of pattern_gen2_tb is

  ------------------------------------------------------------------------------
  -- CONSTANTS
  ------------------------------------------------------------------------------

  -- C_N_COLOUR: Bit width of one colour
  -- C_N_PX: Bit width for pixel information bus
  -- C_I_H_RES: Pixel width of monitor
  -- C_I_V_RES: Pixel height of monitor
  -- C_T: Period for one clock cycle
  constant C_N_COLOUR : integer := 4;
  constant C_N_PX     : integer := 10;
  constant C_I_H_RES  : integer := 640;
  constant C_I_V_RES  : integer := 480;
  constant C_T        : time    := 40 ns;

  ------------------------------------------------------------------------------
  -- COMPONENTS
  ------------------------------------------------------------------------------

  component pattern_gen2 is
    generic (
      n_colour  : integer;
      n_px      : integer;
      i_h_res   : integer;
      i_v_res   : integer
    );
    port (
      rst_i   : in  std_logic;
      clk_i   : in  std_logic;
      v_px_i  : in  std_logic_vector (n_px-1 downto 0);
      h_px_i  : in  std_logic_vector (n_px-1 downto 0);
      red_o   : out std_logic_vector (n_colour-1 downto 0);
      green_o : out std_logic_vector (n_colour-1 downto 0);
      blue_o  : out std_logic_vector (n_colour-1 downto 0)
    );
  end component pattern_gen2;

  ------------------------------------------------------------------------------
  -- TYPEDEFS
  ------------------------------------------------------------------------------

  -- t_colour: Represent colours and help during debugging
  type t_colour is (RED, GREEN, BLUE, UNKOWN);

  -- Signals for In- and Outputs
  signal s_rst_i   : std_logic := '1';
  signal s_clk_i   : std_logic := '1';
  signal s_v_px_i  : std_logic_vector (C_N_PX-1 downto 0) := (others => '1');
  signal s_h_px_i  : std_logic_vector (C_N_PX-1 downto 0) := (others => '1');
  signal s_red_o   : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_green_o : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_blue_o  : std_logic_vector (C_N_COLOUR-1 downto 0);

  -- s_colour: Variable to track during simulation
  signal s_colour  : t_colour;

  -- s_v_back_porch: Simulation info for vertical back porch
  -- s_v_front_porch: Simulation info for vertical front porch
  -- s_h_back_porch: Simulation info for horizontal back porch
  -- s_h_front_porch: Simulation info for horizontal front porch
  signal s_v_back_porch  : std_logic := '0';
  signal s_v_front_porch : std_logic := '0';
  signal s_h_back_porch  : std_logic := '0';
  signal s_h_front_porch : std_logic := '0';

begin

  ------------------------------------------------------------------------------
  -- Device under test
  ------------------------------------------------------------------------------
  u_dut : pattern_gen2
  generic map (
    n_colour  => C_N_COLOUR,
    n_px      => C_N_PX,
    i_h_res   => C_I_H_RES,
    i_v_res   => C_I_V_RES
  )
  port map (
    rst_i   => s_rst_i,
    clk_i   => s_clk_i,
    v_px_i  => s_v_px_i,
    h_px_i  => s_h_px_i,
    red_o   => s_red_o,
    green_o => s_green_o,
    blue_o  => s_blue_o
  );

  -- Create reset pulse and clock
  s_rst_i <= '0' after C_T/2;
  s_clk_i <= not s_clk_i after C_T/2;

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

  ------------------------------------------------------------------------------
  -- Increase vertical and horizontal pixel index
  ------------------------------------------------------------------------------
  p_sim: process
  begin

    wait for C_T;

    loop

      -- V Back Porch
      s_v_back_porch <= '1';
      for i in 0 to 26399 loop
        wait for C_T;
      end loop;
      s_v_back_porch <= '0';

      -- Lines
      for y in 0 to 479 loop

        -- H Sync + Back Porch
        s_h_back_porch <= '1';
        for i in 0 to 143 loop
          wait for C_T;
        end loop;
        s_h_back_porch <= '0';

        s_v_px_i <= std_logic_vector(to_unsigned(y, s_v_px_i'length));

        -- RGB Data
        for x in 0 to 639 loop
          s_h_px_i <= std_logic_vector(to_unsigned(x, s_h_px_i'length));
          wait for C_T;
        end loop;

        -- H Front Porch
        s_h_front_porch <= '1';
        for i in 0 to 15 loop
          wait for C_T;
        end loop;
        s_h_front_porch <= '0';

      end loop;

      -- V Front Porch
      s_v_front_porch <= '1';
      for i in 0 to 7999 loop
        wait for C_T;
      end loop;
      s_v_front_porch <= '0';

    end loop;

  end process p_sim;

end architecture sim;
