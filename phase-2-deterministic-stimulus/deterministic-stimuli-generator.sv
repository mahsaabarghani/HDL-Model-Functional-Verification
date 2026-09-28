module newstim();

    // Testbench signals
    reg        tb_HCLK;
    reg        tb_HRESET;
    reg        tb_HWRITE;
    reg        tb_HSEL;
    reg [31:0] tb_HWDATA;
    reg [31:0] tb_HADDR;
    
    wire       tb_HREADY;
    wire [31:0] tb_HRDATA;

    integer    file; // File handle for logging
    
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
    
    // Stimulus
    initial begin
        //**** Initialization - Do Not Change ****
        tb_HRESET = 1;
        tb_HWRITE = 0;
        tb_HSEL = 0;
        tb_HWDATA = 32'h0;
        tb_HADDR = 32'h0;
        
        // Reset period
        #100;
        tb_HRESET = 0;
        #20;

        file = $fopen("deterministic_output.txt", "w");
        //**** End Initialization ****

        // Scenario 1: Simple Write Operation
        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 1;
        tb_HWDATA = 32'hDEADBEEF;
        tb_HADDR = 32'h80000000;
        #50;
        #1; 
        $fwrite(file, "Scenario 1: Time: %0t | tb_HREADY: %b | tb_HRDATA: %h\n", $time, tb_HREADY, tb_HRDATA);

        // Scenario 2: Simple Read Operation
        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 0;
        tb_HADDR = 32'h80000000;
        #50;
        #1; 
        $fwrite(file, "Scenario 2: Time: %0t | tb_HREADY: %b | tb_HRDATA: %h\n", $time, tb_HREADY, tb_HRDATA);

        #100;

        // Scenario 3: Write, Reset, and Read Operation
        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 1;
        tb_HWDATA = 32'h55555555;
        tb_HADDR = 32'h89444444;
        #20;
        tb_HRESET = 1;
        #10;
        tb_HRESET = 0;
        #60;
        tb_HSEL = 1;
        tb_HWRITE = 0;
        tb_HADDR = 32'h89444444;
        #1; 
        $fwrite(file, "Scenario 3: Time: %0t | tb_HREADY: %b | tb_HRDATA: %h\n", $time, tb_HREADY, tb_HRDATA);

        #100;

        // Scenario 4: Multiple Write Operations
        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 1;
        tb_HWDATA = 32'hCAFEBABE;
        tb_HADDR = 32'h80000004;
        #50;
        #1;
        $fwrite(file, "Scenario 4: Time: %0t | tb_HREADY: %b | tb_HRDATA: %h\n", $time, tb_HREADY, tb_HRDATA);

        @(posedge tb_HCLK);
        tb_HWDATA = 32'hBADC0DE;
        tb_HADDR = 32'h80000008;
        #50;
        #1;
        $fwrite(file, "Scenario 4: Time: %0t | tb_HREADY: %b | tb_HRDATA: %h\n", $time, tb_HREADY, tb_HRDATA);

        // Scenario 5: Bank Boundary Test
        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 1;
        tb_HWDATA = 32'h12345678;
        tb_HADDR = 32'h88000000;
        #50;
        #1;
        $fwrite(file, "Scenario 5: Time: %0t | tb_HREADY: %b | tb_HRDATA: %h\n", $time, tb_HREADY, tb_HRDATA);

        #100;

        // Scenario 6: Sequential Read After Write in Different Banks
        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 0;
        tb_HADDR = 32'h88000000;
        #60;
        #1;
        $fwrite(file, "Scenario 6: Time: %0t | tb_HREADY: %b | tb_HRDATA: %h\n", $time, tb_HREADY, tb_HRDATA);

        #100;

        // Scenario 7: Reset During Operation
        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 1;
        tb_HWDATA = 32'hAABBCCDD;
        tb_HADDR = 32'h8000000C;
        #30;
        tb_HRESET = 1;
        #20;
        tb_HRESET = 0;
        #10;
        $fwrite(file, "Scenario 7: Time: %0t | tb_HREADY: %b | Reset Triggered\n", $time, tb_HREADY);

        #100;
        
        // Close file
        $fclose(file); // End of simulation
    end
endmodule
