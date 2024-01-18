
library IEEE;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu is

    Port (  i_clk : in std_logic;
			i_ce : in std_logic;
			i_reset : in std_logic;
			o_halt : out std_logic;
			
			o_addr : out std_logic_vector(7 downto 0);
			i_data : in std_logic_vector(15 downto 0);
			o_data : out std_logic_vector(15 downto 0);
			o_we : out std_logic
	);
	
end cpu;

architecture Behavioral of cpu is

-- Components
component reg_file is
	Port (  i_clk : in std_logic;
			i_ce : in std_logic;
			i_we : in std_logic;
			i_r1_addr : in std_logic_vector(3 downto 0);
			i_r2_addr : in std_logic_vector(3 downto 0);
			i_w_addr : in std_logic_vector(3 downto 0);
			o_r1_data : out std_logic_vector(15 downto 0);
			o_r2_data : out std_logic_vector(15 downto 0);
			i_w_data : in std_logic_vector(15 downto 0)
	);
end component reg_file;

component alu is
    Port (  i_a : in std_logic_vector(15 downto 0);
			i_b : in std_logic_vector(15 downto 0);
			i_op : in std_logic_vector (2 downto 0);
			o_r : out std_logic_vector(15 downto 0)
	);
end component alu;

-- Internal signals
signal halted : std_logic;
signal pc : std_logic_vector(7 downto 0);
signal ir : std_logic_vector(15 downto 0);

signal reg_we : std_logic;
signal reg_r1_addr : std_logic_vector(3 downto 0);	-- R[d] for memory stores, branches and jump register, otherwise R[s] 
signal reg_r2_addr : std_logic_vector(3 downto 0);	-- always R[t]
signal reg_w_addr : std_logic_vector(3 downto 0);	-- always R[d]

signal reg_r1_data : std_logic_vector(15 downto 0); 
signal reg_r2_data : std_logic_vector(15 downto 0); 
signal reg_w_data : std_logic_vector(15 downto 0); 

signal alu_r : std_logic_vector(15 downto 0);
signal alu_op : std_logic_vector(2 downto 0);

-- instruction decode result signals
signal opcode : std_logic_vector(3 downto 0);
signal rs : std_logic_vector(3 downto 0);
signal rd : std_logic_vector(3 downto 0);
signal rt : std_logic_vector(3 downto 0);
signal addr_imm : std_logic_vector(7 downto 0);

signal is_positive, is_zero : std_logic;

type state_type is (reset, T1, T2, T3, T4);
signal state, next_state : state_type;

begin

-- instantiate register file and ALU
U_reg : reg_file port map (i_clk, i_ce, reg_we, reg_r1_addr, reg_r2_addr, reg_w_addr, reg_r1_data, reg_r2_data, reg_w_data);
U_alu : alu port map (reg_r1_data, reg_r2_data, alu_op, alu_r);

o_halt <= halted;

-- select r1 to be either R[s] or R[d]
reg_r1_addr <= rd when  opcode = "1001" or opcode = "1011" or opcode = "1100" or opcode = "1101" or opcode = "1110" else rs;
reg_r2_addr <= rt;
reg_w_addr <= rd;
alu_op <= opcode(2 downto 0);

-- decode instruction
opcode <= ir(15 downto 12);
rd <= ir(11 downto 8); -- R[d]
rs <= ir(7 downto 4); -- R[s]
rt <= ir(3 downto 0); -- R[t]
addr_imm <= ir(7 downto 0);

-- set register write source
reg_w_data <= 	alu_r when opcode = "0001" or opcode = "0010" or opcode = "0011" or opcode = "0100" or opcode = "0101" or opcode = "0110" else -- alu to reg
				"00000000" & addr_imm when opcode = "0111" else -- load address
				i_data when opcode = "1000" or opcode = "1010" else -- mem to reg
				"00000000" & pc when opcode ="1111" else -- pc to reg
				(others => '0');

-- memory write enable
o_we <= '1' when (opcode = "1001" or opcode = "1011") and state = T2 else '0';

-- register write enable
reg_we <= '1' when (opcode = "0001" or opcode = "0010" or opcode = "0011" or opcode = "0100" or opcode = "0101" or opcode = "0110" or opcode = "0111" 
					or opcode = "1000" or opcode = "1010" or opcode ="1111") and state = T2 else '0';


o_addr <= pc when  state = T1 else
		  reg_r2_data(7 downto 0) when opcode = "1010" or opcode = "1011" else
		  addr_imm when opcode = "1000" or opcode = "1001" else (others => '0');

o_data <= reg_r1_data when opcode = "1011" or opcode = "1001" else (others => '0');


is_zero <= '1' when reg_r1_data = x"00" else '0';
is_positive <= '0' when reg_r1_data(15) = '1' or reg_r1_data(14 downto 0) = x"00" else '1'; 

process (i_clk, i_reset, i_ce, halted)
begin
	if i_reset = '0' then
		halted <= '0';
		pc <= x"02"; -- x"10"
		state <= reset;
		
	else if rising_edge(i_clk) and i_ce = '1' and (not halted = '1') then
			
			case next_state is
			
			when T1 =>
				case opcode is
				
				when x"C" =>
					if is_zero = '1' then
						pc <= addr_imm;
					end if;
					
				when x"D" =>
					if is_positive = '1' then
						pc <= addr_imm;
					end if;
				
				when x"E" =>
				    pc <= reg_r1_data(7 downto 0);
				
				when x"F" =>
				    pc <= addr_imm;
				
				when others =>
					 pc <= pc;
				
				end case;
			
			when T2 =>
				ir <= i_data;
				pc <= pc + '1';
			
				if opcode = "0000" and not (pc = x"02") then
					halted <= '1';
				end if;	
			
			when others =>
			
			end case;
			state <= next_state;
			
		end if;
	end if;
end process;

process (state)
begin
	-- declare default state for next_state to avoid latches
	next_state <= state; 
	case state is
	when reset =>
		next_state <= T1;
	when T1 =>
		next_state <= T2;
	when T2 =>
		next_state <= T1;
	when others =>
		next_state <= reset;
	end case;
end process;

end Behavioral;
