-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY pngen_test IS
END pngen_test;

ARCHITECTURE structural OF pngen_test IS

COMPONENT pngen  -- component declaratie
	PORT
	(
		clk     	: IN std_logic;				-- clock signaal
		clk_en  	: IN std_logic;				-- clock enable om clock frequentie te verlagen
		rst			: IN std_logic;				-- reset om terug naar initiele situatie te gaan		
		pn_ml1   	: OUT std_logic;			-- pn code 1
		pn_ml2  	: OUT std_logic;			-- pn code 2
		pn_gold  	: OUT std_logic;   		 	-- ml1 XOR ml2
		pn_start 	: OUT std_logic      		-- registers staan terug op start
	);
END COMPONENT;

FOR uut : pngen USE ENTITY work.pngen(behavior); -- signalen aanmaken die overeenkomen met de poorten
  
	CONSTANT period   	: TIME := 100 ns;
	CONSTANT delay    	: TIME := 10 ns;
	SIGNAL end_of_sim 	: BOOLEAN := false;
	
	SIGNAL clk        	: std_logic;
	SIGNAL clk_en     	: std_logic;
	SIGNAL rst        	: std_logic;
	SIGNAL pn_ml1     	: std_logic;
	SIGNAL pn_ml2     	: std_logic;
	SIGNAL pn_gold	 	: std_logic;
	SIGNAL pn_start		: std_logic;
	
BEGIN

uut: pngen PORT MAP -- ports aan signalen verbinden met port mapping
    (
      	clk    		=> clk,
      	clk_en 		=> clk_en,
      	rst    		=> rst,
      	pn_ml1 		=> pn_ml1,
      	pn_ml2 		=> pn_ml2,
		pn_gold		=> pn_gold,
		pn_start 	=> pn_start
    );

clock : PROCESS -- kloksignaal aanmaken voor de synchrone elementen
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

	PROCEDURE tbvector(CONSTANT stimvect : IN std_logic)IS -- test vector aanmaken
		BEGIN
			rst <= stimvect; -- inputs "linken" met de vector
      
			WAIT FOR period;
	END tbvector;
	BEGIN	-- verschillende mogelijke scenario's aflopen

		clk_en <= '1';
		tbvector('1');
		WAIT FOR period*5;
		tbvector('0');
		WAIT FOR period*100;
      
		end_of_sim <= true;
		WAIT;

	END PROCESS;
END;


