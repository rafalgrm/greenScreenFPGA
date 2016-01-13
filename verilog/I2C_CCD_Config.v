module I2C_CCD_Config (	//	Host Side
						iCLK,
						iRST_N,
						//	I2C Side
						I2C_SCLK,
						I2C_SDAT
						);
						
//	Host Side
input			iCLK;
input			iRST_N;

//	I2C Side
output		I2C_SCLK;

inout			I2C_SDAT;

//	Internal Registers/Wires
reg	[15:0]	mI2C_CLK_DIV;
reg	[31:0]	mI2C_DATA;
reg				mI2C_CTRL_CLK;
reg				mI2C_GO;
wire				mI2C_END;
wire				mI2C_ACK;
reg	[23:0]	LUT_DATA;
reg	[5:0]	LUT_INDEX;
reg	[3:0]	mSetup_ST;


//////////////   CMOS sensor registers setting //////////////////////

reg	[24:0]	combo_cnt;
wire			combo_pulse;

reg	[1:0]	izoom_mode_sw_delay;

reg	[3:0]	iexposure_adj_delay;
wire			exposure_adj_set;	
wire			exposure_adj_reset;
reg	[15:0]	sensor_exposure;


wire [23:0] sensor_start_row;
wire [23:0] sensor_start_column;
wire [23:0] sensor_row_size;
wire [23:0] sensor_column_size; 
wire [23:0] sensor_row_mode;
wire [23:0] sensor_column_mode;

assign sensor_start_row 		= 24'h010036; // 24'h010000;
assign sensor_start_column 	= 24'h020010; // 24'h020000;
assign sensor_row_size	 		= 24'h030280; // 24'h0301E0; //  0797
assign sensor_column_size 		= 24'h0401E0; // 24'h040280; //  0x0A1F
assign sensor_row_mode 			= 24'h22001A; // 24'h22001A;
assign sensor_column_mode		= 24'h23001A; // 24'h23001A;

// 256x192
// 20x20
		
always@(posedge iCLK or negedge iRST_N)
	begin
		if (!iRST_N)
			combo_cnt <= 0;
		else if (!iexposure_adj_delay[3])
			combo_cnt <= combo_cnt + 1;
		else
			combo_cnt <= 0;	
	end
	
assign combo_pulse = (combo_cnt == 25'h1fffff) ? 1 : 0;				
		
wire	i2c_reset;		

assign i2c_reset = iRST_N & ~exposure_adj_reset & ~combo_pulse ;

/////////////////////////////////////////////////////////////////////

//	Clock Setting
parameter	CLK_Freq	=	50000000;	//	50	MHz
parameter	I2C_Freq	=	20000;		//	20	KHz
//	LUT Data Number
parameter	LUT_SIZE	=	26;

/////////////////////	I2C Control Clock	////////////////////////
always@(posedge iCLK or negedge i2c_reset)
begin
	if(!i2c_reset)
	begin
		mI2C_CTRL_CLK	<=	0;
		mI2C_CLK_DIV	<=	0;
	end
	else
	begin
		if( mI2C_CLK_DIV	< (CLK_Freq/I2C_Freq) )
		mI2C_CLK_DIV	<=	mI2C_CLK_DIV+1;
		else
		begin
			mI2C_CLK_DIV	<=	0;
			mI2C_CTRL_CLK	<=	~mI2C_CTRL_CLK;
		end
	end
end
////////////////////////////////////////////////////////////////////
I2C_Controller 	u0	(	.CLOCK(mI2C_CTRL_CLK),		//	Controller Work Clock
						.I2C_SCLK(I2C_SCLK),		//	I2C CLOCK
 	 	 	 	 	 	.I2C_SDAT(I2C_SDAT),		//	I2C DATA
						.I2C_DATA(mI2C_DATA),		//	DATA:[SLAVE_ADDR,SUB_ADDR,DATA]
						.GO(mI2C_GO),      			//	GO transfor
						.END(mI2C_END),				//	END transfor 
						.ACK(mI2C_ACK),				//	ACK
						.RESET(i2c_reset)
					);
					
//////////////////////	Config Control	////////////////////////////
always@(posedge mI2C_CTRL_CLK or negedge i2c_reset)
begin
	if(!i2c_reset)
	begin
		LUT_INDEX	<=	0;
		mSetup_ST	<=	0;
		mI2C_GO		<=	0;

	end

	else if(LUT_INDEX<LUT_SIZE)
		begin
			case(mSetup_ST)
			0:	begin
					mI2C_DATA	<=	{8'hBA,LUT_DATA};
					mI2C_GO		<=	1;
					mSetup_ST	<=	1;
				end
			1:	begin
					if(mI2C_END)
					begin
						if(!mI2C_ACK)
						mSetup_ST	<=	2;
						else
						mSetup_ST	<=	0;							
						mI2C_GO		<=	0;
					end
				end
			2:	begin
					LUT_INDEX	<=	LUT_INDEX+1;
					mSetup_ST	<=	0;
				end
			endcase
		end
end

/////////////////////	Config Data LUT	  //////////////////////////		
always
begin
	case(LUT_INDEX)
	0	:	LUT_DATA	<=	24'h000000;
	1	:	LUT_DATA	<=	24'h200000;				//	Mirror Row and Columns
	2	:	LUT_DATA	<=	24'h090100;				//	Exposure // {8'h09,sensor_exposure}
	3	:	LUT_DATA	<=	24'h0500A0;				//	H_Blanking
	4	:	LUT_DATA	<=	24'h06002D;				//	V_Blanking	
	5	:	LUT_DATA	<=	24'h0A0000;				//	change latch
	6	:	LUT_DATA	<=	24'h2B000b;				//	Green 1 Gain
	7	:	LUT_DATA	<=	24'h2C000f;				//	Blue Gain
	8	:	LUT_DATA	<=	24'h2D000f;				//	Red Gain
	9	:	LUT_DATA	<=	24'h2E000b;				//	Green 2 Gain
	10	:	LUT_DATA	<=	24'h100000;				//	set up PLL power on
	11	:	LUT_DATA	<=	24'h100000;				//	PLL_m_Factor<<8+PLL_n_Divider	
	12	:	LUT_DATA	<=	24'h120000;				//	PLL_p1_Divider	
	13	:	LUT_DATA	<=	24'h100000;				//	set USE PLL	 
	14	:	LUT_DATA	<=	24'h980000;				//	disable calibration 	
	18	:	LUT_DATA	<=	sensor_start_row 	;	//	set start row	
	19	:	LUT_DATA	<=	sensor_start_column ;	//	set start column 	

	20	:	LUT_DATA	<=	sensor_row_size;		//	set row size to 	
	21	:	LUT_DATA	<=	sensor_column_size;	//	set column size to 2047
	22	:	LUT_DATA	<=	sensor_row_mode;		//	set row mode in bin mode
	23	:	LUT_DATA	<=	sensor_column_mode;	//	set column mode in bin mode
	24	:	LUT_DATA	<=	24'h4901A8;				//	row black target		
	25	:	LUT_DATA	<=	24'h1E0000;				//	read mode
	default:LUT_DATA	<=	24'h000000;
	endcase
end

endmodule