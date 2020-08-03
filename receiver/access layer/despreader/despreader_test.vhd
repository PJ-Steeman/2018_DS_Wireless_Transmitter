-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY despreader_rx_test IS
END despreader_rx_test;

ARCHITECTURE structural OF despreader_rx_test IS

COMPONENT despreader_rx  -- component declaratie
	PORT
	(
		clk          : IN  std_logic;
		clk_en       : IN  std_logic;
		rst          : IN  std_logic;
		sdi_spread   : IN  std_logic;
		pn_seq      : IN  std_logic;
		chip_sample2   : IN  std_logic;
		sdi_despread : OUT std_logic
	);
END COMPONENT;

FOR uut : despreader_rx USE ENTITY work.despreader_rx(behavior); -- signalen aanmaken die overeenkomen met de poorten
  
	CONSTANT period   	: TIME := 100 ns;
	CONSTANT delay    	: TIME := 10 ns;
	SIGNAL end_of_sim 	: BOOLEAN := false;
	
	SIGNAL clk        	: std_logic;
	SIGNAL clk_en     	: std_logic;
	SIGNAL rst        	: std_logic;
	SIGNAL sdi_spread  	: std_logic;
	SIGNAL pn_seq 		: std_logic;
	SIGNAL chip_sample2		: std_logic;
	SIGNAL sdi_despread	: std_logic;
	
BEGIN

uut: despreader_rx PORT MAP -- ports aan signalen verbinden met port mapping
    (
      	clk    	   	=> clk,
      	clk_en 		=> clk_en,
      	rst    		=> rst,
      	sdi_spread 	=> sdi_spread,
      	pn_seq 		=> pn_seq,
	     chip_sample2	=> chip_sample2,
	     sdi_despread	=> sdi_despread
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

	PROCEDURE tbvector(CONSTANT stimvect : IN std_logic_vector(3 DOWNTO 0))IS -- test vector aanmaken
		BEGIN
		 
		sdi_spread <= stimvect(3);
		pn_seq <= stimvect(2);
		chip_sample2 <= stimvect(1);
		rst <= stimvect(0); -- inputs "linken" met de vector
      
			WAIT FOR period;
	END tbvector;
	BEGIN	-- verschillende mogelijke scenario's aflopen

		clk_en <= '1';

		tbvector("0001");
		WAIT FOR period*5;
		tbvector("1000");
		WAIT FOR period*15;
		tbvector("1100");
		WAIT FOR period*15;
		tbvector("1110");
		tbvector("1100");
		WAIT FOR period*15;
		tbvector("0110");
		tbvector("0100");
		WAIT FOR period*15;
      
		end_of_sim <= true;
		WAIT;

	END PROCESS;
END;