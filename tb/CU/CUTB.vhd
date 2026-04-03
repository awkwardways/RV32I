library ieee;
use ieee.std_logic_1164.all;

entity control_unit_tb is
end entity control_unit_tb;

architecture sim of control_unit_tb is 
  constant ADDR_WIDTH_TB : integer := 12;
  constant DATA_WIDTH_TB : integer := 32;
  constant CLK_FREQ      : integer := 20e6;
  constant CLK_PERIOD    : time    := 1000 ms / CLK_FREQ;

  signal clk_tb : std_logic := '0';
  signal inc_pc_tb : std_logic;
  signal instr_bus_tb : std_logic_vector(DATA_WIDTH_TB - 1 downto 0);
  signal begin_strb_tb : std_logic;
  signal done_strb_tb : std_logic;
  signal alu_en_tb : std_logic;
  signal alu_op_tb : std_logic_vector(2 downto 0);
  signal rd_sel_tb : std_logic_vector(4 downto 0);
  signal rs1_sel_tb : std_logic_vector(4 downto 0);
  signal rs2_sel_tb : std_logic_vector(4 downto 0);
  signal count_tb : std_logic_vector(ADDR_WIDTH_TB - 1 downto 0);
  signal address_out_tb : std_logic_vector(ADDR_WIDTH_TB - 1 downto 0);
  signal din_in_tb      : std_logic_vector(DATA_WIDTH_TB - 1 downto 0);
  signal din_out_tb     : std_logic_vector(DATA_WIDTH_TB - 1 downto 0);
  signal dout_in_tb     : std_logic_vector(DATA_WIDTH_TB - 1 downto 0);
  signal mem_en_tb      : std_logic;
  signal wre_in_tb      : std_logic;
  signal wre_out_tb     : std_logic;
  signal busy_tb        : std_logic;

begin

  clk_tb <= not clk_tb after CLK_PERIOD / 2;

  UUT: entity work.control_unit(rtl)
  port map(
    clk => clk_tb, 
    inc_pc => inc_pc_tb, 
    instr_bus => instr_bus_tb, 
    wre => wre_in_tb,
    begin_strb => begin_strb_tb, 
    done_strb => done_strb_tb, 
    alu_en => alu_en_tb, 
    alu_op => alu_op_tb, 
    rd_sel => rd_sel_tb, 
    rs1_sel => rs1_sel_tb, 
    rs2_sel => rs2_sel_tb 
  );

  PC: entity work.program_counter(rtl)
  port map(
    reset => '0',
    count => count_tb,
    clk => clk_tb,
    inc => inc_pc_tb
  );

  MU: entity work.memory_unit(rtl)
  generic map(
    ADDR_WIDTH => ADDR_WIDTH_TB,
    DATA_WIDTH => DATA_WIDTH_TB
  )
  port map(
    address_in  => count_tb,
    address_out => address_out_tb, 
    din_in      => din_in_tb,
    din_out     => din_out_tb,
    dout_in     => dout_in_tb,
    dout_out    => instr_bus_tb,
    mem_en      => mem_en_tb,
    wre_in      => wre_in_tb,
    wre_out     => wre_out_tb,
    clk         => clk_tb,
    begin_strb  => begin_strb_tb,
    done_strb   => done_strb_tb,
    busy        => busy_tb
  );

  RAM: entity work.ram(rtl)
  generic map(
    ADDR_WIDTH => ADDR_WIDTH_TB,
    DATA_WIDTH => DATA_WIDTH_TB
  )
  port map(
    address => address_out_tb,
    din => din_out_tb,
    dout => dout_in_tb,
    en => mem_en_tb,
    wre => wre_out_tb,
    clk => clk_tb
  );

end architecture sim;