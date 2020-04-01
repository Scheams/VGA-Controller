-------------------------------------------------------------------------------
-- Simulation model for a VGA Monitor with 640x480 pixels resolution
-- and 60 Hz frame rate 
--
-- Author: Peter Roessler
-- Affiliation: University of Applied Sciences Technikum Wien
--              Department of Embedded Systems
-- WWW: http://embsys.technikum-wien.at
-- Date: 2015-02-28
-- Filename: vga_monitor_.vhd (VHDL Entity)
--
-- Description: Simulates a VGA Monitor with a resolution of 640x480 pixels
--              and a frame rate of 60 Hz. Once the first vertical sync
--              pulse followed by a horizontal sync pulse is received after
--              a reset, the model starts to perform timing checks for all
--              following horizontal and vertical sync pulses as well as for
--              the blanking periods during the front and back porch.
--              Additionally, all frames received from the VGA interface
--              are stored as images in the PPM (Portable Pixmap)
--              graphics format.   
--
-- Generics: g_no_frames ...... Number of frames received from the VGA interface
--                              that are being processed by the simulation model.
--                              Each received frame will be stored as an image,
--                              named "frame01.ppm", "frame02.ppm" ... to
--                              "frameXX.ppm" (where XX = g_no_frames).
--                              Be careful! Each single PPM file has a size of
--                              up to 3 MBytes!   
--           g_path ........... Path where the PPM files will be stored.
--                              For example, if g_path = "vga_output/" all images
--                              are stored in the sub-directory "vga_output" that
--                              resides in simulator's directory. Note, that the
--                              the path must exist (otherwise the simulation model
--                              will terminate with an error message).
--
-- I/O Ports: s_reset_i ....... hi-active reset signal
--            s_vga_red_i ..... red color component (4 bit) of VGA interface             
--            s_vga_green_i ... green color component (4 bit) of VGA interface              
--            s_vga_blue_i .... blue color component (4 bit) of VGA interface              
--            s_vga_hsync_i ... horizontal sync line (active hi) of VGA interface
--            s_vga_vsync_i ... vertical sync line (active hi) of VGA interface
--            
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity vga_monitor is
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
end vga_monitor;
