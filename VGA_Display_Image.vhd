library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity VGA_Display is
    Port (
        clk   : in  std_logic;
        Hsync : out std_logic := '1';
        Vsync : out std_logic := '1';
        R_out : out std_logic_vector(3 downto 0);
        G_out : out std_logic_vector(3 downto 0);
        B_out : out std_logic_vector(3 downto 0)
    );
end VGA_Display;

architecture Behavioral of VGA_Display is
component blk_mem_gen_0 is
    PORT (
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(11 DOWNTO 0);  
        douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
end component;


--ClockScaling
    shared variable counter : integer := 0;
    signal clk25: std_logic := '0';
--12 Bits RGB Extraction from memory
    signal RGB_sig: std_logic_vector(11 downto 0);
--16 bits memory address
    signal address : STD_LOGIC_VECTOR(16 downto 0) := (others => '0');
--HorizontalValues
    constant H_RES    : integer := 640;
    constant H_FP     : integer := 16;
    constant H_SYNC   : integer := 96;
    constant H_BP     : integer := 48;
--VerticalValues
    constant V_RES    : integer := 480;
    constant V_FP     : integer := 10;
    constant V_SYNC   : integer := 2;
    constant V_BP     : integer := 33;
    
    begin
    
    clock_generation : process (clk)--ClockScaling Process
    begin
        if rising_edge(clk) then
            if counter = 1 then
                counter := 0;
                clk25   <= not clk25;
            else
                counter := counter + 1;
            end if;
        end if;
    end process;
    
    Blk_Ram: blk_mem_gen_0 port map(clk25,'1',"0", address, (others => '0'), RGB_sig);--Block memory assignment

    process (clk25)
        variable HC   : integer := 1; --Horizontal Counter
        variable VC   : integer := 1; --Vertical Counter
    begin
        if rising_edge(clk25) then
            if HC < H_RES + H_FP + H_SYNC + H_BP then --HorizontalActiveArea---800
                if HC <= H_RES then --VisibleArea
                    if(HC <= 300 and VC <= 300) then --only display the dimenstions of the image
                        R_out <= RGB_sig(11 downto 8);
                        G_out <= RGB_sig(7 downto 4);
                        B_out <= RGB_sig(3 downto 0);
                        address <= address + 1;
                    else
                        R_out <= "0000";
                        G_out <= "0000";
                        B_out <= "0000";                    
                    end if;    
                end if;    
-----------------------RESET------------------------------------------------------            
                if HC > H_RES + H_FP and HC < H_RES + H_FP + H_SYNC then --Hsync is only 0 at the sync pulse region
                    Hsync <= '0';
                else
                    Hsync <= '1';
                end if;
            HC := HC + 1;
-----------------------IncrementVC------------------------------------------------           
            else    
                HC := 1;
                    if (VC < V_RES + V_FP + V_SYNC + V_BP) then --VerticalActiveArea
                        if VC > V_RES + V_FP and VC < V_RES + V_FP + V_SYNC then --Vsync is only 0 at the sync pulse region
                            Vsync <= '0';
                        else
                            Vsync <= '1';
                        end if;
                        VC := VC + 1;
                    else --ResetVC
                        VC := 1;
                        address <= (others => '0');--resetting the address after each frame
                    end if;   
            end if; --HorizontalActiveArea
        end if; -- risingEdge
    end process;
end Behavioral;
