-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY segdec_test IS
END segdec_test;

ARCHITECTURE structural OF segdec_test IS

COMPONENT segdec IS
	PORT
	(
		ingang    : IN std_logic_vector(3 DOWNTO 0);
		uitgang_b : OUT std_logic_vector(6 DOWNTO 0)
	);
END COMPONENT;

FOR uut : segdec USE ENTITY work.segdec(behavior); -- signalen aanmaken die overeenkomen met de poorten

	CONSTANT period   : TIME := 100 ns;
	CONSTANT delay    : TIME := 10 ns;
	SIGNAL end_of_sim : BOOLEAN := false;
	
	SIGNAL ingang        : std_logic_vector(3 DOWNTO 0);
	SIGNAL uitgang_b     : std_logic_vector(6 DOWNTO 0);
	
BEGIN

uut: segdec PORT MAP		-- ports aan signalen verbinden met port mapping
	(
		ingang    => ingang,
		uitgang_b => uitgang_b
	);
			
tb : PROCESS	-- testbench
BEGIN
	FOR teller IN 0 TO 15 LOOP		-- teller die tot 15 telt
		ingang <= CONV_STD_LOGIC_VECTOR(teller, 4);		-- zet de getallen om in 4-bit binair en dan naar ingang
		WAIT FOR period;
	END LOOP;
	end_of_sim <= true;
	WAIT;
END PROCESS;
END;
