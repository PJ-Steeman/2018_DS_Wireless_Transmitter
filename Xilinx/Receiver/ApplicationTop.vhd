--Pieter-Jan Steeman

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY apptop_rx IS
	PORT
	(
		clk        	: IN std_logic;
		clk_en     	: IN std_logic;
		rst        	: IN std_logic;
		bit_sample	: IN std_logic;
		pre_in	  	: IN std_logic_vector(6 DOWNTO 0);
		latch_in  	: IN std_logic_vector(3 DOWNTO 0);
		seg_display	: OUT std_logic_vector(6 DOWNTO 0)
	);
END apptop_rx;

ARCHITECTURE behavior OF apptop_rx IS

SIGNAL int_latch_out     : std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');

COMPONENT latch_rx
PORT
(
	clk        	: IN std_logic;
	clk_en     	: IN std_logic;
	rst        	: IN std_logic;
	bit_sample : IN  std_logic;
	pre	   : IN  std_logic_vector(6 DOWNTO 0);
	latch_in   : IN  std_logic_vector(3 DOWNTO 0); 
	latch_out  : OUT std_logic_vector(3 DOWNTO 0) 
);
END COMPONENT;

COMPONENT segdec_rx
PORT
(
	ingang    : IN std_logic_vector(3 DOWNTO 0);
	uitgang_b : OUT std_logic_vector(6 DOWNTO 0)
);
END COMPONENT;

BEGIN

datalatch_rx : latch_rx
PORT MAP
(
	clk => clk,
	clk_en => clk_en,
	rst => rst,
	bit_sample  => bit_sample,
	pre   		=> pre_in,
	latch_in  	=> latch_in,
	latch_out  	=> int_latch_out
);
decoder_rx : segdec_rx
PORT MAP
(
	ingang    => int_latch_out,
	uitgang_b => seg_display
);
END behavior;
