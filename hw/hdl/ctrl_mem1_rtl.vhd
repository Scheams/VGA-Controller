--------------------------------------------------------------------------------
-- Title :      Memory Control 1 (RTL Architecture)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       ctrl_mem1_rtl.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 14.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b, Vivado 2019.2
-- Language:    VHDL 1076-2002
--------------------------------------------------------------------------------
-- Description: The "Memory Control 1" unit reads the stored information from
--              the ROM 1 which is a 320x240 image. This image gets then shown
--              4 times on the monitor.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 03.04.2020   v1.0.0   Christoph Amon   Initial stage
-- 04.04.2020   v1.0.1   Christoph Amon   Add limitation to address line
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.vga_specs_pkg.all;

architecture rtl of ctrl_mem1 is

  ------------------------------------------------------------------------------
  -- CONSTANTS
  ------------------------------------------------------------------------------

  -- Max address of ROM
  constant C_MAX_ADDR : std_logic_vector (g_img.n_rom-1 downto 0)
    := std_logic_vector(to_unsigned(g_img.size_rom - 1, g_img.n_rom));

  ------------------------------------------------------------------------------
  -- SIGNALS
  ------------------------------------------------------------------------------

  -- Signal to read ROM address
  signal s_rom_addr_o : std_logic_vector (g_img.n_rom-1 downto 0);

  -- Store previous pixel information
  signal s_prev_px    : std_logic_vector (g_specs.addr.n_h-1 downto 0);

  -- Counter for 4 images
  signal s_cnt_img1   : unsigned (g_img.n_rom-1 downto 0);
  signal s_cnt_img2   : unsigned (g_img.n_rom-1 downto 0);
  signal s_cnt_img3   : unsigned (g_img.n_rom-1 downto 0);
  signal s_cnt_img4   : unsigned (g_img.n_rom-1 downto 0);

begin

  -- Assign signal to output
  rom_addr_o <= s_rom_addr_o;

  -- Convert ROM data to single colours
  p_bus_to_rgb(g_colour.n_rgb, rom_data_i, red_o, green_o, blue_o);

  ------------------------------------------------------------------------------
  -- Memory Control 1 process, handle image counter and rom address output
  ------------------------------------------------------------------------------
  p_process: process (rst_i, clk_i)
  begin


    if clk_i'event and (clk_i = '1') then

      -- Reset counters (Synch reset for ROM)
      if rst_i = '1' then
        s_cnt_img1 <= (others => '0');
        s_cnt_img2 <= (others => '0');
        s_cnt_img3 <= (others => '0');
        s_cnt_img4 <= (others => '0');
        s_prev_px <= (others => '1');
        s_rom_addr_o <= (others => '0');

      else
          if s_prev_px /= h_px_i then

            -- Reset all counter
            if unsigned(v_px_i) = 0 and unsigned(h_px_i) = 0 then
              s_cnt_img1 <= (others => '0');
              s_cnt_img2 <= (others => '0');
              s_cnt_img3 <= (others => '0');
              s_cnt_img4 <= (others => '0');
              s_rom_addr_o <= (others => '0');

            elsif unsigned(h_px_i) < g_img.width then
              -- First column, first row (1. image)
              if unsigned(v_px_i) < g_img.height then
                s_cnt_img1 <= s_cnt_img1 + 1;
                if s_cnt_img1 >= g_img.size_rom-1 then
                  s_rom_addr_o <= C_MAX_ADDR;
                else
                  s_rom_addr_o <= std_logic_vector(s_cnt_img1 + 1);
                end if;
              -- First column, second row (2. image)
              else
                s_cnt_img2 <= s_cnt_img2 + 1;
                if s_cnt_img2 >= g_img.size_rom-1 then
                  s_rom_addr_o <= C_MAX_ADDR;
                else
                  s_rom_addr_o <= std_logic_vector(s_cnt_img2 + 1);
                end if;
              end if;

            else
              -- Seconds column, first row (3. image)
              if unsigned(v_px_i) < g_img.height then
                s_cnt_img3 <= s_cnt_img3 + 1;
                if s_cnt_img3 >= g_img.size_rom-1 then
                  s_rom_addr_o <= C_MAX_ADDR;
                else
                  s_rom_addr_o <= std_logic_vector(s_cnt_img3 + 1);
                end if;
              -- Seconds column, second row (4. image)
              else
                s_cnt_img4 <= s_cnt_img4 + 1;
                if s_cnt_img4 >= g_img.size_rom-1 then
                  s_rom_addr_o <= C_MAX_ADDR;
                else
                  s_rom_addr_o <= std_logic_vector(s_cnt_img4 + 1);
                end if;
              end if;
            end if;
          end if;

          -- Set previous pixel info
          s_prev_px <= h_px_i;
        end if;
    end if;
  end process p_process;

end architecture rtl;
