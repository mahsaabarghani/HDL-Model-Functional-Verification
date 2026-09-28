module Checker (
    input logic         clk,
    input logic         reset,
    input logic [31:0]  golden_HRDATA,
    input logic [31:0]  tb_HRDATA,
    input logic         golden_HREADY,
    input logic         tb_HREADY,
    input logic [31:0]  address,
    output logic [15:0] error_count
);

    integer filecheck;

    initial begin
        filecheck = $fopen("checker_output.txt", "w");
        if (filecheck == 0) begin
            $display("Error: Could not open file checker_output.txt");
            $finish;
        end
    end

    logic [15:0] local_error_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            local_error_count <= 0;
        end else begin
            if (golden_HREADY && tb_HREADY) begin
                if (golden_HRDATA != tb_HRDATA) begin
                    local_error_count <= local_error_count + 1;
                    $fwrite(filecheck, "Error: Time %0t Address %h Golden %h DUV %h\n", $time, address, golden_HRDATA, tb_HRDATA);
                end else if(golden_HRDATA == tb_HRDATA) begin
                    $fwrite(filecheck, "OK: Time %0t Address %h Golden %h DUV %h\n", $time, address, golden_HRDATA, tb_HRDATA);
                end
             else begin
                $fwrite(filecheck, "Not Ready: Time %0t Address %h Golden %h DUV %h\n", $time, address, golden_HRDATA, tb_HRDATA);
            end
        end
        end
    end

    assign error_count = local_error_count;

    final begin
        $fclose(filecheck);
    end
endmodule
