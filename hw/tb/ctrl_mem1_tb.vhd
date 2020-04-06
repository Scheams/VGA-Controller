--------------------------------------------------------------------------------
-- Title :      Memory Control 1 (Testbench)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       ctrl_mem1_tb.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 06.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2002
--------------------------------------------------------------------------------
-- Description: The "Memory Control 1" unit reads the stored information from
--              the ROM 1 which is a 320x240 image. This image gets then shown
--              4 times on the monitor.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 03.04.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.vga_specs_pkg.all;
use work.vga_sim_pkg.all;

entity ctrl_mem1_tb is
end entity ctrl_mem1_tb;

architecture sim of ctrl_mem1_tb is

  ------------------------------------------------------------------------------
  -- COMPONENT
  ------------------------------------------------------------------------------

  component ctrl_mem1
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

  ------------------------------------------------------------------------------
  -- SIGNALS
  ------------------------------------------------------------------------------

  -- In- and outputs of DUT
  signal s_rst_i       : std_logic := '1';
  signal s_clk_i       : std_logic := '1';
  signal s_v_px_i      : std_logic_vector (SPECS.addr.n_v-1 downto 0);
  signal s_h_px_i      : std_logic_vector (SPECS.addr.n_h-1 downto 0);
  signal s_rom_data_i  : std_logic_vector (COLOUR.n_bus-1 downto 0);
  signal s_rom_addr_o  : std_logic_vector (IMG1.n_rom-1 downto 0);
  signal s_red_o       : std_logic_vector (COLOUR.n_rgb-1 downto 0);
  signal s_green_o     : std_logic_vector (COLOUR.n_rgb-1 downto 0);
  signal s_blue_o      : std_logic_vector (COLOUR.n_rgb-1 downto 0);

  -- State signals for VGA output
  signal s_v_back_porch  : std_logic := '0';
  signal s_v_front_porch : std_logic := '0';
  signal s_h_back_porch  : std_logic := '0';
  signal s_h_front_porch : std_logic := '0';

begin

  ------------------------------------------------------------------------------
  -- Device under test
  ------------------------------------------------------------------------------
  u_dut: ctrl_mem1
  generic map (
    g_specs   => SPECS,
    g_colour  => COLOUR,
    g_img     => VGA_320x240_IMG
  )
  port map (
    rst_i       => s_rst_i,
    clk_i       => s_clk_i,
    v_px_i      => s_v_px_i,
    h_px_i      => s_h_px_i,
    rom_data_i  => s_rom_data_i,
    rom_addr_o  => s_rom_addr_o,
    red_o       => s_red_o,
    green_o     => s_green_o,
    blue_o      => s_blue_o
  );

  -- Create reset pulse and clock signal
  s_rst_i <= '0' after T_RST;
  s_clk_i <= not s_clk_i after T_OSC/2;

  ------------------------------------------------------------------------------
  -- Increase vertical and horizontal pixel index
  ------------------------------------------------------------------------------
  p_sim: process
  begin

    s_v_px_i <= (others => '1');
    s_h_px_i <= (others => '1');
    s_rom_data_i <= (others => '1');

    wait for T_RST;

    loop

      -- V Back Porch
      s_v_back_porch <= '1';
      for i in 0 to 26399 loop
        wait for T_VGA;
      end loop;
      s_v_back_porch <= '0';

      -- Lines
      for y in 0 to 479 loop

        -- H Sync + Back Porch
        s_h_back_porch <= '1';
        for i in 0 to 143 loop
          wait for T_VGA;
        end loop;
        s_h_back_porch <= '0';

        s_v_px_i <= std_logic_vector(to_unsigned(y, s_v_px_i'length));

        -- RGB Data
        for x in 0 to 639 loop
          s_h_px_i <= std_logic_vector(to_unsigned(x, s_h_px_i'length));
          wait for T_VGA;
        end loop;

        -- H Front Porch
        s_h_front_porch <= '1';
        for i in 0 to 15 loop
          wait for T_VGA;
        end loop;
        s_h_front_porch <= '0';

      end loop;

      -- V Front Porch
      s_v_front_porch <= '1';
      for i in 0 to 7999 loop
        wait for T_VGA;
      end loop;
      s_v_front_porch <= '0';

    end loop;

  end process p_sim;
end architecture sim;
