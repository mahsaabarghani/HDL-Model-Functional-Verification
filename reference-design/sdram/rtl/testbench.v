
module sdram_top_tb();

    // Testbench signals
    reg        tb_HCLK;
    reg        tb_HRESET;
    reg        tb_HWRITE;
    reg        tb_HSEL;
    reg [31:0] tb_HWDATA;
    reg [31:0] tb_HADDR;
    
    wire        tb_HREADY;
    wire [31:0] tb_HRDATA;
    
    // Instance of design under test
    sdram_top DUT (
        .in_HCLK(tb_HCLK),
        .in_HRESET(tb_HRESET),
        .in_HWRITE(tb_HWRITE),
        .in_HSEL(tb_HSEL),
        .in_HWDATA(tb_HWDATA),
        .in_HADDR(tb_HADDR),
        .out_HREADY(tb_HREADY),
        .out_HRDATA(tb_HRDATA)
    );
    
    // Clock generation
    initial begin
        tb_HCLK = 0;
        forever #5 tb_HCLK = ~tb_HCLK;
    end
    
  
    
    // Test stimulus
    initial begin
        // Initialize signals
        tb_HRESET = 1;
        tb_HWRITE = 0;
        tb_HSEL = 0;
        tb_HWDATA = 32'h0;
        tb_HADDR = 32'h0;
        
        // Reset period
        #100;
        tb_HRESET = 0;
        #20;
        
        // Write operation
        $display("Starting Write Operation at time %0t", $time);
        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 1;    // Write = 1
        tb_HWDATA = 32'hDEADBEEF;
        tb_HADDR = 32'h80000000;  // Bank 0, Row 0, Column 0
        
        // Wait for HREADY to assert
        while (!tb_HREADY) @(posedge tb_HCLK);
        
        // Deassert signals
        @(posedge tb_HCLK);
        tb_HSEL = 0;
        tb_HWRITE = 0;
        tb_HWDATA = 32'h0;
        tb_HADDR = 32'h0;
        
        // Wait a few cycles
        #50;
        
        // Read operation
        $display("Starting Read Operation at time %0t", $time);
        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 0;  // Read = 0
        tb_HADDR = 32'h80000000;  // Same address as write
       
        
        
    end
    
    

endmodule