-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY transmitterTop is
  PORT 
  (
    	clk     	   : IN std_logic;							-- clock signaal
	   rst     	   : IN std_logic;							-- reset
	   up_knop     : IN std_logic;       -- up
	   down_knop   : IN std_logic;  -- de uitgang van de counter
	   dip		       : IN std_logic_vector(1 DOWNTO 0);
    	dec_uit     : OUT std_logic_vector(6 DOWNTO 0); -- de aansturing voor de 7seg display
	   sdo_spread	 : OUT std_logic
  );
END transmitterTop;

ARCHITECTURE behavior OF transmitterTop IS
    
    -- aanmaken van componenten om later op te roepen
    
COMPONENT apptop
PORT
	(
		clk     	 : IN std_logic;							-- clock signaal
		clk_en  	 : IN std_logic;							-- clock enable om clock frequentie te verlagen
		rst     	 : IN std_logic;							-- reset
		up        : IN std_logic;       -- up
		down      : IN std_logic;       -- down
		data      : OUT std_logic_vector(3 DOWNTO 0);  -- de uitgang van de counter
  		seg       : OUT std_logic_vector(6 DOWNTO 0)   -- de aansturing voor de 7seg display
	);
END COMPONENT;

COMPONENT datatop
PORT
	(
		clk     	 : IN std_logic;							-- clock signaal
		clk_en  	 : IN std_logic;							-- clock enable om clock frequentie te verlagen
		rst     	 : IN std_logic;							-- reset
		pn_start  : IN std_logic;       -- up
		data      : IN std_logic_vector(3 DOWNTO 0);  -- de uitgang van de counter
  		sdo_posenc: OUT std_logic -- de aansturing voor de 7seg display
	);
END COMPONENT;

COMPONENT acctop
PORT
	(
		clk     	 : IN std_logic;							-- clock signaal
		clk_en  	 : IN std_logic;							-- clock enable om clock frequentie te verlagen
		rst     	 : IN std_logic;							-- reset
		dip1      : IN std_logic;       
		dip2      : IN std_logic;      
		sdo_posenc: IN std_logic;
		pn_start  : OUT std_logic; 
  		sdo_spread: OUT std_logic

	);
END COMPONENT;

COMPONENT clkDiv_tx
PORT
	(
		clk     : IN std_logic;
		rst     : IN std_logic;
		clk_en  : OUT std_logic
	);
END COMPONENT;

SIGNAL sdo_posenc_int, pn_start_int, dip1, dip2 : std_logic;
SIGNAL data_int : std_logic_vector(3 DOWNTO 0);
SIGNAL clk_en : std_logic;

BEGIN
    -- de benodigde componenten oproepen en van port mapping de juiste signalen eraan verbinden

dip1 <= dip(0);
dip2 <= dip(1);

deler : clkDiv_tx
PORT MAP(
  clk => clk,
  rst => rst,
  clk_en => clk_en
);

app_int : apptop
PORT MAP(
		clk => clk,
		clk_en => clk_en,
		rst => rst,
		up => up_knop,							
		down => down_knop,						
		data => data_int,
		seg => dec_uit		    -- output
	);

dat_int : datatop
PORT MAP(
		clk => clk,
		clk_en => clk_en,
		rst => rst,
		pn_start => pn_start_int,											
		data => data_int,
		sdo_posenc => sdo_posenc_int   	-- output
	);

acc_int : acctop
PORT MAP(
		clk => clk,
		clk_en => clk_en,
		rst => rst,
		dip1 => dip1,
		dip2 => dip2,
		sdo_posenc => sdo_posenc_int,
		pn_start => pn_start_int,											
		sdo_spread => sdo_spread
	);

END behavior;