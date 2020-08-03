-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY apptop_test IS
END apptop_test;

ARCHITECTURE structural of apptop_test is

COMPONENT apptop
  PORT 
  (
    clk     	: IN std_logic;
	clk_en  	: IN std_logic;
	rst     	: IN std_logic;
	up        	: IN std_logic;    
	down      	: IN std_logic;
	data      	: OUT std_logic_vector(3 DOWNTO 0);
    seg       	: OUT std_logic_vector(6 DOWNTO 0) 
  );
END COMPONENT;

FOR uut : apptop USE ENTITY work.apptop(behavior); -- signalen aanmaken die overeenkomen met de poorten
  
	CONSTANT period   : TIME := 100 ns;
	CONSTANT delay    : TIME := 10 ns;
	SIGNAL end_of_sim : BOOLEAN := false;
	
	SIGNAL clk        : std_logic;
	SIGNAL clk_en     : std_logic;
	SIGNAL rst        : std_logic;
	SIGNAL up         : std_logic;
	SIGNAL down       : std_logic;
	SIGNAL data       : std_logic_vector(3 DOWNTO 0);
	SIGNAL seg        : std_logic_vector(6 DOWNTO 0);
  
	SIGNAL int_data : std_logic_vector(3 DOWNTO 0);
	SIGNAL int_deb_up, int_deb_down, int_edge_up, int_edge_down : std_logic;
	
BEGIN

uut: apptop PORT MAP -- ports aan signalen verbinden met port mapping
    (
      	clk    => clk,
      	clk_en => clk_en,
      	rst    => rst,
      	up     => up,
      	down   => down,
      	data   => data,
      	seg    => seg
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
		  up <= stimvect(2);    -- inputs "linken" met de vector
			down <= stimvect(1); 
			rst <= stimvect(0);
      
			WAIT FOR period;
	END tbvector;
	BEGIN	-- verschillende mogelijke scenario's aflopen
clk_en <= '1';

		tbvector("001"); -- reset voor initialisatie
		WAIT FOR period;
		tbvector("100");
		tbvector("000");
		tbvector("100");
		tbvector("000");
		tbvector("100");
		WAIT FOR period*50;
		tbvector("000");
		WAIT FOR period*50;
		tbvector("110");
		WAIT FOR period*50;
		tbvector("100");
		WAIT FOR period*50;
		tbvector("100");
		WAIT FOR period*50;
		tbvector("000");
		WAIT FOR period*50;
		tbvector("100");
		WAIT FOR period*50;
		tbvector("100");
		tbvector("010");
		tbvector("100");
		tbvector("010");
		tbvector("100");
		tbvector("010");
		tbvector("100");
		tbvector("010");
		tbvector("100");
		tbvector("010");
		tbvector("100");
		WAIT FOR period*50;
		tbvector("000");
		WAIT FOR period*50;
		tbvector("100");
		WAIT FOR period*20;
		tbvector("000");
		tbvector("010");
		tbvector("000");
		tbvector("010");
		WAIT FOR period*50;
		tbvector("000");
		WAIT FOR period*50;
		tbvector("010");
		WAIT FOR period*50;
		tbvector("001"); 
		WAIT FOR period;
		tbvector("010");
		WAIT FOR period*50;
		tbvector("000");
		WAIT FOR period*50;
		tbvector("000");
		WAIT FOR period*50;
		tbvector("010");
		WAIT FOR period*50;
		tbvector("000");
		WAIT FOR period*50;
		tbvector("010");
		WAIT FOR period*50;
		tbvector("000");
		WAIT FOR period*50;
		tbvector("010");
		WAIT FOR period*50;
      
		end_of_sim <= true;
		WAIT;

	END PROCESS;
END;