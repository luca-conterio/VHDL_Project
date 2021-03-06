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
-- immagine 10x24 con minr=1, maxr=5   -------------> AGGUINGERE POI MINC E MAXC
signal RAM: ram_type := (2 => "00011000", 3 => "00001010", 4 => "10000000", 103 => "10000000", 46 => "10000000", 106 => "10000000", 40 => "10000000", 121 => "10000000", 32 => "10000000", 138 => "10000000", 111 => "10000000", 135 => "10000000", 134 => "10000000", 109 => "10000000", 97 => "10000000", 65 => "10000000", 117 => "10000000", 127 => "10000000", 123 => "10000000", 55 => "10000000", 39 => "10000000", 72 => "10000000", 132 => "10000000", 133 => "10000000", 57 => "10000000", 35 => "10000000", 131 => "10000000", 116 => "10000000", 137 => "10000000", 130 => "10000000", 56 => "10000000", 128 => "10000000", 96 => "10000000", 124 => "10000000", 107 => "10000000", 54 => "10000000", 139 => "10000000", 125 => "10000000", 110 => "10000000", 38 => "10000000", 93 => "10000000", 114 => "10000000", 136 => "10000000", 33 => "10000000", 85 => "10000000", 99 => "10000000", 66 => "10000000", 60 => "10000000", 94 => "10000000", 129 => "10000000", 101 => "10000000", 44 => "10000000", 76 => "10000000", others => (others =>'0'));


component project_reti_logiche is
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

