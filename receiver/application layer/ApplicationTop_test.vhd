-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY apptop_rx_test IS
END apptop_rx_test;

ARCHITECTURE structural of apptop_rx_test is

COMPONENT apptop_rx
  PORT 
  (
	clk       	: IN std_logic;
	clk_en    	: IN std_logic;
	rst       	: IN std_logic;
	bit_sample	: IN std_logic;
	pre_in	  	: IN std_logic_vector(6 DOWNTO 0);
	latch_in  	: IN std_logic_vector(3 DOWNTO 0);
	seg_display	: OUT std_logic_vector(6 DOWNTO 0)
  );
END COMPONENT;

FOR uut : apptop_rx USE ENTITY work.apptop_rx(behavior); -- signalen aanmaken die overeenkomen met de poorten
  
	CONSTANT period   : TIME := 100 ns;
	CONSTANT delay    : TIME := 10 ns;
	SIGNAL end_of_sim : BOOLEAN := false;
	
	SIGNAL clk        : std_logic;
	SIGNAL clk_en     : std_logic;
	SIGNAL rst        : std_logic;
	SIGNAL bit_sample : std_logic;
	SIGNAL pre_in     : std_logic_vector(6 DOWNTO 0);
	SIGNAL latch_in   : std_logic_vector(3 DOWNTO 0);
	SIGNAL seg_display: std_logic_vector(6 DOWNTO 0);

	SIGNAL int_latch_out:std_logic_vector(3 DOWNTO 0);
	
BEGIN

uut: apptop_rx PORT MAP -- ports aan signalen verbinden met port mapping
    (
      	clk    		=> clk,
      	clk_en 		=> clk_en,
      	rst    		=> rst,
      	bit_sample      => bit_sample,
      	pre_in   	=> pre_in,
      	latch_in   	=> latch_in,
      	seg_display    	=> seg_display
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

	PROCEDURE tbvector(CONSTANT stimvect : IN std_logic_vector(12 DOWNTO 0))IS -- test vector aanmaken
		BEGIN
		 
		pre_in <= stimvect(12 DOWNTO 6);
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