-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY latch_test_rx IS
END latch_test_rx;

ARCHITECTURE structural OF latch_test_rx IS

COMPONENT latch_rx  -- component declaratie
	PORT
	(
		clk        : IN  std_logic;
		clk_en     : IN  std_logic;
		rst        : IN  std_logic;
		bit_sample : IN  std_logic;
		pre	   : IN  std_logic_vector(6 DOWNTO 0);
		latch_in   : IN  std_logic_vector(3 DOWNTO 0); 
		latch_out  : OUT std_logic_vector(3 DOWNTO 0) 
	);
END COMPONENT;

FOR uut : latch_rx USE ENTITY work.latch_rx(behavior); -- signalen aanmaken die overeenkomen met de poorten
  
	CONSTANT period   	: TIME := 100 ns;
	CONSTANT delay    	: TIME := 10 ns;
	SIGNAL end_of_sim 	: BOOLEAN := false;
	
	SIGNAL clk        	: std_logic;
	SIGNAL clk_en     	: std_logic;
	SIGNAL rst        	: std_logic;
	SIGNAL bit_sample  	: std_logic;
	SIGNAL pre 		: std_logic_vector(6 DOWNTO 0);
	SIGNAL latch_in		: std_logic_vector(3 DOWNTO 0);
	SIGNAL latch_out	: std_logic_vector(3 DOWNTO 0);
	
BEGIN

uut: latch_rx PORT MAP -- ports aan signalen verbinden met port mapping
    (
      	clk    	   	=> clk,
      	clk_en 		=> clk_en,
      	rst    		=> rst,
      	bit_sample 	=> bit_sample,
      	pre 		=> pre,
	latch_in	=> latch_in,
	latch_out	=> latch_out
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

	PROCEDURE tbvector(CONSTANT stimvect : IN std_logic_vector(12 DOWNTO 0))IS -- test vector aanmaken
		BEGIN
		 
		pre <= stimvect(12 DOWNTO 6);
		latch_in <= stimvect(5 DOWNTO 2);
		bit_sample <= stimvect(1);
		rst <= stimvect(0); -- inputs "linken" met de vector
      
			WAIT FOR period;
	END tbvector;
	BEGIN	-- verschillende mogelijke scenario's aflopen

		clk_en <= '1';

		tbvector("0000000000001");
		WAIT FOR period*5;
		tbvector("1111110111100");
		WAIT FOR period*15;
		tbvector("1100110111110");
		WAIT FOR period*15;
		tbvector("1100110111100");
		WAIT FOR period*15;
		tbvector("0111110111100");
		WAIT FOR period*15;
		tbvector("0111110111110");
		WAIT FOR period*15;
      
		end_of_sim <= true;
		WAIT;

	END PROCESS;
END;


