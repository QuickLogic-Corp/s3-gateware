
library IEEE;
use IEEE.std_logic_1164.all;
entity RAM8K_2X1_CELL_MACRO is
      Port (    A1_0 : In    STD_LOGIC_VECTOR (10 downto 0);
                A1_1 : In    STD_LOGIC_VECTOR (10 downto 0);
                A2_0 : In    STD_LOGIC_VECTOR (10 downto 0);
                A2_1 : In    STD_LOGIC_VECTOR (10 downto 0);
             ASYNC_FLUSH_0 : In    STD_LOGIC;
             ASYNC_FLUSH_1 : In    STD_LOGIC;
             ASYNC_FLUSH_S0,ASYNC_FLUSH_S1:in std_logic;
              CLK1_0 : In    STD_LOGIC;
              CLK1_1 : In    STD_LOGIC;
             CLK1EN_0 : In    STD_LOGIC;
             CLK1EN_1 : In    STD_LOGIC;
              CLK2_0 : In    STD_LOGIC;
              CLK2_1 : In    STD_LOGIC;
	       CLK2EN_0 : In    STD_LOGIC;
             CLK2EN_1 : In    STD_LOGIC;
              CLK1S_0 : In    STD_LOGIC;
              CLK1S_1 : In    STD_LOGIC;
              CLK2S_0 : In    STD_LOGIC;
              CLK2S_1 : In    STD_LOGIC;
             CONCAT_EN_0 : In    STD_LOGIC;
             CONCAT_EN_1 : In    STD_LOGIC;
               CS1_0 : In    STD_LOGIC;
               CS1_1 : In    STD_LOGIC;
               CS2_0 : In    STD_LOGIC;
               CS2_1 : In    STD_LOGIC;
	       DIR_0 : In    STD_LOGIC;
               DIR_1 : In    STD_LOGIC;
             FIFO_EN_0 : In    STD_LOGIC;
             FIFO_EN_1 : In    STD_LOGIC;
             PIPELINE_RD_0 : In    STD_LOGIC;
             PIPELINE_RD_1 : In    STD_LOGIC;
               P1_0 : In    STD_LOGIC;
               P1_1 : In    STD_LOGIC;
	       P2_0 : In    STD_LOGIC;
               P2_1 : In    STD_LOGIC;
             SYNC_FIFO_0 : In    STD_LOGIC;
             SYNC_FIFO_1 : In    STD_LOGIC;
                WD_0 : In    STD_LOGIC_VECTOR (17 downto 0);
                WD_1 : In    STD_LOGIC_VECTOR (17 downto 0);
              WEN1_0 : In    STD_LOGIC_VECTOR (1 downto 0);
              WEN1_1 : In    STD_LOGIC_VECTOR (1 downto 0);
	      WIDTH_SELECT1_0 : In    STD_LOGIC_VECTOR (1 downto 0);
             WIDTH_SELECT1_1 : In    STD_LOGIC_VECTOR (1 downto 0);
             WIDTH_SELECT2_0 : In    STD_LOGIC_VECTOR (1 downto 0);
             WIDTH_SELECT2_1 : In    STD_LOGIC_VECTOR (1 downto 0);
             Almost_Empty_0 : Out   STD_LOGIC;
             Almost_Empty_1 : Out   STD_LOGIC;
             Almost_Full_0 : Out   STD_LOGIC;
             Almost_Full_1 : Out   STD_LOGIC;
             POP_FLAG_0 : Out   STD_LOGIC_VECTOR (3 downto 0);
             POP_FLAG_1 : Out   STD_LOGIC_VECTOR (3 downto 0);
             PUSH_FLAG_0 : Out   STD_LOGIC_VECTOR (3 downto 0);
             PUSH_FLAG_1 : Out   STD_LOGIC_VECTOR (3 downto 0);
                RD_0 : Out   STD_LOGIC_VECTOR (17 downto 0);
                RD_1 : Out   STD_LOGIC_VECTOR (17 downto 0) );

   attribute syn_isclock: boolean;
 attribute syn_isclock of CLK1_0: signal is true;
 attribute syn_isclock of CLK1_1: signal is true;
 attribute syn_isclock of CLK2_0: signal is true;
 attribute syn_isclock of CLK2_1: signal is true;
attribute BLACK_BOX : boolean;
attribute BLACK_BOX of RAM8K_2X1_CELL_MACRO : entity is true;
end RAM8K_2X1_CELL_MACRO;


architecture SCHEMATIC of RAM8K_2X1_CELL_MACRO is

   signal Almost_Empty_0_DUMMY : STD_LOGIC;
   signal Almost_Empty_1_DUMMY : STD_LOGIC;
   signal Almost_Full_0_DUMMY : STD_LOGIC;
   signal Almost_Full_1_DUMMY : STD_LOGIC;
   signal POP_FLAG_0_DUMMY : STD_LOGIC_VECTOR  (3 downto 0);
   signal POP_FLAG_1_DUMMY : STD_LOGIC_VECTOR  (3 downto 0);
   signal PUSH_FLAG_0_DUMMY : STD_LOGIC_VECTOR  (3 downto 0);
   signal PUSH_FLAG_1_DUMMY : STD_LOGIC_VECTOR  (3 downto 0);
   signal RD_0_DUMMY : STD_LOGIC_VECTOR  (17 downto 0);
   signal RD_1_DUMMY : STD_LOGIC_VECTOR  (17 downto 0);

   component RAM8K_2X1_CELL
      Port (    A1_0 : In    STD_LOGIC_VECTOR  (10 downto 0);
                A1_1 : In    STD_LOGIC_VECTOR  (10 downto 0);
                A2_0 : In    STD_LOGIC_VECTOR  (10 downto 0);
                A2_1 : In    STD_LOGIC_VECTOR  (10 downto 0);
             ASYNC_FLUSH_0 : In    STD_LOGIC;
             ASYNC_FLUSH_1 : In    STD_LOGIC;
			 ASYNC_FLUSH_S0  ,ASYNC_FLUSH_S1:in std_logic;
              CLK1_0 : In    STD_LOGIC;
              CLK1_1 : In    STD_LOGIC;
	       CLK1EN_0 : In    STD_LOGIC;
             CLK1EN_1 : In    STD_LOGIC;
              CLK2_0 : In    STD_LOGIC;
              CLK2_1 : In    STD_LOGIC;
	      CLK2EN_0 : In    STD_LOGIC;
             CLK2EN_1 : In    STD_LOGIC;
			  CLK1S_0 : In    STD_LOGIC;
              CLK1S_1 : In    STD_LOGIC;
              CLK2S_0 : In    STD_LOGIC;
              CLK2S_1 : In    STD_LOGIC;
             CONCAT_EN_0 : In    STD_LOGIC;
             CONCAT_EN_1 : In    STD_LOGIC;
               CS1_0 : In    STD_LOGIC;
               CS1_1 : In    STD_LOGIC;
               CS2_0 : In    STD_LOGIC;
               CS2_1 : In    STD_LOGIC;
	       DIR_0 : in STD_LOGIC;
	       DIR_1 : in STD_LOGIC;
             FIFO_EN_0 : In    STD_LOGIC;
             FIFO_EN_1 : In    STD_LOGIC;
             PIPELINE_RD_0 : In    STD_LOGIC;
             PIPELINE_RD_1 : In    STD_LOGIC;
               P1_0 : In    STD_LOGIC;
               P1_1 : In    STD_LOGIC;
	       P2_0 : In    STD_LOGIC;
               P2_1 : In    STD_LOGIC;
             SYNC_FIFO_0 : In    STD_LOGIC;
             SYNC_FIFO_1 : In    STD_LOGIC;
                WD_0 : In    STD_LOGIC_VECTOR  (17 downto 0);
                WD_1 : In    STD_LOGIC_VECTOR  (17 downto 0);
              WEN1_0 : In    STD_LOGIC_VECTOR  (1 downto 0);
              WEN1_1 : In    STD_LOGIC_VECTOR  (1 downto 0);
             WIDTH_SELECT1_0 : In    STD_LOGIC_VECTOR  (1 downto 0);
             WIDTH_SELECT1_1 : In    STD_LOGIC_VECTOR  (1 downto 0);
             WIDTH_SELECT2_0 : In    STD_LOGIC_VECTOR  (1 downto 0);
             WIDTH_SELECT2_1 : In    STD_LOGIC_VECTOR  (1 downto 0);
             Almost_Empty_0 : Out   STD_LOGIC;
             Almost_Empty_1 : Out   STD_LOGIC;
             Almost_Full_0 : Out   STD_LOGIC;
             Almost_Full_1 : Out   STD_LOGIC;
             POP_FLAG_0 : Out   STD_LOGIC_VECTOR  (3 downto 0);
             POP_FLAG_1 : Out   STD_LOGIC_VECTOR  (3 downto 0);
             PUSH_FLAG_0 : Out   STD_LOGIC_VECTOR  (3 downto 0);
             PUSH_FLAG_1 : Out   STD_LOGIC_VECTOR  (3 downto 0);
                RD_0 : Out   STD_LOGIC_VECTOR  (17 downto 0);
                RD_1 : Out   STD_LOGIC_VECTOR  (17 downto 0) );

   end component;

begin


   Almost_Empty_0 <= Almost_Empty_0_DUMMY;
   Almost_Empty_1 <= Almost_Empty_1_DUMMY;
   Almost_Full_0 <= Almost_Full_0_DUMMY;
   Almost_Full_1 <= Almost_Full_1_DUMMY;
   POP_FLAG_0(3 downto 0) <= POP_FLAG_0_DUMMY(3 downto 0);
   POP_FLAG_1(3 downto 0) <= POP_FLAG_1_DUMMY(3 downto 0);
   PUSH_FLAG_0(3 downto 0) <= PUSH_FLAG_0_DUMMY(3 downto 0);
   PUSH_FLAG_1(3 downto 0) <= PUSH_FLAG_1_DUMMY(3 downto 0);
   RD_0(17 downto 0) <= RD_0_DUMMY(17 downto 0);
   RD_1(17 downto 0) <= RD_1_DUMMY(17 downto 0);
   I1 : RAM8K_2X1_CELL
      Port Map ( A1_0(10 downto 0)=>A1_0(10 downto 0),
                 A1_1(10 downto 0)=>A1_1(10 downto 0),
                 A2_0(10 downto 0)=>A2_0(10 downto 0),
                 A2_1(10 downto 0)=>A2_1(10 downto 0),
	         ASYNC_FLUSH_0=>ASYNC_FLUSH_0,
                 ASYNC_FLUSH_1=>ASYNC_FLUSH_1, 
				 ASYNC_FLUSH_S0=>ASYNC_FLUSH_S0  ,
				 ASYNC_FLUSH_S1=>ASYNC_FLUSH_S1,
				 CLK1_0=>CLK1_0,
                 CLK1_1=>CLK1_1, CLK2_0=>CLK2_0, CLK2_1=>CLK2_1,
		 CLK1S_0=>CLK1S_0, CLK1S_1=>CLK1S_1, CLK2S_0=>CLK2S_0, CLK2S_1=>CLK2S_1,
                 CONCAT_EN_0=>CONCAT_EN_0, CONCAT_EN_1=>CONCAT_EN_1, CLK2EN_0=>CLK2EN_0,
                 CLK2EN_1=>CLK2EN_1,CLK1EN_0=>CLK1EN_0, CLK1EN_1=>CLK1EN_1,
                 CS1_0=>CS1_0, CS1_1=>CS1_1, CS2_0=>CS2_0, CS2_1=>CS2_1,
                 FIFO_EN_0=>FIFO_EN_0, FIFO_EN_1=>FIFO_EN_1,
                 PIPELINE_RD_0=>PIPELINE_RD_0,
                 PIPELINE_RD_1=>PIPELINE_RD_1, P1_0=>P1_0,
		 DIR_0 => DIR_0, DIR_1=> DIR_1,
                 P1_1=>P1_1,  P2_0=>P2_0,
                 P2_1=>P2_1, SYNC_FIFO_0=>SYNC_FIFO_0,
                 SYNC_FIFO_1=>SYNC_FIFO_1,
                 WD_0(17 downto 0)=>WD_0(17 downto 0),
                 WD_1(17 downto 0)=>WD_1(17 downto 0),
                 WEN1_0(1 downto 0)=>WEN1_0(1 downto 0),
                 WEN1_1(1 downto 0)=>WEN1_1(1 downto 0),
                 WIDTH_SELECT1_0(1 downto 0)=>WIDTH_SELECT1_0(1 downto 0),
                 WIDTH_SELECT1_1(1 downto 0)=>WIDTH_SELECT1_1(1 downto 0),
                 WIDTH_SELECT2_0(1 downto 0)=>WIDTH_SELECT2_0(1 downto 0),
                 WIDTH_SELECT2_1(1 downto 0)=>WIDTH_SELECT2_1(1 downto 0),
                 Almost_Empty_0=>Almost_Empty_0_DUMMY,
                 Almost_Empty_1=>Almost_Empty_1_DUMMY,
                 Almost_Full_0=>Almost_Full_0_DUMMY,
                 Almost_Full_1=>Almost_Full_1_DUMMY,
                 POP_FLAG_0(3 downto 0)=>POP_FLAG_0_DUMMY(3 downto 0),
                 POP_FLAG_1(3 downto 0)=>POP_FLAG_1_DUMMY(3 downto 0),
                 PUSH_FLAG_0(3 downto 0)=>PUSH_FLAG_0_DUMMY(3 downto 0),
                 PUSH_FLAG_1(3 downto 0)=>PUSH_FLAG_1_DUMMY(3 downto 0),
                 RD_0(17 downto 0)=>RD_0_DUMMY(17 downto 0),
                 RD_1(17 downto 0)=>RD_1_DUMMY(17 downto 0) );

end SCHEMATIC;


library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RAM_RW is
generic(wr_addr_int :integer := 9;
        rd_addr_int :integer := 8;
	wr_depth_int :integer := 1024;
	rd_depth_int :integer := 512;
        wr_width_int :integer := 9;
        rd_width_int :integer := 18;
        reg_rd_int : integer :=0; 
	wr_enable_int:integer:=1; 
	device_8k_int :integer := 1);
		
port (WA : in std_logic_vector (wr_addr_int-1  downto 0);
      RA:in std_logic_vector(rd_addr_int-1 downto 0);
      WD : in std_logic_vector( wr_width_int-1  downto 0);
      WD_SEL,RD_SEL:in std_logic;
      WEN:std_logic_vector(wr_enable_int-1 downto 0);
      WClk,RClk: in std_logic;
      WClk_En,RClk_En: in std_logic;
      WClk_Sel,RClk_Sel: in std_logic;
      RD : out std_logic_vector(rd_width_int-1  downto 0) );
attribute syn_isclock: boolean;
attribute syn_isclock of WClk: signal is true; 
attribute syn_isclock of RClk: signal is true; 
end RAM_RW;
Architecture arch of RAM_RW is

attribute noopt:boolean;
component RAM8K_2X1_CELL_MACRO 
      Port (    A1_0 : In    STD_LOGIC_VECTOR (10 downto 0);
                A1_1 : In    STD_LOGIC_VECTOR (10 downto 0);
                A2_0 : In    STD_LOGIC_VECTOR (10 downto 0);
                A2_1 : In    STD_LOGIC_VECTOR (10 downto 0);
             ASYNC_FLUSH_0 : In    STD_LOGIC;
             ASYNC_FLUSH_1 : In    STD_LOGIC;
			  ASYNC_FLUSH_S0,ASYNC_FLUSH_S1:in std_logic;
              CLK1_0 : In    STD_LOGIC;
              CLK1_1 : In    STD_LOGIC;
             CLK1EN_0 : In    STD_LOGIC;
             CLK1EN_1 : In    STD_LOGIC;
              CLK2_0 : In    STD_LOGIC;
              CLK2_1 : In    STD_LOGIC;
	       CLK2EN_0 : In    STD_LOGIC;
             CLK2EN_1 : In    STD_LOGIC;
             CLK1S_0 : In    STD_LOGIC;
              CLK1S_1 : In    STD_LOGIC;
              CLK2S_0 : In    STD_LOGIC;
              CLK2S_1 : In    STD_LOGIC;
             CONCAT_EN_0 : In    STD_LOGIC;
             CONCAT_EN_1 : In    STD_LOGIC;
               CS1_0 : In    STD_LOGIC;
               CS1_1 : In    STD_LOGIC;
               CS2_0 : In    STD_LOGIC;
               CS2_1 : In    STD_LOGIC;
	       DIR_0 : In    STD_LOGIC;
               DIR_1 : In    STD_LOGIC;
             FIFO_EN_0 : In    STD_LOGIC;
             FIFO_EN_1 : In    STD_LOGIC;
             PIPELINE_RD_0 : In    STD_LOGIC;
             PIPELINE_RD_1 : In    STD_LOGIC;
                P1_0 : In    STD_LOGIC;
                P1_1 : In    STD_LOGIC;
                P2_0 : In    STD_LOGIC;
                P2_1 : In    STD_LOGIC;
             SYNC_FIFO_0 : In    STD_LOGIC;
             SYNC_FIFO_1 : In    STD_LOGIC;
                WD_0 : In    STD_LOGIC_VECTOR (17 downto 0);
                WD_1 : In    STD_LOGIC_VECTOR (17 downto 0);
              WEN1_0 : In    STD_LOGIC_VECTOR (1 downto 0);
              WEN1_1 : In    STD_LOGIC_VECTOR (1 downto 0);
             WIDTH_SELECT1_0 : In    STD_LOGIC_VECTOR (1 downto 0);
             WIDTH_SELECT1_1 : In    STD_LOGIC_VECTOR (1 downto 0);
             WIDTH_SELECT2_0 : In    STD_LOGIC_VECTOR (1 downto 0);
             WIDTH_SELECT2_1 : In    STD_LOGIC_VECTOR (1 downto 0);
             Almost_Empty_0 : Out   STD_LOGIC;
             Almost_Empty_1 : Out   STD_LOGIC;
             Almost_Full_0 : Out   STD_LOGIC;
             Almost_Full_1 : Out   STD_LOGIC;
             POP_FLAG_0 : Out   STD_LOGIC_VECTOR (3 downto 0);
             POP_FLAG_1 : Out   STD_LOGIC_VECTOR (3 downto 0);
             PUSH_FLAG_0 : Out   STD_LOGIC_VECTOR (3 downto 0);
             PUSH_FLAG_1 : Out   STD_LOGIC_VECTOR (3 downto 0);
                RD_0 : Out   STD_LOGIC_VECTOR (17 downto 0);
                RD_1 : Out   STD_LOGIC_VECTOR (17 downto 0) );
end component;

constant mod2 :integer :=(wr_width_int) mod 2;
constant mod4 : integer :=(wr_width_int) mod 4;

constant zero_36_2 :integer := (36-wr_width_int) / 2;
constant zero_36_2_odd : integer :=(36-wr_width_int+1)/2;
constant zero_18_2_odd:integer := (18-wr_width_int+1)/2;
constant zero_36_4_1:integer :=(36-wr_width_int+1)/4;
constant zero_36_4_2 :integer :=(36-wr_width_int+2)/4;
constant zero_36_4_3 :integer :=(36-wr_width_int+3)/4;
constant zero_36_4 :integer := (36- wr_width_int) /4 ;
constant zero_18_2:integer :=(18-wr_width_int)/2;
constant by_2 :integer := (wr_width_int)/2;
constant by_4 :integer := (wr_width_int)/4;
constant by_4_2:integer := (wr_width_int/4)*2;
constant by_4_3:integer :=(wr_width_int/4)*3;
constant zero_18_2_rg :integer := 18-wr_width_int;
constant zero_9_2_rg :integer := 9-wr_width_int;
constant by_2_read :integer := (rd_width_int)/2;
constant by_4_read :integer := (rd_width_int)/4;
constant by_4_readx2 :integer :=(rd_width_int/4)*2;
constant by_4_readx3 :integer :=(rd_width_int/4)*3;

Signal VCC,GND :std_logic;
Signal WS1,WS2,WS_GND,WEN2,WEN1:std_logic_vector(1 downto 0);
signal addr_wr0,addr_rd0,addr_wr1,addr_rd1: std_logic_vector(10 downto 0);
signal in_reg :std_logic_vector(36 downto 0);
signal out_reg: std_logic_vector(36 downto 0);
signal wen_reg:std_logic_vector( 3 downto 0);
signal reg_rd : std_logic;
begin
VCC <='1';
GND<='0';
reg_rd <= '0' when reg_rd_int=0 else '1';
WS_GND<="00";

wen_reg(3 downto wr_enable_int)<=(others=>'0');
wen_reg(wr_enable_int-1 downto 0)<=WEN;


U1:if((wr_width_int =36 or wr_width_int = 18 or wr_width_int =9) or (wr_width_int = rd_width_int))generate
	in_reg(35 downto wr_width_int)<=(others=>'0');
	in_reg(wr_width_int-1 downto 0)<=WD;
end generate U1;
U2: if(wr_depth_int = 512) generate
	U3:if(rd_depth_int = 1024)generate
	     U7:if(wr_width_int > 18)generate
			U8:if(mod2 = 0)generate
				in_reg(17 downto 18-zero_36_2)<=(others=>'0');
				in_reg(35 downto 36-zero_36_2)<=(others=>'0');
				in_reg(18-zero_36_2-1 downto 0)<=WD(by_2-1 downto 0);
				in_reg(36-zero_36_2-1 downto 18)<=WD(wr_width_int-1 downto by_2);
			end generate U8;
			U9:if(mod2 /= 0)generate
				in_reg(35 downto wr_width_int)<=(others=>'0');
				in_reg(wr_width_int-1 downto 0)<=WD;
			end generate U9;
		end generate U7;
		U10:if(wr_width_int <= 18) generate
			U11: if(mod2 = 0)generate 
				in_reg(8 downto 9-zero_18_2)<=(others=>'0'); 
				in_reg(17 downto 18-zero_18_2)<=(others=>'0'); 
				in_reg(9-zero_18_2-1 downto 0)<=WD(by_2-1 downto 0);
				in_reg(18-zero_18_2-1 downto 9) <= WD(wr_width_int-1 downto by_2);
			end generate U11;
			U12: if(mod2 /= 0)generate
				in_reg(35 downto wr_width_int)<=(others=>'0');
				in_reg(wr_width_int-1 downto 0)<=WD;
			end generate U12;
		end generate U10;
	end generate U3;
	U13: if(rd_depth_int = 2048)generate
		U14:if(mod4=0)generate
			in_reg(35 downto 36-zero_36_4)<=(others=>'0');
			in_reg(26 downto 27-zero_36_4)<=(others=>'0');
			in_reg(17 downto 18-zero_36_4)<=(others=>'0');
			in_reg(8 downto 9-zero_36_4)<=(others=>'0');
			in_reg(36-zero_36_4-1 downto 27)<=WD(wr_width_int-1 downto by_4_3);
			in_reg(27-zero_36_4-1 downto 18)<=WD(by_4_3-1 downto by_4_2);
			in_reg(18-zero_36_4-1 downto 9)<=WD(by_4_2-1 downto by_4);
			in_reg(9-zero_36_4-1 downto 0)<=WD(by_4-1 downto 0);

		end generate U14;
		U15:if(mod4 /= 0)generate
			in_reg(35 downto wr_width_int)<=(others=>'0');
			in_reg(wr_width_int-1 downto 0)<=WD;
		end generate U15;
	end generate U13;
end generate U2;
U16: if(wr_depth_int = 1024)generate
	U17:if(rd_depth_int = 2048)generate
		U18:if(mod2=0)generate
			in_reg(8 downto 9-zero_18_2)<=(others=>'0');
			in_reg(17 downto 18-zero_18_2)<=(others=>'0');
			in_reg(9-zero_18_2-1 downto 0)<=WD(by_2-1 downto 0);
			in_reg(18-zero_18_2-1 downto 9)<=WD(wr_width_int-1 downto by_2);
		end generate U18;
		U19:if(mod2 /= 0)generate
			in_reg(35 downto wr_width_int)<=(others=>'0');
			in_reg(wr_width_int-1 downto 0)<=WD;
		end generate U19;
	
	end generate U17;
	U18: if(rd_depth_int=512)generate
		in_reg(35 downto wr_width_int)<=(others=>'0');
		in_reg(wr_width_int-1 downto 0)<=WD;
	end generate U18;
end generate U16;

U19: if(wr_depth_int= 2048) generate
	in_reg(35 downto wr_width_int)<=(others=>'0');
	in_reg(wr_width_int-1 downto 0)<=WD;
end generate U19;




---Generating widht selects
U20: if(rd_depth_int = 2048 and wr_depth_int = 512) generate
	WS1<="10";
end generate U20;
U21: if(rd_depth_int = 2048 and wr_depth_int=1024) generate
	WS1<="01";
end generate U21;
U22: if(wr_depth_int =512 and wr_width_int <=18 and rd_depth_int/=2048) generate
		WS1<="01";
end generate U22;
U23: if((wr_width_int  <= 9 and wr_depth_int /=512) or (wr_depth_int=1024 and rd_depth_int /=2048 and wr_width_int <=9)) generate
	WS1<="00";
end generate U23;
U24:if((wr_width_int >9 and wr_width_int<=18)or (wr_depth_int =512 and rd_depth_int /= 2048 and wr_width_int<=18)) generate
	WS1<="01";
end generate U24;
U25:if(wr_width_int >18) generate
		WS1<="10";
end generate U25; 


U26: if(wr_depth_int=2048 and rd_depth_int=512) generate
	WS2<= "10";
end generate U26;
U27: if(wr_depth_int = 2048 and rd_depth_int = 1024)generate
	WS2<="01";
end generate U27;
U28: if(rd_depth_int =512 and rd_width_int <=18 and wr_depth_int /= 2048) generate
	WS2<="01";
end generate U28;

U29:if((rd_width_int <=9 and rd_depth_int /= 512 ) or (rd_depth_int =1024 and wr_depth_int /=2048 and rd_width_int <=9))generate
    WS2<="00";
End generate U29;
U30: if((rd_width_int>9  and rd_width_int <=18 ) or (rd_depth_int = 512 and wr_depth_int /=2048 and rd_width_int <=18) )generate
     WS2<="01";
End generate U30;
U31: if(rd_width_int >18)generate
     WS2<= "10";
end generate U31;

---Generating write address
U32:if(wr_addr_int = 11) generate
	addr_wr0(10 downto 0)<= WA;
end generate U32;
U33: if(wr_addr_int <11) generate
	addr_wr0(10 downto wr_addr_int)<=(others=>'0');
	addr_wr0(wr_addr_int-1 downto 0)<=WA;
end generate U33;
	addr_wr1<=(others=>'0');
---Generating read address
U34:if(rd_addr_int = 11) generate
        addr_rd0(10 downto 0)<=RA;
end generate U34;
U60:if(rd_addr_int < 11) generate
	addr_rd0(10 downto rd_addr_int)<=(others=>'0');
	addr_rd0(rd_addr_int-1 downto 0)<=RA;
end generate U60;
	addr_rd1<=(others=>'0');

U35: if((((wr_width_int<= 18) and (wr_depth_int=512)) or ((wr_width_int<=9) and (wr_depth_int=1024))) and (rd_depth_int /=2048)) generate 
	DRAM8k : RAM8K_2X1_CELL_MACRO	
		port map(		CLK1_0=>WClk,
					CLK2_0=>RClk,
					CLK1EN_0=>WClk_En,
					CLK2EN_0=>RClk_En,
					CLK1EN_1=>GND,
					CLK2EN_1=>GND,
					CLK1S_0=>WClk_Sel,
					CLK2S_0=>RClk_Sel,
					WD_0=>in_reg(17 downto 0),
					RD_0 => out_reg(17 downto 0),
					A1_0(10 downto 0)=>addr_wr0,
       		                        A2_0(10 downto 0)=>addr_rd0,
                        		CS1_0=>WD_SEL,
					CS2_0=>RD_SEL,
    	         			WEN1_0=>wen_reg(1 downto 0),
                                        ASYNC_FLUSH_0=>GND,
			        	P1_0=>GND,
					P2_0=>GND,	
					ALMOST_FULL_0=>open,
			 		ALMOST_EMPTY_0=>open,
					PUSH_FLAG_0=>open,
                        		POP_FLAG_0=>open,
                        		FIFO_EN_0=>GND,
					SYNC_FIFO_0=>GND, 
				         DIR_0=>GND,
			        	 DIR_1=>GND,	 

					PIPELINE_RD_0=>reg_rd,
					WIDTH_SELECT1_0=>WS1,
                    WIDTH_SELECT2_0=>WS2,
                    ASYNC_FLUSH_1 => GND,
                    ASYNC_FLUSH_S0=>GND,
					ASYNC_FLUSH_S1=>GND,
					Clk1_1=>GND,
                    CLK2_1=>GND,
					CLK1S_1=>VCC,
					CLK2S_1=>VCC,
					WD_1=>in_reg(35 downto 18),
					RD_1=>out_reg(35 downto 18),
					A1_1(10 downto 0)=>addr_wr1,
			 		A2_1(10 downto 0)=>addr_rd1,	
					CS1_1=>GND,	
			 		CS2_1=>GND,
			 	        WEN1_1=>wen_reg(3 downto 2),	
                                                
                        		P1_1=>GND,
					P2_1=>GND,
 					ALMOST_FULL_1=>open,
			 		ALMOST_EMPTY_1=>open,
					PUSH_FLAG_1=>open,
					POP_FLAG_1=>open,
					FIFO_EN_1 => GND,
                        		SYNC_FIFO_1=>GND,

					PIPELINE_RD_1=>reg_rd,
					WIDTH_SELECT1_1=>WS_GND,
                        		WIDTH_SELECT2_1=>WS_GND,

			 		CONCAT_EN_0 =>GND,
			 		CONCAT_EN_1 => GND
                       );
end generate U35;

U36: if( (wr_width_int > 18 and wr_depth_int=512) or (wr_width_int > 9 and wr_depth_int=1024)or wr_depth_int > 1024 or rd_depth_int =2048 ) generate 
	DRAM16k : RAM8K_2X1_CELL_MACRO
		port map(		CLK1_0=>WClk,
					CLK2_0=>RClk,
					CLK1S_0=>WClk_Sel,
					CLK2S_0=>RClk_Sel,
					CLK1EN_0=>WClk_En,
					CLK2EN_0=>RClk_En,
					CLK1EN_1=>GND,
					CLK2EN_1=>GND,
					WD_0=>in_reg(17 downto 0),
					RD_0 => out_reg(17 downto 0),
					A1_0(10 downto 0)=>addr_wr0,
                        		A2_0(10 downto 0)=>addr_rd0,
                        		CS1_0=>WD_SEL,
					CS2_0=>RD_SEL,
    	         			WEN1_0=>wen_reg(1 downto 0),
					ASYNC_FLUSH_0=>GND,
				  	ASYNC_FLUSH_1 => GND,
 ASYNC_FLUSH_S0=>GND,ASYNC_FLUSH_S1=>GND,
					P1_0=>GND,
					P2_0=>GND,	
					ALMOST_FULL_0=>open,
			 		ALMOST_EMPTY_0=>open,
					PUSH_FLAG_0=>open,
                        		POP_FLAG_0=>open,
                        		FIFO_EN_0=>GND,
					SYNC_FIFO_0=>GND,  
					DIR_0=>GND,
			        	 DIR_1=>GND,

					PIPELINE_RD_0=>reg_rd,
					WIDTH_SELECT1_0=>WS1,
                      		        WIDTH_SELECT2_0=>WS2,


					Clk1_1=>WClk,
                        		CLK2_1=>RClk,
					CLK1S_1=>WClk_Sel,
					CLK2S_1=>RClk_Sel,
					WD_1=>in_reg(35 downto 18),
					RD_1=>out_reg(35 downto 18),
					A1_1(10 downto 0)=>addr_wr1,
			 		A2_1(10 downto 0)=>addr_rd1,	
					CS1_1=>GND,	
			 		CS2_1=>GND,
			 	    WEN1_1=>wen_reg(3 downto 2),                                           
                    P1_1=>GND,
					P2_1=>GND,
 					ALMOST_FULL_1=>open,
			 		ALMOST_EMPTY_1=>open,
					PUSH_FLAG_1=>open,
					POP_FLAG_1=>open,
					FIFO_EN_1 => GND,
                        		SYNC_FIFO_1=>GND,

					PIPELINE_RD_1=>reg_rd,
					WIDTH_SELECT1_1=>WS_GND,
                        		WIDTH_SELECT2_1=>WS_GND,

			 		CONCAT_EN_0 => VCC,
			 		CONCAT_EN_1 => GND
                       );
end generate U36;

U37: if (wr_width_int = rd_width_int ) generate
	RD<=out_reg(rd_width_int-1 downto 0);      
end generate U37;
U38: if((wr_depth_int = 1024 and wr_width_int >9) and (wr_width_int/=rd_width_int))  generate
	U39: if(rd_width_int >18) generate
		RD(rd_width_int-1 downto by_2_read)<=out_reg(35-zero_18_2_rg downto 18);


		RD(by_2_read-1 downto  0)<= out_reg(17-zero_18_2_rg downto 0);
        end generate U39; 
	U40:if(rd_width_int <=9) generate
		RD(rd_width_int-1 downto 0)<=out_reg(rd_width_int-1 downto 0);
	end generate U40; 
	U41: if(rd_width_int <18 and rd_width_int >9) generate
		RD(rd_width_int-1 downto by_2_read) <= out_reg(17-zero_9_2_rg downto 9);
		RD(by_2_read-1 downto 0)<=out_reg(8-zero_9_2_rg downto 0);	
	end generate U41; 
end generate U38;	
U42 :if(wr_depth_int =1024 and wr_width_int <=9 and rd_width_int /= wr_width_int) generate
		RD(rd_width_int-1  downto  by_2_read) <= out_reg(17-zero_9_2_rg downto 9);
		RD(by_2_read-1 downto 0)<=out_reg(8-zero_9_2_rg downto 0);	
end generate U42;

U43: if(wr_depth_int = 2048) generate 
	U44:if(rd_depth_int = 512) generate
		RD(rd_width_int-1 downto by_4_readx3 )<= out_reg(35-zero_9_2_rg downto 27);
		RD(by_4_readx3-1 downto  by_4_readx2)<=out_reg(26-zero_9_2_rg downto 18);
		RD(by_4_readx2-1 downto by_4_read)<=out_reg(17-zero_9_2_rg downto 9);
		RD(by_4_read-1 downto 0)<=out_reg(8-zero_9_2_rg downto 0);
	end generate U44;	
	U45: if(rd_depth_int = 1024) generate
		RD(rd_width_int-1  downto  by_2_read) <= out_reg(17-zero_9_2_rg downto 9);
		RD(by_2_read-1 downto 0)<=out_reg(8-zero_9_2_rg downto 0);	
	end generate U45;
end generate U43;
U46: if(wr_depth_int = 512) generate
RD(rd_width_int-1 downto 0) <= out_reg(rd_width_int-1 downto 0);
end generate U46;
end arch;	


