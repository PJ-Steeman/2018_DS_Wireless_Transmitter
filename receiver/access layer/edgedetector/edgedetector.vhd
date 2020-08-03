-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY edgedetector_rx IS
	PORT
	(
		clk     : IN std_logic;		-- clock signaal
		clk_en  : IN std_logic;		-- clock enable om clock frequentie te verlagen
		rst     : IN std_logic;		-- reset
		ingang  : IN std_logic; 	-- input
		uitgang : OUT std_logic  	-- output
	);
END edgedetector_rx;

ARCHITECTURE behavior OF edgedetector_rx IS
	TYPE state IS (s0, s1, s2);             -- verschillende states van de FSM
	SIGNAL pres_state, next_state : state;
BEGIN

syn_edge : PROCESS(clk)         			-- synchroon deel edge detector
BEGIN
	IF (rising_edge(clk) AND clk_en = '1') THEN
		IF rst = '1' THEN             		-- als reset hoog is -> dan gaat men naar state 0
			pres_state <= s0;
		ELSE                          		-- normaal gezien gaat men naar de next state
			pres_state <= next_state;
		END IF;
	END IF;
END PROCESS syn_edge;

com_edge : PROCESS(pres_state, ingang)   	-- cominatorisch deel edge detector
BEGIN
	CASE pres_state IS
		WHEN s0 => uitgang <= '0';	    	-- initiele state
			IF (ingang = '1') THEN  	    -- als er data binnen komt
				next_state <= s1;       	-- ga naar state 1
			ELSE				       		-- zo niet
				next_state <= s0;	    	-- ga naar state 0
			END IF;
		WHEN s1 => uitgang <= '1';      	-- output een puls
			next_state <= s2;
		WHEN s2 => uitgang <= '0';      	-- beindeigd de puls na 1 klokperiode
			IF (ingang = '0') THEN 			-- als er geen data binnenkomt
				next_state <= s0;	    	-- ga naar state 0(initiele state)
			ELSE
				next_state <= s2;	    	-- zo wel, ga naar state 2(deze state)
			END IF;
	END CASE;
END PROCESS com_edge;
END behavior;