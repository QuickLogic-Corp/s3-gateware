library IEEE;
use IEEE.std_logic_1164.all;
entity RAM8K_2X1_CELL_MACRO is
      Port (    CLK1_0,CLK2_0	 	: in std_logic;
		CLK1S_0,CLK2S_0	 	: in std_logic;
			WD_0	                : in std_logic_vector(17 downto 0);
			A1_0,A2_0    	     : in std_logic_vector(10 downto 0);
			CS1_0,CS2_0		   : in std_logic;
			WEN1_0	         : in std_logic_vector(1 downto 0);
			CLK1EN_0,CLK2EN_0 	: in std_logic;
			P1_0           	: in std_logic;
			P2_0           	: in std_logic;
			ALMOST_FULL_0  	: out std_logic;
			ALMOST_EMPTY_0 	: out std_logic;
			PUSH_FLAG_0,POP_FLAG_0	: out std_logic_vector(3 downto 0);
			RD_0			: out std_logic_vector(17 downto 0);
			FIFO_EN_0,SYNC_FIFO_0  : in std_logic;
			PIPELINE_RD_0		: in std_logic;
			WIDTH_SELECT1_0 	: in std_logic_vector(1 downto 0);
			WIDTH_SELECT2_0	: in std_logic_vector(1 downto 0);
			DIR_0          	: in std_logic;
			ASYNC_FLUSH_0         	: in std_logic;
			ASYNC_FLUSH_S0         	: in std_logic;
			CONCAT_EN_0         	: in std_logic;
            CLK1S_1,CLK2S_1		: in std_logic;
			CLK1_1,CLK2_1		: in std_logic;
			WD_1			: in std_logic_vector(17 downto 0);
			A1_1,A2_1		: in std_logic_vector(10 downto 0);
			CS1_1,CS2_1		: in std_logic;
			WEN1_1	        	: in std_logic_vector(1 downto 0);
			CLK1EN_1,CLK2EN_1 	: in std_logic;
			P1_1           	: in std_logic;
			P2_1           	: in std_logic;
			ALMOST_FULL_1  	: out std_logic;
			ALMOST_EMPTY_1 	: out std_logic;
			PUSH_FLAG_1,POP_FLAG_1	: out std_logic_vector(3 downto 0);
			RD_1			: out std_logic_vector(17 downto 0);
			FIFO_EN_1,SYNC_FIFO_1  : in std_logic;
			PIPELINE_RD_1		: in std_logic;
			WIDTH_SELECT1_1 	: in std_logic_vector(1 downto 0);
			WIDTH_SELECT2_1	: in std_logic_vector(1 downto 0);
			DIR_1          	: in std_logic;
			ASYNC_FLUSH_1         	: in std_logic;
			ASYNC_FLUSH_S1         	: in std_logic;
      		CONCAT_EN_1         	: in std_logic);

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
      Port (    CLK1_0,CLK2_0	 	: in std_logic;
		CLK1S_0,CLK2S_0	 	: in std_logic;
			WD_0	                : in std_logic_vector(17 downto 0);
			A1_0,A2_0    	     : in std_logic_vector(10 downto 0);
			CS1_0,CS2_0		   : in std_logic;
			WEN1_0	         : in std_logic_vector(1 downto 0);
			CLK1EN_0,CLK2EN_0 	: in std_logic;
			P1_0           	: in std_logic;
			P2_0           	: in std_logic;
			ALMOST_FULL_0  	: out std_logic;
			ALMOST_EMPTY_0 	: out std_logic;
			PUSH_FLAG_0,POP_FLAG_0	: out std_logic_vector(3 downto 0);
			RD_0			: out std_logic_vector(17 downto 0);
			FIFO_EN_0,SYNC_FIFO_0  : in std_logic;
			PIPELINE_RD_0		: in std_logic;
			WIDTH_SELECT1_0 	: in std_logic_vector(1 downto 0);
			WIDTH_SELECT2_0	: in std_logic_vector(1 downto 0);
			DIR_0          	: in std_logic;
			ASYNC_FLUSH_0         	: in std_logic;
			ASYNC_FLUSH_S0         	: in std_logic;
			CONCAT_EN_0         	: in std_logic;
            CLK1S_1,CLK2S_1		: in std_logic;
			CLK1_1,CLK2_1		: in std_logic;
			WD_1			: in std_logic_vector(17 downto 0);
			A1_1,A2_1		: in std_logic_vector(10 downto 0);
			CS1_1,CS2_1		: in std_logic;
			WEN1_1	        	: in std_logic_vector(1 downto 0);
			CLK1EN_1,CLK2EN_1 	: in std_logic;
			P1_1           	: in std_logic;
			P2_1           	: in std_logic;
			ALMOST_FULL_1  	: out std_logic;
			ALMOST_EMPTY_1 	: out std_logic;
			PUSH_FLAG_1,POP_FLAG_1	: out std_logic_vector(3 downto 0);
			RD_1			: out std_logic_vector(17 downto 0);
			FIFO_EN_1,SYNC_FIFO_1  : in std_logic;
			PIPELINE_RD_1		: in std_logic;
			WIDTH_SELECT1_1 	: in std_logic_vector(1 downto 0);
			WIDTH_SELECT2_1	: in std_logic_vector(1 downto 0);
			DIR_1          	: in std_logic;
			ASYNC_FLUSH_1         	: in std_logic;
			ASYNC_FLUSH_S1         	: in std_logic;
       		CONCAT_EN_1         	: in std_logic );
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
                 A2_1(10 downto 0)=>A2_1(10 downto 0), CLK1_0=>CLK1_0,
                 CLK1_1=>CLK1_1, CLK2_0=>CLK2_0, CLK2_1=>CLK2_1,
				 CLK1S_1=>CLK1S_1,CLK1S_0=>CLK1S_0,  CLK2S_0=>CLK2S_0,CLK2S_1=>CLK2S_1,
				 CLK1EN_1=>CLK1EN_1,CLK1EN_0=>CLK1EN_0, CLK2EN_0=>CLK2EN_0, CLK2EN_1=>CLK2EN_1,
                 CONCAT_EN_0=>CONCAT_EN_0, CONCAT_EN_1=>CONCAT_EN_1,
                 CS1_0=>CS1_0, CS1_1=>CS1_1, CS2_0=>CS2_0, CS2_1=>CS2_1,
                 FIFO_EN_0=>FIFO_EN_0, FIFO_EN_1=>FIFO_EN_1,
                 P1_1=>P1_1,P2_1=>P2_1,
				 P1_0=>P1_0,P2_0=>P2_0,
				 DIR_1=>DIR_1,DIR_0=>DIR_0,
				 ASYNC_FLUSH_1=>ASYNC_FLUSH_1,ASYNC_FLUSH_0=>ASYNC_FLUSH_0	,			 
				 ASYNC_FLUSH_S1=>ASYNC_FLUSH_S1,ASYNC_FLUSH_S0=>ASYNC_FLUSH_S0,
                 PIPELINE_RD_0=>PIPELINE_RD_0,
                 PIPELINE_RD_1=>PIPELINE_RD_1,
                 SYNC_FIFO_0=>SYNC_FIFO_0,
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

entity FIFO is
generic( wr_depth_int :integer := 1024;
	rd_depth_int :integer := 512;
        wr_width_int :integer := 9;
        rd_width_int :integer := 18;
	reg_rd_int : integer :=0;
        sync_fifo_int:integer :=1;
        device_8k_int :integer := 0); 
port (
      DIN : in std_logic_vector( wr_width_int-1  downto 0);
      PUSH: in std_logic;
      POP: in std_logic; 
      Fifo_Push_Flush,Fifo_Pop_Flush:in std_logic;
      Push_Clk,Pop_Clk: in std_logic;
	  Push_Clk_En,Pop_Clk_En,Fifo_Dir,Async_Flush,Push_Clk_Sel,Pop_Clk_Sel,Async_Flush_Sel: in std_logic;
      Almost_Full,Almost_Empty: out std_logic;	
      PUSH_FLAG,POP_FLAG:out std_logic_vector(3 downto 0);
      DOUT : out std_logic_vector(rd_width_int-1  downto 0) );
attribute syn_isclock: boolean;
attribute syn_isclock of Push_Clk: signal is true; 
attribute syn_isclock of Pop_Clk: signal is true; 
end FIFO;

Architecture arch of FIFO is

component RAM8K_2X1_CELL_MACRO
      Port (    A1_0              : In    STD_LOGIC_VECTOR  (10 downto 0);
            A1_1              : In    STD_LOGIC_VECTOR  (10 downto 0);
            A2_0              : In    STD_LOGIC_VECTOR  (10 downto 0);
            A2_1              : In    STD_LOGIC_VECTOR  (10 downto 0);
            ASYNC_FLUSH_0     : In    STD_LOGIC;
            ASYNC_FLUSH_1     : In    STD_LOGIC;
			ASYNC_FLUSH_S0     : In    STD_LOGIC;
            ASYNC_FLUSH_S1     : In    STD_LOGIC;
            CLK1_0            : In    STD_LOGIC;
            CLK1_1            : In    STD_LOGIC;
            CLK1EN_0          : In    STD_LOGIC;
            CLK1EN_1          : In    STD_LOGIC;
            CLK1S_0           : In    STD_LOGIC;
            CLK1S_1           : In    STD_LOGIC;
            CLK2_0            : In    STD_LOGIC;
            CLK2_1            : In    STD_LOGIC;
            CLK2EN_0          : In    STD_LOGIC;
            CLK2EN_1          : In    STD_LOGIC;
            CLK2S_0           : In    STD_LOGIC;
            CLK2S_1           : In    STD_LOGIC;
            CONCAT_EN_0       : In    STD_LOGIC;
            CONCAT_EN_1       : In    STD_LOGIC;
            CS1_0             : In    STD_LOGIC;
            CS1_1             : In    STD_LOGIC;
            CS2_0             : In    STD_LOGIC;
            CS2_1             : In    STD_LOGIC;
            DIR_0             : In    STD_LOGIC;
            DIR_1             : In    STD_LOGIC;
            FIFO_EN_0         : In    STD_LOGIC;
            FIFO_EN_1         : In    STD_LOGIC;
            P1_0              : In    STD_LOGIC;
            P1_1              : In    STD_LOGIC;
            P2_0              : In    STD_LOGIC;
            P2_1              : In    STD_LOGIC;
            PIPELINE_RD_0     : In    STD_LOGIC;
            PIPELINE_RD_1     : In    STD_LOGIC;
            SYNC_FIFO_0       : In    STD_LOGIC;
            SYNC_FIFO_1       : In    STD_LOGIC;
            WD_0              : In    STD_LOGIC_VECTOR  (17 downto 0);
            WD_1              : In    STD_LOGIC_VECTOR  (17 downto 0);
            WEN1_0            : In    STD_LOGIC_VECTOR  (1 downto 0);
            WEN1_1            : In    STD_LOGIC_VECTOR  (1 downto 0);
            WIDTH_SELECT1_0   : In    STD_LOGIC_VECTOR  (1 downto 0);
            WIDTH_SELECT1_1   : In    STD_LOGIC_VECTOR  (1 downto 0);
            WIDTH_SELECT2_0   : In    STD_LOGIC_VECTOR  (1 downto 0);
            WIDTH_SELECT2_1   : In    STD_LOGIC_VECTOR  (1 downto 0);
            Almost_Empty_0    : Out   STD_LOGIC;
            Almost_Empty_1    : Out   STD_LOGIC;
            Almost_Full_0     : Out   STD_LOGIC;
            Almost_Full_1     : Out   STD_LOGIC;
            POP_FLAG_0        : Out   STD_LOGIC_VECTOR  (3 downto 0);
            POP_FLAG_1        : Out   STD_LOGIC_VECTOR  (3 downto 0);
            PUSH_FLAG_0       : Out   STD_LOGIC_VECTOR  (3 downto 0);
            PUSH_FLAG_1       : Out   STD_LOGIC_VECTOR  (3 downto 0);
            RD_0              : Out   STD_LOGIC_VECTOR  (17 downto 0);
            RD_1              : Out   STD_LOGIC_VECTOR  (17 downto 0) );
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
Signal WS1,WS2,WS_GND,WEN1_GND:std_logic_vector(1 downto 0);
signal addr_wr,addr_rd: std_logic_vector(10 downto 0);
signal in_reg :std_logic_vector(36 downto 0);
signal out_reg: std_logic_vector(35 downto 0);
signal reg_rd : std_logic;
signal WEN1:std_logic_vector(1 downto 0);
signal sync_fifo:std_logic;
begin
VCC <='1';
GND<='0';
WEN1(0)<=PUSH;
WEN1(1)<='0';
reg_rd <= '0' when reg_rd_int=0 else '1';
sync_fifo<='0' when sync_fifo_int=0 else '1';
WS_GND<="00";
WEN1_GND<="00";
addr_rd<=(others=>'0');

---Generating data


U1:if((wr_width_int =36 or wr_width_int = 18 or wr_width_int =9) or (wr_width_int = rd_width_int))generate
	in_reg(35 downto wr_width_int)<=(others=>'0');
	in_reg(wr_width_int-1 downto 0)<=DIN;
end generate U1;
U2: if(wr_depth_int = 512) generate
	U3:if(rd_depth_int = 1024)generate
	     U7:if(wr_width_int > 18)generate
			U8:if(mod2 = 0)generate
				in_reg(17 downto 18-zero_36_2)<=(others=>'0');
				in_reg(35 downto 36-zero_36_2)<=(others=>'0');
				in_reg(18-zero_36_2-1 downto 0)<=DIN(by_2-1 downto 0);
				in_reg(36-zero_36_2-1 downto 18)<=DIN(wr_width_int-1 downto by_2);
			end generate U8;
			U9:if(mod2 /= 0)generate
				in_reg(35 downto wr_width_int)<=(others=>'0');
				in_reg(wr_width_int-1 downto 0)<=DIN;
			end generate U9;
		end generate U7;
		U10:if(wr_width_int <= 18) generate
			U11: if(mod2 = 0)generate 
				in_reg(8 downto 9-zero_18_2)<=(others=>'0'); 
				in_reg(17 downto 18-zero_18_2)<=(others=>'0'); 
				in_reg(9-zero_18_2-1 downto 0)<=DIN(by_2-1 downto 0);
				in_reg(18-zero_18_2-1 downto 9) <= DIN(wr_width_int-1 downto by_2);
			end generate U11;
			U12: if(mod2 /= 0)generate
				in_reg(35 downto wr_width_int)<=(others=>'0');
				in_reg(wr_width_int-1 downto 0)<=DIN;
			end generate U12;
		end generate U10;
	end generate U3;
	U13: if(rd_depth_int = 2048)generate
		U14:if(mod4=0)generate
			in_reg(35 downto 36-zero_36_4)<=(others=>'0');
			in_reg(26 downto 27-zero_36_4)<=(others=>'0');
			in_reg(17 downto 18-zero_36_4)<=(others=>'0');
			in_reg(8 downto 9-zero_36_4)<=(others=>'0');
			in_reg(36-zero_36_4-1 downto 27)<=DIN(wr_width_int-1 downto by_4_3);
			in_reg(27-zero_36_4-1 downto 18)<=DIN(by_4_3-1 downto by_4_2);
			in_reg(18-zero_36_4-1 downto 9)<=DIN(by_4_2-1 downto by_4);
			in_reg(9-zero_36_4-1 downto 0)<=DIN(by_4-1 downto 0);

		end generate U14;
		U15:if(mod4 /= 0)generate
			in_reg(35 downto wr_width_int)<=(others=>'0');
			in_reg(wr_width_int-1 downto 0)<=DIN;
		end generate U15;
	end generate U13;
end generate U2;
U16: if(wr_depth_int = 1024)generate
	U17:if(rd_depth_int = 2048)generate
		U18:if(mod2=0)generate
			in_reg(8 downto 9-zero_18_2)<=(others=>'0');
			in_reg(17 downto 18-zero_18_2)<=(others=>'0');
			in_reg(9-zero_18_2-1 downto 0)<=DIN(by_2-1 downto 0);
			in_reg(18-zero_18_2-1 downto 9)<=DIN(wr_width_int-1 downto by_2);
		end generate U18;
		U19:if(mod2 /= 0)generate
			in_reg(35 downto wr_width_int)<=(others=>'0');
			in_reg(wr_width_int-1 downto 0)<=DIN;
		end generate U19;
	
	end generate U17;
	U18: if(rd_depth_int=512)generate
		in_reg(35 downto wr_width_int)<=(others=>'0');
		in_reg(wr_width_int-1 downto 0)<=DIN;
	end generate U18;
end generate U16;

U19: if(wr_depth_int= 2048) generate
	in_reg(35 downto wr_width_int)<=(others=>'0');
	in_reg(wr_width_int-1 downto 0)<=DIN;
end generate U19;




---Generating widht selects
U20: if(rd_depth_int = 2048 and wr_depth_int = 512) generate
	WS1<="10";
end generate U20;
U21: if(rd_depth_int = 2048 and wr_depth_int=1024) generate
	WS1<="01";
end generate U21;
U22: if(wr_depth_int =512 and wr_width_int <=18 and rd_depth_int /=2048) generate
		WS1<="01";
end generate U22;
U23: if((wr_width_int  <= 9  and wr_depth_int /=512) or (wr_depth_int=1024 and rd_depth_int /=2048 and wr_width_int <=9)) generate
	WS1<="00";
end generate U23;
U24:if((wr_width_int >9 and wr_width_int<=18 ) or (wr_depth_int =512 and rd_depth_int /= 2048 and wr_width_int<=18)) generate
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
U28: if(rd_depth_int =512 and rd_width_int <=18 and wr_depth_int /=2048) generate
	WS2<="01";
end generate U28;

U29:if((rd_width_int <=9 and rd_depth_int /= 512 ) or (rd_depth_int =1024 and wr_depth_int /=2048 and rd_width_int <=9))generate

    WS2<="00";
End generate U29;
U30: if((rd_width_int>9  and rd_width_int <=18) or (rd_depth_int = 512 and wr_depth_int /=2048 and rd_width_int <=18) )generate
     WS2<="01";
End generate U30;
U31: if(rd_width_int >18)generate
     WS2<= "10";
end generate U31;


U35: if((((wr_width_int<= 18) and (wr_depth_int=512)) or ((wr_width_int<=9) and (wr_depth_int=1024))) and (rd_depth_int /=2048)) generate 
	FIFO8k : RAM8K_2X1_CELL_MACRO
		port map(	CLK1_0=>Push_Clk,
				CLK2_0=>Pop_Clk,
				CLK1S_0=>Push_Clk_Sel,
				CLK2S_0=>Pop_Clk_Sel,
				CLK1En_0=>Push_Clk_En,
				CLK2En_0=>Pop_Clk_En,
				ASYNC_FLUSH_0=>Async_Flush,
				ASYNC_FLUSH_S0=>Async_Flush_Sel,
				DIR_0=>Fifo_Dir,
				P1_0=>PUSH,
				P2_0=>POP,
				
				WD_0=>in_reg(17 downto 0),
				RD_0 => out_reg(17 downto 0),
				A1_0(10 downto 0)=>addr_wr,
                        	A2_0(10 downto 0)=>addr_rd,
                        	CS1_0=>Fifo_Push_Flush,
				CS2_0=>Fifo_Pop_Flush,
    	         		WEN1_0=>WEN1,

			
				ALMOST_FULL_0=>Almost_Full,
	 			ALMOST_EMPTY_0=>Almost_Empty,
				PUSH_FLAG_0=>PUSH_FLAG,
       	                        POP_FLAG_0=>POP_FLAG,
              	                FIFO_EN_0=>VCC,
				SYNC_FIFO_0=>sync_fifo,  

				PIPELINE_RD_0=>reg_rd,
				WIDTH_SELECT1_0=>WS1,
                       	        WIDTH_SELECT2_0=>WS2,

				Clk1_1=>GND,
                        	CLK2_1=>GND,
                        	CLK1S_1=>GND,
                        	CLK2S_1=>GND,
                        	Clk1En_1=>GND,
                        	CLK2En_1=>GND,
							P1_1=>GND,
				P2_1=>GND,
                        	
				WD_1=>in_reg(35 downto 18),
				RD_1=>out_reg(35 downto 18),
				A1_1(10 downto 0)=>addr_wr,
			 	A2_1(10 downto 0)=>addr_rd,	
				CS1_1=>GND,	
			 	CS2_1=>GND,
			        WEN1_1=>WEN1_GND,	
                                                
                                --POP_1=>GND,
 				ALMOST_FULL_1=>open,
			 	ALMOST_EMPTY_1=>open,
				PUSH_FLAG_1=>open,
				POP_FLAG_1=>open,
				FIFO_EN_1 => GND,
                SYNC_FIFO_1=>GND, 
				PIPELINE_RD_1=>GND,
				WIDTH_SELECT1_1=>WS_GND,
                WIDTH_SELECT2_1=>WS_GND,		
				ASYNC_FLUSH_1=>GND,
				ASYNC_FLUSH_S1=>GND, 
				DIR_1=>GND, 
			 	CONCAT_EN_0 =>GND,
			 	CONCAT_EN_1 => GND
                       );
end generate U35;
U36: if( (wr_width_int > 18 and wr_depth_int=512) or (wr_width_int > 9 and wr_depth_int=1024)or wr_depth_int > 1024  or rd_depth_int =2048) generate 
	FIFO16k : RAM8K_2X1_CELL_MACRO
		port map(	CLK1_0=>Push_Clk,
				CLK2_0=>Pop_Clk,
				CLK1En_0=>Push_Clk_En,
				CLK2En_0=>Pop_Clk_En,
				CLK1S_0=>Push_Clk_Sel,
				CLK2S_0=>Pop_Clk_Sel,
				
				P1_0=>PUSH,
				P2_0=>POP,
				P1_1=>PUSH,
				P2_1=>POP,
				ASYNC_FLUSH_0=>Async_Flush,
				ASYNC_FLUSH_S0=>Async_Flush_Sel,
				DIR_0=>Fifo_Dir,
				WD_0=>in_reg(17 downto 0),
				RD_0 => out_reg(17 downto 0),
				A1_0(10 downto 0)=>addr_wr,
                        	A2_0(10 downto 0)=>addr_rd,
                        	CS1_0=>Fifo_Push_Flush,
				CS2_0=>Fifo_Pop_Flush,
    	         		WEN1_0=>WEN1,

					
				ALMOST_FULL_0=>Almost_Full,
			 	ALMOST_EMPTY_0=>Almost_Empty,
				PUSH_FLAG_0=>PUSH_FLAG,
                        	POP_FLAG_0=>POP_FLAG,
                        	FIFO_EN_0=>VCC,
				SYNC_FIFO_0=>sync_fifo,  

				PIPELINE_RD_0=>reg_rd,
				WIDTH_SELECT1_0=>WS1,
                        	WIDTH_SELECT2_0=>WS2,

				Clk1_1=>Push_Clk,
                        	CLK2_1=>Pop_Clk,
				WD_1=>in_reg(35 downto 18),
				RD_1=>out_reg(35 downto 18),
				A1_1(10 downto 0)=>addr_wr,
			 	A2_1(10 downto 0)=>addr_rd,	
				CS1_1=>GND,	
			 	CS2_1=>GND,
			        WEN1_1=>WEN1_GND,	
                                                
                        --	POP_1=>GND,
 				ALMOST_FULL_1=>open,
			 	ALMOST_EMPTY_1=>open,
				PUSH_FLAG_1=>open,
				POP_FLAG_1=>open,
				FIFO_EN_1 => GND,
                SYNC_FIFO_1=>GND,
				CLK1En_1=>Push_Clk_En,
				CLK2En_1=>Pop_Clk_En,
				CLK1S_1=>Push_Clk_En,
				CLK2S_1=>Pop_Clk_En,
				ASYNC_FLUSH_1=>Async_Flush,
				ASYNC_FLUSH_S1=>Async_Flush_Sel,
				DIR_1=>Fifo_Dir,
				

				PIPELINE_RD_1=>reg_rd,
				WIDTH_SELECT1_1=>WS_GND,
                        	WIDTH_SELECT2_1=>WS_GND,
       
			 	CONCAT_EN_0 => VCC,
			 	CONCAT_EN_1 => GND
                       );
end generate U36;

U37: if (wr_width_int = rd_width_int ) generate
	DOUT<=out_reg(rd_width_int-1 downto 0);      
end generate U37;
U38: if(wr_depth_int = 1024 and wr_width_int >9 and (wr_width_int /= rd_width_int)) generate
	U39: if(rd_width_int >18) generate
		DOUT(rd_width_int-1 downto by_2_read)<=out_reg(35-zero_18_2_rg downto 18);


		DOUT(by_2_read-1 downto  0)<= out_reg(17-zero_18_2_rg downto 0);
        end generate U39; 
	U40:if(rd_width_int <=9) generate
		DOUT(rd_width_int-1 downto 0)<=out_reg(rd_width_int-1 downto 0);
	end generate U40; 
	U41: if(rd_width_int <18 and rd_width_int >9) generate
		DOUT(rd_width_int-1 downto by_2_read) <= out_reg(17-zero_9_2_rg downto 9);
		DOUT(by_2_read-1 downto 0)<=out_reg(8-zero_9_2_rg downto 0);	
	end generate U41; 
end generate U38;	
U42 :if(wr_depth_int =1024 and wr_width_int <=9  and (wr_width_int/= rd_width_int)) generate
		DOUT(rd_width_int-1  downto  by_2_read) <= out_reg(17-zero_9_2_rg downto 9);
		DOUT(by_2_read-1 downto 0)<=out_reg(8-zero_9_2_rg downto 0);	
end generate U42;

U43: if(wr_depth_int = 2048) generate 
	U44:if(rd_depth_int = 512) generate
		DOUT(rd_width_int-1 downto by_4_readx3 )<= out_reg(35-zero_9_2_rg downto 27);
		DOUT(by_4_readx3-1 downto  by_4_readx2)<=out_reg(26-zero_9_2_rg downto 18);
		DOUT(by_4_readx2-1 downto by_4_read)<=out_reg(17-zero_9_2_rg downto 9);
		DOUT(by_4_read-1 downto 0)<=out_reg(8-zero_9_2_rg downto 0);
	end generate U44;	
	U45: if(rd_depth_int = 1024) generate
		DOUT(rd_width_int-1  downto  by_2_read) <= out_reg(17-zero_9_2_rg downto 9);
		DOUT(by_2_read-1 downto 0)<=out_reg(8-zero_9_2_rg downto 0);	
	end generate U45;
end generate U43;
U46: if(wr_depth_int = 512) generate
DOUT(rd_width_int-1 downto 0) <= out_reg(rd_width_int-1 downto 0);
end generate U46;
end arch;	

