module CCD_Capture(	oDATA,
					oDataValid,
					oX_Counter,
					oY_Counter,
					oFrame_Counter,
					iDATA,
					inputFrameValid,
					inputLineValid,
					iSTART,
					iEND,
					iCLK,
					iRST
					);
					
input	[11:0]	iDATA;
input			inputFrameValid;
input			inputLineValid;
input			iSTART;
input			iEND;
input			iCLK;
input			iRST;
output	[11:0]	oDATA;
output	[15:0]	oX_Counter;
output	[15:0]	oY_Counter;
output	[31:0]	oFrame_Counter;
output			oDataValid;
reg				Pre_FrameValid;
reg				mCCD_FrameValid;
reg				mCCD_LineValid;
reg		[11:0]	mCCD_DATA;
reg		[15:0]	X_Counter;
reg		[15:0]	Y_Counter;
reg		[31:0]	Frame_Cont;
reg				mSTART;

parameter COLUMN_WIDTH = 1280;

// Dajemy liczniki na wyjscie
assign	oX_Counter		=	X_Counter;
assign	oY_Counter		=	Y_Counter;
assign	oFrame_Counter	=	Frame_Cont;
// Tak samo dane
assign	oDATA		=	mCCD_DATA;
assign	oDataValid		=	mCCD_FrameValid & mCCD_LineValid;

always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
		mSTART	<=	0;
	else
	begin
		if(iSTART)
			mSTART	<=	1;
		if(iEND)
			mSTART	<=	0;		
	end
end

always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	begin
		Pre_FrameValid	<=	0;
		mCCD_FrameValid	<=	0;
		mCCD_LineValid	<=	0;

		X_Counter		<=	0;
		Y_Counter		<=	0;
	end
	else
	begin
		Pre_FrameValid	<=	inputFrameValid;
		// Sprawdzamy czy nie zmienilo sie od poprzedniej instrukcji
		if( ({Pre_FrameValid,inputFrameValid}==2'b01) && mSTART )
			mCCD_FrameValid	<=	1; // Bylo okej ale nie jest okej -> nieokej
		else if({Pre_FrameValid,inputFrameValid}==2'b10)
			mCCD_FrameValid	<=	0; // Bylo nie okej ale jest okrej -> okej
		mCCD_LineValid	<=	inputLineValid; // To po prostu prypisanie
		if(mCCD_FrameValid)
			begin
				if(mCCD_LineValid)
				begin // Tutaj frame jest valid i line jest valid
					if(X_Counter < (COLUMN_WIDTH-1))
						X_Counter	<=	X_Counter+1;
					else
					begin
						X_Counter	<=	0;
						Y_Counter	<=	Y_Counter+1;
					end
				end
			end
		else
			begin // Tutaj jezeli frame nie jest valid
				X_Counter	<=	0;
				Y_Counter	<=	0;
				// Minelismy cala klatke
			end
	end
end

// Tutaj inkrementujemy frame counter
always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
		Frame_Cont	<=	0;
	else
	begin
		if( ({Pre_FrameValid,inputFrameValid}==2'b01) && mSTART )
			Frame_Cont	<=	Frame_Cont+1;
	end
end

// Tutaj jezeli jest dobry frame to kopiujemy dane
always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
		mCCD_DATA	<=	0;
	else if (inputLineValid)
		mCCD_DATA	<=	iDATA;
	else
		mCCD_DATA	<=	0;	
end			

reg	inputFrameValid_delay;

wire inputFrameValid_fetch;	
reg	[15:0]	y_count_d;


always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
		y_count_d	<=	0;
	else
		y_count_d	<=	Y_Counter;	
end


always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
		inputFrameValid_delay	<=	0;
	else
		inputFrameValid_delay	<=	inputFrameValid;	
end

assign inputFrameValid_fetch = ({inputFrameValid_delay,inputFrameValid}==2'b10)?1:0;  


endmodule