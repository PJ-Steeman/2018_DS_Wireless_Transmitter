-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY clkDiv_rx_test IS
END clkDiv_rx_test;

ARCHITECTURE structural OF clkDiv_rx_test IS

COMPONENT clkDiv_rx 
	PORT
	(
		clk     : IN std_logic;
		rst     : IN std_logic;
		clk_en  : OUT std_logic
	);
END COMPONENT;

FOR uut : clkDiv_rx USE ENTITY work.clkDiv_rx(behavior); -- signalen aanmaken die overeenkomen met de poorten

	CONSTANT PERIOD   : TIME := 100 ns;
	CONSTANT DELAY    : TIME := 10 ns;
	SIGNAL end_of_sim : BOOLEAN := false;
	
	SIGNAL clk        : std_logic;
	SIGNAL clk_en     : std_logic;
	SIGNAL rst        : std_logic;

	
BEGIN

uut: clkDiv_rx PORT MAP		-- ports aan signalen verbinden met port mapping
	(
		clk     => clk,
		clk_en  => clk_en,
		rst     => rst
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

	PROCEDURE tbvector(CONSTANT stimvect : IN std_logic)IS -- vector aanmaken
		BEGIN
			rst <= stimvect;
      
		WAIT FOR period;
	END tbvector;
	BEGIN	-- verschillende mogelijke scenario's aflopen

		tbvector('1'); -- reset voor initialisatie
		WAIT FOR period;
		tbvector('0');
		WAIT FOR period*1000;
      
		end_of_sim <= true;
		WAIT;
		
	END PROCESS;
END;