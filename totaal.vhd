-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY totaal is
  PORT 
  (
		clk     	   	: IN std_logic;							-- clock signaal
		rst     	   	: IN std_logic;							-- reset
		up_knop      : IN std_logic;       -- up
	  down_knop    : IN std_logic;  -- de uitgang van de counter
		dip		       	: IN std_logic_vector(1 DOWNTO 0);
		disp_trans   : OUT std_logic_vector(6 DOWNTO 0);
   	disp_rec     : OUT std_logic_vector(6 DOWNTO 0) -- de aansturing voor de 7seg display
  );
END totaal;

ARCHITECTURE behavior OF totaal IS
    
    -- aanmaken van componenten om later op te roepen
    
COMPONENT transmitterTop is
  PORT 
  (
    	clk     	   : IN std_logic;							-- clock signaal
	   rst     	   : IN std_logic;							-- reset
	   up_knop     : IN std_logic;       -- up
	   down_knop   : IN std_logic;  -- de uitgang van de counter
	   dip		       : IN std_logic_vector(1 DOWNTO 0);
    	dec_uit     : OUT std_logic_vector(6 DOWNTO 0); -- de aansturing voor de 7seg display
	   sdo_spread	 : OUT std_logic
	);
END COMPONENT;

COMPONENT receiverTop_rx is
  PORT 
  (
		clk     	   	: IN std_logic;							-- clock signaal
		rst     	   	: IN std_logic;							-- reset
		sdo_spread  	: IN std_logic;       -- up
		dip		       	: IN std_logic_vector(1 DOWNTO 0);
   	display_b    : OUT std_logic_vector(6 DOWNTO 0) -- de aansturing voor de 7seg display
  );
END COMPONENT;

SIGNAL sdo_spread : std_logic;

BEGIN
    -- de benodigde componenten oproepen en van port mapping de juiste signalen eraan verbinden

trans_int : transmitterTop
PORT MAP(
		clk       	 => clk,
		rst       	 => rst,
		up_knop	    => up_knop,
		down_knop	  => down_knop,
		dip  	      => dip,
		dec_uit	    => disp_trans,
		sdo_spread  => sdo_spread
	);

rec_int : receiverTop_rx
PORT MAP(
		clk        	=> clk,
		rst        	=> rst,
		sdo_spread  => sdo_spread,
		dip 	       => dip,
		display_b	  => disp_rec
	);
END behavior;