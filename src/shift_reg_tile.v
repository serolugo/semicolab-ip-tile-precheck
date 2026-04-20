`timescale 1ns / 1ps

module shift_reg_tile #(
    parameter REG_WIDTH     = 32,
    parameter CSR_IN_WIDTH  = 16,
    parameter CSR_OUT_WIDTH = 16
)(
    input  wire                      clk,
    input  wire                      arst_n,
    input  wire [CSR_IN_WIDTH-1:0]   csr_in,
    input  wire [REG_WIDTH-1:0]      data_reg_a,
    input  wire [REG_WIDTH-1:0]      data_reg_b,
    output reg  [REG_WIDTH-1:0]      data_reg_c,
    output wire [CSR_OUT_WIDTH-1:0]  csr_out,
    output wire                      csr_in_re
    
);

    // csr_in[0] = shift enable
    // csr_in[1] = load enable
    // data_reg_a = parallel load data
    // data_reg_b = shift amount (1 to 8)
    // data_reg_c = shift register output

    always @(posedge clk or negedge arst_n) begin
        if (!arst_n)
            data_reg_c <= 32'b0;
        else if (csr_in[1])
            data_reg_c <= data_reg_a;
        else if (csr_in[0])
            data_reg_c <= data_reg_c >> data_reg_b[4:0];
    end

    assign csr_out    = {14'b0, csr_in[1], csr_in[0]};
    assign csr_in_re  = 1'b1;


endmodule
