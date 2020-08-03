-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY datatop is
  PORT 
  (
    clk     	 : IN std_logic;							-- clock signaal
		clk_en  	 : IN std_logic;							-- clock enable om clock frequentie te verlagen
		rst     	 : IN std_logic;							-- reset
		pn_start  : IN std_logic;       -- up
		data      : IN std_logic_vector(3 DOWNTO 0);  -- de uitgang van de counter
    sdo_posenc: OUT std_logic -- de aansturing voor de 7seg display
  );
END datatop;

ARCHITECTURE behavior OF datatop IS
    
    -- aanmaken van componenten om later op te roepen
    
COMPONENT seqcont
PORT
	(
		clk     	: IN std_logic;							-- clock signaal
		clk_en  	: IN std_logic;							-- clock enable om clock frequentie te verlagen
		rst     	: IN std_logic;							-- reset
		pn_start : IN std_logic;							
		load 	   : OUT std_logic;						
		shift    : OUT std_logic		    -- output
	);
END COMPONENT;

COMPONENT datareg
PORT
	(
		clk     	: IN std_logic;							-- clock signaal
		clk_en  	: IN std_logic;							-- clock enable om clock frequentie te verlagen
		rst     	: IN std_logic;							-- reset
		load     : IN std_logic;											
		shift    : IN std_logic;
		data     : IN std_logic_vector(3 DOWNTO 0);
		sdo_posenc: OUT std_logic    	-- output
	);
END COMPONENT;

SIGNAL load_int, shift_int : std_logic;

BEGIN
    -- de benodigde componenten oproepen en van port mapping de juiste signalen eraan verbinden

seqcont_int : seqcont
PORT MAP(
		clk => clk,
		clk_en => clk_en,
		rst => rst,
		pn_start => pn_start,							
		load => load_int,						
		shift => shift_int		    -- output
	);

datareg_int : datareg
PORT MAP(
		clk => clk,
		clk_en => clk_en,
		rst => rst,
		load => load_int,											
		shift => shift_int,
		data => data,
		sdo_posenc => sdo_posenc   	-- output
	);

END behavior;