module memory_controller(
    input clk,
    input [31:0] memory_val,
    input [9:0] address,
    input read,
    input write,
    output reg [31:0] value
);

    reg [31:0] memory_bank [0:1023];
    reg [31:0] cache_data [0:31];      
    reg        cache_valid [0:31];

    wire [4:0] index = address[4:0];   

    always @(posedge clk) begin
        if (write) begin
            memory_bank[address] <= memory_val;
            cache_data[index] <= memory_val;     
            cache_valid[index] <= 1'b1;
        end
        else if (read) begin
            if (cache_valid[index]) begin
                value <= cache_data[index];     
            end else begin
                value <= memory_bank[address];  
                cache_data[index] <= memory_bank[address]; 
                cache_valid[index] <= 1'b1;
            end
        end
    end

endmodule
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

    always #5 clk = ~clk;  

    initial begin
        clk = 0;
        address = 10'd0;
        memory_val = 32'd42;
        write = 1;
        read = 0;
        #10;  

        write = 0;
        read = 1;
        #10;

        $display("Read value = %d", value);
        $finish;
    end
endmodule
