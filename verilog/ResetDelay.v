module	ResetDelay(iCLK,iRST,oRST_0,oRST_1,oRST_2);
	// Inputs are clock and reset
	input		iCLK;
	input		iRST;
	// Emmits three reset signals
	output reg	oRST_0;
	output reg	oRST_1;
	output reg	oRST_2;

	// Counter
	reg	[31:0]	Cont;

always@(posedge iCLK or negedge iRST)
begin
	if(!iRST) // If RST ground all outputs
		begin
			Cont	<=	0;
			oRST_0	<=	0;
			oRST_1	<=	0;
			oRST_2	<=	0;
		end
	else
		begin
			if(Cont != 32'h114FFFF) // 18 153 471 dec
				Cont	<=	Cont+1;
			if(Cont >= 32'h1FFFFF) // 2 097 151 dec ~9x times
				oRST_0	<=	1;
			if(Cont >= 32'h2FFFFF) // 3 145 727 dec ~6x times
				oRST_1	<=	1;
			if(Cont >= 32'h114FFFF) // 18 153 471 dec
				oRST_2	<=	1;
		end
end

endmodule