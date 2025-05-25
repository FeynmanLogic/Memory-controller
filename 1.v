//code written by Dhruv Kulkarni, refined by AI
module memory_controller(
    input clk,
    input [31:0] memory_val,
    input [9:0] address,
    input read,
    input write,
    output reg [31:0] value
);
integer i,flag;
integer min_val, min_index;

    reg [31:0] memory_bank [0:1023];
    reg [31:0] cache_data [0:31];      
    reg        cache_valid [0:31];
    reg  [31:0]      cache_indexes[0:31];
    wire [4:0] index = address[4:0];   
    //my thinkiing is to add numbers 
    //and then find the min among them and calculate which index is to be eliminated

    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            cache_valid[i] = 0;
            cache_indexes[i] = 0;
        end
    end
    always @(posedge clk) begin
        if (write) begin
            memory_bank[address] <= memory_val;
            cache_data[index] <= memory_val;     
            cache_valid[index] <= 1'b1;
            cache_indexes[index] <= cache_indexes[index]+1;
        end
        flag=0;
        for (i=0;i<32;i=i+1) begin
                    flag=flag+cache_valid[i];
        end
        if (flag ==32)

        begin
    //will write LRU replacement policy here
        min_val = 32'hFFFF;
        for (i = 0; i < 32; i = i + 1) begin
        if (cache_indexes[i] < min_val) begin
            min_val = cache_indexes[i];
            min_index = i;
        end
        end
        cache_valid[min_index]=1'b0;
        cache_indexes[min_index]=0;
        end
        else if (read) begin
            if (cache_valid[index]) begin
                value <= cache_data[index];     
                cache_indexes[index] <= cache_indexes[index]+1;
            end else begin
                value <= memory_bank[address];  
                cache_data[index] <= memory_bank[address]; 
                cache_valid[index] <= 1'b1;
                cache_indexes[index] <= cache_indexes[index]+1;
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
