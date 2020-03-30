--------------------------------------------------------------------------------
-- Title : VGA Control Testbench
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : vga_ctrl_tb.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 30.03.2020
-- Platform : ModelSim - Starter Edition 10.5b
--------------------------------------------------------------------------------
-- Description: Testbench for VGA Control
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 30.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_ctrl_tb is
end vga_ctrl_tb;

architecture sim of vga_ctrl_tb is

  component vga_ctrl
    port (
      rst_i    : in  std_logic;
      clk_i    : in  std_logic;
      rgb_i    : in  std_logic_vector (11 downto 0);

      h_sync_o : out std_logic;
      v_sync_o : out std_logic;
      red_o    : out std_logic_vector (3 downto 0);
      green_o  : out std_logic_vector (3 downto 0);
      blue_o   : out std_logic_vector (3 downto 0);
      px_x_o   : out std_logic_vector (9 downto 0);
      px_y_o   : out std_logic_vector (9 downto 0)
    );
  end component vga_ctrl;

  signal s_rst_i    : std_logic := '1';
  signal s_clk_i    : std_logic := '1';
  signal s_rgb_i    : std_logic_vector (11 downto 0);
  signal s_h_sync_o : std_logic;
  signal s_v_sync_o : std_logic;
  signal s_red_o    : std_logic_vector (3 downto 0);
  signal s_green_o  : std_logic_vector (3 downto 0);
  signal s_blue_o   : std_logic_vector (3 downto 0);
  signal s_px_x_o   : std_logic_vector (9 downto 0);
  signal s_px_y_o   : std_logic_vector (9 downto 0);

begin

  u_dut: vga_ctrl
  port map(
    rst_i    => s_rst_i,
    clk_i    => s_clk_i,
    rgb_i    => s_rgb_i,
    h_sync_o => s_h_sync_o,
    v_sync_o => s_v_sync_o,
    red_o    => s_red_o,
    green_o  => s_green_o,
    blue_o   => s_blue_o,
    px_x_o   => s_px_x_o,
    px_y_o   => s_px_y_o
  );

  s_rst_i <= '0' after 20 ns;
  s_clk_i <= not s_clk_i after 20 ns;

  s_rgb_i <= (others => '1');

end sim;
