----------------------------------------------------------------------------------
-- Company:
-- Engineer:
-- Luca Conterio - Matricola: 843317 - Cod. Persona: 10498418
-- Andrea Donati - Matricola: 847492 - Cod. Persona: 10497694
--
-- Create Date: 03/04/2018 10:09:07 AM
-- Design Name:
-- Module Name: project_reti_logiche - Behavioral
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is
     Port (
           i_clk       : in std_logic;
           i_start     : in std_logic;
           i_rst       : in std_logic;
           i_data      : in std_logic_vector(7 downto 0);
           o_address   : out std_logic_vector(15 downto 0);
           o_data      : out std_logic_vector(7 downto 0);
           o_en        : out std_logic;
           o_we        : out std_logic;
           o_done      : out std_logic
     );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is

type state_type is (RESET, S0, S1, S2, S3, CALC, AREA0, AREA1, WRITE0, WRITE1, FINE);

signal state      : state_type := RESET;                                              -- stato della macchina
signal next_state : state_type := S0;                                                 -- stato prossimo della macchina

signal start      : std_logic := '0';                                                 -- se = '1' fa partire la computazione
signal fine_mult  : std_logic := '0';
signal trov       : std_logic := '0';
signal geSoglia   : std_logic := '0';
signal fine_imm   : std_logic := '0';
signal finito     : std_logic := '0';                                                 -- se = '1' indica fine della computazione
signal addr       : std_logic_vector (15 downto 0) := (1=>'1',others => '0');         -- contatore per gli indirizzi
signal ncol       : std_logic_vector (7 downto 0);                                    -- numero colonne della matrice
signal nrow       : std_logic_vector (7 downto 0);                                    -- numero righe della matrice
signal rows       : std_logic_vector (7 downto 0);                                    -- numero righe effettive dell'immagine    --->  usate per il calcolo 
signal cols       : std_logic_vector (7 downto 0);                                    -- numero colonne effettive dell'immagine        del risultato (area immagine)
signal soglia     : std_logic_vector (7 downto 0);                                    -- soglia di accettazione per i pixel dell'immagine
signal result     : std_logic_vector (15 downto 0) := (others => '0');                -- area effettiva dell'immagine
signal curr_row   : std_logic_vector (7 downto 0) := (others => '0');                 -- riga corrente
signal curr_col   : std_logic_vector (7 downto 0) := (others => '0');                 -- colonna corrente
signal maxr       : std_logic_vector (7 downto 0);                                    -- prima riga con almeno un val >= soglia
signal minr       : std_logic_vector (7 downto 0);                                    -- ultima riga con almeno un val >= soglia
signal maxc       : std_logic_vector (7 downto 0);                                    -- prima colonna con almeno un val >= soglia
signal minc       : std_logic_vector (7 downto 0);                                    -- ultima colonna con almeno un val >= soglia
signal cont       : std_logic_vector (7 downto 0) := (others => '0');                 -- contatore utilizzato per calcolo di maxc, inizializzato a 1


begin
    
    o_we      <= '1' when state = WRITE0 or state = WRITE1 else '0';
    o_en      <= '1' when start = '1' else '0';
    
    o_address <= addr;
    
    geSoglia  <= '1' when i_data >= soglia else '0';
    fine_imm  <= '1' when curr_row > nrow or curr_row = 255 else '0';
    fine_mult <= '1' when cont = rows else '0';
    
    finito    <= '1' when state = FINE else '0';                -- utilizzo anche il segnale "finito" perché non posso leggere il valore di o_done dato che è solo output
    o_done    <= finito;
    
    STATE_REG: process(i_clk, i_start, i_rst, start, finito)
        begin
            if rising_edge(i_start) then                        -- inizio computazione
                start <= '1';
            end if;
            
            if rising_edge(i_rst) or rising_edge(finito) then   -- se i_rst = '1' devo resettare e ricominciare
                start <= '0';                                   -- se finito = '1', resetto perché ho finito il calcolo dell'area
            end if;
            
            if falling_edge(i_clk) then
                if start = '1' then        
                    state <= next_state;   -- eseguo l'operazione "state <= next_state" in modo che sia sincrona con il clock e solo se il segnale interno "start" è a 1   
                else 
                    state <= RESET;        -- altrimenti vado in RESET e poi in S0, aspettando l'arrivo di un segnale di start
                end if;
            end if;
            
        end process STATE_REG;

    FSM: process(i_clk, state, start, addr, fine_mult, fine_imm, trov)
        begin
            
            if falling_edge(i_clk) then
            
                case state is
                    
                   when RESET   =>  next_state <= S0;
                
                   when S0      =>  ncol <= i_data;                       -- leggo valore indirizzo 2 (numero colonne)
                                    next_state <= S1;
    
                   when S1      =>  nrow <= i_data;                       -- leggo valore indirizzo 3 (numero righe)
                                    next_state <= S2;
                   
                   when S2      =>  soglia   <= i_data;                   -- leggo valore indirizzo 4 (valore di soglia)
                                    next_state <= S3;
                                    
                   when S3      =>  next_state <= CALC;
                                    
                   when CALC    =>  if fine_imm = '1' then
                                       if trov = '1' then
                                           next_state <= AREA0;
                                       else 
                                           next_state <= WRITE0;
                                       end if;
                                    end if;
                   
                   when AREA0  =>  cols <= (maxc - minc) + 1;
                                   rows <= (maxr - minr) + 1;
                                   next_state <= AREA1;
                                    
                   when AREA1   =>  if fine_mult = '1' then
                                       next_state <= WRITE0;
                                    end if;
    
                   when WRITE0  =>  o_data <= result(7 downto 0);  -- scrivo 8 bit meno significativi (7 downto 0)
                                    next_state <= WRITE1;
    
                   when WRITE1  =>  o_data <= result(15 downto 8); -- scrivo 8 bit piu' significativi (15 downto 8)
                                    next_state <= FINE;  
                                    
                   when FINE    =>  next_state <= RESET;
    
                   when others  =>  next_state <= FINE;
                   
                end case;
            end if;
            
        end process FSM;
        
    ADDRESS_COUNTER: process(i_clk, state, start)
        begin
           if falling_edge(i_clk) then
                case state is 
                    when S0     =>  addr <= (1=>'1', others=>'0');
                    when S1     =>  addr <= (0=>'1', 1=>'1', others=>'0');
                    when S2     =>  addr <= (2=>'1', others=>'0');
                    when S3     =>  addr <= (0=>'1', 2=>'1', others=>'0');
                    when CALC   =>  if curr_row <= nrow then
                                        addr <= addr + 1;
                                    end if;
                    when WRITE0 =>  addr <= (others=>'0');
                    when WRITE1 =>  addr <= (0=>'1', others=>'0');
                    when others =>  -- non faccio nulla;
                end case;
            end if;
        end process ADDRESS_COUNTER;
                    
    COMPARATOR_SOGLIA: process(i_clk, i_data, state)
        begin
            if falling_edge(i_clk) then
                case state is
                    when RESET  =>  trov <= '0';
                    when CALC   =>  if geSoglia = '1' then
                                       trov <= '1';
                                    end if;
                    when others => -- non faccio nulla;
                end case;
             end if;
         end process COMPARATOR_SOGLIA;
        
    COMPUTATION_1: process(i_clk, state)
        begin
            if falling_edge(i_clk) then
                case state is
                    when S2     =>  minr <= nrow;
                    when CALC   =>  if geSoglia = '1' and curr_row < minr then
                                        minr <= curr_row;
                                    end if;
                    when others => -- non faccio nulla;
                end case;
            end if;
        end process COMPUTATION_1;
        
     COMPUTATION_2: process(i_clk, state)
           begin
               if falling_edge(i_clk) then
                   case state is
                       when S1     =>  minc <= ncol;
                       when CALC   =>  if geSoglia = '1' and curr_col < minc then
                                           minc <= curr_col;
                                       end if;
                       when others => -- non faccio nulla;
                   end case;
               end if;
           end process COMPUTATION_2;
        
    COMPUTATION_3: process(i_clk, state)
        begin
            if falling_edge(i_clk) then
                case state is
                    when RESET  =>  maxr <= (0=>'1',others=>'0');
                    when CALC   =>  if geSoglia = '1' and curr_row > maxr then
                                        if curr_row <= nrow then
                                            maxr <= curr_row;
                                        end if;
                                    end if;
                    when others => -- non faccio nulla;
                end case;
            end if;
        end process COMPUTATION_3;
        
    COMPUTATION_4: process(i_clk, state)
        begin
            if falling_edge(i_clk) then
                case state is
                    when RESET  =>  maxc <= (0=>'1',others=>'0');
                    when CALC   =>  if geSoglia = '1' and curr_col > maxc then
                                        maxc <= curr_col;
                                    end if;
                    when others => -- non faccio nulla;
                end case;
            end if;
        end process COMPUTATION_4;
        
    COMPUTATION_ROWS: process(i_clk, state)
        begin
            if falling_edge(i_clk) then
                case state is
                    when RESET  =>  curr_row <= (0=>'1',others=>'0');
                    when CALC   =>  if curr_col = ncol then
                                        curr_row <= curr_row + 1;
                                    end if;
                    when others => -- non faccio nulla;
                end case;
            end if;
        end process COMPUTATION_ROWS;
        
    COMPUTATION_COLS: process(i_clk, state)
        begin
            if falling_edge(i_clk) then
                case state is
                    when RESET  =>  curr_col <= (0=>'1',others=>'0');
                    when CALC   =>  if curr_col = ncol then
                                        curr_col <= (0=>'1',others=>'0');
                                    else
                                        curr_col <= curr_col + 1;
                                    end if;
                    when others => -- non faccio nulla;
                end case;
            end if;
        end process COMPUTATION_COLS;
        
    MULTIPLIER: process(i_clk, state, cont)
        begin
            if falling_edge(i_clk) then
                case state is
                    when RESET  =>  result <= (others=>'0');
                    when AREA1  =>  if fine_mult = '0' then
                                        result <= result + cols;
                                    end if;
                    when others => -- non faccio nulla;
                end case;
            end if;
        end process MULTIPLIER;
        
    COUNTER: process(i_clk, state)
        begin
            if falling_edge(i_clk) then
                case state is
                    when S1     =>  cont <= (0=>'1',others=>'0');
                    when AREA1  =>  cont <= cont + 1;
                    when others => -- non faccio nulla;
                end case;
            end if;
        end process COUNTER;

end Behavioral;

