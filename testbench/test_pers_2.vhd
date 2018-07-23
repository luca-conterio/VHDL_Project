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
signal RAM: ram_type := (2 => "00000010", 3 => "01100100", 4 => "01001000", 6 => "11010011", 11 => "00111000", 14 => "11101101", 15 => "10101011", 18 => "10010011", 20 => "11110110", 22 => "01010100", 23 => "00100100", 25 => "10001110", 26 => "10101100", 27 => "11001101", 28 => "01111100", 38 => "01000010", 44 => "11100011", 45 => "01011110", 49 => "00000110", 50 => "01101010", 52 => "11010001", 56 => "10000101", 60 => "01100100", 61 => "00010100", 64 => "10000010", 66 => "10000001", 67 => "01101110", 68 => "01001010", 70 => "10010000", 72 => "11100001", 74 => "01111110", 77 => "11111101", 79 => "01110001", 80 => "01001011", 81 => "01001101", 82 => "01110000", 86 => "00001100", 87 => "10110111", 89 => "00011011", 94 => "00011111", 98 => "10011011", 100 => "00101100", 101 => "01000001", 103 => "00101100", 106 => "00101001", 107 => "10010110", 111 => "10010010", 113 => "10110011", 114 => "01111101", 115 => "00010110", 117 => "11110111", 120 => "11101111", 122 => "11101011", 124 => "11110110", 128 => "01100010", 129 => "00010101", 131 => "11100111", 133 => "10010101", 134 => "10010101", 140 => "01100011", 144 => "11001011", 145 => "11111110", 146 => "11101100", 147 => "00010011", 148 => "11100011", 152 => "00101011", 159 => "01000110", 160 => "00000010", 162 => "00010111", 164 => "10001000", 166 => "10000101", 167 => "11010011", 171 => "11010001", 175 => "10101111", 176 => "00110000", 178 => "01100011", 181 => "11110110", 182 => "01100000", 185 => "10010011", 191 => "00100010", 194 => "11101100", 198 => "11010101", others => (others =>'0'));component project_reti_logiche is 
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
assert RAM(0) = "11000010" report "FAIL low bits" severity failure;
assert false report "Simulation Ended!, test passed" severity failure;
end process test;
end projecttb;