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
signal RAM: ram_type := (2 => "11111111", 3 => "11111111", 4 => "00000000", 55 => "11111101", 87 => "01010110", 229 => "11011110", 237 => "00010001", 384 => "10010101", 411 => "01111001", 515 => "10001110", 725 => "01101011", 1169 => "01111000", 1263 => "01010110", 1324 => "10010100", 1535 => "00101100", 1561 => "00000011", 1589 => "11111010", 1814 => "11010110", 1853 => "11001001", 1997 => "00011100", 2115 => "01111100", 2375 => "10010100", 2395 => "10100011", 2563 => "01111110", 2582 => "00110111", 2762 => "01000011", 2994 => "10110101", 3064 => "01000010", 3178 => "01100100", 3214 => "11001101", 3436 => "11001000", 3485 => "00110111", 3493 => "10111010", 3589 => "01101110", 3648 => "11111110", 3915 => "10010111", 3956 => "11100011", 3978 => "11100100", 4019 => "11101010", 4073 => "01100011", 4679 => "01110000", 4767 => "10111111", 4801 => "00010000", 4999 => "01101010", 5060 => "10111010", 5148 => "11100100", 5241 => "00011011", 5279 => "00110110", 5366 => "10100001", 5541 => "00100111", 5607 => "11000001", 5707 => "01100001", 5712 => "11010000", 5722 => "11101101", 5724 => "10000101", 5865 => "00001110", 6258 => "00100001", 6289 => "11010001", 6529 => "01111101", 6586 => "10011111", 6693 => "10011100", 6773 => "10111000", 6894 => "00110101", 7019 => "01110001", 7048 => "11011010", 7073 => "00011111", 7420 => "00001010", 7462 => "10011000", 7486 => "00111111", 7527 => "00110110", 7701 => "00000011", 8109 => "11110110", 8110 => "11000110", 8357 => "01011110", 8371 => "10100000", 8404 => "10111100", 8635 => "11100101", 8638 => "01101011", 8669 => "11010110", 8698 => "11010000", 8726 => "01001111", 8972 => "00110110", 9110 => "11001011", 9147 => "10011101", 9228 => "10000101", 9286 => "10100110", 9546 => "01101010", 9655 => "01010111", 9657 => "01000001", 9792 => "11011101", 9794 => "00001000", 9824 => "01000101", 9825 => "10100111", 9833 => "00101110", 10107 => "10011011", 10140 => "10100100", 10173 => "11110010", 10230 => "01111000", 10300 => "11101011", 10457 => "10110100", 10473 => "01011100", 10675 => "10101001", 10820 => "10001010", 11027 => "11101101", 11167 => "11010100", 11205 => "10011111", 11210 => "11111110", 11251 => "10110111", 11307 => "10110011", 11618 => "10000101", 11633 => "11101110", 11651 => "11010001", 11711 => "11100000", 11999 => "01000100", 12126 => "01111101", 12127 => "01101100", 12144 => "00100100", 12191 => "00110110", 12434 => "11101010", 12496 => "10100101", 12507 => "01010111", 12603 => "00100001", 12623 => "01101100", 12710 => "11100001", 12818 => "00000101", 12913 => "01111010", 12932 => "00100100", 12942 => "01001001", 12983 => "10000111", 13023 => "11010011", 13048 => "10110111", 13098 => "10011010", 13150 => "00110111", 13391 => "01110000", 13522 => "11011110", 13532 => "01011100", 13628 => "11111110", 13693 => "01101100", 13736 => "11001111", 13919 => "00110011", 14040 => "11100010", 14081 => "11100010", 14290 => "00100100", 14331 => "11011010", 14469 => "11001101", 14597 => "11000001", 14624 => "00101011", 14771 => "00100111", 15039 => "10111100", 15207 => "00010001", 15453 => "10001100", 15491 => "11101110", 15502 => "00100010", 15594 => "11000101", 15771 => "01001111", 15791 => "10111100", 15810 => "10001101", 15831 => "11010010", 15866 => "11111101", 16026 => "01101000", 16123 => "00011001", 16128 => "11101111", 16134 => "00010100", 16142 => "10111010", 16212 => "10101000", 16433 => "00011100", 16500 => "01111001", 16548 => "10101100", 16590 => "00101100", 16691 => "10100001", 16987 => "00011011", 17034 => "11100000", 17108 => "11110101", 17253 => "00110101", 17310 => "10010001", 17450 => "00101100", 17459 => "01111101", 17589 => "11010011", 17599 => "01100110", 17652 => "11010100", 17702 => "10001110", 17756 => "01000111", 17854 => "00111001", 17878 => "10010010", 17930 => "10100011", 18112 => "11110000", 18201 => "01011111", 18288 => "00000001", 18306 => "11010000", 18466 => "11011011", 18591 => "10110111", 18765 => "11000001", 18970 => "11100000", 18985 => "01000010", 19024 => "01000001", 19279 => "11100111", 19303 => "01101101", 19324 => "10110101", 19461 => "11111111", 19624 => "11110001", 19812 => "00001111", 19904 => "00101111", 19936 => "01110010", 20078 => "01111010", 20330 => "10100100", 20334 => "00110101", 20642 => "11000100", 20817 => "10100011", 20983 => "10010001", 21067 => "00001011", 21125 => "01001011", 21135 => "00000011", 21302 => "11010101", 21356 => "10110111", 21387 => "11011101", 21520 => "11001010", 21557 => "10001000", 21570 => "00010001", 21582 => "11001011", 21628 => "01001010", 21648 => "10000000", 21697 => "10010000", 21926 => "10001111", 22042 => "10101110", 22067 => "00101111", 22323 => "11110000", 22620 => "01001010", 22737 => "01001101", 22794 => "10010010", 22860 => "01100001", 22861 => "00000111", 22873 => "11000110", 22916 => "01010000", 22977 => "10111110", 22990 => "01101011", 23148 => "10011101", 23230 => "01110101", 23295 => "01110111", 23307 => "10010010", 23320 => "00101000", 23515 => "00011010", 23655 => "11000111", 23840 => "10101111", 23922 => "11101000", 23937 => "01100000", 23979 => "01001001", 23980 => "00011111", 24084 => "01011100", 24137 => "11100011", 24219 => "10011010", 24229 => "11000101", 24239 => "11000000", 24243 => "11000010", 24250 => "11000011", 24303 => "01110010", 24322 => "00110111", 24501 => "11001010", 24536 => "10100000", 24624 => "10000101", 24780 => "01011110", 24793 => "11011100", 24806 => "11011001", 25107 => "11111011", 25210 => "01010100", 25275 => "11100001", 25283 => "11001010", 25578 => "10101101", 25729 => "11011011", 25734 => "00110010", 25791 => "11011111", 25919 => "01101100", 25971 => "01001001", 26202 => "10101000", 26214 => "01010110", 26216 => "10001101", 26261 => "11110100", 26400 => "11001001", 26429 => "10101110", 26451 => "10000010", 26668 => "00110110", 26977 => "01011010", 27481 => "00010010", 27549 => "11011110", 27829 => "01001110", 28015 => "10010110", 28034 => "01110000", 28336 => "10111011", 28511 => "11010111", 28770 => "10011000", 28812 => "10000011", 28947 => "01111100", 29111 => "00111000", 29206 => "01110000", 29283 => "10101000", 29369 => "11011111", 29484 => "01001001", 29511 => "01101001", 29537 => "01110000", 29652 => "10101100", 29693 => "01000010", 29896 => "01100100", 29899 => "01110000", 29929 => "11000100", 30212 => "10100001", 30311 => "01100010", 30323 => "10111111", 30334 => "01000010", 30337 => "11100010", 30341 => "11110001", 30375 => "00100011", 30391 => "00100111", 30497 => "01111100", 30517 => "10001100", 30571 => "11100110", 30581 => "00101011", 30609 => "01001000", 30624 => "11011011", 30737 => "00010111", 30828 => "00001000", 30865 => "10001111", 30872 => "11000011", 31053 => "00100001", 31236 => "00111000", 31257 => "10010001", 31333 => "00001010", 31351 => "10010010", 31422 => "01100101", 31424 => "01111100", 31505 => "00110000", 31509 => "11001001", 31609 => "01100011", 31849 => "10001101", 31880 => "11011111", 32116 => "00100001", 32140 => "10100001", 32141 => "01111010", 32164 => "00001000", 32190 => "11110101", 32397 => "00011101", 32431 => "00100010", 32642 => "11111001", 32688 => "11110101", 32740 => "00110000", others => (others =>'0'));component project_reti_logiche is 
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

assert RAM(1) = "11111110" report "FAIL high bits" severity failure;
assert RAM(0) = "00000001" report "FAIL low bits" severity failure;
assert false report "Simulation Ended!, test passed" severity failure;
end process test;
end projecttb;