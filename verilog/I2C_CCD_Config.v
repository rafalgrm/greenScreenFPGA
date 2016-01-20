module I2C_CCD_Config (	
	// Host Side
	iCLK,
	iRST_N,
	// I2C Side
	I2C_SCLK,
	I2C_SDAT
);
						
//	Host Side
input			iCLK;
input			iRST_N;

//	I2C Side
output			I2C_SCLK;

inout			I2C_SDAT;

//	Wewnętrzne rejestry / przewody

reg	[15:0]	masterI2C_CLK_DIV;
reg	[31:0]	masterI2C_DATA;
reg			masterI2C_CTRL_CLK;
reg			masterI2C_GO;
wire		masterI2C_END;
wire		masterI2C_ACK;
reg	[23:0]	DATA_DATA;
reg	[5:0]	DATA_INDEX;
reg	[3:0]	masterSetup_ST;


//   Ustawienia matrycy

reg	[15:0]	sensor_exposure;

wire [23:0] sensor_start_row;
wire [23:0] sensor_start_column;
wire [23:0] sensor_row_size;
wire [23:0] sensor_column_size; 
wire [23:0] sensor_row_mode;
wire [23:0] sensor_column_mode;

assign sensor_start_row 		= 24'h010036; // 24'h010000;
assign sensor_start_column 		= 24'h020010; // 24'h020000;
assign sensor_row_size	 		= 24'h030280; // 24'h0301E0; //  0797
assign sensor_column_size 		= 24'h0401E0; // 24'h040280; //  0x0A1F
assign sensor_row_mode 			= 24'h22001A; // 24'h22001A;
assign sensor_column_mode		= 24'h23001A; // 24'h23001A;

// 256x192
// 20x20
						
wire	i2c_reset;		

assign 	i2c_reset = iRST_N;

// Configuration constants

//	Clock Setting
parameter	CLK_Freq	=	50000000;	//	50	MHz
parameter	I2C_Freq	=	20000;		//	20	KHz
//	DATA Number
parameter	DATA_SIZE	=	26;


// Deklaracja modułu I2C_Controller

I2C_Controller 	u0	(	.iCLK(masterI2C_CTRL_CLK),	
						.I2C_SCLK(I2C_SCLK),		
 	 	 	 	 	 	.I2C_SDAT(I2C_SDAT),		
						.I2C_DATA(masterI2C_DATA),		
						.GO(masterI2C_GO),      			
						.END(masterI2C_END),				
						.ACK(masterI2C_ACK),
						.RESET(i2c_reset)
					);
					

// Stworzenie zegara dla interfejsu I2C

always@(posedge iCLK or negedge i2c_reset)
begin
	if(!i2c_reset)
	begin
		masterI2C_CTRL_CLK	<=	0;
		masterI2C_CLK_DIV	<=	0;
	end
	else
	begin
		if( masterI2C_CLK_DIV < (CLK_Freq / I2C_Freq) )
			masterI2C_CLK_DIV <=	masterI2C_CLK_DIV + 1;
		else
		begin
			masterI2C_CLK_DIV	<=	0;
			masterI2C_CTRL_CLK	<=	~masterI2C_CTRL_CLK;
		end
	end
end

				
				
//	Kontrola 
always@(posedge masterI2C_CTRL_CLK or negedge i2c_reset)
begin
	if(!i2c_reset)
	begin
		DATA_INDEX	<=	0;
		masterSetup_ST	<=	0;
		masterI2C_GO		<=	0;
	end

	else if(DATA_INDEX < DATA_SIZE)
		begin
			case(masterSetup_ST)
			0:	begin
					masterI2C_DATA	<=	{8'hBA,DATA_DATA};
					masterI2C_GO		<=	1;
					masterSetup_ST	<=	1;
				end
			1:	begin
					if(masterI2C_END)
					begin
						if(!masterI2C_ACK)
						masterSetup_ST	<=	2;
						else
						masterSetup_ST	<=	0;							
						masterI2C_GO		<=	0;
					end
				end
			2:	begin
					DATA_INDEX	<=	DATA_INDEX+1;
					masterSetup_ST	<=	0;
				end
			endcase
		end
end

//	Config Data		
always
begin
	case(DATA_INDEX)
	0	:	DATA_DATA	<=	24'h000000;
	1	:	DATA_DATA	<=	24'h200000;				//	Mirror Row and Columns
	2	:	DATA_DATA	<=	24'h090100;				//	Exposure // {8'h09,sensor_exposure}
	3	:	DATA_DATA	<=	24'h0500A0;				//	H_Blanking
	4	:	DATA_DATA	<=	24'h06002D;				//	V_Blanking	
	5	:	DATA_DATA	<=	24'h0A0000;				//	change latch
	6	:	DATA_DATA	<=	24'h2B000b;				//	Green 1 Gain
	7	:	DATA_DATA	<=	24'h2C000f;				//	Blue Gain
	8	:	DATA_DATA	<=	24'h2D000f;				//	Red Gain
	9	:	DATA_DATA	<=	24'h2E000b;				//	Green 2 Gain
	10	:	DATA_DATA	<=	24'h100000;				//	set up PLL power on
	11	:	DATA_DATA	<=	24'h100000;				//	PLL_m_Factor<<8+PLL_n_Divider	
	12	:	DATA_DATA	<=	24'h120000;				//	PLL_p1_Divider	
	13	:	DATA_DATA	<=	24'h100000;				//	set USE PLL	 
	14	:	DATA_DATA	<=	24'h980000;				//	disable calibration 	
	18	:	DATA_DATA	<=	sensor_start_row 	;	//	set start row	
	19	:	DATA_DATA	<=	sensor_start_column ;	//	set start column 	

	20	:	DATA_DATA	<=	sensor_row_size;		//	set row size to 	
	21	:	DATA_DATA	<=	sensor_column_size;		//	set column size to 2047
	22	:	DATA_DATA	<=	sensor_row_mode;		//	set row mode in bin mode
	23	:	DATA_DATA	<=	sensor_column_mode;		//	set column mode in bin mode
	24	:	DATA_DATA	<=	24'h4901A8;				//	row black target		
	25	:	DATA_DATA	<=	24'h1E0000;				//	read mode
	default:DATA_DATA	<=	24'h000000;
	endcase
end

endmodule