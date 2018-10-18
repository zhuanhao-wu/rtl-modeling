// Generated automatically via PyRTL
// As one initial test of synthesis, map to FPGA with:
//   yosys -p "synth_xilinx -top toplevel" thisfile.v

module toplevel(one_left, full_o, rd_data_o, wr_en_i, rd_en_i, reset, empty_o, wr_data_i, clk);
    input rd_en_i;
    input reset;
    input wr_en_i;
    input[31:0] wr_data_i;
    input clk;
    output full_o;
    output[31:0] rd_data_o;
    output empty_o;
    output one_left;

    reg[2:0] read_pointer;
    reg[2:0] write_pointer;
    wire[2:0] tmp8;
    wire[3:0] tmp5;
    wire[31:0] const_11_0;
    wire const_5_0;
    wire[2:0] tmp16;
    wire[3:0] tmp9;
    wire tmp17;
    wire[3:0] tmp15;
    wire ren;
    wire[1:0] waddr;
    wire tmp24;
    wire[31:0] wdata;
    wire const_7_0;
    wire[2:0] tmp6;
    wire[3:0] tmp4;
    wire[31:0] tmp33;
    wire const_2_0;
    wire[31:0] rdata;
    wire tmp19;
    reg[31:0] tmp32;
    wire[2:0] const_3_0;
    wire tmp29;
    wire[1:0] tmp34;
    wire tmp18;
    wire tmp3;
    wire[1:0] tmp0;
    wire[1:0] tmp20;
    wire[3:0] tmp11;
    wire[1:0] tmp35;
    wire[1:0] tmp7;
    wire[2:0] tmp1;
    wire[1:0] tmp26;
    wire[1:0] raddr;
    wire[3:0] tmp2;
    wire empty_int;
    wire const_9_0;
    wire const_0_1;
    wire const_1_0;
    wire[31:0] const_12_0;
    wire[3:0] tmp28;
    wire const_8_1;
    wire[2:0] tmp27;
    wire full_or_empty;
    wire[3:0] tmp14;
    wire tmp13;
    wire[1:0] tmp21;
    wire const_4_1;
    wire tmp25;
    wire[3:0] tmp30;
    wire tmp10;
    wire tmp23;
    wire const_10_0;
    wire const_6_0;
    wire[3:0] tmp12;
    wire wen;
    wire tmp31;
    wire[31:0] tmp36;
    wire tmp22;

    reg[31:0] mem_0[3:0];

    assign const_9_0 = 0;
    assign const_5_0 = 0;
    assign const_1_0 = 0;
    assign const_12_0 = 0;
    assign const_0_1 = 1;
    assign const_3_0 = 0;
    assign const_4_1 = 1;
    assign const_10_0 = 0;
    assign const_11_0 = 0;
    assign const_7_0 = 0;
    assign const_8_1 = 1;
    assign const_2_0 = 0;
    assign const_6_0 = 0;
    always @( posedge clk )
    begin
        tmp32 <= mem_0[raddr];
    end
    assign tmp20 = {write_pointer[1], write_pointer[0]};
    assign tmp35 = {write_pointer[1], write_pointer[0]};
    assign tmp21 = {read_pointer[1], read_pointer[0]};
    assign tmp16 = {tmp15[2], tmp15[1], tmp15[0]};
    assign tmp0 = {const_1_0, const_1_0};
    assign tmp33 = ren ? tmp32 : const_11_0;
    assign waddr = tmp35;
    assign tmp12 = wr_en_i ? tmp9 : tmp11;
    assign tmp13 = {const_7_0};
    assign tmp15 = reset ? tmp14 : tmp12;
    assign tmp4 = {tmp3, read_pointer};
    assign empty_int = tmp19;
    assign wen = wr_en_i;
    assign tmp3 = {const_2_0};
    assign one_left = tmp31;
    assign tmp8 = {tmp7, const_4_1};
    assign tmp25 = full_or_empty & empty_int;
    assign ren = rd_en_i;
    assign tmp6 = {tmp5[2], tmp5[1], tmp5[0]};
    assign tmp9 = write_pointer + tmp8;
    assign tmp22 = tmp20 == tmp21;
    assign tmp27 = {tmp26, const_8_1};
    assign tmp34 = {read_pointer[1], read_pointer[0]};
    assign tmp1 = {tmp0, const_0_1};
    assign raddr = tmp34;
    assign tmp7 = {const_5_0, const_5_0};
    assign rd_data_o = tmp36;
    assign tmp5 = rd_en_i ? tmp2 : tmp4;
    assign empty_o = tmp25;
    assign tmp26 = {const_9_0, const_9_0};
    assign tmp28 = read_pointer + tmp27;
    assign wdata = wr_data_i;
    assign tmp24 = full_or_empty & tmp23;
    assign full_o = tmp24;
    assign tmp14 = {tmp13, const_3_0};
    assign tmp31 = tmp30 == tmp28;
    assign full_or_empty = tmp22;
    assign tmp17 = {write_pointer[2]};
    assign rdata = tmp33;
    assign tmp29 = {const_10_0};
    assign tmp30 = {tmp29, write_pointer};
    assign tmp10 = {const_6_0};
    assign tmp23 = ~empty_int;
    assign tmp11 = {tmp10, write_pointer};
    assign tmp2 = tmp1 + read_pointer;
    assign tmp36 = rd_en_i ? rdata : const_12_0;
    assign tmp19 = tmp17 == tmp18;
    assign tmp18 = {read_pointer[2]};

    always @( posedge clk )
    begin
        if (wen) begin
                mem_0[waddr] <= wdata;
        end
        read_pointer <= tmp6;
        write_pointer <= tmp16;
    end
endmodule

