module GreenScreen(
		////////////////////	Clock Input	 	////////////////////	 
		iCLK_28,						//  28.63636 MHz
		iCLK_50,						//	50 MHz
		iCLK_50_2,						//	50 MHz
		iCLK_50_3,						//	50 MHz
		iCLK_50_4,						//	50 MHz
		iEXT_CLOCK,						//	External Clock
		////////////////////	Push Button		////////////////////
		iKEY,							//	Pushbutton[3:0]
		////////////////////	DPDT Switch		////////////////////
		iSW,							//	Toggle Switch[17:0]
		////////////////////	7-SEG Display	////////////////////
		oHEX0_D,						//	Seven Segment Digit 0
		oHEX0_DP,						//  Seven Segment Digit 0 decimal point
		oHEX1_D,						//	Seven Segment Digit 1
		oHEX1_DP,						//  Seven Segment Digit 1 decimal point
		oHEX2_D,						//	Seven Segment Digit 2
		oHEX2_DP,						//  Seven Segment Digit 2 decimal point
		oHEX3_D,						//	Seven Segment Digit 3
		oHEX3_DP,						//  Seven Segment Digit 3 decimal point
		oHEX4_D,						//	Seven Segment Digit 4
		oHEX4_DP,						//  Seven Segment Digit 4 decimal point
		oHEX5_D,						//	Seven Segment Digit 5
		oHEX5_DP,						//  Seven Segment Digit 5 decimal point
		oHEX6_D,						//	Seven Segment Digit 6
		oHEX6_DP,						//  Seven Segment Digit 6 decimal point
		oHEX7_D,						//	Seven Segment Digit 7
		oHEX7_DP,						//  Seven Segment Digit 7 decimal point
		////////////////////////	LED		////////////////////////
		oLEDG,							//	LED Green[8:0]
		oLEDR,							//	LED Red[17:0]		
		////////////////////	I2C		////////////////////////////
		I2C_SDAT,						//	I2C Data
		oI2C_SCLK,						//	I2C Clock
		////////////////////	VGA		////////////////////////////
		oVGA_CLOCK,   					//	VGA Clock
		oVGA_HS,						//	VGA H_SYNC
		oVGA_VS,						//	VGA V_SYNC
		oVGA_BLANK_N,					//	VGA BLANK
		oVGA_SYNC_N,					//	VGA SYNC
		oVGA_R,   						//	VGA Red[9:0]
		oVGA_G,	 						//	VGA Green[9:0]
		oVGA_B,  						//	VGA Blue[9:0]
		////////////////////	GPIO	////////////////////////////
		GPIO_1,							//	GPIO Connection 1 I/O
		GPIO_CLKIN_N1,                  //	GPIO Connection 1 Clock Input 0 pin GPIO Connection 1 PLL Out 
		GPIO_CLKIN_P1,                  //	GPIO Connection 1 Clock Input 1
		GPIO_CLKOUT_N1,                 //	GPIO Connection 1 Clock Output 0
		GPIO_CLKOUT_P1                  //	GPIO Connection 1 Clock Output 1 GPIO Connection 1 PLL Out 
	   
	);

//===========================================================================
// Deklaracje portow
//===========================================================================
////////////////////////	Wejsca zegarowe	 	////////////////////////
	input				iCLK_28;					//  28.63636 MHz
	input				iCLK_50;					//	50 MHz
	input				iCLK_50_2;				//	50 MHz
	input          iCLK_50_3;			//	50 MHz
	input          iCLK_50_4;				//	50 MHz
	input          iEXT_CLOCK;				//	External Clock
	////////////////////////	Push Button		////////////////////////
	input	[3:0]		iKEY;					//	Pushbutton[3:0]
	////////////////////////	DPDT Switch		////////////////////////
	input	[17:0]	iSW;					//	Toggle Switch[17:0]
	////////////////////////	7-SEG Dispaly	////////////////////////
	output	[6:0]	oHEX0_D;				//	Seven Segment Digit 0
	output			oHEX0_DP;				//  Seven Segment Digit 0 decimal point
	output	[6:0]	oHEX1_D;				//	Seven Segment Digit 1
	output			oHEX1_DP;				//  Seven Segment Digit 1 decimal point
	output	[6:0]	oHEX2_D;				//	Seven Segment Digit 2
	output			oHEX2_DP;				//  Seven Segment Digit 2 decimal point
	output	[6:0]	oHEX3_D;				//	Seven Segment Digit 3
	output			oHEX3_DP;				//  Seven Segment Digit 3 decimal point
	output	[6:0]	oHEX4_D;				//	Seven Segment Digit 4
	output			oHEX4_DP;				//  Seven Segment Digit 4 decimal point
	output	[6:0]	oHEX5_D;				//	Seven Segment Digit 5
	output			oHEX5_DP;				//  Seven Segment Digit 5 decimal point
	output	[6:0]	oHEX6_D;				//	Seven Segment Digit 6
	output			oHEX6_DP;				//  Seven Segment Digit 6 decimal point
	output	[6:0]	oHEX7_D;				//	Seven Segment Digit 7
	output			oHEX7_DP;				//  Seven Segment Digit 7 decimal point
	////////////////////////////	LED		////////////////////////////
	output	[8:0]	oLEDG;					//	LED Green[8:0]
	output	[17:0]	oLEDR;					//	LED Red[17:0]		
	////////////////////////	I2C		////////////////////////////////
	inout				I2C_SDAT;				//	I2C Data
	output			oI2C_SCLK;				//	I2C Clock
	////////////////////////	VGA			////////////////////////////
	output			oVGA_CLOCK;   			//	VGA Clock
	output			oVGA_HS;				//	VGA H_SYNC
	output			oVGA_VS;				//	VGA V_SYNC
	output			oVGA_BLANK_N;			//	VGA BLANK
	output			oVGA_SYNC_N;			//	VGA SYNC
	output	[9:0]	oVGA_R;   				//	VGA Red[9:0]
	output	[9:0]	oVGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	oVGA_B;   				//	VGA Blue[9:0]
	////////////////////////	GPIO	////////////////////////////////
	inout		[31:0]	GPIO_1;					//	GPIO Connection 1 I/O
	input			GPIO_CLKIN_N1;          //	GPIO Connection 1 Clock Input 0 GPIO Connection 1 PLL In
	input			GPIO_CLKIN_P1;          //	GPIO Connection 1 Clock Input 1 GPIO Connection 1 PLL In // unused
	inout			GPIO_CLKOUT_N1;         //	GPIO Connection 1 Clock Output 0 GPIO Connection 1 PLL Out 
	inout			GPIO_CLKOUT_P1;         //	GPIO Connection 1 Clock Output 1 GPIO Connection 1 PLL Out // unused 
///////////////////////////////////////////////////////////////////
//=============================================================================
// Deklaracje REG/WIRE
//=============================================================================

	//	CCD
	wire	[11:0]	CCD_DATA;
	wire			CCD_SDAT;
	wire			CCD_SCLK;
	wire			CCD_FLASH;
	wire			CCD_FVAL;
	wire			CCD_LVAL;
	wire			CCD_PIXCLK;
	wire			CCD_MCLK;				//	CCD Master Clock

	wire	[15:0]	Read_DATA1;
	wire	[15:0]	Read_DATA2;
	wire				VGA_CTRL_CLK;
	wire	[11:0]	mCCD_DATA;
	wire				mCCD_DVAL;
	wire				mCCD_DVAL_d;
	wire	[15:0]	X_Cont;
	wire	[15:0]	Y_Cont;
	wire	[9:0]		X_ADDR;
	wire	[31:0]	Frame_Cont;
	wire				DLY_RST_0;
	wire				DLY_RST_1;
	wire				DLY_RST_2;
	wire				Read;
	reg	[11:0]	rCCD_DATA;
	reg				rCCD_LVAL;
	reg				rCCD_FVAL;
	wire	[11:0]	sCCD_R;
	wire	[11:0]	sCCD_G;
	wire	[11:0]	sCCD_B;
	wire				sCCD_DVAL;
	wire	[9:0]		oVGA_R;
	wire	[9:0]		oVGA_G;
	wire	[9:0]		oVGA_B;
	reg	[1:0]		rClk;
	wire				sdram_ctrl_clk;
	
	
/* LOGIC */

	assign	CCD_DATA[0]	=	GPIO_1[11]; // Pin 16
	assign	CCD_DATA[1]	=	GPIO_1[10]; // Pin 15
	assign	CCD_DATA[2]	=	GPIO_1[9]; // Pin 14
	assign	CCD_DATA[3]	=	GPIO_1[8]; // Pin 13
	assign	CCD_DATA[4]	=	GPIO_1[7]; // Pin 10
	assign	CCD_DATA[5]	=	GPIO_1[6]; // Pin 9
	assign	CCD_DATA[6]	=	GPIO_1[5]; // Pin 8
	assign	CCD_DATA[7]	=	GPIO_1[4]; // Pin 7
	assign	CCD_DATA[8]	=	GPIO_1[3]; // Pin 6
	assign	CCD_DATA[9]	=	GPIO_1[2]; // Pin 5
	assign	CCD_DATA[10]=	GPIO_1[1]; // Pin 4
	assign	CCD_DATA[11]=	GPIO_1[0]; // Pin 2

	assign	GPIO_CLKOUT_N1	=	CCD_MCLK; // GPIO Connection 1 PLL Out // unused for now :)
	assign 	CCD_MCLK =	VGA_CTRL_CLK;
	assign	CCD_FVAL	=	GPIO_1[18]; // GPIO Connection 1 IO[31]
	assign	CCD_LVAL	=	GPIO_1[17];
	assign	CCD_PIXCLK	=	GPIO_CLKIN_N1; // GPIO Connection 1 PLL In

	assign	GPIO_1[15]	=	1'b1;  // TRIGGER Pin 22

	assign	GPIO_1[14]	=	DLY_RST_1; // Pin 20 RESET_N

	assign	oLEDR		=	iSW;

	assign	oVGA_CLOCK	=	~VGA_CTRL_CLK;

	always@(posedge iCLK_50)	rClk	<=	rClk+1;


	always@(posedge VGA_CTRL_CLK)
	begin
		rCCD_DATA	<=	CCD_DATA;
		rCCD_LVAL	<=	CCD_LVAL;
		rCCD_FVAL	<=	CCD_FVAL;
	end
	
	assign Read_DATA2[9:0] = sCCD_R;
	assign {Read_DATA1[14:10],Read_DATA2[14:10]} = sCCD_G;
	assign Read_DATA1[9:0] = sCCD_B;

/* VGA Module */ 


vga_controller	vga	(	//	Host Side
					.outRequest(Read),
					.inRed(Read_DATA2[9:0]),
					.inGreen({Read_DATA1[14:10],Read_DATA2[14:10]}),
					.inBlue(Read_DATA1[9:0]),
					//	VGA Side
					.outVGA_R(oVGA_R),
					.outVGA_G(oVGA_G),
					.outVGA_B(oVGA_B),
					.outVGA_H_SYNC(oVGA_HS),
					.outVGA_V_SYNC(oVGA_VS),
					.outVGA_SYNC(oVGA_SYNC_N),
					.outVGA_BLANK(oVGA_BLANK_N),
					//	Control Signal
					.iCLK(VGA_CTRL_CLK),
					.iRST_N(DLY_RST_2)
);	

						
/* VGA Phase locked loop Module */ 
		
					
vga_pll   phase_loop	(
				.areset(!DLY_RST_0),
				.inclk0(iCLK_50),
				.c0(VGA_CTRL_CLK)
);


/* Reset delay */ 

ResetDelay		reset_delayer	(	.iCLK(iCLK_50),
							.iRST(iKEY[0]),
							.oRST_0(DLY_RST_0),
							.oRST_1(DLY_RST_1),
							.oRST_2(DLY_RST_2)
);

/* Image conversion */ 

RAWToRGB		image_conversion	(	.iCLK(VGA_CTRL_CLK),
					.iRST_n(DLY_RST_1),
					.iData(mCCD_DATA),
					.iDataValid(mCCD_DVAL),
					.oRed(sCCD_R),
					.oGreen(sCCD_G),
					.oBlue(sCCD_B),
					.oDataValid(sCCD_DVAL),
					.iZoom(iSW[17:16]),
					.iX_Counter(X_Cont),
					.iY_Counter(Y_Cont)
);


assign oLEDG[7] = rCCD_FVAL;

assign oLEDG[6] = rCCD_LVAL;

assign oLEDG[5] = CCD_PIXCLK;
// Zebysmy wiedzieli ktory reset
assign oLEDG[3] = iKEY[0];
assign oLEDG[2] = DLY_RST_2;
assign oLEDG[1] = DLY_RST_1;
assign oLEDG[0] = DLY_RST_0;

assign oLEDG[4] = rCCD_FVAL;


/* */
CCD_Capture		camera_capture	(	.oDATA(mCCD_DATA),
							.oDataValid(mCCD_DVAL),
							.oX_Counter(X_Cont),
							.oY_Counter(Y_Cont),
							.oFrame_Counter(Frame_Cont),
							.iDATA(rCCD_DATA),
							.inputFrameValid(rCCD_FVAL),
							.inputLineValid(rCCD_LVAL),
							.iCLK(VGA_CTRL_CLK),
							.iRST(DLY_RST_2)
						);		

/*
						

/* */						
/*				
I2C_CCD_Config 		i2c_Config	(	//	Host Side
							.iCLK(iCLK_50),
							.iRST_N(DLY_RST_2),
							.iZOOM_MODE_SW(iSW[16]),
							.iEXPOSURE_ADJ(iKEY[1]),
							.iEXPOSURE_DEC_p(iSW[0]),
							//	I2C Side
							.I2C_SCLK(GPIO_1[20]),
							.I2C_SDAT(GPIO_1[19])
						);
*/					
/* Module for displaying information about color captured by camera*/
						
SEG7_DISPLAY 			segment_display	(	.oSEG0(oHEX0_D),.oSEG1(oHEX1_D),
							.oSEG2(oHEX2_D),.oSEG3(oHEX3_D),
							.oSEG4(oHEX4_D),.oSEG5(oHEX5_D),
							.oSEG6(oHEX6_D),.oSEG7(oHEX7_D),
							.iDIG(Frame_Cont)
						);


endmodule
