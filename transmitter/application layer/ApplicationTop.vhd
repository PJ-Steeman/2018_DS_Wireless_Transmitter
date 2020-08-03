-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY apptop is
  PORT 
  (
		clk     	: IN std_logic;							-- clock signaal
		clk_en  	: IN std_logic;							-- clock enable om clock frequentie te verlagen
		rst     	: IN std_logic;							-- reset
		up        	: IN std_logic;       					-- up
		down      	: IN std_logic;       					-- down
		data      	: OUT std_logic_vector(3 DOWNTO 0);  	-- de uitgang van de counter
		seg       	: OUT std_logic_vector(6 DOWNTO 0)   	-- de aansturing voor de 7seg display
  );
END apptop;

ARCHITECTURE behavior OF apptop IS
        
COMPONENT segdec			-- aanmaken van de definitie van een segdec (voor betekenis signalen zie segdec.vhd)
PORT
  (
    ingang     : IN std_logic_vector(3 DOWNTO 0);
    uitgang_b  : OUT std_logic_vector(6 DOWNTO 0)
  );
END COMPONENT;

COMPONENT debouncer			-- aanmaken van de definitie van een debouncer (voor betekenis signalen zie debouncer.vhd)
PORT
	(
		clk     : IN std_logic;	
		clk_en  : IN std_logic;	
		rst     : IN std_logic;	
		cha    	: IN std_logic; 
		syncha 	: OUT std_logic 
	);
END COMPONENT;

COMPONENT edgedetector		-- aanmaken van de definitie van een edgedetector (voor betekenis signalen zie edgedetector.vhd)
  PORT
	(
		clk     : IN std_logic;	
		clk_en  : IN std_logic;	
		rst     : IN std_logic;	
		ingang  : IN std_logic; 	
		uitgang : OUT std_logic  	
	);
END COMPONENT;

COMPONENT udcounter 		-- aanmaken van de definitie van een udcounter (voor betekenis signalen zie udcounter.vhd)
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

SIGNAL int_data : std_logic_vector(3 DOWNTO 0);			-- interne signalen van de application layer
SIGNAL int_deb_up, int_deb_down, int_edge_up, int_edge_down : std_logic;

BEGIN
    
data <= int_data; 

debouncer_up : debouncer	-- de benodigde componenten aanmaken en via port mapping de juiste signalen eraan verbinden
PORT MAP(
    clk => clk,
	clk_en => clk_en,
	rst => rst,
	cha => up,
	syncha => int_deb_up
);

debouncer_down : debouncer
PORT MAP(
    clk => clk,
	clk_en => clk_en,
	rst => rst,
	cha => down,
	syncha => int_deb_down
);

edge_up : edgedetector
PORT MAP(
    clk => clk,
	clk_en => clk_en,
	rst => rst,
	ingang => int_deb_up,
	uitgang => int_edge_up
);

edge_down : edgedetector
PORT MAP(
    clk => clk,
	clk_en => clk_en,
	rst => rst,
	ingang => int_deb_down,
	uitgang => int_edge_down
);

counter : udcounter
PORT MAP(
    clk => clk,
	clk_en => clk_en,
	rst => rst,
	plus	=> int_edge_up,
	min	=> int_edge_down,
	uitgang => int_data
);	   

segmentdec : segdec
PORT MAP(
    ingang => int_data,
    uitgang_b => seg
); 

END behavior;