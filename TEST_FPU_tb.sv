`timescale 1ns/1ps

module test_fpu_bf16_ext_edge_tb;
  // Parameters for bfloat16 FPU
  parameter DATA_WIDTH = 16;
  parameter CTRL_WIDTH = 4;

  // Clock and Reset signals
  reg clk;
  reg rst_n;

  // FPU interface signals
  reg [DATA_WIDTH-1:0] in_a;
  reg [DATA_WIDTH-1:0] in_b;
  reg [CTRL_WIDTH-1:0] op_select; // Mapping: 0 = ADD, 1 = MAC, 2 = MUL, 3 = EQ, 4 = NE, 5 = LE, 6 = LT, 7 = GE, 8 = GT
  reg write_en;
  reg clear_acc;
  wire [DATA_WIDTH-1:0] out;
  wire [4:0] exc_flag;

  // Instantiate the FPU Core DUT (bfloat16 configuration)
  // Here, the DUT is the TEST_FPU module.
  TEST_FPU dut (
    .clk(clk),
    .rst_n(rst_n),
    .IN_A(in_a),
    .IN_B(in_b),
    .OP_SELECT(op_select),
    .WRITE_EN(write_en),
    .CLR_ACC(clear_acc),
    .OUT_C(out),
    .OUT_EXC_FLAGS(exc_flag)
  );

  // Clock generation: 10 ns period
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Main test sequence: basic arithmetic, comparisons and edge-case tests.
  initial begin
    // Initialize signals and apply reset
    rst_n = 0;
    write_en = 0;
    clear_acc = 0;
    op_select = 0;
    in_a = 0;
    in_b = 0;
    #20;
    
    // Deassert reset
    rst_n = 1;
    #10;
    
    // --- Basic Arithmetic Tests ---
    // Test 1: ADD (op_select = 0)
    // 3.5 (16'h4060) + 1.5 (16'h3FC0) ? 5.0 (expected ~16'h40A0)
    op_select = 4'd0;
    in_a = 16'h4060;
    in_b = 16'h3FC0;
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 ADD Test: in_a = %h, in_b = %h, out = %h, exc_flag = %h", in_a, in_b, out, exc_flag);
    
    // Test 2: MUL (op_select = 2)
    // 1.0 (16'h3F80) * 2.0 (16'h4000) = 2.0 (16'h4000)
    op_select = 4'd2;
    in_a = 16'h3F80;
    in_b = 16'h4000;
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 MUL Test: in_a = %h, in_b = %h, out = %h, exc_flag = %h", in_a, in_b, out, exc_flag);

    // Test 3: MAC (op_select = 1)
    // Clear accumulator then accumulate: 1.0 (16'h3F80) * 2.0 (16'h4000) = 2.0
    op_select = 4'd1;
    clear_acc = 1; #10; clear_acc = 0;
    write_en = 1;
    in_a = 16'h3F80; // 1.0
    in_b = 16'h4000; // 2.0
    #10; write_en = 0;
    #20;
    $display("BF16 MAC Test: in_a = %h, in_b = %h, out = %h, exc_flag = %h", in_a, in_b, out, exc_flag);
    
    // --- Comparison Tests ---
    // Test 4: EQ (op_select = 3) - Equal: 1.0 == 1.0 should yield TRUE.
    op_select = 4'd3;
    in_a = 16'h3F80;
    in_b = 16'h3F80;
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 EQ True: in_a = %h, in_b = %h, out = %h", in_a, in_b, out);

    // Test 5: EQ (op_select = 3) - Unequal: 1.0 == 2.0 should yield FALSE.
    op_select = 4'd3;
    in_a = 16'h3F80;
    in_b = 16'h4000;
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 EQ False: in_a = %h, in_b = %h, out = %h", in_a, in_b, out);

    // Test 6: NE (op_select = 4) - Not Equal: 1.0 != 2.0 should yield TRUE.
    op_select = 4'd4;
    in_a = 16'h3F80;
    in_b = 16'h4000;
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 NE True: in_a = %h, in_b = %h, out = %h", in_a, in_b, out);
    
    // Test 7: NE (op_select = 4) - Equal: 1.0 != 1.0 should yield FALSE.
    op_select = 4'd4;
    in_a = 16'h3F80;
    in_b = 16'h3F80;
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 NE False: in_a = %h, in_b = %h, out = %h", in_a, in_b, out);

    // Test 8: LE (op_select = 5) - 1.0 <= 2.0 should yield TRUE.
    op_select = 4'd5;
    in_a = 16'h3F80;
    in_b = 16'h4000;
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 LE True: in_a = %h, in_b = %h, out = %h", in_a, in_b, out);
    
    // Test 9: LE (op_select = 5) - 2.0 <= 1.0 should yield FALSE.
    op_select = 4'd5;
    in_a = 16'h4000;
    in_b = 16'h3F80;
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 LE False: in_a = %h, in_b = %h, out = %h", in_a, in_b, out);

    // Test 10: LT (op_select = 6) - 1.0 < 2.0 should yield TRUE.
    op_select = 4'd6;
    in_a = 16'h3F80;
    in_b = 16'h4000;
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 LT True: in_a = %h, in_b = %h, out = %h", in_a, in_b, out);
    
    // Test 11: LT (op_select = 6) - 2.0 < 1.0 should yield FALSE.
    op_select = 4'd6;
    in_a = 16'h4000;
    in_b = 16'h3F80;
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 LT False: in_a = %h, in_b = %h, out = %h", in_a, in_b, out);

    // Test 12: GE (op_select = 7) - 2.0 >= 2.0 should yield TRUE.
    op_select = 4'd7;
    in_a = 16'h4000;
    in_b = 16'h4000;
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 GE True: in_a = %h, in_b = %h, out = %h", in_a, in_b, out);
    
    // Test 13: GE (op_select = 7) - 1.0 >= 2.0 should yield FALSE.
    op_select = 4'd7;
    in_a = 16'h3F80;
    in_b = 16'h4000;
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 GE False: in_a = %h, in_b = %h, out = %h", in_a, in_b, out);

    // Test 14: GT (op_select = 8) - 2.0 > 1.0 should yield TRUE.
    op_select = 4'd8;
    in_a = 16'h4000;
    in_b = 16'h3F80;
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 GT True: in_a = %h, in_b = %h, out = %h", in_a, in_b, out);
    
    // Test 15: GT (op_select = 8) - 1.0 > 2.0 should yield FALSE.
    op_select = 4'd8;
    in_a = 16'h3F80;
    in_b = 16'h4000;
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 GT False: in_a = %h, in_b = %h, out = %h", in_a, in_b, out);

    // --- Edge-Case Tests ---
    // Test 16: Zero Comparison (EQ) - Positive zero (16'h0000) vs. Negative zero (16'h8000)
    op_select = 4'd3; // EQ operation
    in_a = 16'h0000; // +0
    in_b = 16'h8000; // -0; these should be considered equal
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 EQ Zero Test: in_a = %h, in_b = %h, out = %h", in_a, in_b, out);

    // Test 17: Operation with Infinity
    // bfloat16 positive infinity: 16'h7F80 (exponent all ones, fraction zero)
    op_select = 4'd0; // ADD operation
    in_a = 16'h7F80; // +infinity
    in_b = 16'h3F80; // 1.0
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 ADD Infinity Test: in_a = %h, in_b = %h, out = %h, exc_flag = %h", in_a, in_b, out, exc_flag);

    // Test 18: Operation with NaN
    // bfloat16 NaN: for example, 16'h7FC1 (exponent all ones, nonzero fraction)
    op_select = 4'd0; // ADD operation
    in_a = 16'h7FC1; // NaN
    in_b = 16'h3F80; // 1.0
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 ADD NaN Test: in_a = %h, in_b = %h, out = %h, exc_flag = %h", in_a, in_b, out, exc_flag);

    // Test 19: Comparison with NaN (EQ) - should yield FALSE
    op_select = 4'd3; // EQ operation
    in_a = 16'h7FC1; // NaN
    in_b = 16'h3F80; // 1.0
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 EQ NaN Test: in_a = %h, in_b = %h, out = %h", in_a, in_b, out);

    // Test 20: Comparison with NaN (NE) - should yield TRUE
    op_select = 4'd4; // NE operation
    in_a = 16'h7FC1; // NaN
    in_b = 16'h3F80; // 1.0
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 NE NaN Test: in_a = %h, in_b = %h, out = %h", in_a, in_b, out);

    // Test 21: Underflow Test - Add very small numbers
    // Example: smallest normalized (16'h0080) + a very small increment (16'h0001)
    op_select = 4'd0; // ADD
    in_a = 16'h0080;
    in_b = 16'h0001;
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 ADD Underflow Test: in_a = %h, in_b = %h, out = %h, exc_flag = %h", in_a, in_b, out, exc_flag);

    // Test 22: Overflow Test - Add two large numbers near maximum finite value
    op_select = 4'd0; // ADD
    in_a = 16'h7F7F;
    in_b = 16'h7F7F;
    write_en = 1; #10; write_en = 0;
    #20;
    $display("BF16 ADD Overflow Test: in_a = %h, in_b = %h, out = %h, exc_flag = %h", in_a, in_b, out, exc_flag);

    $finish;
  end

endmodule
