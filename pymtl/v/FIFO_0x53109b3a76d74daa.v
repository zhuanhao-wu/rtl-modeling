//-----------------------------------------------------------------------------
// FIFO_0x53109b3a76d74daa
//-----------------------------------------------------------------------------
// depth_width: 2
// data_width: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module FIFO_0x53109b3a76d74daa
(
  input  wire [   0:0] clk,
  output reg  [   0:0] empty_o,
  output reg  [   0:0] full_o,
  output reg  [   0:0] one_left,
  output reg  [  31:0] rd_data_o,
  input  wire [   0:0] rd_en_i,
  input  wire [   0:0] reset,
  input  wire [  31:0] wr_data_i,
  input  wire [   0:0] wr_en_i
);

  // wire declarations
  wire   [  31:0] mem_data_out;


  // register declarations
  reg    [   0:0] empty_int;
  reg    [   0:0] full_or_empty;
  reg    [   2:0] write_pointer;

  // localparam declarations
  localparam aw = 2;

  // read_plus_1 temporaries
  wire   [   0:0] read_plus_1$clk;
  wire   [   2:0] read_plus_1$in0;
  wire   [   2:0] read_plus_1$in1;
  wire   [   0:0] read_plus_1$reset;
  wire   [   0:0] read_plus_1$cin;
  wire   [   0:0] read_plus_1$cout;
  wire   [   2:0] read_plus_1$out;

  Adder_0x64f9bb3b020d2b2c read_plus_1
  (
    .clk   ( read_plus_1$clk ),
    .in0   ( read_plus_1$in0 ),
    .in1   ( read_plus_1$in1 ),
    .reset ( read_plus_1$reset ),
    .cin   ( read_plus_1$cin ),
    .cout  ( read_plus_1$cout ),
    .out   ( read_plus_1$out )
  );

  // mem temporaries
  wire   [  31:0] mem$wdata;
  wire   [   1:0] mem$waddr;
  wire   [   0:0] mem$clk;
  wire   [   0:0] mem$wen;
  wire   [   0:0] mem$ren;
  wire   [   1:0] mem$raddr;
  wire   [   0:0] mem$reset;
  wire   [  31:0] mem$rdata;

  _RAM_0x5c7c7e4a8c4f475e mem
  (
    .wdata ( mem$wdata ),
    .waddr ( mem$waddr ),
    .clk   ( mem$clk ),
    .wen   ( mem$wen ),
    .ren   ( mem$ren ),
    .raddr ( mem$raddr ),
    .reset ( mem$reset ),
    .rdata ( mem$rdata )
  );

  // read_pointer temporaries
  wire   [   0:0] read_pointer$reset;
  wire   [   0:0] read_pointer$en;
  wire   [   0:0] read_pointer$clk;
  wire   [   2:0] read_pointer$in_;
  wire   [   2:0] read_pointer$out;

  RegEnRst_0x1099485158c4776f read_pointer
  (
    .reset ( read_pointer$reset ),
    .en    ( read_pointer$en ),
    .clk   ( read_pointer$clk ),
    .in_   ( read_pointer$in_ ),
    .out   ( read_pointer$out )
  );

  // signal connections
  assign mem$clk            = clk;
  assign mem$raddr          = read_pointer$out[1:0];
  assign mem$ren            = rd_en_i;
  assign mem$reset          = reset;
  assign mem$waddr          = write_pointer[1:0];
  assign mem$wdata          = wr_data_i;
  assign mem$wen            = wr_en_i;
  assign mem_data_out       = mem$rdata;
  assign read_plus_1$clk    = clk;
  assign read_plus_1$in0    = 3'd1;
  assign read_plus_1$in1    = read_pointer$out;
  assign read_plus_1$reset  = reset;
  assign read_pointer$clk   = clk;
  assign read_pointer$en    = rd_en_i;
  assign read_pointer$in_   = read_plus_1$out;
  assign read_pointer$reset = reset;


  // PYMTL SOURCE:
  //
  // @s.tick_rtl
  // def block_sync():
  //             if s.reset:
  //                 s.write_pointer.next = 0
  //             if s.wr_en_i:
  //                 s.write_pointer.next = s.write_pointer + 1

  // logic for block_sync()
  always @ (posedge clk) begin
    if (reset) begin
      write_pointer <= 0;
    end
    else begin
    end
    if (wr_en_i) begin
      write_pointer <= (write_pointer+1);
    end
    else begin
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def block_comb():
  //             s.empty_int.value     = s.write_pointer[aw] == s.read_pointer.out[aw]
  //             s.full_or_empty.value = s.write_pointer[:aw] == s.read_pointer.out[:aw]
  //             s.full_o.value        = s.full_or_empty & ~s.empty_int
  //             s.empty_o.value       = s.full_or_empty & s.empty_int
  //             s.one_left.value      = (s.read_pointer.out + 1) == s.write_pointer
  //             s.rd_data_o.value     = s.mem_data_out if s.rd_en_i else 0

  // logic for block_comb()
  always @ (*) begin
    empty_int = (write_pointer[aw] == read_pointer$out[aw]);
    full_or_empty = (write_pointer[(aw)-1:0] == read_pointer$out[(aw)-1:0]);
    full_o = (full_or_empty&~empty_int);
    empty_o = (full_or_empty&empty_int);
    one_left = ((read_pointer$out+1) == write_pointer);
    rd_data_o = rd_en_i ? mem_data_out : 0;
  end


endmodule // FIFO_0x53109b3a76d74daa
`default_nettype wire

//-----------------------------------------------------------------------------
// Adder_0x64f9bb3b020d2b2c
//-----------------------------------------------------------------------------
// nbits: 3
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Adder_0x64f9bb3b020d2b2c
(
  input  wire [   0:0] cin,
  input  wire [   0:0] clk,
  output wire [   0:0] cout,
  input  wire [   2:0] in0,
  input  wire [   2:0] in1,
  output wire [   2:0] out,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [   3:0] t0__0;
  reg    [   3:0] t1__0;
  reg    [   3:0] temp;

  // localparam declarations
  localparam twidth = 4;

  // signal connections
  assign cout = temp[3];
  assign out  = temp[2:0];


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //
  //       # Zero extend the inputs by one bit so we can generate an extra
  //       # carry out bit
  //
  //       t0 = zext( s.in0, twidth )
  //       t1 = zext( s.in1, twidth )
  //
  //       s.temp.value = t0 + t1 + s.cin

  // logic for comb_logic()
  always @ (*) begin
    t0__0 = { { twidth-3 { 1'b0 } }, in0[2:0] };
    t1__0 = { { twidth-3 { 1'b0 } }, in1[2:0] };
    temp = ((t0__0+t1__0)+cin);
  end


endmodule // Adder_0x64f9bb3b020d2b2c
`default_nettype wire

//-----------------------------------------------------------------------------
// _RAM_0x5c7c7e4a8c4f475e
//-----------------------------------------------------------------------------
// num_entries: 4
// data_nbits: 32
// reset_value: 0
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module _RAM_0x5c7c7e4a8c4f475e
(
  input  wire [   0:0] clk,
  input  wire [   1:0] raddr,
  output reg  [  31:0] rdata,
  input  wire [   0:0] ren,
  input  wire [   0:0] reset,
  input  wire [   1:0] waddr,
  input  wire [  31:0] wdata,
  input  wire [   0:0] wen
);

  // wire declarations
  wire   [  31:0] mem$000;
  wire   [  31:0] mem$001;
  wire   [  31:0] mem$002;
  wire   [  31:0] mem$003;


  // localparam declarations
  localparam num_entries = 4;
  localparam reset_value = 0;

  // loop variable declarations
  integer i;


  // array declarations
  reg    [  31:0] mem[0:3];
  assign mem$000 = mem[  0];
  assign mem$001 = mem[  1];
  assign mem$002 = mem[  2];
  assign mem$003 = mem[  3];

  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def seq_logic():
  //             if s.reset:
  //                 for i in xrange(s.num_entries):
  //                     s.mem[i].next = s.reset_value
  //             elif s.wen:
  //                 s.mem[s.waddr].next = s.wdata

  // logic for seq_logic()
  always @ (posedge clk) begin
    if (reset) begin
      for (i=0; i < num_entries; i=i+1)
      begin
        mem[i] <= reset_value;
      end
    end
    else begin
      if (wen) begin
        mem[waddr] <= wdata;
      end
      else begin
      end
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //             s.rdata.value = s.mem[ s.raddr ]

  // logic for comb_logic()
  always @ (*) begin
    rdata = mem[raddr];
  end


endmodule // _RAM_0x5c7c7e4a8c4f475e
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEnRst_0x1099485158c4776f
//-----------------------------------------------------------------------------
// dtype: 3
// reset_value: 0
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEnRst_0x1099485158c4776f
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [   2:0] in_,
  output reg  [   2:0] out,
  input  wire [   0:0] reset
);

  // localparam declarations
  localparam reset_value = 0;



  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def seq_logic():
  //       if s.reset:
  //         s.out.next = reset_value
  //       elif s.en:
  //         s.out.next = s.in_

  // logic for seq_logic()
  always @ (posedge clk) begin
    if (reset) begin
      out <= reset_value;
    end
    else begin
      if (en) begin
        out <= in_;
      end
      else begin
      end
    end
  end


endmodule // RegEnRst_0x1099485158c4776f
`default_nettype wire

