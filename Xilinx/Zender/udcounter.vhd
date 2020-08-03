-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY udcounter IS
	PORT
	(
		clk     	: IN std_logic;							-- clock signaal
		clk_en  	: IN std_logic;							-- clock enable om clock frequentie te verlagen
		rst     	: IN std_logic;							-- reset
		plus		   : IN std_logic;						-- om teller te doen optellen
		min	    	: IN std_logic;							-- om teller te doen aftellen
		uitgang  : OUT std_logic_vector(3 DOWNTO 0)			-- output
	);
END udcounter;

ARCHITECTURE behavior OF udcounter IS
	SIGNAL pres_count : std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');	-- huidige teller waarde
	SIGNAL next_count : std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');	-- volgende teller waarde
BEGIN

uitgang <= pres_count;		-- huidige teller waarde naar uitgang

syn_count : PROCESS (clk)						-- synchroon deel counter
BEGIN
	IF (rising_edge(clk) AND clk_en = '1') THEN
		IF (rst = '1') THEN 					-- als reset = 1 -> huidige teller waarde = 0000
			pres_count <= (OTHERS => '0');
		ELSE 									-- zet volgende teller waarde in huidig teller geheugen
			pres_count <= next_count;
		END IF;
	END IF;
END PROCESS syn_count;

com_count : PROCESS (pres_count, plus, min)		-- combinatorisch deel counter
BEGIN
	IF min = '1' AND plus = '0' THEN 			-- aftellen
		next_count <= pres_count - 1;
	ELSIF plus = '1' AND min = '0' THEN			-- optellen
		next_count <= pres_count + 1;
	ELSE
	  next_count <= pres_count;
	END IF;
END PROCESS com_count;
END behavior;