-------------------------------------------------------------------------------
-- Simulation model for a VGA monitor with 640x480 pixels resolution
-- and 60 Hz frame rate 
--
-- Author: Peter Roessler
-- Affiliation: University of Applied Sciences Technikum Wien
--              Department of Embedded Systems
-- WWW: http://embsys.technikum-wien.at
-- Date: 2015-02-28
-- Filename: vga_monitor_sim.vhd (VHDL Architecture)
--
-- Description: Simulates a VGA monitor with a resolution of 640x480 pixels
--              and a frame rate of 60 Hz. See header of entity "vga_monitor"
--              concerning details on the functionality and the usage of the
--              simulation model.              
--              
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.conv_integer;
use std.textio.all;

architecture sim of vga_monitor is 

  -- VGA timing parameters for 640x480 pixels resolution @ 60 Hz frame rate 
  constant c_pixclk       : time := 40 ns;              -- pixel clock period (1/25 MHz)
  constant c_h_res        : integer := 640;             -- horizontal resolution (pixels)
  constant c_v_res        : integer := 480;             -- vertical resolution (pixels)
  constant c_h_frontporch : time := c_pixclk*16;        -- horizontal front porch
  constant c_h_syncwidth  : time := c_pixclk*96;        -- width of horizontal sync pulse
  constant c_h_backporch  : time := c_pixclk*48;        -- horizontal back porch
  constant c_h_line       : time := c_pixclk*c_h_res +  -- duration of whole line
                                    c_h_frontporch +
                                    c_h_syncwidth +
                                    c_h_backporch;
  constant c_v_frontporch : time := c_h_line*10;        -- vertical front porch
  constant c_v_syncwidth  : time := c_h_line*2;         -- width of vertical sync pulse
  constant c_v_backporch  : integer := 33;              -- vertical back porch (number of lines)
  constant c_v_frame      : integer := c_v_res +        -- duration of whole frame (number of lines)
                                    c_v_frontporch/c_h_line +
                                    c_v_syncwidth/c_h_line +
                                    c_v_backporch;
  constant c_v_nosync     : time := c_h_line*c_v_res +  -- duration of whole frame minus vertical sync pulse 
                                    c_v_frontporch +
                                    c_h_line*c_v_backporch;

  -- state of vertical VGA timing FSM
  type t_vstate is (RESET, V_FIRSTSYNC, V_WAITSYNC, V_SYNC, IDLE);
  signal s_vstate : t_vstate := RESET;

  -- state of horizontal VGA timing FSM
  type t_hstate is (V_FIRSTSYNC, H_FIRSTSYNC, H_FRONTPORCH, H_SYNC, H_BACKPORCH, H_VISIBLE, IDLE);
  signal s_hstate : t_hstate := V_FIRSTSYNC;

  -- frame, line and pixel that is currently being processed 
  signal s_frame : integer;
  signal s_line : integer;
  signal s_pixel : integer;

  -- "timer" signal
  signal s_timer : boolean := false;
  
begin

  -----------------------------------------------------------------------------
  -- state machine which handles vertical VGA timing of the VGA monitor
  -----------------------------------------------------------------------------
  p_vtiming : process (s_reset_i, s_vga_vsync_i, s_hstate)

    variable v_t : time;

  begin
    case s_vstate is

      -------------------------------------------------------------------------
      -- STATE "Reset"
      -------------------------------------------------------------------------
      when RESET =>
        -- reset deasserted
        if (s_reset_i = '0') then
          assert false
            report "VGA Monitor: Reset deasserted, waiting for V-Sync pulse ..."
            severity note;
          s_vstate <= V_FIRSTSYNC;
        end if;

      -------------------------------------------------------------------------
      -- STATE "Wait for first V-Sync pulse after reset"
      -------------------------------------------------------------------------
      when V_FIRSTSYNC =>
        if (s_reset_i = '1') then
          s_vstate <= RESET;

        -- falling V-Sync edge detected
        elsif (s_vga_vsync_i'event and s_vga_vsync_i = '0') then
          assert false
            report "VGA Monitor: Falling V-Sync edge detected, starting to perform vertical timing checks ..."
            severity note;
          v_t := now;
          s_vstate <= V_WAITSYNC;
        end if;

      -------------------------------------------------------------------------
      -- STATE "Wait for next V-Sync pulse"
      -------------------------------------------------------------------------
      when V_WAITSYNC =>
        if (s_reset_i = '1') then
          s_vstate <= RESET;

        elsif (s_hstate = IDLE) then
          s_vstate <= IDLE;

        elsif (s_vga_vsync_i = '1') then
          if ((now - v_t) < c_v_nosync) then
            assert false
              report "VGA Monitor: Rising V-Sync edge too early while receiving frame " &
                integer'image(s_frame) & "!"
              severity failure;
            s_vstate <= IDLE;

          elsif ((now - v_t) > c_v_nosync) then
            assert false
              report "VGA Monitor: Rising V-Sync edge missing while receiving frame " &
                integer'image(s_frame) & "!"
              severity failure;
            s_vstate <= IDLE;

          -- next V-Sync pulse
          else
            v_t := now;
            s_vstate <= V_SYNC;
          end if;
        end if;

      -------------------------------------------------------------------------
      -- STATE "V-Sync pulse"
      -------------------------------------------------------------------------
      when V_SYNC =>
        if (s_reset_i = '1') then
          s_vstate <= RESET;

        elsif (s_hstate = IDLE) then
          s_vstate <= IDLE;

        elsif (s_vga_vsync_i = '0') then
          if ((now - v_t) < c_v_syncwidth) then
            assert false
              report "VGA Monitor: Falling V-Sync edge too early while receiving frame " &
                integer'image(s_frame) & "!"
              severity failure;
            s_vstate <= IDLE;

          elsif ((now - v_t) > c_v_syncwidth) then
            assert false
              report "VGA Monitor: Falling V-Sync missing while receiving frame " &
                integer'image(s_frame) & "!"
              severity failure;
            s_vstate <= IDLE;

          -- end of V-Sync pulse
          else
            v_t := now;
            s_vstate <= V_WAITSYNC;
          end if;
        end if;

      -------------------------------------------------------------------------
      -- STATE "Idle state"
      -------------------------------------------------------------------------
      when IDLE =>
        null; -- wait until end of simulation

    end case;
  end process p_vtiming;

  -----------------------------------------------------------------------------
  -- state machine which handles horizontal VGA timing of the VGA monitor
  -----------------------------------------------------------------------------
  p_htiming : process (s_reset_i, s_vga_hsync_i, s_vga_vsync_i, s_timer,
                       s_vstate, s_vga_red_i, s_vga_green_i, s_vga_blue_i)

    variable v_t : time;

    -- file holding a single frame received from the VGA interface 
    file f_image : text;
    variable v_filestatus : file_open_status;
    variable v_fileline : line;
    variable v_filename : string(1 to 11);

  begin
    case s_hstate is

      -------------------------------------------------------------------------
      -- STATE "Wait for first V-Sync pulse after reset"
      -------------------------------------------------------------------------
      when V_FIRSTSYNC =>
        -- first falling V-Sync edge after reset detected 
        if ((s_vga_vsync_i'event and s_vga_vsync_i = '0') and
            (s_vstate = V_FIRSTSYNC)) then
          s_frame <= 0;
          s_pixel <= 0;
           
          -- rising H-Sync edge during falling V-Sync edge
          if (s_vga_hsync_i'event and s_vga_hsync_i = '1') then
            assert false
              report "VGA Monitor: Rising H-Sync edge detected, starting to perform horizontal timing checks ..."
              severity note;
            v_t := now;
            s_line <= c_v_frame - c_v_backporch - 1;
            s_hstate <= H_SYNC;

          else
            v_t := now;
            s_hstate <= H_FIRSTSYNC;
          end if;
        end if;

      -------------------------------------------------------------------------
      -- STATE "Wait for first H-Sync pulse after first V-Sync pulse"
      -------------------------------------------------------------------------
      when H_FIRSTSYNC =>
        if (s_reset_i = '1') then
          s_hstate <= V_FIRSTSYNC;

        elsif (s_vstate = IDLE) then
          s_hstate <= IDLE;

        -- rising H-Sync edge detected
        elsif (s_vga_hsync_i'event and s_vga_hsync_i = '1') then
          assert false
            report "VGA Monitor: Rising H-Sync edge detected, starting to perform horizontal timing checks ..."
            severity note;
          if ((now - v_t) <= c_h_frontporch) then
            s_line <= c_v_frame - c_v_backporch - 1;

          elsif (((now - v_t) >= (c_h_frontporch + c_h_res*c_pixclk)) and
                 ((now - v_t) <= c_h_line)) then
            s_line <= c_v_frame - c_v_backporch;

          else
            assert false
              report "VGA Monitor: Invalid phase shift between V-Sync pulse and H-Sync pulse!"
              severity failure;
            s_hstate <= IDLE;
          end if;

          v_t := now;
          s_hstate <= H_SYNC;
        end if;

      -------------------------------------------------------------------------
      -- STATE "H-Sync pulse"
      -------------------------------------------------------------------------
      when H_SYNC =>
        if (s_reset_i = '1') then
          file_close(f_image);
          s_hstate <= V_FIRSTSYNC;

        elsif (s_vstate = IDLE) then
          file_close(f_image);
          s_hstate <= IDLE;

        elsif ((s_vga_red_i /= "0000") or (s_vga_green_i /= "0000") or (s_vga_blue_i /= "0000")) then
          file_close(f_image);
          assert false
            report "VGA Monitor: No blanking value on RGB signals during horizontal sync pulse in line " &
              integer'image(s_line) & ", frame " & integer'image(s_frame) & "!"
            severity failure;
          s_hstate <= IDLE;

        elsif (s_vga_hsync_i = '0') then
          if ((now - v_t) < c_h_syncwidth) then
            file_close(f_image);
            assert false
              report "VGA Monitor: Falling H-Sync edge too early while receiving line " &
                integer'image(s_line) & ", frame " & integer'image(s_frame) & "!"
              severity failure;
            s_hstate <= IDLE;

          elsif ((now - v_t) > c_h_syncwidth) then
            file_close(f_image);
            assert false
              report "VGA Monitor: Falling H-Sync edge missing while receiving line " &
                integer'image(s_line) & ", frame " & integer'image(s_frame) & "!"
              severity failure;
            s_hstate <= IDLE;

          -- end of H-Sync pulse
          else
            v_t := now;
            s_timer <= false, true after c_h_backporch;  
            s_hstate <= H_BACKPORCH;
          end if;
        end if;

      -------------------------------------------------------------------------
      -- STATE "Horizontal back porch"
      -------------------------------------------------------------------------
      when H_BACKPORCH =>
        if (s_reset_i = '1') then
          file_close(f_image);
          s_hstate <= V_FIRSTSYNC;

        elsif (s_vstate = IDLE) then
          file_close(f_image);
          s_hstate <= IDLE;

        elsif (((s_vga_red_i /= "0000") or (s_vga_green_i /= "0000") or (s_vga_blue_i /= "0000")) and
               ((now - v_t) /= c_h_backporch)) then
          file_close(f_image);
          assert false
            report "VGA Monitor: No blanking value on RGB signals during horizontal back porch in line " &
              integer'image(s_line) & ", frame " & integer'image(s_frame) & "!"
            severity failure;
          s_hstate <= IDLE;

        elsif (s_vga_hsync_i = '1') then
          file_close(f_image);
          assert false
            report "VGA Monitor: Rising H-Sync edge during horizontal back porch in line " &
              integer'image(s_line) & ", frame " & integer'image(s_frame) & "!"
            severity failure;
          s_hstate <= IDLE;
          
        -- end of horizontal back porch
        elsif (s_timer) then
          if (s_line = (c_v_frame - 1)) then -- last line in current frame
            file_close(f_image);
            if (s_frame = g_no_frames) then
              assert false
                report "VGA Monitor: " & integer'image(s_frame) & " frames successfully received (actually no failure)!"
                severity failure;
              s_hstate <= IDLE;
            else
              v_t := now;
              s_frame <= s_frame + 1;
              s_line <= 0;
              assert false
                report "VGA Monitor: Starting to store image data of frame " & integer'image(s_frame + 1) & " ..."
                severity note;

              -- open new image file for write accesse to store image data
              if (s_frame < (10 - 1)) then
                v_filename := "frame0" & integer'image(s_frame + 1) & ".ppm";
              else
                v_filename := "frame" & integer'image(s_frame + 1) & ".ppm";
              end if;
              file_open(v_filestatus, f_image, g_path & v_filename, WRITE_MODE); 
              if (v_filestatus /= OPEN_OK) then
                assert false
                  report "VGA Monitor: Cannot open file " & g_path & v_filename & " for write access!"
                  severity failure;
                s_hstate <= IDLE;
              else
                -- write header (as defined by PPM graphics format) to current image file:
                -- * P3 (identifies "PPM ASCII" format)
                -- * horizontal resolution of image
                -- * vertical resolution of image
                -- * 15 (color depth)
                write(v_fileline, string'("P3 "));
                write(v_fileline, c_h_res);
                write(v_fileline, string'(" "));
                write(v_fileline, c_v_res);
                write(v_fileline, string'(" 15"));
                writeline(f_image, v_fileline);
              end if;
            end if;

          else
            v_t := now;
            s_line <= s_line + 1;
          end if;

          s_timer <= false, true after c_pixclk;  
          s_hstate <= H_VISIBLE;
        end if;

      -------------------------------------------------------------------------
      -- STATE "Visible area"
      -------------------------------------------------------------------------
      when H_VISIBLE =>
        if (s_reset_i = '1') then
          file_close(f_image);
          s_hstate <= V_FIRSTSYNC;

        elsif (s_vstate = IDLE) then
          file_close(f_image);
          s_hstate <= IDLE;

        elsif (s_vga_hsync_i = '1') then
          file_close(f_image);
          assert false
            report "VGA Monitor: Rising H-Sync edge too early while receiving frame " &
              integer'image(s_frame) & ", line " & integer'image(s_line) & ", pixel " &
              integer'image(s_pixel)
            severity failure;
          s_hstate <= IDLE;
          
        -- next pixel received
        elsif (s_timer) then
          if (s_line < c_v_res) then
            -- write current pixel (consisting of RGB triplet) to image file:
            write(v_fileline, conv_integer(s_vga_red_i));
            write(v_fileline, string'(" "));
            write(v_fileline, conv_integer(s_vga_green_i));
            write(v_fileline, string'(" "));
            write(v_fileline, conv_integer(s_vga_blue_i));
            writeline(f_image, v_fileline);
          end if;

          if (s_pixel = (c_h_res - 1)) then -- last pixel in current line
            v_t := now;
            s_pixel <= 0; 
            s_timer <= false, true after c_h_frontporch;  
            s_hstate <= H_FRONTPORCH;
          else
            s_pixel <= s_pixel + 1; 
            s_timer <= false, true after c_pixclk;  
          end if;
        end if;

      -------------------------------------------------------------------------
      -- STATE "Horizontal front porch"
      -------------------------------------------------------------------------
      when H_FRONTPORCH =>
        if (s_reset_i = '1') then
          file_close(f_image);
          s_hstate <= V_FIRSTSYNC;

        elsif (s_vstate = IDLE) then
          file_close(f_image);
          s_hstate <= IDLE;

        elsif (((s_vga_red_i /= "0000") or (s_vga_green_i /= "0000") or (s_vga_blue_i /= "0000")) and
               (v_t /= now)) then
          file_close(f_image);
          assert false
            report "VGA Monitor: No blanking value on RGB signals during horizontal front porch in line " &
              integer'image(s_line) & ", frame " & integer'image(s_frame) & "!"
            severity failure;
          s_hstate <= IDLE;

        elsif (s_vga_hsync_i = '1') then
          if ((now - v_t) < c_h_frontporch) then
            file_close(f_image);
            assert false
              report "VGA Monitor: Rising H-Sync edge too early during horizontal front porch in line " &
                integer'image(s_line) & ", frame " & integer'image(s_frame) & "!"
              severity failure;
            s_hstate <= IDLE;

          elsif ((now - v_t) > c_h_frontporch) then
            file_close(f_image);
            assert false
              report "VGA Monitor: Rising H-Sync edge missing while receiving line " &
                integer'image(s_line) & ", frame " & integer'image(s_frame) & "!"
              severity failure;
            s_hstate <= IDLE;

          -- end of horizontal front porch
          else
            v_t := now;
            s_hstate <= H_SYNC;
          end if;
        end if;
          
      -------------------------------------------------------------------------
      -- STATE "Idle state"
      -------------------------------------------------------------------------
      when IDLE =>
        null; -- wait until end of simulation

    end case;
  end process p_htiming;
end sim; 
