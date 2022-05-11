/*
    Author : Rakotojaona Nambinina
    email : Andrianoelisoa.Rakotojaona@gmail.com
    Description : State machine writing data alternatively to two different BRAM , BRAM1 and BRAM2
*/
`timescale 1ns / 1ps

module counter(
               clk,
               rst,
               tx,
               wr_en_1,
               wr_add_1,
               wr_data_1,
               wr_en_2,
               wr_add_2,
               wr_data_2
               );
  // input port
  input clk;
  input rst;
  input tx;
  // output port 
  output reg  wr_en_1; // enable BRAM1
  output reg [31:0] wr_add_1; // address of BRAM1
  output reg [31:0]wr_data_1; // write data
  output reg wr_en_2; // enable BRAM2
  output reg [31:0] wr_add_2; // write address BRAM2
  output reg [31:0] wr_data_2; // write data on BRAM2
  
  // memory occupied for the two BRAM
  reg [1:0] ramUsed;
  // counter 
  integer counter ;
  
  // state 
  integer state;
  
  always @ (posedge clk)
    begin
      counter <= counter + 1;
      if (rst)
        begin
          state <=0;
          counter <=0;
          ramUsed <=2'b10;
          wr_en_1 <=1'bx;
          wr_add_1 <= 32'dx;
          wr_data_1 <= 32'dx;
          wr_en_2 <=1'bx;
          wr_add_2 <= 32'dx;
          wr_data_2 <= 32'dx;
        end
      else
        begin
          case (state)
            0:
              begin
                if (counter ==32'd5)
                  begin
                    state <=2;
                    counter <=0;
                  end 
              end
            1:
              begin
                if (counter ==32'd5)
                  begin
                    state <=2;
                  end 
              end
            2:
              begin
                if (tx ==1  && ramUsed == 2'b01)
                  begin
                    state <=3;
                    counter <=0;
                  end
               if (tx ==1 && ramUsed == 2'b10)
                 begin
                   state <=1;
                   counter <=0;
                 end  
              end 
            3:
              begin
                if (counter == 5'd5)
                  begin
                    state <=2;
                  end 
              end  
          endcase
        end 
      end
  
  always @ (negedge clk)
    begin
      case (state)
        0:
          begin
             // ram Used
            ramUsed <=2'b10;
            // do not write to the BRAM1
            wr_en_1 <=0;
            wr_add_1 <= 32'dx;
            wr_data_1 <=32'dx;
            // Write to the BRAM2
            wr_en_2 <=1;
            wr_add_2 <= 32'd1;
            wr_data_2 <=32'd3;
          end
        1:
          begin
            // write BRAM1
            ramUsed <=2'b01;
            wr_en_1 <=1;
            wr_add_1 <= 32'd1;
            wr_data_1 <=32'd3;
            // Do not write BRAM2
            wr_en_2 <=0;
            wr_add_2 <= 32'dx;
            wr_data_2 <=32'dx;
          end
        2:
          begin
            // wait event it means we do not write BRAM1 AND BRAM2
            wr_en_1 <=0;
            wr_add_1 <= 32'dx;
            wr_data_1 <=32'dx;
            // Do not write BRAM2
            wr_en_2 <=0;
            wr_add_2 <= 32'dx;
            wr_data_2 <=32'dx;
          end
        3:
          begin
            ramUsed <=2'b10;
            // Do not write BRAM1
            wr_en_1 <=0;
            wr_add_1 <= 32'dx;
            wr_data_1 <=32'dx;
            // write BRAM2
            wr_en_2 <=1;
            wr_add_2 <= 32'd1;
            wr_data_2 <=32'd3;
          end 

      endcase
    end  

endmodule
/* 
Test bench


module ramtb(

    );
    
  reg clk;
  reg rst;
  reg tx;
  // output port 
  wire   wr_en_1; // enable BRAM1
  wire  [31:0] wr_add_1; // address of BRAM1
  wire  [31:0]wr_data_1; // write data
  wire  wr_en_2; // enable BRAM2
  wire  [31:0] wr_add_2; // write address BRAM2
  wire  [31:0] wr_data_2; // write data on BRAM2
  
  counter uut(
               clk,
               rst,
               tx,
               wr_en_1,
               wr_add_1,
               wr_data_1,
               wr_en_2,
               wr_add_2,
               wr_data_2
               );
  // input port
  initial
    begin
      clk =0;
      rst =1;
      tx=0;
      #10
      rst=0;
      #30
      tx=1;
      #10
      tx=0;
      #115
      tx=1;
      #10
      tx=0;
    end 
  always
    begin
      #5 clk = ! clk;
    end
endmodule
*/
