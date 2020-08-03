-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY acctop_test IS
END acctop_test;

ARCHITECTURE structural of acctop_test is

COMPONENT acctop
   PORT 
    (
		clk     	: IN std_logic;	
		clk_en  	: IN std_logic;	
		rst     	: IN std_logic;	
		dip1      	: IN std_logic;       
		dip2      	: IN std_logic;      
		sdo_posenc	: IN std_logic;
		pn_start  	: OUT std_logic; 
		sdo_spread	: OUT std_logic
  );
END COMPONENT;

FOR uut : acctop USE ENTITY work.acctop(behavior); -- signalen aanmaken die overeenkomen met de poorten
  
	CONSTANT period   : TIME := 100 ns;
	CONSTANT delay    : TIME := 10 ns;
	SIGNAL end_of_sim : BOOLEAN := false;
	
	SIGNAL clk        : std_logic;
	SIGNAL clk_en     : std_logic;
	SIGNAL rst        : std_logic;
	SIGNAL dip1       : std_logic;       
	SIGNAL dip2       : std_logic;      
	SIGNAL	sdo_posenc : std_logic;
	SIGNAL	pn_start   : std_logic; 
	SIGNAL sdo_spread : std_logic;
  
	SIGNAL int_pn_ml1, int_pn_ml2, int_pn_gold, int_sdo_posenc, int_pn_start : std_logic; 
	SIGNAL int_sdo_spread, xor1, xor2, xor3 : std_logic;

	
BEGIN

uut: acctop PORT MAP -- ports aan signalen verbinden met port mapping
    (
      	clk    => clk,
      	clk_en => clk_en,
      	rst    => rst,
		dip1   => dip1,       
	    dip2   => dip2,     
	    sdo_posenc => sdo_posenc,
	    pn_start => pn_start,
		sdo_spread => sdo_spread
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

	PROCEDURE tbvector(CONSTANT stimvect : IN std_logic_vector(3 DOWNTO 0))IS -- test vector aanmaken
		BEGIN
			sdo_posenc <= stimvect(3);
			dip1 <= stimvect(2);    -- inputs "linken" met de vector
			dip2 <= stimvect(1); 
			rst <= stimvect(0);
      
			WAIT FOR period;
	END tbvector;
	BEGIN	-- verschillende mogelijke scenario's aflopen
		clk_en <= '1';

		tbvector("0001"); -- reset voor initialisatie
		WAIT FOR period;
		tbvector("0010");
		WAIT FOR period*50;
		tbvector("0100");
		WAIT FOR period*50;
		tbvector("1110");
		WAIT FOR period*50;
		
		end_of_sim <= true;
		WAIT;

	END PROCESS;
END;