-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY clkDiv_rx IS
	PORT
	(
		clk     : IN std_logic;
		rst     : IN std_logic;
		clk_en  : OUT std_logic
	);
END;

ARCHITECTURE behavior OF clkDiv_rx IS
	SIGNAL next_count		: std_logic;
	SIGNAL pres_count		: std_logic;
	SIGNAL enable		: std_logic := '1';
	SIGNAL next_enable	: std_logic := '0';
	CONSTANT TRIGGER	: std_logic := '1';
BEGIN
  
clk_en <= enable;

syn_count : PROCESS (clk)
BEGIN
	IF (rising_edge(clk)) THEN
		IF (rst = '1') THEN 
			pres_count <= '0';
			enable <= '1';
		ELSE
			pres_count <= next_count;
			enable <= next_enable;
		END IF;
	END IF;
END PROCESS syn_count;

com_count : PROCESS (pres_count, enable)
BEGIN
	next_count <= not(pres_count);
	IF (pres_count = TRIGGER) THEN
		next_enable <= '1';
	ELSE
		next_enable <= '0';
	END IF;
END PROCESS com_count;
END behavior;