library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instr_mem is
    Port (
        addr    : in  STD_LOGIC_VECTOR(31 downto 0);
        instr   : out STD_LOGIC_VECTOR(31 downto 0)
    );
end instr_mem;

architecture Behavioral of instr_mem is
    type memory_array is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
    signal memory : memory_array := (
        -- 000000001001 00000 000 00101 0010011
        0 => x"00900293", -- addi x5, x0, 9 
        
        -- XXXX|XXXX|XXXX|XXXX|XXXX| 0011|0 001|0111|
        1 => x"00000317", -- load_addr x6, array
        
        -- 0000|0000|0000| 0011|0 010| 0011|1 000|0011|
        2 => x"00032383", -- lw x7, 0(x6)  

        -- 0000|0000|0100| 0011|0 000| 0011|0 001|0011|   
        3 => x"00430313", -- loop: addi x6, x6, 4   
        
        -- 0000|0000|0000| 0011|0 010| 0101|0 000|0011|
        4 => x"00032503", -- lw x10, 0(x6)   
         
        -- 0000|000 0|0111| 0101|0 000| 0011|1 011|0011
        5 => x"007503B3", --       add x7, x10, x7 
        
        -- 0000|0000|0001| 0010|1 001| 0010|1 001|0011|
        6 => x"00129293", --       subi x5, x5, 1 (or "addi x5, x5, -1")  
        
        -- imm = -20 = 000000010100 2's complement -> 1 1 111110 110 0
        -- imm = -20 = 000000101000 2's complement -> 1 1 111101 100 0
        
        -- 1 111|110 0|0000| 0010|1 001| 110 0| 1 110|0011|
--        x"FC029CE3" <- this is wrong because of the right shift
        -- 1 111|101 0|0000| 0010|1 001| 100 0| 1 110|0011|
--        x"FA0298E3"

        7 => x"FA0298E3", --     bne x5, x0, loop   1 [jump -20; note: assumes PC is incremented by 4]
        
        --imm = 000000000100 2's complement -> 1111111111 1111111100
        -- 1 111|1111|100 1| 1111|1111| 0000|0 110|1111|
        8 => x"FF9FF06F", -- done: j done             [jump -4; note: assumes PC is incremented by 4]               
        others => (others => '0')
    );
begin
    process(addr)
    begin
        instr <= memory(to_integer(unsigned(addr(7 downto 0))));
    end process;
end Behavioral;
