-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY udcounter_test IS
END udcounter_test;

ARCHITECTURE structural OF udcounter_test IS

COMPONENT udcounter 
	PORT
	(
		clk     	: IN std_logic;							
		clk_en  	: IN std_logic;							
		rst     	: IN std_logic;				
		plus		: IN std_logic;	
		min	    	: IN std_logic;	
		uitgang  	: OUT std_logic_vector(3 DOWNTO 0)
	);
END COMPONENT;

FOR uut : udcounter USE ENTITY work.udcounter(behavior); -- signalen aanmaken die overeenkomen met de poorten

	CONSTANT PERIOD   : TIME := 100 ns;
	CONSTANT DELAY    : TIME := 10 ns;
	SIGNAL end_of_sim : BOOLEAN := false;
	
	SIGNAL clk        : std_logic;
	SIGNAL clk_en     : std_logic;
	SIGNAL rst        : std_logic;
	SIGNAL plus       : std_logic;
	SIGNAL min        : std_logic;
	SIGNAL uitgang    : std_logic_vector(3 DOWNTO 0);
	
BEGIN

uut: udcounter PORT MAP		-- ports aan signalen verbinden met port mapping
	(
		clk     => clk,
		clk_en  => clk_en,
		rst     => rst,
		plus    => plus,
		min     => min,
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

	PROCEDURE tbvector(CONSTANT stimvect : IN std_logic_vector(2 DOWNTO 0))IS -- vector aanmaken
		BEGIN
			min <= stimvect(2); 	-- inputs "linken" met de vector
			plus <= stimvect(1); 
			rst <= stimvect(0);
      
		WAIT FOR period;
	END tbvector;
	BEGIN	-- verschillende mogelijke scenario's aflopen

		clk_en <= '1';

		tbvector("001"); -- reset voor initialisatie
		WAIT FOR period;
		tbvector("010");
		WAIT FOR period*30;
		tbvector("100");
		WAIT FOR period*20;
      
		end_of_sim <= true;
		WAIT;
		
	END PROCESS;
END;

