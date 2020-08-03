-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY acctop is
  PORT 
  (
		clk     	 	: IN std_logic;			-- clock signaal
		clk_en  	 	: IN std_logic;			-- clock enable om clock frequentie te verlagen
		rst     	 	: IN std_logic;			-- reset
		dip1      		: IN std_logic;       	-- waarde van dipswitch 1
		dip2      		: IN std_logic;      	-- waarde van dipswitch 2
		sdo_posenc		: IN std_logic;			-- waarde die uit schuifregister komt
		pn_start  		: OUT std_logic; 		-- geeft start van pn code aan
		sdo_spread		: OUT std_logic			-- output voor antenne
  );
END acctop;

ARCHITECTURE behavior OF acctop IS
        
COMPONENT mux		-- aanmaken van de definitie van een mux (voor betekenis signalen zie mux.vhd)
  PORT
	(
		in0 			: IN std_logic;
		in1 			: IN std_logic;
		in2 			: IN std_logic;
		in3  			: IN std_logic;
		sel		        : IN std_logic_vector(1 DOWNTO 0);
		sdo_spread      : OUT std_logic
	);
END COMPONENT;

COMPONENT pngen		-- aanmaken van de definitie van een pngen (voor betekenis signalen zie pngen.vhd)
  PORT
	(
		clk     		: IN std_logic;			
		clk_en  		: IN std_logic;			
		rst			   	: IN std_logic;					
		pn_ml1   		: OUT std_logic;		
		pn_ml2  		: OUT std_logic;		
		pn_gold  		: OUT std_logic;   		
		pn_start 		: OUT std_logic      	
	);
END COMPONENT;

SIGNAL int_pn_ml1, int_pn_ml2, int_pn_gold, int_pn_start : std_logic; 		-- interne signalen in de access layer
SIGNAL int_sdo_spread, xor1, xor2, xor3 : std_logic;

BEGIN					-- verbinden van interne signalen met de in/uitgangen
    
sdo_spread <= int_sdo_spread; 
pn_start <= int_pn_start;

xor1 <= int_pn_ml1 XOR  sdo_posenc;
xor2 <= int_pn_ml2 XOR  sdo_posenc;
xor3 <= int_pn_gold XOR  sdo_posenc;

int_pngen : pngen		-- de benodigde componenten aanmaken en via port mapping de juiste signalen eraan verbinden
PORT MAP(
    clk => clk,
	clk_en => clk_en,
	rst => rst,
    pn_ml1  => int_pn_ml1,
	pn_ml2  => int_pn_ml2,
	pn_gold  => int_pn_gold,
	pn_start  => int_pn_start
);

int_mux : mux
PORT MAP(
    in0 => sdo_posenc,
    in1 => xor1,
    in2 => xor2,
    in3 => xor3,
	sel(0) =>   dip1,
	sel(1) =>   dip2,         	
	sdo_spread  =>  int_sdo_spread      
);  

END behavior;