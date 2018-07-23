----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2017 17:48:44
-- Design Name: 
-- Module Name: FSM_testbench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
 
entity project_tb is
end project_tb;


architecture projecttb of project_tb is
constant c_CLOCK_PERIOD		: time := 15 ns;
signal   tb_done		: std_logic;
signal   mem_address		: std_logic_vector (15 downto 0) := (others => '0');
signal   tb_rst		    : std_logic := '0';
signal   tb_start		: std_logic := '0';
signal   tb_clk		    : std_logic := '0';
signal   mem_o_data,mem_i_data		: std_logic_vector (7 downto 0);
signal   enable_wire  		: std_logic;
signal   mem_we		: std_logic;

type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
signal RAM: ram_type := (2 => "01101001", 3 => "00001100", 4 => "11111111", 9 => "01001011", 16 => "00110010", 30 => "00101101", 33 => "11000001", 53 => "10010001", 58 => "01001101", 62 => "11000111", 85 => "10001111", 86 => "11111011", 93 => "10100001", 106 => "00101100", 115 => "00100011", 119 => "00111010", 125 => "00010010", 140 => "00100111", 144 => "01100010", 148 => "00011101", 150 => "10001111", 204 => "11011000", 206 => "10011010", 246 => "10000010", 259 => "11000111", 373 => "11110101", 379 => "11101110", 380 => "01011010", 398 => "11010011", 406 => "11010010", 417 => "11111011", 419 => "10011010", 435 => "11111110", 440 => "11111011", 453 => "00111100", 481 => "10100010", 483 => "10000100", 485 => "00010110", 510 => "00101101", 514 => "11100111", 527 => "11001100", 553 => "00101010", 555 => "10011010", 558 => "10011100", 567 => "11000100", 579 => "00000001", 597 => "10100010", 605 => "01001101", 633 => "01001100", 640 => "11101110", 647 => "00010011", 648 => "00110101", 658 => "11111000", 677 => "00110110", 687 => "10101100", 713 => "11010000", 727 => "00011101", 742 => "01100100", 784 => "01011011", 794 => "01000010", 809 => "11000101", 823 => "10010010", 836 => "01111100", 855 => "10110010", 873 => "00011101", 874 => "11001111", 905 => "01101100", 946 => "11010100", 958 => "10110001", 976 => "01110000", 987 => "10110010", 1032 => "00101011", 1049 => "11011011", 1054 => "00100110", 1063 => "10010110", 1093 => "10111101", 1099 => "01110011", 1100 => "11101101", 1105 => "01110100", 1113 => "10011100", 1130 => "11010000", 1141 => "10001111", 1153 => "11000001", 1168 => "11011000", 1194 => "00100010", 1202 => "11000010", 1209 => "00110100", 1216 => "11000011", 1217 => "11010010", 1222 => "11010100", 1224 => "11111011", 1225 => "00011010", 1233 => "11010110", 1235 => "10101010", 1239 => "00001100", 1257 => "11011101", 1258 => "11111011", others => (others =>'0'));component project_reti_logiche is 
    port (
            i_clk         : in  std_logic;
            i_start       : in  std_logic;
            i_rst         : in  std_logic;
            i_data       : in  std_logic_vector(7 downto 0); --1 byte
            o_address     : out std_logic_vector(15 downto 0); --16 bit addr: max size is 255*255 + 3 more for max x and y and thresh.
            o_done            : out std_logic;
            o_en         : out std_logic;
            o_we       : out std_logic;
            o_data            : out std_logic_vector (7 downto 0)
          );
end component project_reti_logiche;


begin 
	UUT: project_reti_logiche
	port map (
		  i_clk      	=> tb_clk,	
          i_start       => tb_start,
          i_rst      	=> tb_rst,
          i_data    	=> mem_o_data,
          o_address  	=> mem_address, 
          o_done      	=> tb_done,
          o_en   	=> enable_wire,
		  o_we 	=> mem_we,
          o_data    => mem_i_data
);

p_CLK_GEN : process is
  begin
    wait for c_CLOCK_PERIOD/2;
    tb_clk <= not tb_clk;
  end process p_CLK_GEN; 
  
  
MEM : process(tb_clk)
   begin
    if tb_clk'event and tb_clk = '1' then
     if enable_wire = '1' then
      if mem_we = '1' then
       RAM(conv_integer(mem_address))              <= mem_i_data;
       mem_o_data                      <= mem_i_data after 1 ns;
      else
       mem_o_data <= RAM(conv_integer(mem_address)) after 1 ns;
      end if;
     end if;
    end if;
   end process;
 
  
test : process is
begin 
wait for 100 ns;
wait for c_CLOCK_PERIOD;
tb_rst <= '1';
wait for c_CLOCK_PERIOD;
tb_rst <= '0';
wait for c_CLOCK_PERIOD;
tb_start <= '1';
wait for c_CLOCK_PERIOD; 
tb_start <= '0';
wait until tb_done = '1';
wait until tb_done = '0';
wait until rising_edge(tb_clk); 

assert RAM(1) = "00000000" report "FAIL high bits" severity failure;
assert RAM(0) = "00000000" report "FAIL low bits" severity failure;
assert false report "Simulation Ended!, test passed" severity failure;
end process test;
end projecttb;