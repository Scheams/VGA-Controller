--------------------------------------------------------------------------------
-- Title :      VGA Top (Testbench)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       vga_top_tb.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 06.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2002
--------------------------------------------------------------------------------
-- Description: The "VGA Top" unit combines all elements together to one
--              VGA controller with implemented image generators.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 01.04.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.vga_specs_pkg.all;
use work.vga_sim_pkg.all;

entity vga_top_tb is
end vga_top_tb;

architecture sim of vga_top_tb is

  ------------------------------------------------------------------------------
  -- COMPONENTS
  ------------------------------------------------------------------------------

  component vga_monitor
    generic(
      g_no_frames : integer range 1 to 99 := 1;
      g_path      : string                := "vga_output/"
      );
    port(
      s_reset_i     : in std_logic;
      s_vga_red_i   : in std_logic_vector(3 downto 0);
      s_vga_green_i : in std_logic_vector(3 downto 0);
      s_vga_blue_i  : in std_logic_vector(3 downto 0);
      s_vga_hsync_i : in std_logic;
      s_vga_vsync_i : in std_logic
      );
  end component vga_monitor;

  component vga_top
    generic (
      g_specs   : t_vga_specs := VGA_640x480_60Hz;
      g_colour  : t_colour    := VGA_4bit_RGB;
      g_img1    : t_image     := VGA_320x240_IMG;
      g_img2    : t_image     := VGA_100x100_IMG;
      g_f_osc   : natural     := 100_000_000;
      g_f_db    : natural     :=       1_000
    );
    port (
      rst_i : in  std_logic;
      clk_i : in  std_logic;
      pb_i  : in  std_logic_vector (3 downto 0);
      sw_i  : in  std_logic_vector (2 downto 0);
      h_sync_o : out std_logic;
      v_sync_o : out std_logic;
      red_o    : out std_logic_vector (g_colour.n_rgb-1 downto 0);
      green_o  : out std_logic_vector (g_colour.n_rgb-1 downto 0);
      blue_o   : out std_logic_vector (g_colour.n_rgb-1 downto 0)
    );
  end component vga_top;

  ------------------------------------------------------------------------------
  -- SIGNALS
  ------------------------------------------------------------------------------

  -- In- and Output signals
  signal s_rst_i     : std_logic := '1';
  signal s_clk_i     : std_logic := '1';
  signal s_pb_i      : std_logic_vector (3 downto 0);
  signal s_sw_i      : std_logic_vector (2 downto 0);
  signal s_h_sync_o  : std_logic;
  signal s_v_sync_o  : std_logic;
  signal s_red_o     : std_logic_vector (COLOUR.n_rgb-1 downto 0);
  signal s_green_o   : std_logic_vector (COLOUR.n_rgb-1 downto 0);
  signal s_blue_o    : std_logic_vector (COLOUR.n_rgb-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- VGA Monitor
  ------------------------------------------------------------------------------
  u_monitor: vga_monitor
  generic map (
    g_no_frames => 4,
    g_path      => "vga_outputs/"
  )
  port map (
    s_reset_i      => s_rst_i,
    s_vga_red_i    => s_red_o,
    s_vga_green_i  => s_green_o,
    s_vga_blue_i   => s_blue_o,
    s_vga_hsync_i  => s_h_sync_o,
    s_vga_vsync_i  => s_v_sync_o
  );

  ------------------------------------------------------------------------------
  -- Device under Test
  ------------------------------------------------------------------------------
  u_dut: vga_top
  generic map (
    g_specs   => SPECS,
    g_colour  => COLOUR,
    g_img1    => IMG1,
    g_img2    => IMG2,
    g_f_osc   => F_VGA,
    g_f_db    => F_DB
  )
  port map (
    rst_i     => s_rst_i,
    clk_i     => s_clk_i,
    pb_i      => s_pb_i,
    sw_i      => s_sw_i,
    h_sync_o  => s_h_sync_o,
    v_sync_o  => s_v_sync_o,
    red_o     => s_red_o,
    green_o   => s_green_o,
    blue_o    => s_blue_o
  );

  -- Generate reset pulse and clock signal
  s_rst_i <= '0' after T_RST;
  s_clk_i <= not s_clk_i after T_VGA / 2;

  p_pb: process
  begin
    s_pb_i <= (others => '0');
    wait for 500 ns;

    s_pb_i(0) <= '1';
    wait for 1 ms;
    s_pb_i(0) <= '0';

    s_pb_i(3) <= '1';
    wait for 1 ms;
    s_pb_i(3) <= '0';

    s_pb_i(0) <= '1';
    wait for 1 ms;
    s_pb_i(0) <= '0';

    s_pb_i(3) <= '1';
    wait for 1 ms;
    s_pb_i(3) <= '0';

    s_pb_i(1) <= '1';
    wait for 1 ms;
    s_pb_i(1) <= '0';

    s_pb_i(2) <= '1';
    wait for 1 ms;
    s_pb_i(2) <= '0';

    s_pb_i(0) <= '1';
    wait for 1 ms;
    s_pb_i(0) <= '0';

    wait;
  end process p_pb;

  ------------------------------------------------------------------------------
  -- Simualtion process
  ------------------------------------------------------------------------------
  p_sim: process
  begin

    -- Reset all use inputs
    s_sw_i <= (others => '0');

    -- PATTERN GENERATOR 1
    -- Wait for first frame start and set source
    wait until s_v_sync_o = '1';
    s_sw_i <= (others => '0');

    -- PATTERN GENERATOR 2
    wait until s_v_sync_o = '1';
    s_sw_i <= (0 => '1', others => '0');

    -- MEMORY CONTROL 1
    wait until s_v_sync_o = '1';
    s_sw_i <= (1 => '1', others => '0');

    -- MEMORY CONTROL 2
    wait until s_v_sync_o = '1';
    s_sw_i <= (2 => '1', others => '0');

    wait;

  end process p_sim;

end sim;
