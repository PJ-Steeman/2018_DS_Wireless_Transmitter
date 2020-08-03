-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY pngen IS
	PORT
	(
		clk     	: IN std_logic;	
		clk_en  	: IN std_logic;	
		rst		    : IN std_logic;		
		pn_ml1   	: OUT std_logic;
		pn_ml2  	: OUT std_logic;
		pn_gold  	: OUT std_logic;
		pn_start 	: OUT std_logic 
	);
END pngen;

ARCHITECTURE behavior OF pngen IS
	SIGNAL pres1, pres2 : std_logic_vector(4 DOWNTO 0) := (OTHERS => '0');	-- huidige pn waarde
	SIGNAL next1, next2 : std_logic_vector(4 DOWNTO 0) := (OTHERS => '0');	-- volgende pn waarde
	CONSTANT preset1  : std_logic_vector(4 DOWNTO 0) := "00010";  -- de preset van de 1ste pn generator
	CONSTANT preset2  : std_logic_vector(4 DOWNTO 0) := "00111";  -- de preset van de 2de pn generator
	SIGNAL start: std_logic := '0';
BEGIN

pn_start <= start;					-- de interne pn_start linken met de uitwendige
pn_ml1 <= pres1(0);					-- presets laden
pn_ml2 <= pres2(0);
pn_gold <= pres1(0) XOR pres2(0);	-- gold maken via XOR

next1 <= (pres1(0) XOR pres1(3)) & pres1(4 DOWNTO 1);
next2 <= (((pres2(0) XOR pres2(1)) XOR pres2(3)) XOR pres2(4)) & pres2(4 DOWNTO 1);

syn_pngen : PROCESS (clk)			-- synchroon deel pn generator
BEGIN
	IF (rising_edge(clk) AND clk_en = '1') THEN	
		IF (rst = '1') THEN			-- als de reset 1 is presets weer laden
			pres1 <= preset1;
			pres2 <= preset2;
		ELSE						-- anders naar de volgende fase gaan
			pres1 <= next1;
			pres2 <= next2;
	  END IF;
	END IF;
END PROCESS syn_pngen;

com_pngen : PROCESS (pres1, pres2)	-- combinatorisch deel pn generator
BEGIN
	IF pres1 = preset1 THEN			-- als men terug de preset heeft bereikt -> pn_start = '1'
		start <= '1';
	ELSE
		start <= '0';
	END IF;
END PROCESS com_pngen;
END behavior;
