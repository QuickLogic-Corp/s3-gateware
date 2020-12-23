
`timescale 1ns / 10ps

module FLL_I2S ( 
                // AHB-To_FPGA Bridge I/F
                WBs_ADR_i,
                WBs_CYC_i,
                WBs_BYTE_STB_i,
                WBs_WE_i,
                WBs_STB_i,
                WBs_DAT_i,
                WBs_CLK_i,
                WBs_RST_i,
                WBs_DAT_o,
                WBs_ACK_o,

                // input clock, from the external master
                bitclk_master,

                // local bitclk
                bitclk_local,

                // interrupts to the M4 processor, to speed up or slow down the local clock
                Interrupt_speedup,
                Interrupt_slowdown,
                
                // debug
                master_wordcnt_is_ahead_o,
                local_wordcnt_is_ahead_o
);


//------Port Parameters----------------

    //  Address offsets shown below are byte offsets, so the 2 LSB's (on the right) should be 0's.

// This parameter can/should be over-ridden when this module is instantiated,
//  since it must be unique across all other modules in the FPGA.
parameter   MODULE_OFFSET       = 17'h0_1000;

// This is the value that is returned when a non-implemented register is read.
parameter   DEFAULT_REG_VALUE   = 32'hFAB_DEF_AC;

// This is the # of bit clock per word
parameter   BIT_CLOCKS_PER_WORD     = 64;

// This is the default value for the sampling time (after reset), in local bit clks.
//  After the # of local clocks specified here, a calculation is done to determine if the
//  local clock frequency needs to be adjusted.
//  This sampling time can be over-written by s/w.
parameter   SAMPLE_LENGTH_DEFAULT = 32'h0000_0400;

// This is the default value for the interval between samples (after reset), in local bit clks.
//  This is the # of local clocks to wait before starting another sample. A value of 0 will
//  result in 0 delay between samples (continuous sampling).
//  This interval can be over-written by s/w.
parameter   SAMPLE_GAP_DEFAULT  = 32'h0000_0400;



//------Port Signals-------------------

// AHB-To_FPGA Bridge I/F
input   [16:0]  WBs_ADR_i           ;  // Address Bus                   to   FPGA
input           WBs_CYC_i           ;  // Cycle Chip Select             to   FPGA 
input   [3:0]   WBs_BYTE_STB_i      ;  // Byte Select                   to   FPGA
input           WBs_WE_i            ;  // Write Enable                  to   FPGA
input           WBs_STB_i           ;  // Strobe Signal                 to   FPGA
input   [31:0]  WBs_DAT_i           ;  // Write Data Bus                to   FPGA
input           WBs_CLK_i           ;  // FPGA Clock                    from FPGA
input           WBs_RST_i           ;  // FPGA Reset                    to   FPGA
output  [31:0]  WBs_DAT_o           ;  // Read Data Bus                 from FPGA
output          WBs_ACK_o           ;  // Transfer Cycle Acknowledge    from FPGA

input           bitclk_master;
input           bitclk_local;

output          Interrupt_speedup;
output          Interrupt_slowdown;

// Debug signals
output          master_wordcnt_is_ahead_o;
output          local_wordcnt_is_ahead_o;

// FPGA Global Signals
wire            WBs_CLK_i           ;  // Wishbone FPGA Clock
wire            WBs_RST_i           ;  // Wishbone FPGA Reset

// Wishbone Bus Signals
wire    [16:0]  WBs_ADR_i           ;  // Wishbone Address Bus
wire            WBs_CYC_i           ;  // Wishbone Client Cycle  Strobe (i.e. Chip Select) 
wire    [3:0]   WBs_BYTE_STB_i      ;  // Wishbone Byte   Enables
wire            WBs_WE_i            ;  // Wishbone Write  Enable Strobe
wire            WBs_STB_i           ;  // Wishbone Transfer      Strobe
wire    [31:0]  WBs_DAT_i           ;  // Wishbone Write  Data Bus
 
reg     [31:0]  WBs_DAT_o           ;  // Wishbone Read   Data Bus


reg             WBs_ACK_o           ;  // Wishbone Client Acknowledge

wire            bitclk_master;
wire            bitclk_local;

wire            Interrupt_speedup;
wire            Interrupt_slowdown;


//======Begin Wishbone register interface======

//------Internal Parameters---------------

// Allow for up to 256 registers in this module
localparam  ADDRWIDTH   =  8;

// register offsets.
    //  Address offsets shown below are byte offsets, so the 2 LSB's (on the right) should be 0's.
localparam  REG_ADDR_CTRL       =  8'h00        ; 
localparam  REG_ADDR_SAMP_LEN   =  8'h04        ; 
localparam  REG_ADDR_SAMP_GAP   =  8'h08        ; 
localparam  REG_ADDR_WC_DIFF    =  8'h0C        ;
localparam  REG_ADDR_WC         =  8'h10        ;
localparam  REG_ADDR_WC_MSTR    =  8'h14        ;
localparam  REG_ADDR_WC_LOCAL   =  8'h18        ;
localparam  REG_ADDR_SCNT_MSTR  =  8'h1C        ;


//------Internal Signals---------------

wire            module_decode   ;

wire            REG_WE_CTRL     ;
wire            REG_WE_SAMP_LEN ;
wire            REG_WE_SAMP_GAP ;

wire            WBs_ACK_o_nxt   ;

reg             reg_enable      ;
reg     [31:0]  reg_sample_len  ;
reg     [31:0]  reg_sample_gap  ;

// debug 
reg     [31:0]  wordcnt_diff    ;
reg     [15:0]  scmaster        ;


assign module_decode = (WBs_ADR_i[16:ADDRWIDTH] == MODULE_OFFSET[16:ADDRWIDTH]);

assign REG_WE_CTRL = ( WBs_ADR_i[ADDRWIDTH-1:2] == REG_ADDR_CTRL[ADDRWIDTH-1:2] ) && module_decode && WBs_CYC_i && WBs_STB_i && WBs_WE_i && (~WBs_ACK_o);
assign REG_WE_SAMP_LEN = ( WBs_ADR_i[ADDRWIDTH-1:2] == REG_ADDR_SAMP_LEN[ADDRWIDTH-1:2] ) && module_decode && WBs_CYC_i && WBs_STB_i && WBs_WE_i && (~WBs_ACK_o);
assign REG_WE_SAMP_GAP = ( WBs_ADR_i[ADDRWIDTH-1:2] == REG_ADDR_SAMP_GAP[ADDRWIDTH-1:2] ) && module_decode && WBs_CYC_i && WBs_STB_i && WBs_WE_i && (~WBs_ACK_o);

// Define the Acknowledge back to the host for registers
assign WBs_ACK_o_nxt  =  module_decode && (WBs_CYC_i) && WBs_STB_i && (~WBs_ACK_o);


// write logic for the registers
always @( posedge WBs_CLK_i or posedge WBs_RST_i)
begin
    if (WBs_RST_i)
    begin
        reg_enable      <= 1'b0;
        reg_sample_len  <= SAMPLE_LENGTH_DEFAULT;
        reg_sample_gap  <= SAMPLE_GAP_DEFAULT;

        WBs_ACK_o       <= 1'b0;
    end  
    else
    begin

        // control register
        if (REG_WE_CTRL) begin
            if (WBs_BYTE_STB_i[0])
                reg_enable              <= WBs_DAT_i[0]     ;
        end

        // sampling length register
        if (REG_WE_SAMP_LEN) begin
            if (WBs_BYTE_STB_i[0])
                reg_sample_len[7:0]     <= WBs_DAT_i[7:0]   ;
            if (WBs_BYTE_STB_i[1])
                reg_sample_len[15:8]    <= WBs_DAT_i[15:8]  ;
            if (WBs_BYTE_STB_i[2])
                reg_sample_len[23:16]   <= WBs_DAT_i[23:16] ;
            if (WBs_BYTE_STB_i[3])
                reg_sample_len[31:24]   <= WBs_DAT_i[31:24] ;
        end

        // sampling delay register
        if (REG_WE_SAMP_GAP) begin
            if (WBs_BYTE_STB_i[0])
                reg_sample_gap[7:0]       <= WBs_DAT_i[7:0]   ;
            if (WBs_BYTE_STB_i[1])
                reg_sample_gap[15:8]      <= WBs_DAT_i[15:8]  ;
            if (WBs_BYTE_STB_i[2])
                reg_sample_gap[23:16]     <= WBs_DAT_i[23:16] ;
            if (WBs_BYTE_STB_i[3])
                reg_sample_gap[31:24]     <= WBs_DAT_i[31:24] ;
        end


        WBs_ACK_o <= WBs_ACK_o_nxt  ;
    end  
end


// read logic for the registers
always @(*)
 begin
    case(WBs_ADR_i[ADDRWIDTH-1:2])
        REG_ADDR_CTRL[ADDRWIDTH-1:2]        : WBs_DAT_o <= {31'b0, reg_enable}  ;
        REG_ADDR_SAMP_LEN[ADDRWIDTH-1:2]    : WBs_DAT_o <= reg_sample_len       ;
        REG_ADDR_SAMP_GAP[ADDRWIDTH-1:2]    : WBs_DAT_o <= reg_sample_gap       ;
        REG_ADDR_WC_DIFF[ADDRWIDTH-1:2]     : WBs_DAT_o <= wordcnt_diff         ;
        REG_ADDR_WC[ADDRWIDTH-1:2]          : WBs_DAT_o <= {wordcnt_shadow_local[15:0], wordcnt_shadow_master[15:0]}       ;
        REG_ADDR_WC_MSTR[ADDRWIDTH-1:2]     : WBs_DAT_o <= wordcnt_shadow_master;
        REG_ADDR_WC_LOCAL[ADDRWIDTH-1:2]    : WBs_DAT_o <= wordcnt_shadow_local ;
        REG_ADDR_SCNT_MSTR[ADDRWIDTH-1:2]   : WBs_DAT_o <= scmaster ;
    default                                 : WBs_DAT_o <= DEFAULT_REG_VALUE    ;
    endcase
end

//======End Wishbone register interface======


//======Begin FLL logic======

wire            rst;
assign rst = WBs_RST_i;


// sync the enable to the each bitclk domain

reg             enable_local_r1     ;
reg             enable_local_r2     ;
reg             enable_local_sync   ;
reg             enable_master_r1    ;
reg             enable_master_r2    ;
reg             enable_master_sync  ;

always @(posedge rst or posedge bitclk_local)
    if (rst) begin
        enable_local_r1     <= 1'b0;
        enable_local_r2     <= 1'b0;
        enable_local_sync   <= 1'b0;
    end else begin
        enable_local_r1     <= reg_enable;
        enable_local_r2     <= enable_local_r1;
        if (enable_local_r1 == enable_local_r2)
            enable_local_sync <= enable_local_r2;
    end

always @(posedge rst or posedge bitclk_master)
    if (rst) begin
        enable_master_r1     <= 1'b0;
        enable_master_r2     <= 1'b0;
        enable_master_sync   <= 1'b0;
    end else begin
        enable_master_r1     <= reg_enable;
        enable_master_r2     <= enable_master_r1;
        if (enable_master_r1 == enable_master_r2)
            enable_master_sync  <= enable_master_r2;
    end


// count words in each domain, when enable=1
//      The FLL control logic will try to maintain the same word count in the local domain,
//      as exists in the master domain, by adjusting the local clock.

reg     [7:0]   bitcnt_local;
reg     [7:0]   bitcnt_master;

reg     [31:0]  wordcnt_local;
reg     [31:0]  wordcnt_master;

reg     [31:0]  wordcnt_shadow_local;
reg     [31:0]  wordcnt_shadow_master;


always @(posedge rst or posedge bitclk_local)
    if (rst) begin
        bitcnt_local <= 8'b0;
        wordcnt_local <= 32'b0;
    end else begin
        if (enable_local_sync == 1'b0) begin
            bitcnt_local <= 8'b0;
            wordcnt_local <= 32'b0;
        end else begin
            if (bitcnt_local == (BIT_CLOCKS_PER_WORD-1)) begin
                bitcnt_local <= 8'b0;
                wordcnt_local <= wordcnt_local + 1;
            end else begin
                bitcnt_local <= bitcnt_local + 1;
                wordcnt_local <= wordcnt_local;
            end
        end
    end

always @(posedge rst or posedge bitclk_master)
    if (rst) begin
        bitcnt_master <= 8'b0;
        wordcnt_master <= 32'b0;
    end else begin
        if (enable_master_sync == 1'b0) begin
            bitcnt_master <= 8'b0;
            wordcnt_master <= 32'b0;
        end else begin
            if (bitcnt_master == (BIT_CLOCKS_PER_WORD-1)) begin
                bitcnt_master <= 8'b0;
                wordcnt_master <= wordcnt_master + 1;
            end else begin
                bitcnt_master <= bitcnt_master + 1;
                wordcnt_master <= wordcnt_master;
            end
        end
    end


// word count shadow registers

reg         shadow_reg_copy;

reg         shadow_reg_copy_local_r1;
reg         shadow_reg_copy_local_r2;
reg         shadow_reg_copy_local_sync;
reg         shadow_reg_copy_master_r1;
reg         shadow_reg_copy_master_r2;
reg         shadow_reg_copy_master_sync;


    // synchronize the shadow register lock signal to each domain
    //      shadow_reg_copy should be active for at least 2 clocks.

always @(posedge rst or posedge bitclk_local)
    if (rst) begin
        shadow_reg_copy_local_r1    <= 1'b0;
        shadow_reg_copy_local_r2    <= 1'b0;
        shadow_reg_copy_local_sync  <= 1'b0;
    end else begin
        shadow_reg_copy_local_r1    <= shadow_reg_copy;
        shadow_reg_copy_local_r2    <= shadow_reg_copy_local_r1;
        if (shadow_reg_copy_local_r1 && !shadow_reg_copy_local_r2)
            shadow_reg_copy_local_sync <= 1'b1;
        else
            shadow_reg_copy_local_sync <= 1'b0;
    end

always @(posedge rst or posedge bitclk_master)
    if (rst) begin
        shadow_reg_copy_master_r1    <= 1'b0;
        shadow_reg_copy_master_r2    <= 1'b0;
        shadow_reg_copy_master_sync  <= 1'b0;
    end else begin
        shadow_reg_copy_master_r1    <= shadow_reg_copy;
        shadow_reg_copy_master_r2    <= shadow_reg_copy_master_r1;
        if (shadow_reg_copy_master_r1 && !shadow_reg_copy_master_r2)
            shadow_reg_copy_master_sync <= 1'b1;
        else
            shadow_reg_copy_master_sync <= 1'b0;
    end


    // shadow registers
    //      these are used to copy the wordcnt registers so the calculations can be done.

always @(posedge rst or posedge bitclk_local)
    if (rst)
        wordcnt_shadow_local <= 0;
    else
        if (shadow_reg_copy_local_sync)
            wordcnt_shadow_local <= wordcnt_local;
        else
            wordcnt_shadow_local <= wordcnt_shadow_local;

always @(posedge rst or posedge bitclk_master)
    if (rst)
        wordcnt_shadow_master <= 0;
    else
        if (shadow_reg_copy_master_sync)
            wordcnt_shadow_master <= wordcnt_master;
        else
            wordcnt_shadow_master <= wordcnt_shadow_master;



// sample counters - one in each clk domain

reg     [31:0]  sample_cnt;
reg     [31:0]  sample_cnt_master;
reg             sample_cnt_enable;
reg             sample_cnt_enable_master;
reg             sample_cnt_enable_master_r1;
reg             sample_cnt_enable_master_r2;

reg             sample_cnt_load;
reg             sample_cnt_load_r1; // this is used to make sure sample_cnt_load is at least 2 clks wide
reg             sample_cnt_load_master;
reg             sample_cnt_load_master_r1;
reg             sample_cnt_load_master_r2;

reg     [31:0]  sample_gap_cnt;
reg             sample_gap_cnt_enable;
reg             sample_gap_cnt_load;


    // sync the sample count enable signal to the master domain
always @(posedge rst or posedge bitclk_master)
    if (rst) begin
        sample_cnt_enable_master_r1 <= 0;
        sample_cnt_enable_master_r2 <= 0;
        sample_cnt_enable_master <= 0;
    end else begin
        sample_cnt_enable_master_r1 <= sample_cnt_enable;
        sample_cnt_enable_master_r2 <= sample_cnt_enable_master_r1;
        if (sample_cnt_enable_master_r1 == sample_cnt_enable_master_r2)
            sample_cnt_enable_master <= sample_cnt_enable_master_r2;
        else
            sample_cnt_enable_master <= sample_cnt_enable_master;
    end

    // sync the sample count load signal to the master domain
always @(posedge rst or posedge bitclk_master)
    if (rst) begin
        sample_cnt_load_master_r1 <= 0;
        sample_cnt_load_master_r2 <= 0;
        sample_cnt_load_master <= 0;
    end else begin
        sample_cnt_load_master_r1 <= sample_cnt_load;
        sample_cnt_load_master_r2 <= sample_cnt_load_r1;
        if (sample_cnt_load_master_r1 || sample_cnt_load_master_r2)
            sample_cnt_load_master <= 1;
        else
            sample_cnt_load_master <= 0;
    end


    // sample counter - local
always @(posedge rst or posedge bitclk_local)
    if (rst)
        sample_cnt <= 0;
    else
        if (sample_cnt_load)
            sample_cnt <= reg_sample_len;
        else
            if (sample_cnt_enable)
                if (sample_cnt == 0)
                    sample_cnt <= sample_cnt;
                else
                    sample_cnt <= sample_cnt - 1;
            else
                sample_cnt <= sample_cnt;


    // sample counter - master
always @(posedge rst or posedge bitclk_master)
    if (rst)
        sample_cnt_master <= 0;
    else
        if (sample_cnt_load_master)
            sample_cnt_master <= reg_sample_len;
        else
            if (sample_cnt_enable_master)
                sample_cnt_master <= sample_cnt_master - 1;
            else
                sample_cnt_master <= sample_cnt_master;



    // sample gap counter
always @(posedge rst or posedge bitclk_local)
    if (rst)
        sample_gap_cnt <= 0;
    else
        if (sample_gap_cnt_load)
            sample_gap_cnt <= reg_sample_gap;
        else
            if (sample_gap_cnt_enable)
                if (sample_gap_cnt == 0)
                    sample_gap_cnt <= sample_gap_cnt;
                else
                    sample_gap_cnt <= sample_gap_cnt - 1;
            else
                sample_gap_cnt <= sample_gap_cnt;


// FLL control logic

reg     [3:0]   compute_timer;

reg     [2:0]   fll_state;
localparam  st_IDLE     = 3'h0;
localparam  st_SAMPLE   = 3'h1;
localparam  st_COMPUTE  = 3'h2;
localparam  st_GAP      = 3'h3;

    // state machine
always @(posedge rst or posedge bitclk_local)
    if (rst)
        fll_state <= st_IDLE;
    else
        case (fll_state)
            st_IDLE     :   
                            if (enable_local_sync)
                                fll_state <= st_SAMPLE;
                            else
                                fll_state <= st_IDLE;
            st_SAMPLE   : 
                            if (sample_cnt == 1)
                                fll_state <= st_COMPUTE;
                            else
                                fll_state <= st_SAMPLE;
            st_COMPUTE  : 
                            if (compute_timer == 4'hF)
                                fll_state <= st_GAP;
                            else
                                fll_state <= st_COMPUTE;
            st_GAP      : 
                            if (sample_gap_cnt == 0)
                                if (enable_local_sync)
                                    fll_state <= st_SAMPLE;
                                else
                                    fll_state <= st_IDLE;
                            else
                                fll_state <= st_GAP;
            default     :
                            fll_state <= st_IDLE;
        endcase


    // timers
always @(posedge rst or posedge bitclk_local)
    if (rst)
        compute_timer <= 0;
    else
        if (fll_state == st_COMPUTE)
            compute_timer <= compute_timer + 1;
        else
            compute_timer <= 0;


    // control signals

always @(posedge rst or posedge bitclk_local)
    if (rst)
        shadow_reg_copy <= 0;
    else
        if (fll_state == st_COMPUTE && (compute_timer[3:2] == 2'b00))   // the 1st 4 clocks in the COMPUTE state
            shadow_reg_copy <= 1;
        else
            shadow_reg_copy <= 0;

always @(posedge rst or posedge bitclk_local)
    if (rst)
        sample_cnt_enable <= 0;
    else
        if (fll_state == st_SAMPLE)
            sample_cnt_enable <= 1;
        else
            sample_cnt_enable <= 0;



always @(posedge rst or posedge bitclk_local)
    if (rst) begin
        sample_cnt_load <= 0;
        sample_cnt_load_r1 <= 0;
    end else begin
        sample_cnt_load_r1 <= sample_cnt_load;

        if (fll_state == st_IDLE || fll_state == st_GAP)
            sample_cnt_load <= 1;
        else
            if (sample_cnt_load && !sample_cnt_load_r1)
                sample_cnt_load <= 1;
            else
                sample_cnt_load <= 0;
    end

always @(posedge rst or posedge bitclk_local)
    if (rst)
        sample_gap_cnt_load <= 0;
    else
        if (fll_state != st_COMPUTE && fll_state != st_GAP)
            sample_gap_cnt_load <= 1;
        else
            sample_gap_cnt_load <= 0;

always @(posedge rst or posedge bitclk_local)
    if (rst)
        sample_gap_cnt_enable <= 0;
    else
        if (fll_state == st_COMPUTE || fll_state == st_GAP)
            sample_gap_cnt_enable <= 1;
        else
            sample_gap_cnt_enable <= 0;


// determine if the word counts are aligned
reg         local_wordcnt_is_ahead;
reg         master_wordcnt_is_ahead;
reg         wordcnts_aligned;

always @(posedge rst or posedge bitclk_local)
    if (rst) begin
        local_wordcnt_is_ahead <= 0;
        master_wordcnt_is_ahead <= 0;
        wordcnts_aligned <= 0;
    end else begin
        // Compare the shadow wordcnt's only when in the COMPUTE state, and only after the shadow counts have been copied,
        //  allowing time for the values to settle (so cross-domain logic won't be needed).
        // Also don't compare if a rollover has occurred on one of the wordcnt's but not the other.
        if (fll_state == st_COMPUTE && compute_timer == 4'h8) begin
            wordcnt_diff = wordcnt_shadow_local - wordcnt_shadow_master;
            if (wordcnt_shadow_local[31] == wordcnt_shadow_master[31]) begin
                if (wordcnt_shadow_local[30:0] == wordcnt_shadow_master[30:0]) begin
                    wordcnts_aligned <= 1;
                    local_wordcnt_is_ahead <= 0;
                    master_wordcnt_is_ahead <= 0;
                end else begin
                    if (wordcnt_shadow_local[30:0] > wordcnt_shadow_master[30:0]) begin
                        wordcnts_aligned <= 0;
                        local_wordcnt_is_ahead <= 1;
                        master_wordcnt_is_ahead <= 0;
                    end else begin
                        wordcnts_aligned <= 0;
                        local_wordcnt_is_ahead <= 0;
                        master_wordcnt_is_ahead <= 1;
                    end
                end
            end else begin  // only one has rolled over; hold the last values
                wordcnts_aligned <= wordcnts_aligned;
                local_wordcnt_is_ahead <= local_wordcnt_is_ahead;
                master_wordcnt_is_ahead <= master_wordcnt_is_ahead;
            end
        end else begin      // hold
            wordcnts_aligned <= wordcnts_aligned;
            local_wordcnt_is_ahead <= local_wordcnt_is_ahead;
            master_wordcnt_is_ahead <= master_wordcnt_is_ahead;
        end
    end


// determine if a speedup or slowdown interrupt is needed
reg         speedup_reg;
reg         slowdown_reg;


    // speedup when: the local clock is slower than the master clock AND the local wordcnt is equal to or less than the master wordcnt,
    //                  OR the local clock is the same as the master clock AND the local wordcnt is less than the master wordcnt.
    // slowdown when: the local clock is faster than the master clock AND the local wordcnt is equal to or greater than the master wordcnt,
    //                  OR the local clock is the same as the master clock AND the local wordcnt is more than the master wordcnt.
always @(posedge rst or posedge bitclk_local)
    if (rst) begin
        speedup_reg <= 0;
        slowdown_reg <= 0;
    end else begin
        if (fll_state == st_COMPUTE && compute_timer == 4'hA) begin
            scmaster <= sample_cnt_master; // Debug
            // check if speedup is needed
//            if  (    (sample_cnt_master[15] && (wordcnts_aligned || master_wordcnt_is_ahead))
//                    ||
//                    (sample_cnt_master == 0 && master_wordcnt_is_ahead)
            if  (    (sample_cnt_master[15] && (master_wordcnt_is_ahead))
                ) begin
                    speedup_reg <= 1;
                    slowdown_reg <= 0;
                end
            // check if slowdown is needed
            else
//                if  (   ((!sample_cnt_master[15] && (sample_cnt_master != 0)) && (wordcnts_aligned || local_wordcnt_is_ahead))
//                        ||
//                        (sample_cnt_master == 0 && local_wordcnt_is_ahead)
                if  (   ((!sample_cnt_master[15] && (sample_cnt_master != 0)) && (local_wordcnt_is_ahead))
                    ) begin
                        speedup_reg <= 0;
                        slowdown_reg <= 1;
                    end
                else begin
                    speedup_reg <= 0;
                    slowdown_reg <= 0;
                end
            // no change
        end else begin
            speedup_reg <= 0;
            slowdown_reg <= 0;
        end
    end

assign  Interrupt_speedup = speedup_reg;
assign  Interrupt_slowdown = slowdown_reg;

assign  master_wordcnt_is_ahead_o = master_wordcnt_is_ahead;
assign  local_wordcnt_is_ahead_o = local_wordcnt_is_ahead;


endmodule

