module testbench;
    reg clk;
    reg [31:0] memory_val;
    reg [9:0] address;
    reg read, write;
    wire [31:0] value;

    memory_controller uut (
        .clk(clk),
        .memory_val(memory_val),
        .address(address),
        .read(read),
        .write(write),
        .value(value)
    );

    always #5 clk = ~clk;  // Toggle clock every 5 time units

    initial begin
        clk = 0;
        address = 10'd0;
        memory_val = 32'd42;
        write = 1;
        read = 0;
        #10;  // wait one clock

        write = 0;
        read = 1;
        #10;

        $display("Read value = %d", value);
        $finish;
    end
endmodule
