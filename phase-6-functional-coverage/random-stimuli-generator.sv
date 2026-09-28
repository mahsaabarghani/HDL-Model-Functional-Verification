module random_stimuli_generator();

    reg        tb_HCLK;
    reg        tb_HRESET;
    reg        tb_HWRITE;
    reg        tb_HSEL;
    reg [31:0] tb_HWDATA;
    reg [31:0] tb_HADDR;
    
    wire       tb_HREADY;
    wire [31:0] tb_HRDATA;
    
    wire [31:0] golden_HRDATA;
    wire golden_HREADY;
    wire [15:0] error_count;

    integer    file;
    integer  i;
    integer seed;
    integer comparison_file;

    
    wire [31:0] total_ops;
    wire [31:0] read_ops;
    wire [31:0] write_ops; 
    wire [31:0] invalid_ops; 

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
    
    Golden_Model_sdram GoldenModel(
        .clk_sys(tb_HCLK),
        .rst_sys(tb_HRESET),
        .write_enable(tb_HWRITE),
        .select_line(tb_HSEL),
        .write_data_in(tb_HWDATA),
        .addr_in(tb_HADDR),
        .ready_out(golden_HREADY),
        .read_data_out(golden_HRDATA)
    );

    Checker checker_inst (
    .clk(tb_HCLK),
    .reset(tb_HRESET),
    .golden_HRDATA(golden_HRDATA),
    .tb_HRDATA(tb_HRDATA),
    .golden_HREADY(golden_HREADY),
    .tb_HREADY(tb_HREADY),
    .address(tb_HADDR),
    .error_count(error_count)
);

    sdram_scoreboard u_sdram_scoreboard (
    .clk_in        (tb_HCLK), 
    .rst_in        (tb_HRESET), 
    .wr_enable_in  (tb_HWRITE),     
    .sel_in        (tb_HSEL),        
    .addr_in       (tb_HADDR), 
    .wr_data_in    (tb_HWDATA),
    .ready_out     (tb_HREADY), 
    .rd_data_out   (tb_HRDATA), 
 
    .total_ops     (total_ops), 
    .read_ops      (read_ops), 
    .write_ops     (write_ops), 
    .invalid_ops   (invalid_ops)
);

    // Clock generation
    initial begin
        tb_HCLK = 0;
        forever #5 tb_HCLK = ~tb_HCLK;
    end
    
    //functional coverage
    covergroup cg_sdram @(posedge tb_HCLK);
        coverpoint tb_HCLK {
            bins all_values = { [0:$] }; 
        }
        coverpoint tb_HRESET {
            bins zero = {0};
            bins one = {1};  
        }
        coverpoint tb_HWRITE {
            bins zero = {0};
            bins one = {1};  
        }
        coverpoint tb_HSEL {
            bins zero = {0};
            bins one = {1};  
        }
        coverpoint tb_HREADY {
            bins zero = {0};
            bins one = {1};  
        }
        coverpoint tb_HWDATA {
            bins all_values = { [0:$] };  // محدوده تمامی مقادیر ممکن
        }
        
        coverpoint tb_HADDR {
            bins all_values = { [0:$] };  
        }
        
        coverpoint tb_HRDATA {
            bins all_values = { [0:$] };  
        }

    endgroup

    cg_sdram sdram_cov = new();


    // Stimulus
    initial begin
        
        seed=10;
        tb_HRESET = 1;
        tb_HWRITE = 0;
        tb_HSEL = 0;
        tb_HWDATA = 32'h0;
        tb_HADDR = 32'h0;
        
        // Reset period
        #100;
        tb_HRESET = 0;
        #20;

        file = $fopen("deterministic_output5.txt", "w");
        comparison_file = $fopen("results_comparison.txt", "w");
        // Scenario 1: Simple Write Operation with random(seed) data
        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 1;
        tb_HADDR = $random(seed)/32'h40000000;
        tb_HWDATA = $random(seed);

        #50;
        #1;
        $fwrite(file, "Scenario 1: Time: %0t | tb_HWRITE: %b | tb_HWDATA: %h | tb_HREADY: %b | tb_HRDATA: %h\n", $time, tb_HWRITE, tb_HWDATA, tb_HREADY, tb_HRDATA);
        compare_and_log(comparison_file, 1);
        // Scenario 2: Simple Read Operation with random(seed) address
        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 0;
        tb_HADDR = tb_HADDR;

        #50;
        #1;
        $fwrite(file, "Scenario 2: Time: %0t | tb_HWRITE: %b | tb_HREADY: %b | tb_HRDATA: %h\n", $time, tb_HWRITE, tb_HREADY, tb_HRDATA);
        compare_and_log(comparison_file, 2);
        // Scenario 3: Write, Reset, and Read Operation with random(seed) data
        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 1;
        tb_HWDATA = $random(seed);
        tb_HADDR = $random(seed)/32'h40000000;

        #20;
        tb_HRESET = 1;
        #10;
        tb_HRESET = 0;
        #50;
        #1;
        tb_HSEL = 1;
        tb_HWRITE = 0;
        tb_HADDR = tb_HADDR;

        #1;
        $fwrite(file, "Scenario 3: Time: %0t |tb_HADDR: %b | tb_HWRITE: %b | tb_HWDATA: %h | tb_HREADY: %b | tb_HRDATA: %h\n", $time,tb_HADDR, tb_HWRITE, tb_HWDATA, tb_HREADY, tb_HRDATA);
        compare_and_log(comparison_file, 3);
        // Scenario 4: Multiple Write Operations with random(seed) data and addresses
        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 1;
        tb_HWDATA = $random(seed);
        tb_HADDR = $random(seed)/32'h40000000;
        #50;
        #1;
        $fwrite(file, "Scenario 4: Time: %0t |tb_HADDR: %h | tb_HWRITE: %b | tb_HWDATA: %h | tb_HREADY: %b | tb_HRDATA: %h\n", $time,tb_HADDR, tb_HWRITE, tb_HWDATA, tb_HREADY, tb_HRDATA);

        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 1;
        tb_HWDATA = $random(seed);
        tb_HADDR = tb_HADDR;
        #50;
        #1;
        $fwrite(file, "Scenario 4: Time: %0t |tb_HADDR: %h | tb_HWRITE: %b | tb_HWDATA: %h | tb_HREADY: %b | tb_HRDATA: %h\n", $time,tb_HADDR, tb_HWRITE, tb_HWDATA, tb_HREADY, tb_HRDATA);
        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 0;
        tb_HADDR = tb_HADDR;
        #50;
        #1;
        $fwrite(file, "Scenario 4: Time: %0t |tb_HADDR: %h | tb_HWRITE: %b | tb_HWDATA: %h | tb_HREADY: %b | tb_HRDATA: %h\n", $time,tb_HADDR, tb_HWRITE, tb_HWDATA, tb_HREADY, tb_HRDATA);
        compare_and_log(comparison_file, 4);
        // Scenario 5: Bank Boundary Test with random(seed) address
        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 1;
        tb_HWDATA = $random(seed);
        tb_HADDR = $random(seed)/32'h40000000; // باید اینجا ادرس رو تعیین میکردم

        #50;
        #1;
        $fwrite(file, "Scenario 5: Time: %0t | tb_HWRITE: %b | tb_HREADY: %b | tb_HRDATA: %h\n", $time, tb_HWRITE, tb_HREADY, tb_HRDATA);
        compare_and_log(comparison_file, 5);
        // Scenario 6: Sequential Read After Write in Different Banks
        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 1;
        tb_HWDATA = $random(seed);
        tb_HADDR = $random(seed)/32'h40000000;
        #50;
        #1;
        $fwrite(file, "Scenario 6: Time: %0t |tb_HADDR: %h | tb_HWRITE: %b | tb_HWDATA: %h | tb_HREADY: %b | tb_HRDATA: %h\n", $time,tb_HADDR, tb_HWRITE, tb_HWDATA, tb_HREADY, tb_HRDATA);

        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 0;
        tb_HADDR = tb_HADDR;
        #50;
        #1;
        $fwrite(file, "Scenario 6: Time: %0t |tb_HADDR: %h | tb_HWRITE: %b | tb_HWDATA: %h | tb_HREADY: %b | tb_HRDATA: %h\n", $time,tb_HADDR, tb_HWRITE, tb_HWDATA, tb_HREADY, tb_HRDATA);
        
        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 0;
        tb_HADDR = tb_HADDR;
        #50;
        #1;
        $fwrite(file, "Scenario 6: Time: %0t |tb_HADDR: %h | tb_HWRITE: %b | tb_HWDATA: %h | tb_HREADY: %b | tb_HRDATA: %h\n", $time,tb_HADDR, tb_HWRITE, tb_HWDATA, tb_HREADY, tb_HRDATA);
        compare_and_log(comparison_file, 6);
        // Scenario 7: Reset During Operation with random(seed) data
        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 1;
        tb_HWDATA = $random(seed);
        tb_HADDR = $random(seed)/32'h40000000;

        #30;
        tb_HRESET = 1;
        #20;
        tb_HRESET = 0;
        #1;
        $fwrite(file, "Scenario 7: Time: %0t |tb_HADDR: %h | tb_HWRITE: %b | tb_HWDATA: %h | tb_HREADY: %b | tb_HRDATA: %h\n| Reset Triggered\n", $time,tb_HADDR, tb_HWRITE, tb_HWDATA, tb_HREADY, tb_HRDATA);
        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 0;
        tb_HADDR = tb_HADDR;
        #50;
        #1;
        $fwrite(file, "Scenario 7: Time: %0t |tb_HADDR: %h | tb_HWRITE: %b | tb_HWDATA: %h | tb_HREADY: %b | tb_HRDATA: %h\n", $time,tb_HADDR, tb_HWRITE, tb_HWDATA, tb_HREADY, tb_HRDATA);
        @(posedge tb_HCLK);
        tb_HSEL = 1;
        tb_HWRITE = 0;
        tb_HADDR = tb_HADDR;
        #50;
        #1;
        $fwrite(file, "Scenario 7: Time: %0t |tb_HADDR: %h | tb_HWRITE: %b | tb_HWDATA: %h | tb_HREADY: %b | tb_HRDATA: %h\n", $time,tb_HADDR, tb_HWRITE, tb_HWDATA, tb_HREADY, tb_HRDATA);
        compare_and_log(comparison_file, 7);
        // Loop for additional random(seed) operations
        for (i = 0; i < 10; i = i + 1) begin
            @(posedge tb_HCLK);
            tb_HADDR = $random(seed)/32'h40000000;
            tb_HWDATA = $random(seed);
            tb_HWRITE = $random(seed) % 2;
            tb_HSEL = 1;

            tb_HRESET = $random(seed) % 2;
            #10;
            tb_HRESET = $random(seed) % 2;

            #40;
            $fwrite(file, "Scenario %0d: Time: %0t | tb_HADDR: %h | tb_HWDATA: %h | tb_HWRITE: %b | tb_HREADY: %b | tb_HRDATA: %h\n",
                    i, $time, tb_HADDR, tb_HWDATA, tb_HWRITE, tb_HREADY, tb_HRDATA);
                    compare_and_log(comparison_file, i  );
            #1;
            end
    

            @(posedge tb_HCLK);
            sdram_cov.sample();

    // Close file
    $fclose(file);
    $fclose(comparison_file); 

        end
        task compare_and_log(input integer file, input integer scenario_id);
            begin
                $fwrite(file, "Scenario %0d: Time=%0t | ", scenario_id, $time);
                if (tb_HRDATA === golden_HRDATA && tb_HREADY === golden_HREADY) begin
                    $fwrite(file, "Match: HRDATA=%h, |tb_HWRITE: %b| HREADY=%b\n" , tb_HRDATA, tb_HWRITE ,tb_HREADY);
                end else begin
                    $fwrite(file, "Mismatch: SDRAM HRDATA=%h, HREADY=%b |tb_HWRITE: %b| Golden HRDATA=%h, HREADY=%b\n",
                            tb_HRDATA, tb_HREADY, tb_HWRITE, golden_HRDATA, golden_HREADY);
                end
            end
        endtask

endmodule
