
`timescale 1ns/1ns

module Pipeline__tb;
   integer file;
   reg clk = 1;
   always @(clk)
      clk <= #5 ~clk;

   reg reset;
   initial begin
      reset = 1;
      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      #1;
      reset = 0;
   end

   initial
      $readmemh("isort32.hex", MIPS.A2.insructionMemory.RAM);

   parameter end_pc = 32'h80;
 
   integer i;
   always @(MIPS.A2.PCF)
      if(MIPS.A2.PCF == end_pc) begin
         for(i=0; i<96; i=i+1) begin
            $write("%x ", MIPS.A2.MemoryData.RAM[32+i]); // 32+ for iosort32
            if(((i+1) % 16) == 0)
               $write("\n");
         end
         $stop;
      end
      
   pipelineCpu MIPS(
      .clk(clk),
      .reset(reset)
   );


endmodule

