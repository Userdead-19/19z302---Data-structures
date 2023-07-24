module speed (
  input clk,
  input rst,
  input [7:0] threshold,
  input [7:0] af,
  input [7:0] bf,
  output reg [7:0] speed,
  output reg [7:0] o_af,
  output reg [7:0] o_bf
);

  reg [7:0] temp_af;
  reg [7:0] temp_bf;

  always @(posedge clk) begin
    if (rst) begin
      temp_af <= 0;
      temp_bf <= 0;
      speed <= 0;
    end else begin
      if (speed < threshold) begin
        temp_af <= af + 10;
      end else if (speed > threshold) begin
        temp_bf <= threshold - speed;
        temp_af <= 0;
      end
    end
  end

  always @* begin
    speed = speed + af - bf;
    o_af = temp_af;
    o_bf = temp_bf;
  end

endmodule

module speed_tb;
  reg clk;
  reg rst;
  reg [7:0] threshold;
  reg [7:0] af;
  reg [7:0] bf;
  wire [7:0] speed;
  wire [7:0] o_af;
  wire [7:0] o_bf;

  speed speedtb (
    .clk(clk),
    .rst(rst),
    .threshold(threshold),
    .af(af),
    .bf(bf),
    .speed(speed),
    .o_af(o_af),
    .o_bf(o_bf)
  );

  initial begin
    rst = 1;
    clk = 0;
    threshold = 100;
    af = 0;
    bf = 0;
    #10 rst = 0;
  end

    initial begin
        repeat(100) begin
            #5 clk = ~clk;
        end
    end
  always @(negedge clk) begin
    af = o_af;
    bf = o_bf;
  end

  initial begin
    $monitor("time = %0d, clk=%b rst=%b threshold=%d af=%d bf=%d speed=%d", $time, clk, rst, threshold, af, bf, speed);
  end

endmodule
