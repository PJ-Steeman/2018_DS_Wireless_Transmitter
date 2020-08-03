-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY edgedetector_rx_test IS
END edgedetector_rx_test;

ARCHITECTURE structural OF edgedetector_rx_test IS

COMPONENT edgedetector_rx  -- component declaratie
	PORT
	(
		clk     : IN std_logic;
		clk_en  : IN std_logic;
		rst     : IN std_logic;
	  	ingang  : IN std_logic;
	  	uitgang : OUT std_logic 
	);
END COMPONENT;

FOR uut : edgedetector_rx USE ENTITY work.edgedetector_rx(behavior); -- signalen aanmaken die overeenkomen met de poorten

	CONSTANT period   : TIME := 100 ns;
	CONSTANT delay    : TIME := 10 ns;
	SIGNAL end_of_sim : BOOLEAN := false;

	SIGNAL clk        : std_logic;
	SIGNAL clk_en     : std_logic;
	SIGNAL rst        : std_logic;
	SIGNAL ingang     : std_logic;
	SIGNAL uitgang    : std_logic;

BEGIN

uut: edgedetector_rx PORT MAP -- ports aan signalen verbinden met port mapping
    (
      	clk     => clk,
      	clk_en  => clk_en,
      	rst     => rst,
      	ingang  => ingang,
      	uitgang => uitgang
    );

clock : PROCESS -- kloksignaal voor de synchrone elementen
	BEGIN
		clk <= '0';
    	WAIT FOR period/2;
    	LOOP
			clk <= '0';
			WAIT FOR period/2;
			clk <= '1';
			WAIT FOR period/2;
			EXIT WHEN end_of_sim;
		END LOOP;
	WAIT;
  END PROCESS clock;

tb : PROCESS -- testbench

	PROCEDURE tbvector(CONSTANT stimvect : IN std_logic_vector(1 DOWNTO 0))IS -- vector aanmaken
		BEGIN
			ingang <= stimvect(1); -- inputs "linken" met de vector
			rst <= stimvect(0);
      
		WAIT FOR period;
	END tbvector;
	BEGIN	-- verschillende mogelijke scenario's aflopen

		clk_en <= '1';

		tbvector("01"); -- reset voor initialisatie
		WAIT FOR period*100;
		tbvector("10");
		WAIT FOR period*100;
		tbvector("00");
		tbvector("10");
		WAIT FOR period*100;
		tbvector("10");
		tbvector("01");
		WAIT FOR period*100;
      
		end_of_sim <= true;
		WAIT;
		
	END PROCESS;
END;
