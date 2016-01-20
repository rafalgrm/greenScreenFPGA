module I2C_Controller (
	iCLK,
	I2C_SCLK, //I2C clock
 	I2C_SDAT, //I2C DATA
	I2C_DATA, // Input Data [SLAVE_ADDR,SUB_ADDR,DATA]
	GO,      //go transfer
	END,     //end transfer 
	W_R,     //W_R
	ACK,     //ACK
	RST

);
	input  iCLK;
	input  [31:0] I2C_DATA;	
	input  GO;	
	input  W_R;
	input  RST;	
	
 	inout  I2C_SDAT;	
	
	output I2C_SCLK;
	output END;	
	output ACK;
	
	reg [31:0] slaveData;
	reg [6:0] SD_COUNTER;
	
	reg SDO;
	reg SCLK;
	reg END;

	// Jezeli SD_Counter jest pomiedzy 4 a 39 to 
	wire I2C_SCLK = SCLK | ( ((SD_COUNTER >= 4) & (SD_COUNTER <=39))? ~iCLK :0 );
	wire I2C_SDAT = SDO? 1'bz : 0 ;

	reg ACK1, ACK2, ACK3, ACK4;
	wire ACK = ACK1 | ACK2 | ACK3 | ACK4;

// I2C COUNTER
always @(negedge RST or posedge iCLK ) begin
	if (!RST) SD_COUNTER=6'b111111;
		else begin
			if (GO == 0) 
					SD_COUNTER = 0; // GO Resetuje licznik
			else 
				if (SD_COUNTER < 41) SD_COUNTER = SD_COUNTER + 1;	// Jest inkrementowany co cykl zegara
		end
end


always @(negedge RST or  posedge iCLK ) begin
	if (!RST) begin SCLK=1;SDO=1; ACK1=0;ACK2=0;ACK3=0;ACK4=0; END=1; end
	else
	case (SD_COUNTER)
		6'd0  : begin ACK1=0 ;ACK2=0 ;ACK3=0 ;ACK4=0 ; END=0; SDO=1; SCLK=1;end
		//start
		6'd1  : begin slaveData=I2C_DATA; SDO=0; end
		6'd2  : SCLK=0;
		// SLAVE addres
		6'd3  : SDO=slaveData[31];
		6'd4  : SDO=slaveData[30];
		6'd5  : SDO=slaveData[29];
		6'd6  : SDO=slaveData[28];
		6'd7  : SDO=slaveData[27];
		6'd8  : SDO=slaveData[26];
		6'd9  : SDO=slaveData[25];
		6'd10 : SDO=slaveData[24];	
		6'd11 : SDO=1'b1;//ACK

		// Register addres 
		6'd12  : begin SDO=slaveData[23]; ACK1=I2C_SDAT; end
		6'd13  : SDO=slaveData[22];
		6'd14  : SDO=slaveData[21];
		6'd15  : SDO=slaveData[20];
		6'd16  : SDO=slaveData[19];
		6'd17  : SDO=slaveData[18];
		6'd18  : SDO=slaveData[17];
		6'd19  : SDO=slaveData[16];
		6'd20  : SDO=1'b1;//ACK

		// Data 
		6'd21  : begin SDO=slaveData[15]; ACK2=I2C_SDAT; end
		6'd22  : SDO=slaveData[14];
		6'd23  : SDO=slaveData[13];
		6'd24  : SDO=slaveData[12];
		6'd25  : SDO=slaveData[11];
		6'd26  : SDO=slaveData[10];
		6'd27  : SDO=slaveData[9];
		6'd28  : SDO=slaveData[8];
		6'd29  : SDO=1'b1;//ACK

		//DATA
		6'd30  : begin SDO=slaveData[7]; ACK3=I2C_SDAT; end
		6'd31  : SDO=slaveData[6];
		6'd32  : SDO=slaveData[5];
		6'd33  : SDO=slaveData[4];
		6'd34  : SDO=slaveData[3];
		6'd35  : SDO=slaveData[2];
		6'd36  : SDO=slaveData[1];
		6'd37  : SDO=slaveData[0];
		6'd38  : SDO=1'b1;//ACK

		
		// Stop
		6'd39 : begin SDO=1'b0;	SCLK=1'b0; ACK4=I2C_SDAT; end	
		6'd40 : SCLK=1'b1; 
		6'd41 : begin SDO=1'b1; END=1; end 

	endcase
end



endmodule
