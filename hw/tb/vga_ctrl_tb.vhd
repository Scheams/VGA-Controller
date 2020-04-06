--------------------------------------------------------------------------------
-- Title :      VGA Control (Testbench)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       vga_ctrl_tb.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 06.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2002
--------------------------------------------------------------------------------
-- Description: The "VGA Control" unit controlls the hardware operation that
--              is transfered through the VGA cable to the monitor. It takes
--              input signals like the colour information and monitor
--              specifications to perform this action.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 30.03.2020   v1.0.0   Christoph Amon   Initial stage
-- 04.04.2020   v1.1.0   Christoph Amon   Add enable signal
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.vga_ctrl_pkg.all;
use work.vga_specs_pkg.all;
use work.vga_sim_pkg.all;

entity vga_ctrl_tb is
end vga_ctrl_tb;

architecture sim of vga_ctrl_tb is

  ------------------------------------------------------------------------------
  -- CONSTANTS
  ------------------------------------------------------------------------------

  -- C_N_COLOUR: Bit width of one colour
  -- C_N_PX: Bit width for pixel information bus
  -- C_T: Period for one clock cycle
  constant C_N_COLOUR : integer := 4;
  constant C_N_PX     : integer := 10;
  constant C_T        : time    := 40 ns;

  -- Horizontal monitor specs in pixels
  constant C_H_PX_VISIBLE_AREA  : integer := 640;
  constant C_H_PX_FRONT_PORCH   : integer := 16;
  constant C_H_PX_SYNC_PULSE    : integer := 96;
  constant C_H_PX_BACK_PORCH    : integer := 48;
  constant C_H_PX_WHOLE_LINE    : integer := 800;

  -- Vertical monitor specs in lines
  constant C_V_LN_VISIBLE_AREA  : integer := 480;
  constant C_V_LN_FRONT_PORCH   : integer := 10;
  constant C_V_LN_SYNC_PULSE    : integer := 2;
  constant C_V_LN_BACK_PORCH    : integer := 33;
  constant C_V_LN_WHOLE_FRAME   : integer := 525;

  -- Horizontal timing specs
  constant C_H_T_VISIBLE_AREA  : time := C_H_PX_VISIBLE_AREA * C_T;
  constant C_H_T_FRONT_PORCH   : time := C_H_PX_FRONT_PORCH  * C_T;
  constant C_H_T_SYNC_PULSE    : time := C_H_PX_SYNC_PULSE   * C_T;
  constant C_H_T_BACK_PORCH    : time := C_H_PX_BACK_PORCH   * C_T;
  constant C_H_T_WHOLE_LINE    : time := C_H_PX_WHOLE_LINE   * C_T;

  -- Vertical timing specs
  constant C_V_T_VISIBLE_AREA  : time := C_V_LN_VISIBLE_AREA * C_H_T_WHOLE_LINE;
  constant C_V_T_FRONT_PORCH   : time := C_V_LN_FRONT_PORCH  * C_H_T_WHOLE_LINE;
  constant C_V_T_SYNC_PULSE    : time := C_V_LN_SYNC_PULSE   * C_H_T_WHOLE_LINE;
  constant C_V_T_BACK_PORCH    : time := C_V_LN_BACK_PORCH   * C_H_T_WHOLE_LINE;
  constant C_V_T_WHOLE_FRAME   : time := C_V_LN_WHOLE_FRAME  * C_H_T_WHOLE_LINE;

  ------------------------------------------------------------------------------
  -- COMPONENTS
  ------------------------------------------------------------------------------

  component vga_ctrl
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

  ------------------------------------------------------------------------------
  -- SIGNALS
  ------------------------------------------------------------------------------

  -- In- and Output signals
  signal s_rst_i      : std_logic := '1';
  signal s_clk_i      : std_logic := '1';
  signal s_red_i      : std_logic_vector (COLOUR.n_rgb-1 downto 0);
  signal s_green_i    : std_logic_vector (COLOUR.n_rgb-1 downto 0);
  signal s_blue_i     : std_logic_vector (COLOUR.n_rgb-1 downto 0);
  signal s_h_sync_o   : std_logic;
  signal s_v_sync_o   : std_logic;
  signal s_red_o      : std_logic_vector (COLOUR.n_rgb-1 downto 0);
  signal s_green_o    : std_logic_vector (COLOUR.n_rgb-1 downto 0);
  signal s_blue_o     : std_logic_vector (COLOUR.n_rgb-1 downto 0);
  signal s_px_h_o     : std_logic_vector (SPECS.addr.n_h-1 downto 0);
  signal s_px_v_o     : std_logic_vector (SPECS.addr.n_v-1 downto 0);

  -- s_h_stamp: Timestamp for horizontal timing checks
  -- s_h_delta: Time difference for horizontal timing checks
  signal s_h_stamp : time := 0 ns;
  signal s_h_delta : time;

  -- s_v_stamp: Timestamp for vertical timing checks
  -- s_v_delta: Time difference for vertical timing checks
  signal s_v_stamp : time := 0 ns;
  signal s_v_delta : time;

begin

  ------------------------------------------------------------------------------
  -- Device under test
  ------------------------------------------------------------------------------
  u_dut: vga_ctrl
  generic map (
    g_specs   => SPECS,
    g_colour  => COLOUR
  )
  port map (
    rst_i    => s_rst_i,
    clk_i    => s_clk_i,
    enable_i => '1',
    red_i    => s_red_i,
    green_i  => s_green_i,
    blue_i   => s_blue_i,
    h_sync_o => s_h_sync_o,
    v_sync_o => s_v_sync_o,
    red_o    => s_red_o,
    green_o  => s_green_o,
    blue_o   => s_blue_o,
    px_h_o   => s_px_h_o,
    px_v_o   => s_px_v_o
  );

  -- Create reset pulse and clock signal
  s_rst_i <= '0' after T_RST;
  s_clk_i <= not s_clk_i after T_VGA / 2;

  -- Create black frame
  s_green_i <= (others => '1');
  s_red_i <= (others => '1');
  s_blue_i <= (others => '1');

  ------------------------------------------------------------------------------
  -- Check horizontal timing
  ------------------------------------------------------------------------------
  p_h_timing: process
    alias s_h_state : t_state
      is << signal .vga_ctrl_tb.u_dut.s_h_state : t_state >>;
  begin

    -- Wait for S_SYNC state
    wait on s_h_state;
    assert s_h_state = S_SYNC report "H State not S_SYNC"
      severity error;

    -- Check front porch timing
    if s_h_stamp /= 0 ns then
      s_h_delta <= now - s_h_stamp;
      s_h_stamp <= now;
      wait for 1 ns;
      assert s_h_delta = C_H_T_FRONT_PORCH
        report "Front Porch (H) is not " & time'image(C_H_T_FRONT_PORCH)
          & " instead " & time'image(s_h_delta)
        severity error;
    else
      s_h_stamp <= now;
    end if;

    -- Wait for S_BACKPORCH state
    wait on s_h_state;
    assert s_h_state = S_BACKPORCH report "H State not S_BACKPORCH"
      severity error;

    -- Calculate delta
    s_h_delta <= now - s_h_stamp;
    s_h_stamp <= now;
    wait for 1 ns;
    assert s_h_delta = C_H_T_SYNC_PULSE
      report "Sync Pulse (H) is not " & time'image(C_H_T_SYNC_PULSE)
        & " instead " & time'image(s_h_delta)
      severity error;

    -- Wait for S_DATA state
    wait on s_h_state;
    assert s_h_state = S_DATA report "H State not S_DATA"
      severity error;

    -- Check back porch timing
    s_h_delta <= now - s_h_stamp;
    s_h_stamp <= now;
    wait for 1 ns;
    assert s_h_delta = C_H_T_BACK_PORCH
      report "Back Porch (H) is not " & time'image(C_H_T_BACK_PORCH)
        & " instead " & time'image(s_h_delta)
      severity error;

    -- Wait for S_FRONTPORCH state
    wait on s_h_state;
    assert s_h_state = S_FRONTPORCH report "H State not S_FRONTPORCH"
      severity error;

    -- Check data timing
    s_h_delta <= now - s_h_stamp;
    s_h_stamp <= now;
    wait for 1 ns;
    assert s_h_delta = C_H_T_VISIBLE_AREA
      report "Visible Area (H) is not " & time'image(C_H_T_VISIBLE_AREA)
        & " instead " & time'image(s_h_delta)
      severity error;

  end process p_h_timing;

  ------------------------------------------------------------------------------
  -- Check vertical timing
  ------------------------------------------------------------------------------
  p_v_timing: process
    alias s_v_state : t_state
      is << signal .vga_ctrl_tb.u_dut.s_v_state : t_state >>;
  begin

    -- Wait for S_SYNC state
    wait on s_v_state;
    assert s_v_state = S_SYNC report "V State not S_SYNC"
      severity error;

    -- Check front porch timing
    if s_v_stamp /= 0 ns then
      s_v_delta <= now - s_v_stamp;
      s_v_stamp <= now;
      wait for 1 ns;
      assert s_v_delta = C_V_T_FRONT_PORCH
        report "Front Porch (V) is not " & time'image(C_V_T_FRONT_PORCH)
          & " instead " & time'image(s_v_delta)
        severity error;
    else
      s_v_stamp <= now;
    end if;

    -- Wait for S_BACKPORCH state
    wait on s_v_state;
    assert s_v_state = S_BACKPORCH report "V State not S_BACKPORCH"
      severity error;

    -- Calculate delta
    s_v_delta <= now - s_v_stamp;
    s_v_stamp <= now;
    wait for 1 ns;
    assert s_v_delta = C_V_T_SYNC_PULSE
      report "Sync Pulse (V) is not " & time'image(C_V_T_SYNC_PULSE)
        & " instead " & time'image(s_v_delta)
      severity error;

    -- Wait for S_DATA state
    wait on s_v_state;
    assert s_v_state = S_DATA report "V State not S_DATA"
      severity error;

    -- Check back porch timing
    s_v_delta <= now - s_v_stamp;
    s_v_stamp <= now;
    wait for 1 ns;
    assert s_v_delta = C_V_T_BACK_PORCH
      report "Back Porch (V) is not " & time'image(C_V_T_BACK_PORCH)
        & " instead " & time'image(s_v_delta)
      severity error;

    -- Wait for S_FRONTPORCH state
    wait on s_v_state;
    assert s_v_state = S_FRONTPORCH report "V State not S_FRONTPORCH"
      severity error;

    -- Check data timing
    s_v_delta <= now - s_v_stamp;
    s_v_stamp <= now;
    wait for 1 ns;
    assert s_v_delta = C_V_T_VISIBLE_AREA
      report "Visible Area (V) is not " & time'image(C_V_T_VISIBLE_AREA)
        & " instead " & time'image(s_v_delta)
      severity error;

  end process p_v_timing;

end sim;
