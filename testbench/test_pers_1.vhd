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
signal RAM: ram_type := (2 => "10000110", 3 => "11101110", 4 => "10001011", 8 => "10000110", 66 => "01000100", 350 => "00010011", 635 => "11111101", 652 => "10101001", 750 => "11000001", 916 => "00110101", 1006 => "00111101", 1394 => "10100111", 1428 => "10010111", 1640 => "10100010", 1802 => "00010001", 1830 => "10111101", 1876 => "00101000", 1904 => "11011111", 2445 => "00010010", 2542 => "01110101", 4152 => "01011001", 4354 => "01011011", 4494 => "01000101", 6623 => "11001011", 7824 => "00011101", 8082 => "11000111", 8271 => "11101100", 8641 => "01010100", 8677 => "10000101", 8830 => "10001101", 8888 => "01001011", 9165 => "01100001", 9377 => "10111100", 10104 => "11111100", 10292 => "01100111", 10506 => "10110010", 10619 => "00110010", 10669 => "10010011", 10843 => "00110110", 10859 => "01011010", 11069 => "01100110", 11863 => "00000111", 12944 => "11110011", 13256 => "11010110", 13317 => "11101100", 13336 => "11110111", 13430 => "11010011", 13908 => "00001010", 14465 => "01100110", 14587 => "11100011", 14593 => "11010001", 14661 => "00101001", 15114 => "00100100", 15190 => "00111111", 15213 => "01001111", 15249 => "01111001", 15315 => "00010011", 15373 => "01010011", 16478 => "01001110", 16519 => "10001111", 16969 => "01100000", 17271 => "00101100", 17308 => "10100110", 17892 => "01101111", 17970 => "11100111", 18797 => "11000001", 18822 => "11101110", 19260 => "11011101", 19595 => "00100110", 19772 => "10001011", 20434 => "00001100", 20583 => "11110110", 21055 => "01000011", 21247 => "00011110", 22050 => "01001001", 22091 => "01100110", 22183 => "01000100", 22683 => "01010100", 22759 => "01101000", 22761 => "01110001", 23030 => "11011101", 23242 => "00100110", 23384 => "00001001", 23576 => "11110101", 23991 => "00010100", 25273 => "01111110", 25854 => "10000101", 26465 => "01010111", 26641 => "11100011", 27016 => "10111001", 27211 => "01001001", 27509 => "10010110", 27626 => "01100110", 27736 => "01011010", 27854 => "11100100", 27863 => "01100111", 28499 => "10011000", 28901 => "11011111", 29524 => "10100111", 30287 => "10001001", 30293 => "10000000", 31130 => "10100111", others => (others =>'0'));component project_reti_logiche is 
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

assert RAM(1) = "01101001" report "FAIL high bits" severity failure;
assert RAM(0) = "10001110" report "FAIL low bits" severity failure;
assert false report "Simulation Ended!, test passed" severity failure;
end process test;
end projecttb;