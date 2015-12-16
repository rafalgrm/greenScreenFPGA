module	vga_controller(	
		//	Host Side
		inRed,
		inGreen,
		inBlue,
		outRequest,

		//	VGA Side
		outVGA_R,
		outVGA_G,
		outVGA_B,
		outVGA_H_SYNC,
		outVGA_V_SYNC,
		outVGA_SYNC,
		outVGA_BLANK,

		//	Control Signal
		iCLK,
		iRST_N,
);
// Config file
`include "vga_config.txt"

//	Host Side
input		[9:0]	inRed;
input		[9:0]	inGreen;
input		[9:0]	inBlue;
output	reg			outRequest;

//	VGA Side
output	reg	[9:0]	outVGA_R;
output	reg	[9:0]	outVGA_G;
output	reg	[9:0]	outVGA_B;
output	reg			outVGA_H_SYNC;
output	reg			outVGA_V_SYNC;
output	reg			outVGA_SYNC;
output	reg			outVGA_BLANK;

wire		[9:0]	mVGA_R;
wire		[9:0]	mVGA_G;
wire		[9:0]	mVGA_B;
reg				mVGA_H_SYNC;
reg				mVGA_V_SYNC;
wire				mVGA_SYNC;
wire				mVGA_BLANK;

//	Clock and reset
input				iCLK;
input				iRST_N;

//	Counters for X and Y
reg		[12:0]		H_Cont;
reg		[12:0]		V_Cont;

// 	Checking the screen borders

assign	mVGA_BLANK	=	mVGA_H_SYNC & mVGA_V_SYNC;
assign	mVGA_SYNC	=	1'b0;

assign	mVGA_R	=	(	H_Cont >= X_START && H_Cont<X_START + H_SYNC_ACT &&
						V_Cont >= Y_START && V_Cont<Y_START + V_SYNC_ACT )
						?	inRed	:	0;
assign	mVGA_G	=	(	H_Cont >= X_START && H_Cont<X_START + H_SYNC_ACT &&
						V_Cont >= Y_START && V_Cont<Y_START + V_SYNC_ACT )
						?	inGreen	:	0;
assign	mVGA_B	=	(	H_Cont >= X_START && H_Cont<X_START + H_SYNC_ACT &&
						V_Cont >= Y_START && V_Cont<Y_START + V_SYNC_ACT )
						?	inBlue	:	0;


always@(posedge iCLK or negedge iRST_N)
	begin
		if (!iRST_N) // 	Checking if reset is high
			begin
				outVGA_R <= 0;
				outVGA_G <= 0;
            outVGA_B <= 0;
				outVGA_BLANK <= 0;
				outVGA_SYNC <= 0;
				outVGA_H_SYNC <= 0;
				outVGA_V_SYNC <= 0; 
			end
		else
			begin
				//if (H_Cont > V_Cont + X_START)
				//begin
					outVGA_R <= 10'b1111111111;
					outVGA_G <= 10'b1111111111;
					outVGA_B <= 10'b1111111111;
				//end
				//outVGA_R <= mVGA_R;
				//outVGA_G <= mVGA_G;
				//outVGA_B <= mVGA_B;
				outVGA_BLANK <= mVGA_BLANK;
				outVGA_SYNC <= mVGA_SYNC;
				outVGA_H_SYNC <= mVGA_H_SYNC;
				outVGA_V_SYNC <= mVGA_V_SYNC;				
			end               
end

//		Informing the master module that we are in drawing area
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
		outRequest <=	0;
	else
		begin
			if(	H_Cont >= X_START-2 && H_Cont < X_START + H_SYNC_ACT-2 &&
				V_Cont >= Y_START && V_Cont < Y_START + V_SYNC_ACT )
				outRequest <=	1;
			else
				outRequest <=	0;
		end
end

always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N) // Do not draw when reset
		begin
			H_Cont		<= 0;
			mVGA_H_SYNC	<= 0;
		end
	else
		begin
			// Increments while in correct horizontal area
			if( H_Cont < H_SYNC_TOTAL )
				H_Cont <= H_Cont + 1;
			else
				H_Cont <= 0;
			//	
			if( H_Cont < H_SYNC_CYC )
				mVGA_H_SYNC	<= 0;
			else
				mVGA_H_SYNC	<= 1;
		end
end

always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N) // Do not draw when reset
	begin
		V_Cont		<=	0;
		mVGA_V_SYNC	<=	0;
	end
	else
		begin
			//	When we are at the start of the line
			if(H_Cont==0)
				begin
					// Increments while we are in correct vertical area
					if( V_Cont < V_SYNC_TOTAL )
						V_Cont <= V_Cont + 1;
					else
						V_Cont <= 0;
					// Checking if we are in the area in which sync should be low
					if(	V_Cont < V_SYNC_CYC )
						mVGA_V_SYNC <= 0;
					else
						mVGA_V_SYNC <= 1;
				end
		end
end

endmodule