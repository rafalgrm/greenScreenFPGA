module	RAWToRGB(	iCLK,
	iRST_n,
	//Read Port 1
	iData,
	iDataValid,
	oRed,
	oGreen,
	oBlue,
	oDataValid,
	iZoom,
	iX_Counter,
	iY_Counter
);

// Clock i reset
input			iCLK,iRST_n;
// Data i data valid
input	[11:0]	iData;
input			iDataValid;
// Kolorki na output
output	[11:0]	oRed;
output	[11:0]	oGreen;
output	[11:0]	oBlue;
// Data valid na output
output			oDataValid;
// Zoom - do usunieci !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
input	[1:0]	iZoom;
// Countery
input	[15:0]	iX_Counter;
input	[15:0]	iY_Counter;

// Bufory dla danych
wire	[11:0]	wData0;
wire	[11:0]	wData1;
wire	[11:0]	wData2;

// Inne bufory dla kolorkow
reg		[11:0]	rRed;
reg		[12:0]	rGreen;
reg		[11:0]	rBlue;
// Dla data valid
reg				rDataValid;

// Dodatkowe buforki
reg		[11:0]	wData0_d1,wData0_d2;
reg		[11:0]	wData1_d1,wData1_d2;
reg		[11:0]	wData2_d1,wData2_d2;

// Register dla data valid
reg				oDataValid;

// Niewiadomoco
reg				dataValid_ctrl;
reg				dataValid_ctrl_en;

//Wyjscie
assign	oRed	=	rRed;
assign	oGreen	=	rGreen[12:1];
assign	oBlue	=	rBlue;

line_buffer		L1	(
					.clken(iDataValid),
					.clock(iCLK),
					.shiftin(iData),
					.shiftout(),
					.taps2x(wData0),
					.taps1x(wData1),
					.taps0x(wData2)
				);

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			begin // Reset
				dataValid_ctrl<=0;
			end	
		else
			begin
				if(iY_Counter > 1)
					begin // Wystarczy wiersz > 1 zeby dane byly valid
						dataValid_ctrl<=1;
					end		
				else
					begin
						dataValid_ctrl<=0;
					end
			end	
	end

always@(posedge dataValid_ctrl or negedge iRST_n)
	begin
		if (!iRST_n)
			begin // Reset
				dataValid_ctrl_en <= 0;
			end	
		else
			begin // Zawsze na 1
				dataValid_ctrl_en <= 1;
			end	
	end


always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			begin // Reset 
				rDataValid <= 0;
				oDataValid <= 0;
			end	
		else
			if(dataValid_ctrl_en)
				begin // Kopiujemy do rejestrow
					rDataValid <= iDataValid;	
					oDataValid <= rDataValid;
				end
			else
				begin // Jezeli nie to nie wiem co
					rDataValid <= iDataValid;
					oDataValid <= 0;
				end	
	end

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			begin // Reset
				wData0_d1<=0;
				wData0_d2<=0;
				wData1_d1<=0;
				wData1_d2<=0;
				wData2_d1<=0;
				wData2_d2<=0;				
			end
		else
			begin // Siup
				{wData0_d2,wData0_d1}<={wData0_d1,wData0};
				{wData1_d2,wData1_d1}<={wData1_d1,wData1};
				{wData2_d2,wData2_d1}<={wData2_d1,wData2};
			end
	end		
	
/** UWAGA UWAGA !!!!!
 ZAWSZE JESTESMY W 2D1 !!!! Na dole na srodku
*/
	
always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			begin
				rRed<=0;
				rGreen<=0;
				rBlue<=0;	
			end
		// Sprawdzamy parzystosc licznika x i y => ZAWSZE ZIELONY G2
		else if ({iY_Counter[0],iX_Counter[0]} == 2'b11)
			begin // Nieparzyste
				if (iY_Counter == 12'd1)
					begin // Drugi wiersz
						rRed<=wData1_d1;
						rGreen<=wData0_d1+wData1;
						rBlue<=wData0;
					end		
				else
					begin // Dla pozostalych wierszy
						rRed<=wData1_d1;
						rGreen<=wData1+wData2_d1;
						rBlue<=wData2;
					end
			end		
		else if ({iY_Counter[0],iX_Counter[0]} == 2'b10)
			begin // Nieparzysty wiersz i parzysta kolumna => ZAWSZE Blue
				if (iY_Counter == 12'd1) 
					begin // Drugi wiersz
						if (iX_Counter == 12'b0)
							begin // Pierwsza kolumna
								rRed<=wData0_d2;
								rGreen<={wData1_d2,1'b0};
								rBlue<=wData1_d1;
							end
						else // Pozostale wiersze
							begin
								rRed<=wData1;
								rGreen<=wData1_d1+wData0;
								rBlue<=wData0_d1;	
							end
					end		
				else
					begin
						// for last one X pixel of the colowm process
						if (iX_Counter == 12'b0)
							begin // Pierwsza kolumna
								rRed<=wData2_d2;
								rGreen<={wData2_d1,1'b0};
								rBlue<=wData1_d1;
							end
						// normal X pixel of the colowm process
						else
							begin
								rRed<=wData1;
								rGreen<=wData1_d1+wData2;
								rBlue<=wData2_d1;	
							end	
					end	
			end		
		else if ({iY_Counter[0],iX_Counter[0]} == 2'b01)
			begin // Parzysty wiersz i nieparzysta kolumna => ZAWSZE CZERWONY
				rRed<=wData2_d1;
				rGreen<=wData2+wData1_d1;
				rBlue<=wData1;		
			end	

		else if ({iY_Counter[0],iX_Counter[0]} == 2'b00)
			begin // Parzysty wiersz i parzysta kolumna => ZAWSZE ZIELONY G1
				if (iX_Counter == 12'b0)
					begin
						rRed<=wData1_d2;
						rGreen<={wData2_d2,1'b0};
						rBlue<=wData2_d1;
					end
				// normal X of the colowm process
				
				else
					begin
						rRed<=wData2;
						rGreen<=wData2_d1+wData1;
						rBlue<=wData1_d1;	
					end	
			end	
	end


endmodule