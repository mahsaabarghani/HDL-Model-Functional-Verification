module sdram_scoreboard ( 
    input logic        clk_in, 
    input logic        rst_in, 
    input logic        wr_enable_in,     
    input logic        sel_in,        
    input logic [31:0] addr_in, 
    input logic [31:0] wr_data_in,
    input logic        ready_out, 
    input logic [31:0] rd_data_out, 
 
    output logic [31:0] total_ops, 
    output logic [31:0] read_ops, 
    output logic [31:0] write_ops, 
    output logic [31:0] invalid_ops 
); 
    integer log_file; 
    initial begin 
          log_file = $fopen("monitor_log.txt","w"); 
          invalid_ops = 0; 
          write_ops = 0; 
          read_ops = 0; 
    end  
 
    
    always @(posedge clk_in or posedge rst_in) begin 
        if (rst_in) begin 
            read_ops = read_ops; 
            write_ops = write_ops; 
            write_ops = write_ops; 
            invalid_ops = invalid_ops; 
        end else  
            if (sel_in && wr_enable_in) begin 
                       write_ops = write_ops + 1;
                       $fwrite(log_file,"WRITE_OP: | Time : %0t | HWDATA : %h | tb_HWRITE: %h | HADDR: %h\n", $time , wr_data_in ,wr_enable_in, addr_in); 
            end else if (sel_in && !wr_enable_in) begin 
                       read_ops = read_ops + 1; 
                       $fwrite(log_file,"READ_OP: | Time : %0t | HRDATA : %h | tb_HWRITE: %h | HADDR: %h\n", $time , rd_data_out , wr_enable_in, addr_in); 
            end else if (ready_out && !sel_in && wr_enable_in) begin
                        invalid_ops = invalid_ops + 1; 
                        $fwrite(log_file,"INVALID_OP: | Time : %0t | HRDATA : %h | HWDATA: %h | tb_HWRITE: %h |  HADDR: %h\n", $time , rd_data_out , wr_data_in ,wr_enable_in, addr_in); 
            end else if(ready_out && !sel_in && !wr_enable_in) begin 
                       invalid_ops = invalid_ops + 1; 
                       $fwrite(log_file,"INVALID_OP: | Time : %0t | HRDATA : %h | HWDATA: %h | tb_HWRITE: %h |  HADDR: %h\n", $time , rd_data_out , wr_data_in ,wr_enable_in, addr_in); 
            end else if(ready_out && sel_in == 1'bx) begin 
                       invalid_ops = invalid_ops + 1; 
                       $fwrite(log_file,"INVALID_OP: | Time : %0t | HRDATA : %h | HWDATA: %h | tb_HWRITE: %h |  HADDR: %h\n", $time , rd_data_out , wr_data_in ,wr_enable_in, addr_in); 
                        end else if(ready_out && wr_enable_in == 1'bx) begin 
                       invalid_ops = invalid_ops + 1; 
                       $fwrite(log_file,"INVALID_OP: | Time : %0t | HRDATA : %h | HWDATA: %h | tb_HWRITE: %h |  HADDR: %h\n", $time , rd_data_out , wr_data_in , wr_enable_in , addr_in); 
            end  
            total_ops = read_ops + write_ops + invalid_ops; 
        end 
 
   final begin   
        $fclose(log_file); 
   end 
 
endmodule
