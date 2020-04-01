--------------------------------------------------------------------------------
-- Title :      VGA Top (Structural Architecture)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       vga_top_structural.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 01.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2008
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
use work.vga_top_pkg.all;

architecture structural of vga_top is

  component vga_ctrl
    generic (
      n_colour          : integer;
      n_px              : integer;
      h_px_visible_area : integer;
      h_px_front_porch  : integer;
      h_px_sync_pulse   : integer;
      h_px_back_porch   : integer;
      h_px_whole_line   : integer;
      v_ln_visible_area : integer;
      v_ln_front_porch  : integer;
      v_ln_sync_pulse   : integer;
      v_ln_back_porch   : integer;
      v_ln_whole_frame  : integer
    );

    port (
      rst_i    : in  std_logic;
      clk_i    : in  std_logic;
      red_i    : in  std_logic_vector (n_colour-1 downto 0);
      green_i  : in  std_logic_vector (n_colour-1 downto 0);
      blue_i   : in  std_logic_vector (n_colour-1 downto 0);
      h_sync_o : out std_logic;
      v_sync_o : out std_logic;
      red_o    : out std_logic_vector (n_colour-1 downto 0);
      green_o  : out std_logic_vector (n_colour-1 downto 0);
      blue_o   : out std_logic_vector (n_colour-1 downto 0);
      px_x_o   : out std_logic_vector (n_px-1 downto 0);
      px_y_o   : out std_logic_vector (n_px-1 downto 0)
    );
  end component vga_ctrl;

  component io_debounce
    generic (
      f_sys      : integer := 100_000_000;
      f_debounce : integer := 1_000;
      n_sw       : integer;
      n_pb       : integer
    );
    port (
      clk_i : in std_logic;
      rst_i : in std_logic;
      sw_i  : in std_logic_vector (n_sw-1 downto 0);
      pb_i  : in std_logic_vector (n_pb-1 downto 0);
      sw_sync_o : out std_logic_vector (n_sw-1 downto 0);
      pb_sync_o : out std_logic_vector (n_pb-1 downto 0)
    );
  end component io_debounce;

  component source_mux
    generic (
      n_colour : integer
    );
    port (
      sw_sync_i   : in  std_logic_vector (2 downto 0);
      rgb_pg1_i   : in  std_logic_vector (3*n_colour-1 downto 0);
      rgb_pg2_i   : in  std_logic_vector (3*n_colour-1 downto 0);
      rgb_mem1_i  : in  std_logic_vector (3*n_colour-1 downto 0);
      rgb_mem2_i  : in  std_logic_vector (3*n_colour-1 downto 0);
      rgb_vga_o   : out std_logic_vector (3*n_colour-1 downto 0)
    );
  end component source_mux;

  component pattern_gen1
    generic (
      n_colour : integer;
      n_px : integer;
      monitor_width : integer
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
  end component pattern_gen1;

  component pattern_gen2
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

  signal s_pb_sync    : std_logic_vector (3 downto 0);
  signal s_sw_sync    : std_logic_vector (2 downto 0);

  signal s_px_h       : std_logic_vector (C_N_PX-1 downto 0);
  signal s_px_v       : std_logic_vector (C_N_PX-1 downto 0);

  signal s_pg1_red    : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_pg1_green  : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_pg1_blue   : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_pg1_rgb    : std_logic_vector (C_N_COLOUR*3-1 downto 0);

  signal s_pg2_red    : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_pg2_green  : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_pg2_blue   : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_pg2_rgb    : std_logic_vector (C_N_COLOUR*3-1 downto 0);

  signal s_mem1_red    : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_mem1_green  : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_mem1_blue   : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_mem1_rgb    : std_logic_vector (C_N_COLOUR*3-1 downto 0);

  signal s_mem2_red    : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_mem2_green  : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_mem2_blue   : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_mem2_rgb    : std_logic_vector (C_N_COLOUR*3-1 downto 0);

  signal s_mux_red    : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_mux_green  : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_mux_blue   : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_mux_rgb    : std_logic_vector (C_N_COLOUR*3-1 downto 0);


begin

  s_pg1_rgb  <= (s_pg1_blue,  s_pg1_green,  s_pg1_red );
  s_pg2_rgb  <= (s_pg2_blue,  s_pg2_green,  s_pg2_red );
  s_mem1_rgb <= (s_mem1_blue, s_mem1_green, s_mem1_red);
  s_mem2_rgb <= (s_mem2_blue, s_mem2_green, s_mem2_red);

  (s_mux_blue,  s_mux_green,  s_mux_red ) <= s_mux_rgb;

  u_controller: vga_ctrl
  generic map (
    n_colour          => C_N_COLOUR,
    n_px              => C_N_PX,
    h_px_visible_area => C_H_PX_VISIBLE_AREA,
    h_px_front_porch  => C_H_PX_FRONT_PORCH,
    h_px_sync_pulse   => C_H_PX_SYNC_PULSE,
    h_px_back_porch   => C_H_PX_BACK_PORCH,
    h_px_whole_line   => C_H_PX_WHOLE_LINE,
    v_ln_visible_area => C_V_LN_VISIBLE_AREA,
    v_ln_front_porch  => C_V_LN_FRONT_PORCH,
    v_ln_sync_pulse   => C_V_LN_SYNC_PULSE,
    v_ln_back_porch   => C_V_LN_BACK_PORCH,
    v_ln_whole_frame  => C_V_LN_WHOLE_FRAME
  )
  port map (
    rst_i    => rst_i,
    clk_i    => clk_i,
    red_i    => s_mux_red,
    green_i  => s_mux_green,
    blue_i   => s_mux_blue,
    h_sync_o => h_sync_o,
    v_sync_o => v_sync_o,
    red_o    => red_o,
    green_o  => green_o,
    blue_o   => blue_o,
    px_x_o   => s_px_h,
    px_y_o   => s_px_v
  );

  u_io: io_debounce
  generic map (
    f_sys      => C_F_CLK,
    f_debounce => 1_000_000,
    n_sw       => sw_i'length,
    n_pb       => pb_i'length
  )
  port map (
    clk_i     => clk_i,
    rst_i     => rst_i,
    sw_i      => sw_i,
    pb_i      => pb_i,
    sw_sync_o => s_sw_sync,
    pb_sync_o => s_pb_sync
  );

  u_mux: source_mux
  generic map (
    n_colour => C_N_COLOUR
  )
  port map (
    sw_sync_i   => s_sw_sync,
    rgb_pg1_i   => s_pg1_rgb,
    rgb_pg2_i   => s_pg2_rgb,
    rgb_mem1_i  => s_mem1_rgb,
    rgb_mem2_i  => s_mem2_rgb,
    rgb_vga_o   => s_mux_rgb
  );

  u_pg1: pattern_gen1
  generic map (
    n_colour      => C_N_COLOUR,
    n_px          => C_N_PX,
    monitor_width => C_H_PX_VISIBLE_AREA
  )
  port map (
    rst_i   => rst_i,
    clk_i   => clk_i,
    v_px_i  => s_px_v,
    h_px_i  => s_px_h,
    red_o   => s_pg1_red,
    green_o => s_pg1_green,
    blue_o  => s_pg1_blue
  );

  u_pg2: pattern_gen2
  port map (
    clk_i   => clk_i,
    rst_i   => rst_i,
    v_px_i  => s_px_v,
    h_px_i  => s_px_h,
    red_o   => s_pg2_red,
    green_o => s_pg2_green,
    blue_o  => s_pg2_blue
  );

end architecture structural;
