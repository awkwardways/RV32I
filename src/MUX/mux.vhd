library ieee;
use ieee.std_logic_1164.all;

entity mux is 
generic(
  DATA_WIDTH : integer := 32
);
port(
  imm  : in std_logic_vector(DATA_WIDTH - 1 downto 0);
  reg  : in std_logic_vector(DATA_WIDTH - 1 downto 0);
  sel  : in std_logic;
  outp : out std_logic_vector(DATA_WIDTH - 1 downto 0)
);
end entity mux;

architecture rtl of mux is 
begin
  outp <= imm when sel = '1' else reg;
end architecture;