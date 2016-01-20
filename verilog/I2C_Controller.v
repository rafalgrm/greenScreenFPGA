module I2C_Controller (
	iCLK,
	I2C_SCLK, //I2C clock
 	I2C_SDAT, //I2C DATA
	I2C_DATA, // Input Data [SLAVE_ADDR,SUB_ADDR,DATA]
	GO,      //	go transfer
	END,     //	end transfer 
	ACK,     //ACK
	RST

);
	input  iCLK;
	input  [31:0] I2C_DATA;	
	input  GO;	
	input  RST;	
	
 	inout  I2C_SDAT;	
	
	output I2C_SCLK;
	output END;	
	output ACK;
	
	reg [31:0] slaveData;
	reg [6:0] SD_COUNTER;
	
	reg out;
	reg SCLK;
	reg END;

	// Jezeli SD_Counter jest pomiedzy 4 a 39 to 
	wire I2C_SCLK = SCLK | ( ((SD_COUNTER >= 4) & (SD_COUNTER <=39))? ~iCLK :0 );
	wire I2C_SDAT = out? 1'bz : 0 ;

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
	if (!RST) begin SCLK=1;out=1; ACK1=0;ACK2=0;ACK3=0;ACK4=0; END=1; end
	else
	case (SD_COUNTER)
		6'd0  : begin ACK1=0 ;ACK2=0 ;ACK3=0 ;ACK4=0 ; END=0; out=1; SCLK=1;end
		// Start
		6'd1  : begin slaveData = I2C_DATA; out=0; end
		6'd2  : SCLK = 0;
		// Slave addres
		6'd3  : out = slaveData[31];
		6'd4  : out = slaveData[30];
		6'd5  : out = slaveData[29];
		6'd6  : out = slaveData[28];
		6'd7  : out = slaveData[27];
		6'd8  : out = slaveData[26];
		6'd9  : out = slaveData[25];
		6'd10 : out = slaveData[24];	
		6'd11 : out = 1'b1;  //ACK

		// Register addres 
		6'd12  : begin out = slaveData[23]; ACK1 = I2C_SDAT; end
		6'd13  : out = slaveData[22];
		6'd14  : out = slaveData[21];
		6'd15  : out = slaveData[20];
		6'd16  : out = slaveData[19];
		6'd17  : out = slaveData[18];
		6'd18  : out = slaveData[17];
		6'd19  : out = slaveData[16];
		6'd20  : out = 1'b1;	//ACK

		// Data 
		6'd21  : begin out = slaveData[15]; ACK2 = I2C_SDAT; end
		6'd22  : out = slaveData[14];
		6'd23  : out = slaveData[13];
		6'd24  : out = slaveData[12];
		6'd25  : out = slaveData[11];
		6'd26  : out = slaveData[10];
		6'd27  : out = slaveData[9];
		6'd28  : out = slaveData[8];
		6'd29  : out = 1'b1;//ACK

		// Data
		6'd30  : begin out = slaveData[7]; ACK3 = I2C_SDAT; end
		6'd31  : out = slaveData[6];
		6'd32  : out = slaveData[5];
		6'd33  : out = slaveData[4];
		6'd34  : out = slaveData[3];
		6'd35  : out = slaveData[2];
		6'd36  : out = slaveData[1];
		6'd37  : out = slaveData[0];
		6'd38  : out = 1'b1;//ACK

		
		// Stop
		6'd39 : begin out = 1'b0;	SCLK = 1'b0; ACK4 = I2C_SDAT; end	
		6'd40 : SCLK = 1'b1; 
		6'd41 : begin out = 1'b1; END = 1; end 

	endcase
end



endmodule
