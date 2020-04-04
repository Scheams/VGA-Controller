--------------------------------------------------------------------------------
-- Title :      Memory Control 1 (RTL Architecture)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       ctrl_mem1_rtl.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 04.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2008
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

architecture rtl of ctrl_mem1 is

  signal s_prev_px : std_logic_vector (n_px-1 downto 0);

  signal s_cnt_img1 : unsigned (n_addr-1 downto 0);
  signal s_cnt_img2 : unsigned (n_addr-1 downto 0);
  signal s_cnt_img3 : unsigned (n_addr-1 downto 0);
  signal s_cnt_img4 : unsigned (n_addr-1 downto 0);

begin

  (red_o, green_o, blue_o) <= rom_data_i;

  p_process: process (rst_i, clk_i)

  begin

    -- Reset counters and colours
    if rst_i = '1' then
      s_cnt_img1 <= (others => '0');
      s_cnt_img2 <= (others => '0');
      s_cnt_img3 <= (others => '0');
      s_cnt_img4 <= (others => '0');
      s_prev_px <= (others => '1');
      rom_addr_o <= (others => '0');

    elsif clk_i'event and (clk_i = '1') then

      if s_prev_px /= h_px_i then
        if unsigned(h_px_i) < i_h_res/2 then
          if unsigned(v_px_i) < i_v_res/2 then
            s_cnt_img1 <= s_cnt_img1 + 1;
            rom_addr_o <= std_logic_vector(s_cnt_img1 + 1);
          else
            s_cnt_img2 <= s_cnt_img2 + 1;
            rom_addr_o <= std_logic_vector(s_cnt_img2 + 1);
          end if;
        else
          if unsigned(v_px_i) < i_v_res/2 then
            s_cnt_img3 <= s_cnt_img3 + 1;
            rom_addr_o <= std_logic_vector(s_cnt_img3 + 1);
          else
            s_cnt_img4 <= s_cnt_img4 + 1;
            rom_addr_o <= std_logic_vector(s_cnt_img4 + 1);
          end if;
        end if;
      end if;

      if unsigned(rom_addr_o) >= 76800-1 then
        rom_addr_o <= std_logic_vector(to_unsigned(76800-1, rom_addr_o'length));
      end if;

      -- Reset all states at begin of frame
      if unsigned(v_px_i) = 0 and unsigned(h_px_i) = 0 then
        s_cnt_img1 <= (others => '0');
        s_cnt_img2 <= (others => '0');
        s_cnt_img3 <= (others => '0');
        s_cnt_img4 <= (others => '0');
        rom_addr_o <= (others => '0');
      end if;

      -- Set previous pixel info
      s_prev_px <= h_px_i;
    end if;
  end process p_process;

end architecture rtl;
