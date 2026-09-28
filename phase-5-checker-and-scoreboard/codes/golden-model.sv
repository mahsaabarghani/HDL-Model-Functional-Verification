module Golden_Model_sdram(
    input        clk_sys,        
    input        rst_sys,
    input        write_enable,
    input        select_line, 
    input [31:0] write_data_in,
    input [31:0] addr_in,      

    output reg        ready_out,
    output reg [31:0] read_data_out
);

    parameter DATA_WIDTH = 32;
    parameter ROWS = 16384; 
    parameter COLUMNS = 512;
    parameter BANKS = 4;

    reg [DATA_WIDTH-1:0] sdram_memory [0:BANKS-1][0:ROWS-1][0:COLUMNS-1];

    reg [1:0] bank_sel;
    reg [13:0] row_sel;
    reg [8:0] col_sel;

    typedef enum logic [3:0] {
        ST_IDLE = 4'b0000,
        ST_READ_ACT = 4'b0001,
        ST_READ_NOP1 = 4'b0010,
        ST_READ_CAS = 4'b0011,
        ST_READ_NOP2 = 4'b0100,
        ST_READ_NOP3 = 4'b0101,
        ST_WRITE_ACT = 4'b0110,
        ST_WRITE_NOP1 = 4'b0111,
        ST_WRITE_CAS = 4'b1000,
        ST_WRITE_NOP2 = 4'b1001,
        ST_WRITE_NOP3 = 4'b1010
    } state_t;

    state_t curr_state, next_state;

    reg [31:0] data_buffer;
    integer log_file;
    integer scenario_counter;

    
    always @(posedge clk_sys or posedge rst_sys) begin
        if (rst_sys) begin
            curr_state <= ST_IDLE;
            ready_out <= 1'b1;
        end else begin
            curr_state <= next_state;
        end
    end

    always @(*) begin
        next_state = curr_state;
        ready_out = 1'b1;

        case (curr_state)
            ST_IDLE: begin
                if (select_line) begin
                    if (write_enable) begin
                        next_state = ST_WRITE_ACT;
                        ready_out = 1'b0;
                    end else begin
                        next_state = ST_READ_ACT;
                        ready_out = 1'b0;
                    end
                end
            end

            ST_READ_ACT: begin next_state = ST_READ_NOP1; end
            ST_READ_NOP1: begin next_state = ST_READ_CAS; end
            ST_READ_CAS: begin next_state = ST_READ_NOP2; end
            ST_READ_NOP2: begin next_state = ST_READ_NOP3; end
            ST_READ_NOP3: begin next_state = ST_IDLE; end
            ST_WRITE_ACT: begin next_state = ST_WRITE_NOP1; end
            ST_WRITE_NOP1: begin next_state = ST_WRITE_CAS; end
            ST_WRITE_CAS: begin next_state = ST_WRITE_NOP2; end
            ST_WRITE_NOP2: begin next_state = ST_WRITE_NOP3; end
            ST_WRITE_NOP3: begin next_state = ST_IDLE; end
            default: begin next_state = ST_IDLE; end

        endcase
    end

    always @(posedge clk_sys) begin
        if (rst_sys) begin
            row_sel <= 14'bx;
            col_sel <= 9'bx;
            bank_sel <= 2'bx;
            read_data_out <= 32'bx;
            data_buffer <= 32'bx;
        end else begin
            case (curr_state)
                ST_READ_ACT: begin
                    row_sel <= addr_in[13:0];
                    bank_sel <= addr_in[15:14];
                end

                ST_WRITE_ACT: begin
                    row_sel <= addr_in[13:0];
                    bank_sel <= addr_in[15:14];
                end

                ST_READ_CAS: begin
                    col_sel <= addr_in[24:16];
                    data_buffer <= sdram_memory[bank_sel][row_sel][col_sel];
                end

                ST_WRITE_CAS: begin
                    col_sel <= addr_in[24:16];
                    data_buffer <= write_data_in;
                end

                ST_READ_NOP2: begin
                    read_data_out <= data_buffer;
                end

                ST_WRITE_NOP3: begin
                    sdram_memory[bank_sel][row_sel][col_sel] <= data_buffer;
                end

                default: begin
                end
            endcase
        end
    end
    
    final begin
        $fclose(log_file);
    end
endmodule
