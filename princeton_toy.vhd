----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/18/2024 12:00:53 AM
-- Design Name: 
-- Module Name: princeton_toy - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity princeton_toy is
    Port ( i_clk : in STD_LOGIC;
           i_ce : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           i_data : in STD_LOGIC_VECTOR (15 downto 0);
           o_data : out STD_LOGIC_VECTOR (15 downto 0);
           o_halted : out STD_LOGIC
           );
end princeton_toy;

architecture Behavioral of princeton_toy is

component cpu is

    Port (  i_clk : in std_logic;
			i_ce : in std_logic;
			i_reset : in std_logic;
			o_halt : out std_logic;
			
			o_addr : out std_logic_vector(7 downto 0);
			i_data : in std_logic_vector(15 downto 0);
			o_data : out std_logic_vector(15 downto 0);
			o_we : out std_logic
	);
	
end component cpu;

component ram_256x16 is

	Port (  i_clk : in std_logic;
			i_ce : in std_logic;
			i_we : in std_logic;
			i_addr : in std_logic_vector(7 downto 0);
			o_data : out std_logic_vector(15 downto 0);
			i_data : in std_logic_vector(15 downto 0)
	);
    
end component ram_256x16;

signal ram_we, cpu_we, out_we : std_logic;
signal addr : std_logic_vector(7 downto 0);
signal cpu_i_data, ram_i_data : std_logic_vector(15 downto 0);
signal cpu_o_data, ram_o_data : std_logic_vector(15 downto 0);

signal cpu_reset : std_logic;

signal port_o_data : std_logic_vector(15 downto 0);

begin

cpu_reset <= not i_reset;

U_cpu: cpu port map (i_clk, i_ce, cpu_reset, o_halted, addr, cpu_i_data, cpu_o_data, cpu_we);	
U_ram: ram_256x16 port map (i_clk, i_ce, ram_we, addr, ram_o_data, ram_i_data);

ram_i_data <= cpu_o_data;
o_data <= port_o_data;

process (addr, cpu_we, i_data, ram_o_data)
begin
if addr = "11111111" then
    ram_we <= '0';
    out_we <= cpu_we;
    cpu_i_data <= i_data;
else
    ram_we <= cpu_we;
    out_we <= '0';
    cpu_i_data <= ram_o_data;
end if;
end process;

process (i_clk)
begin

if rising_edge(i_clk) then
    
    if out_we = '1' then
        port_o_data <= cpu_o_data;
    end if;
    
end if;

end process;

end Behavioral;
