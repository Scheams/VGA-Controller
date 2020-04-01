--------------------------------------------------------------------------------
-- Title : VGA Control Testbench
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : vga_ctrl_tb.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 31.03.2020
-- Platform : ModelSim - Starter Edition 10.5b
-- Language: VHDL 1076-2008
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

library work;
use work.vga_ctrl_pkg.all;
use work.vga_top_pkg.all;

entity vga_ctrl_tb is
end vga_ctrl_tb;

architecture sim of vga_ctrl_tb is

  component vga_ctrl
    generic (
      n_colour : integer;
      n_px     : integer;

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
      red_i    : in std_logic_vector (n_colour-1 downto 0);
      green_i  : in std_logic_vector (n_colour-1 downto 0);
      blue_i   : in std_logic_vector (n_colour-1 downto 0);

      h_sync_o : out std_logic;
      v_sync_o : out std_logic;
      red_o    : out std_logic_vector (n_colour-1 downto 0);
      green_o  : out std_logic_vector (n_colour-1 downto 0);
      blue_o   : out std_logic_vector (n_colour-1 downto 0);
      px_x_o   : out std_logic_vector (n_px-1 downto 0);
      px_y_o   : out std_logic_vector (n_px-1 downto 0)
    );
  end component vga_ctrl;

  signal s_rst_i      : std_logic := '1';
  signal s_clk_i      : std_logic := '1';
  signal s_red_i      : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_green_i    : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_blue_i     : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_h_sync_o   : std_logic;
  signal s_v_sync_o   : std_logic;
  signal s_red_o      : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_green_o    : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_blue_o     : std_logic_vector (C_N_COLOUR-1 downto 0);
  signal s_px_x_o     : std_logic_vector (C_N_PX-1 downto 0);
  signal s_px_y_o     : std_logic_vector (C_N_PX-1 downto 0);

  constant C_H_T_VISIBLE_AREA  : time := C_H_PX_VISIBLE_AREA * C_T_CLK;
  constant C_H_T_FRONT_PORCH   : time := C_H_PX_FRONT_PORCH  * C_T_CLK;
  constant C_H_T_SYNC_PULSE    : time := C_H_PX_SYNC_PULSE   * C_T_CLK;
  constant C_H_T_BACK_PORCH    : time := C_H_PX_BACK_PORCH   * C_T_CLK;
  constant C_H_T_WHOLE_LINE    : time := C_H_PX_WHOLE_LINE   * C_T_CLK;

  constant C_V_T_VISIBLE_AREA  : time := C_V_LN_VISIBLE_AREA * C_H_T_WHOLE_LINE;
  constant C_V_T_FRONT_PORCH   : time := C_V_LN_FRONT_PORCH  * C_H_T_WHOLE_LINE;
  constant C_V_T_SYNC_PULSE    : time := C_V_LN_SYNC_PULSE   * C_H_T_WHOLE_LINE;
  constant C_V_T_BACK_PORCH    : time := C_V_LN_BACK_PORCH   * C_H_T_WHOLE_LINE;
  constant C_V_T_WHOLE_FRAME   : time := C_V_LN_WHOLE_FRAME  * C_H_T_WHOLE_LINE;

  signal s_h_stamp : time := 0 ns;
  signal s_h_delta : time;
  alias s_h_state : t_state
    is << signal .vga_ctrl_tb.u_dut.s_h_state : t_state >>;

  signal s_v_stamp : time := 0 ns;
  signal s_v_delta : time;
  alias s_v_state : t_state
    is << signal .vga_ctrl_tb.u_dut.s_v_state : t_state >>;

begin

  u_dut: vga_ctrl
  generic map (
    n_colour => C_N_COLOUR,
    n_px     => C_N_PX,

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
    rst_i    => s_rst_i,
    clk_i    => s_clk_i,
    red_i    => s_red_i,
    green_i  => s_green_i,
    blue_i   => s_blue_i,
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

  s_green_i <= (others => '1');
  s_red_i <= (others => '1');
  s_blue_i <= (others => '1');

  p_h_timing: process
  begin

    -- Wait for S_SYNC state
    wait on s_h_state;
    assert s_h_state = S_SYNC report "H State not S_SYNC" severity error;

    -- Check front porch timing
    if s_h_stamp /= 0 ns then
      s_h_delta <= now - s_h_stamp;
      s_h_stamp <= now;
      wait for 1 ns;
      assert s_h_delta = C_H_T_FRONT_PORCH
        report "Front Porch (H) is not " & time'image(C_H_T_FRONT_PORCH) & " instead " & time'image(s_h_delta)
        severity warning;
    else
      s_h_stamp <= now;
    end if;

    -- Wait for S_BACKPORCH state
    wait on s_h_state;
    assert s_h_state = S_BACKPORCH report "H State not S_BACKPORCH" severity error;

    -- Calculate delta
    s_h_delta <= now - s_h_stamp;
    s_h_stamp <= now;
    wait for 1 ns;
    assert s_h_delta = C_H_T_SYNC_PULSE
      report "Sync Pulse (H) is not " & time'image(C_H_T_SYNC_PULSE) & " instead " & time'image(s_h_delta)
      severity warning;

    -- Wait for S_DATA state
    wait on s_h_state;
    assert s_h_state = S_DATA report "H State not S_DATA" severity error;

    -- Check back porch timing
    s_h_delta <= now - s_h_stamp;
    s_h_stamp <= now;
    wait for 1 ns;
    assert s_h_delta = C_H_T_BACK_PORCH
      report "Back Porch (H) is not " & time'image(C_H_T_BACK_PORCH) & " instead " & time'image(s_h_delta)
      severity warning;

    -- Wait for S_FRONTPORCH state
    wait on s_h_state;
    assert s_h_state = S_FRONTPORCH report "H State not S_FRONTPORCH" severity error;

    -- Check data timing
    s_h_delta <= now - s_h_stamp;
    s_h_stamp <= now;
    wait for 1 ns;
    assert s_h_delta = C_H_T_VISIBLE_AREA
      report "Visible Area (H) is not " & time'image(C_H_T_VISIBLE_AREA) & " instead " & time'image(s_h_delta)
      severity warning;

  end process p_h_timing;

  p_v_timing: process
  begin

    -- Wait for S_SYNC state
    wait on s_v_state;
    assert s_v_state = S_SYNC report "V State not S_SYNC" severity error;

    -- Check front porch timing
    if s_v_stamp /= 0 ns then
      s_v_delta <= now - s_v_stamp;
      s_v_stamp <= now;
      wait for 1 ns;
      assert s_v_delta = C_V_T_FRONT_PORCH
        report "Front Porch (V) is not " & time'image(C_V_T_FRONT_PORCH) & " instead " & time'image(s_v_delta)
        severity warning;
    else
      s_v_stamp <= now;
    end if;

    -- Wait for S_BACKPORCH state
    wait on s_v_state;
    assert s_v_state = S_BACKPORCH report "V State not S_BACKPORCH" severity error;

    -- Calculate delta
    s_v_delta <= now - s_v_stamp;
    s_v_stamp <= now;
    wait for 1 ns;
    assert s_v_delta = C_V_T_SYNC_PULSE
      report "Sync Pulse (V) is not " & time'image(C_V_T_SYNC_PULSE) & " instead " & time'image(s_v_delta)
      severity warning;

    -- Wait for S_DATA state
    wait on s_v_state;
    assert s_v_state = S_DATA report "V State not S_DATA" severity error;

    -- Check back porch timing
    s_v_delta <= now - s_v_stamp;
    s_v_stamp <= now;
    wait for 1 ns;
    assert s_v_delta = C_V_T_BACK_PORCH
      report "Back Porch (V) is not " & time'image(C_V_T_BACK_PORCH) & " instead " & time'image(s_v_delta)
      severity warning;

    -- Wait for S_FRONTPORCH state
    wait on s_v_state;
    assert s_v_state = S_FRONTPORCH report "V State not S_FRONTPORCH" severity error;

    -- Check data timing
    s_v_delta <= now - s_v_stamp;
    s_v_stamp <= now;
    wait for 1 ns;
    assert s_v_delta = C_V_T_VISIBLE_AREA
      report "Visible Area (V) is not " & time'image(C_V_T_VISIBLE_AREA) & " instead " & time'image(s_v_delta)
      severity warning;

  end process p_v_timing;



end sim;
