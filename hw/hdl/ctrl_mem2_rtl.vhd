--------------------------------------------------------------------------------
-- Title :      Memory Control 1 (RTL Architecture)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       ctrl_mem2_rtl.vhd
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

architecture rtl of ctrl_mem2 is

  signal s_prev_px : std_logic_vector (n_px-1 downto 0);
  signal s_cnt_img : unsigned (n_addr-1 downto 0);
  signal s_img     : std_logic;

  signal s_pb_prev : std_logic_vector (pb_i'length-1 downto 0);

  signal s_h_tmp_offset : integer;
  signal s_v_tmp_offset : integer;
  signal s_h_offset : integer;
  signal s_v_offset : integer;

begin

  p_rgb: process (s_img, rom_data_i)
  begin
    if s_img = '1' then
      (red_o, green_o, blue_o) <= rom_data_i;
    else
      red_o <= (others => '0');
      green_o <= (others => '0');
      blue_o <= (others => '0');
    end if;
  end process p_rgb;

  p_process: process (rst_i, clk_i)
  begin

    -- Reset counters and colours
    if rst_i = '1' then
      s_cnt_img <= (others => '0');
      rom_addr_o <= (others => '0');

      s_h_tmp_offset <= 0;
      s_v_tmp_offset <= 0;
      s_h_offset <= 0;
      s_v_offset <= 0;

    elsif clk_i'event and (clk_i = '1') then

      if s_pb_prev(0) = '0' and pb_i(0) = '1' then
        if s_h_tmp_offset < i_h_res - 100 then
          s_h_tmp_offset <= s_h_tmp_offset + 30;
        end if;
      end if;

      if s_pb_prev(1) = '0' and pb_i(1) = '1' then
        if s_h_tmp_offset >= 30 then
          s_h_tmp_offset <= s_h_tmp_offset - 30;
        end if;
      end if;

      if s_pb_prev(2) = '0' and pb_i(2) = '1' then
        if s_v_tmp_offset >= 30 then
          s_v_tmp_offset <= s_v_tmp_offset - 30;
        end if;
      end if;

      if s_pb_prev(3) = '0' and pb_i(3) = '1' then
        if s_v_tmp_offset < i_v_res - 100 then
          s_v_tmp_offset <= s_v_tmp_offset + 30;
        end if;
      end if;

      if s_prev_px /= h_px_i then
        if unsigned(h_px_i) >= s_h_offset and unsigned(h_px_i) < 100+s_h_offset and unsigned(v_px_i) >= s_v_offset and unsigned(v_px_i) < 100+s_v_offset then
          s_cnt_img <= s_cnt_img + 1;
          s_img <= '1';
        else
          s_img <= '0';
        end if;

        if unsigned(v_px_i) = 0 and unsigned(h_px_i) = 0 then
          s_cnt_img <= (others => '0');
          rom_addr_o <= (others => '0');

          s_h_offset <= s_h_tmp_offset;
          s_v_offset <= s_v_tmp_offset;
        elsif unsigned(s_cnt_img) >= 10000-1 then
          rom_addr_o <= std_logic_vector(to_unsigned(10000-1, rom_addr_o'length));
        else
          rom_addr_o <= std_logic_vector(s_cnt_img + 1);
        end if;
      end if;

      s_prev_px <= h_px_i;
      s_pb_prev <= pb_i;
    end if;
  end process p_process;

end architecture rtl;