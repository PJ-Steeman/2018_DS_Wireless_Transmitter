-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY dpll_rx_test IS
END dpll_rx_test;

ARCHITECTURE structural OF dpll_rx_test IS

COMPONENT dpll_rx  -- component declaratie
	PORT
	(
		  clk          : IN  std_logic;
		  clk_en       : IN  std_logic;
		  rst          : IN  std_logic;
		  sdi_spread   : IN  std_logic;
		  chip_sample  : OUT std_logic;
		  chip_sample1 : OUT std_logic;
		  chip_sample2 : OUT std_logic;
		  extb_out     : OUT std_logic
	);
END COMPONENT;

FOR uut : dpll_rx USE ENTITY work.dpll_rx(behavior); -- signalen aanmaken die overeenkomen met de poorten
  
	CONSTANT period   	: TIME := 100 ns;
	CONSTANT delay    	: TIME := 10 ns;
	SIGNAL end_of_sim 	: BOOLEAN := false;
	
	SIGNAL clk        	: std_logic;
	SIGNAL clk_en     	: std_logic;
	SIGNAL rst        	: std_logic;
	SIGNAL sdi_spread  : std_logic;
	SIGNAL chip_sample : std_logic;
	SIGNAL chip_sample1: std_logic;
	SIGNAL chip_sample2: std_logic;
	SIGNAL extb_out    : std_logic;
	
BEGIN

uut: dpll_rx PORT MAP -- ports aan signalen verbinden met port mapping
    (
      	clk    	   	=> clk,
      	clk_en 		   => clk_en,
      	rst    		   => rst,
      	sdi_spread 	=> sdi_spread,
      	chip_sample => chip_sample,
		   chip_sample1=> chip_sample1,
		   chip_sample2=> chip_sample2,
		   extb_out    => extb_out
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

	PROCEDURE tbvector(CONSTANT stimvect : IN std_logic_vector(1 DOWNTO 0))IS -- test vector aanmaken
		BEGIN
		  sdi_spread <= stimvect(1);
			rst <= stimvect(0); -- inputs "linken" met de vector
      
			WAIT FOR period;
	END tbvector;
	BEGIN	-- verschillende mogelijke scenario's aflopen

		clk_en <= '1';
		tbvector("01");
		WAIT FOR period*5;
		tbvector("10");
		WAIT FOR period*15;
		tbvector("00");
		WAIT FOR period*15;
		tbvector("10");
		WAIT FOR period*15;
		tbvector("00");
		WAIT FOR period*15;
		tbvector("10");
		WAIT FOR period*15;
		tbvector("00");
		WAIT FOR period*15;
		tbvector("10");
		WAIT FOR period*15;
		tbvector("00");
		WAIT FOR period*15;
		tbvector("10");
		WAIT FOR period*15;
		tbvector("10");
		WAIT FOR period*15;
      
		end_of_sim <= true;
		WAIT;

	END PROCESS;
END;


