--------------------------------------------------------------------------------
-- Title :      VGA Top (Structural Architecture)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       vga_top_structural.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 14.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b, Vivado 2019.2
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

architecture structural of vga_top is

  ------------------------------------------------------------------------------
  -- COMPONENTS
  ------------------------------------------------------------------------------

  component vga_pll is
    port (
      reset     : in  std_logic;
      clk_i     : in  std_logic;
      clk_o     : out std_logic;
      locked_o  : out std_logic
    );
  end component vga_pll;

  component vga_ctrl is
    generic (
      g_specs   : t_vga_specs;
      g_colour  : t_colour
    );
    port (
      rst_i    : in  std_logic;
      clk_i    : in  std_logic;
      enable_i : in  std_logic;
      red_i    : in  std_logic_vector (g_colour.n_rgb-1 downto 0);
      green_i  : in  std_logic_vector (g_colour.n_rgb-1 downto 0);
      blue_i   : in  std_logic_vector (g_colour.n_rgb-1 downto 0);
      h_sync_o : out std_logic;
      v_sync_o : out std_logic;
      red_o    : out std_logic_vector (g_colour.n_rgb-1 downto 0);
      green_o  : out std_logic_vector (g_colour.n_rgb-1 downto 0);
      blue_o   : out std_logic_vector (g_colour.n_rgb-1 downto 0);
      px_h_o   : out std_logic_vector (g_specs.addr.n_h-1 downto 0);
      px_v_o   : out std_logic_vector (g_specs.addr.n_v-1 downto 0)
    );
  end component vga_ctrl;

  component io_debounce is
    generic (
      f_sys      : integer := 100_000_000;
      f_debounce : integer := 1_000;
      n_sw       : integer;
      n_pb       : integer
    );
    port (
      rst_i : in std_logic;
      clk_i : in std_logic;
      sw_i  : in std_logic_vector (n_sw-1 downto 0);
      pb_i  : in std_logic_vector (n_pb-1 downto 0);
      sw_sync_o : out std_logic_vector (n_sw-1 downto 0);
      pb_sync_o : out std_logic_vector (n_pb-1 downto 0)
    );
  end component io_debounce;

  component source_mux is
    generic (
      g_colour  : t_colour
    );
    port (
      sw_sync_i   : in  std_logic_vector (2 downto 0);
      rgb_pg1_i   : in  std_logic_vector (g_colour.n_bus-1 downto 0);
      rgb_pg2_i   : in  std_logic_vector (g_colour.n_bus-1 downto 0);
      rgb_mem1_i  : in  std_logic_vector (g_colour.n_bus-1 downto 0);
      rgb_mem2_i  : in  std_logic_vector (g_colour.n_bus-1 downto 0);
      rgb_vga_o   : out std_logic_vector (g_colour.n_bus-1 downto 0)
    );
  end component source_mux;

  component pattern_gen1 is
    generic (
      g_specs   : t_vga_specs;
      g_colour  : t_colour
    );
    port (
      rst_i   : in  std_logic;
      clk_i   : in  std_logic;
      v_px_i  : in  std_logic_vector (g_specs.addr.n_v-1 downto 0);
      h_px_i  : in  std_logic_vector (g_specs.addr.n_h-1 downto 0);
      red_o   : out std_logic_vector (g_colour.n_rgb-1 downto 0);
      green_o : out std_logic_vector (g_colour.n_rgb-1 downto 0);
      blue_o  : out std_logic_vector (g_colour.n_rgb-1 downto 0)
    );
  end component pattern_gen1;

  component pattern_gen2 is
    generic (
      g_specs   : t_vga_specs;
      g_colour  : t_colour
    );
    port (
      rst_i   : in  std_logic;
      clk_i   : in  std_logic;
      v_px_i  : in  std_logic_vector (g_specs.addr.n_v-1 downto 0);
      h_px_i  : in  std_logic_vector (g_specs.addr.n_h-1 downto 0);
      red_o   : out std_logic_vector (g_colour.n_rgb-1 downto 0);
      green_o : out std_logic_vector (g_colour.n_rgb-1 downto 0);
      blue_o  : out std_logic_vector (g_colour.n_rgb-1 downto 0)
    );
  end component pattern_gen2;

  component ctrl_mem1 is
    generic (
      g_specs   : t_vga_specs;
      g_colour  : t_colour;
      g_img     : t_image
    );
    port (
      rst_i       : in  std_logic;
      clk_i       : in  std_logic;
      v_px_i      : in  std_logic_vector (g_specs.addr.n_v-1 downto 0);
      h_px_i      : in  std_logic_vector (g_specs.addr.n_h-1 downto 0);
      rom_data_i  : in  std_logic_vector (g_colour.n_bus-1 downto 0);
      rom_addr_o  : out std_logic_vector (g_img.n_rom-1 downto 0);
      red_o       : out std_logic_vector (g_colour.n_rgb-1 downto 0);
      green_o     : out std_logic_vector (g_colour.n_rgb-1 downto 0);
      blue_o      : out std_logic_vector (g_colour.n_rgb-1 downto 0)
    );
  end component ctrl_mem1;

  component rom_mem1 is
    port (
      clka  : in  std_logic;
      addra : in  std_logic_vector (16 downto 0);
      douta : out std_logic_vector (11 downto 0)
    );
  end component rom_mem1;

  component ctrl_mem2 is
    generic (
      g_specs   : t_vga_specs;
      g_colour  : t_colour;
      g_img     : t_image
    );
    port (
      rst_i       : in  std_logic;
      clk_i       : in  std_logic;
      v_px_i      : in  std_logic_vector (g_specs.addr.n_v-1 downto 0);
      h_px_i      : in  std_logic_vector (g_specs.addr.n_h-1 downto 0);
      rom_data_i  : in  std_logic_vector (g_colour.n_bus-1 downto 0);
      pb_i        : in  std_logic_vector (3 downto 0);
      rom_addr_o  : out std_logic_vector (g_img.n_rom-1 downto 0);
      red_o       : out std_logic_vector (g_colour.n_rgb-1 downto 0);
      green_o     : out std_logic_vector (g_colour.n_rgb-1 downto 0);
      blue_o      : out std_logic_vector (g_colour.n_rgb-1 downto 0)
    );
  end component ctrl_mem2;

  component rom_mem2 is
    port (
      clka  : in  std_logic;
      addra : in  std_logic_vector (13 downto 0);
      douta : out std_logic_vector (11 downto 0)
    );
  end component rom_mem2;

  ------------------------------------------------------------------------------
  -- SIGNALS
  ------------------------------------------------------------------------------

  signal s_vga_clk    : std_logic;
  signal s_locked     : std_logic;

  -- Internal debounced push-buttons and switches
  signal s_pb_sync    : std_logic_vector (3 downto 0);
  signal s_sw_sync    : std_logic_vector (2 downto 0);

  -- Internal horizontal and vertical pixel index
  signal s_px_h       : std_logic_vector (g_specs.addr.n_h-1 downto 0);
  signal s_px_v       : std_logic_vector (g_specs.addr.n_v-1 downto 0);

  -- Internal ROM 1 communication signals
  signal s_rom1_data  : std_logic_vector (g_colour.n_bus-1 downto 0);
  signal s_rom1_addr  : std_logic_vector (g_img1.n_rom-1 downto 0);

  -- Internal ROM 2 communication signals
  signal s_rom2_data  : std_logic_vector (g_colour.n_bus-1 downto 0);
  signal s_rom2_addr  : std_logic_vector (g_img2.n_rom-1 downto 0);

  -- Internal RGB channels of Pattern Generator 1
  signal s_pg1_red    : std_logic_vector (g_colour.n_rgb-1 downto 0);
  signal s_pg1_green  : std_logic_vector (g_colour.n_rgb-1 downto 0);
  signal s_pg1_blue   : std_logic_vector (g_colour.n_rgb-1 downto 0);
  signal s_pg1_rgb    : std_logic_vector (g_colour.n_bus-1 downto 0);

  -- Internal RGB channels of Pattern Generator 2
  signal s_pg2_red    : std_logic_vector (g_colour.n_rgb-1 downto 0);
  signal s_pg2_green  : std_logic_vector (g_colour.n_rgb-1 downto 0);
  signal s_pg2_blue   : std_logic_vector (g_colour.n_rgb-1 downto 0);
  signal s_pg2_rgb    : std_logic_vector (g_colour.n_bus-1 downto 0);

  -- Internal RGB channels of Memory Control 1
  signal s_mem1_red    : std_logic_vector (g_colour.n_rgb-1 downto 0);
  signal s_mem1_green  : std_logic_vector (g_colour.n_rgb-1 downto 0);
  signal s_mem1_blue   : std_logic_vector (g_colour.n_rgb-1 downto 0);
  signal s_mem1_rgb    : std_logic_vector (g_colour.n_bus-1 downto 0);

  -- Internal RGB channels of Memory Control 2
  signal s_mem2_red    : std_logic_vector (g_colour.n_rgb-1 downto 0);
  signal s_mem2_green  : std_logic_vector (g_colour.n_rgb-1 downto 0);
  signal s_mem2_blue   : std_logic_vector (g_colour.n_rgb-1 downto 0);
  signal s_mem2_rgb    : std_logic_vector (g_colour.n_bus-1 downto 0);

  -- Internal RGB channels of MUX
  signal s_mux_red    : std_logic_vector (g_colour.n_rgb-1 downto 0);
  signal s_mux_green  : std_logic_vector (g_colour.n_rgb-1 downto 0);
  signal s_mux_blue   : std_logic_vector (g_colour.n_rgb-1 downto 0);
  signal s_mux_rgb    : std_logic_vector (g_colour.n_bus-1 downto 0);


begin

  -- Map all 3 RGB channels to one bus
  p_rgb_to_bus(g_colour.n_rgb, s_pg1_rgb,
    s_pg1_red,  s_pg1_green,  s_pg1_blue);
  p_rgb_to_bus(g_colour.n_rgb, s_pg2_rgb,
    s_pg2_red,  s_pg2_green,  s_pg2_blue);
  p_rgb_to_bus(g_colour.n_rgb, s_mem1_rgb,
    s_mem1_red, s_mem1_green, s_mem1_blue);
  p_rgb_to_bus(g_colour.n_rgb, s_mem2_rgb,
    s_mem2_red, s_mem2_green, s_mem2_blue);

  -- Split RGB bus into 3 channels
  p_bus_to_rgb(g_colour.n_rgb, s_mux_rgb, s_mux_red, s_mux_green, s_mux_blue);

  ------------------------------------------------------------------------------
  -- VGA PLL
  ------------------------------------------------------------------------------
  u_pll: vga_pll
  port map (
    reset    => rst_i,
    clk_i    => clk_i,
    clk_o    => s_vga_clk,
    locked_o => s_locked
  );

  ------------------------------------------------------------------------------
  -- VGA Controller
  ------------------------------------------------------------------------------
  u_controller: vga_ctrl
  generic map (
    g_specs   => g_specs,
    g_colour  => g_colour
  )
  port map (
    rst_i    => rst_i,
    clk_i    => s_vga_clk,
    enable_i => s_locked,
    red_i    => s_mux_red,
    green_i  => s_mux_green,
    blue_i   => s_mux_blue,
    h_sync_o => h_sync_o,
    v_sync_o => v_sync_o,
    red_o    => red_o,
    green_o  => green_o,
    blue_o   => blue_o,
    px_h_o   => s_px_h,
    px_v_o   => s_px_v
  );

  ------------------------------------------------------------------------------
  -- IO Debounce
  ------------------------------------------------------------------------------
  u_io: io_debounce
  generic map (
    f_sys      => g_f_osc,
    f_debounce => g_f_db,
    n_sw       => sw_i'length,
    n_pb       => pb_i'length
  )
  port map (
    clk_i     => s_vga_clk,
    rst_i     => rst_i,
    sw_i      => sw_i,
    pb_i      => pb_i,
    sw_sync_o => s_sw_sync,
    pb_sync_o => s_pb_sync
  );

  ------------------------------------------------------------------------------
  -- Source Multiplexer
  ------------------------------------------------------------------------------
  u_mux: source_mux
  generic map (
    g_colour => g_colour
  )
  port map (
    sw_sync_i   => s_sw_sync,
    rgb_pg1_i   => s_pg1_rgb,
    rgb_pg2_i   => s_pg2_rgb,
    rgb_mem1_i  => s_mem1_rgb,
    rgb_mem2_i  => s_mem2_rgb,
    rgb_vga_o   => s_mux_rgb
  );

  ------------------------------------------------------------------------------
  -- Pattern Generator 1
  ------------------------------------------------------------------------------
  u_pg1: pattern_gen1
  generic map (
    g_specs   => g_specs,
    g_colour  => g_colour
  )
  port map (
    rst_i   => rst_i,
    clk_i   => s_vga_clk,
    v_px_i  => s_px_v,
    h_px_i  => s_px_h,
    red_o   => s_pg1_red,
    green_o => s_pg1_green,
    blue_o  => s_pg1_blue
  );

  ------------------------------------------------------------------------------
  -- Pattern Generator 2
  ------------------------------------------------------------------------------
  u_pg2: pattern_gen2
  generic map (
    g_specs   => g_specs,
    g_colour  => g_colour
  )
  port map (
    clk_i   => s_vga_clk,
    rst_i   => rst_i,
    v_px_i  => s_px_v,
    h_px_i  => s_px_h,
    red_o   => s_pg2_red,
    green_o => s_pg2_green,
    blue_o  => s_pg2_blue
  );

  ------------------------------------------------------------------------------
  -- Memory Control 1
  ------------------------------------------------------------------------------
  u_mc1: ctrl_mem1
  generic map (
    g_specs   => g_specs,
    g_colour  => g_colour,
    g_img     => g_img1
  )
  port map (
    rst_i       => rst_i,
    clk_i       => s_vga_clk,
    v_px_i      => s_px_v,
    h_px_i      => s_px_h,
    rom_data_i  => s_rom1_data,
    rom_addr_o  => s_rom1_addr,
    red_o       => s_mem1_red,
    green_o     => s_mem1_green,
    blue_o      => s_mem1_blue
  );

  ------------------------------------------------------------------------------
  -- ROM 1
  ------------------------------------------------------------------------------
  u_rom1: rom_mem1
  port map (
    clka  => s_vga_clk,
    addra => s_rom1_addr,
    douta => s_rom1_data
  );

  ------------------------------------------------------------------------------
  -- Memory Control 2
  ------------------------------------------------------------------------------
  u_mc2: ctrl_mem2
  generic map (
    g_specs   => g_specs,
    g_colour  => g_colour,
    g_img     => g_img2
  )
  port map (
    rst_i       => rst_i,
    clk_i       => s_vga_clk,
    v_px_i      => s_px_v,
    h_px_i      => s_px_h,
    rom_data_i  => s_rom2_data,
    pb_i        => s_pb_sync,
    rom_addr_o  => s_rom2_addr,
    red_o       => s_mem2_red,
    green_o     => s_mem2_green,
    blue_o      => s_mem2_blue
  );

  ------------------------------------------------------------------------------
  -- ROM 2
  ------------------------------------------------------------------------------
  u_rom2: rom_mem2
  port map (
    clka  => s_vga_clk,
    addra => s_rom2_addr,
    douta => s_rom2_data
  );

end architecture structural;
