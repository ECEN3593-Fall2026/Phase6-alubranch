/**
    * cpu.sv
    * 
    * This module represents a simplified pipelined CPU with fetch, decode, execute,
    * memory, and writeback stages. It connects the stages together and manages the
    * flow of instructions and data through the pipeline.
    *
    */


// How would I debug
   // Use the comment in the gtkwave (to separate stages) 
   // Show the clock and reset only once, 
   // Show the pc and instruction at each stage
   // See that those are going through the pipeline correctly

   // Then I would look at rs1 and rs2 at decode stage
   // See that those match what I expect based on the instruction at that stage
   //  (look at what got printed out and note pc and instruction values and instruction string)

   // Then, add in the register file outputs at decode stage
   // See that those are correct (look in the initialization in regfile.sv to see what values to expect)
   //   (note: the read from regfile is combinational, so the outputs should match the input address in the same cycle)

   // Then add in the execute stage inputs (reg1, reg2, immed) and see those are correct 
   //   (they should be what was in the decode stage one cycle later)

module cpu (
    input logic clk, 
    input logic reset, 
    input logic [31:0] instruction_data,
    output logic [31:0] instruction_address
    );

    import instr_strings_pkg::*;
    import enum_defines_pkg::*;

    enum_defines_pkg::pc_src_t s_pc_src;  //phase 6

    logic [31:0] ifid_pc;
    logic [31:0] ifid_instr;

    logic [31:0] idex_pc;
    logic [31:0] idex_instr;
    logic [31:0] idex_reg1;
    logic [31:0] idex_reg2;
    logic [31:0] idex_immed;

    logic [4:0] idex_rs1; // new for phase 5
    logic [4:0] idex_rs2; // new for phase 5
    //instr_op_t idex_instr_str; // phase 3 only, will change in phase 4

    branch_sel_t  idex_branch_sel; // phase 6
    rfwt_sel_t idex_rfwt_sel; // phase 6
    branch_op_t idex_branch_op; // phase 6
    logic s_flush_pipeline; // phase 6 - signal to indicate whether to flush the pipeline (i.e., when we are taking a branch and the instructions that were fetched after the branch instruction are not valid and need to be flushed)



    alu_op_t      idex_alu_op;
    alu_src1_sel_t    idex_alu_src1_sel;
    alu_src2_sel_t    idex_alu_src2_sel;
    logic         idex_regwrite;

    // Phase 4 additional decoded output
    output logic [4:0]    idex_rd;   // destination register address, so WB stage can know destination register


    logic [31:0] exme_pc;
    logic [31:0] exme_instr;
    logic [31:0] exme_alu_result;
    logic [4:0]    exme_rd;   // destination register address, so WB stage can know destination register
    logic        exme_regwrite;


    logic [31:0] exme_target_address;
    rfwt_sel_t exme_rfwt_sel;
    logic exme_alu_zero;
    branch_op_t exme_branch_op; 
    


    logic [31:0] mewb_pc;
    logic [31:0] mewb_instr;
    logic [31:0] mewb_alu_result;
    logic [4:0]  mewb_rd;   // destination register address, so WB stage can know destination register
    logic        mewb_regwrite;

    rfwt_sel_t mewb_rfwt_sel; // phase 6


    logic wb_regwrite;
    logic [4:0] wb_rd;
    logic [31:0] wb_writedata;

    fetch fetch_stage (
        .clk(clk),
        .reset(reset),
        .instruction_data(instruction_data),
        .instruction_address(instruction_address),
        .ifid_pc(ifid_pc),
        .ifid_instr(ifid_instr),
        .s_pc_src(s_pc_src), // phase 6 part 3a
        .branch_target_address(exme_target_address), // phase 6 part 3a
        .s_flush_pipeline(s_flush_pipeline) // phase 6 part 3b
    );

    decode decode_stage(
        .clk(clk),
        .reset(reset),
        .ifid_pc(ifid_pc),
        .ifid_instr(ifid_instr),
        .idex_pc(idex_pc), 
        .idex_instr(idex_instr), 
        .idex_reg1(idex_reg1), 
        .idex_reg2(idex_reg2), 
        .idex_immed(idex_immed), 
//        .idex_instr_str(idex_instr_str), 
        .wb_regwrite(wb_regwrite), 
        .wb_rd(wb_rd), 
        .wb_writedata(wb_writedata),
        .idex_alu_op(idex_alu_op),
        .idex_alu_src2_sel(idex_alu_src2_sel),
        .idex_regwrite(idex_regwrite),
        .idex_rd(idex_rd),
        .idex_rs1(idex_rs1),
        .idex_rs2(idex_rs2),
        .idex_alu_src1_sel(idex_alu_src1_sel), // phase 6 part 2
        .idex_branch_sel(idex_branch_sel), // phase 6 part 3a
        .idex_rfwt_sel(idex_rfwt_sel), // phase 6 part 3a
        .idex_branch_op(idex_branch_op), // phase 6 part 3a
        .s_flush_pipeline(s_flush_pipeline) // phase 6 part 3b
    );

    execute execute_stage (
        .clk(clk),
        .reset(reset),
        .idex_pc(idex_pc),
        .idex_instr(idex_instr),
        .exme_pc(exme_pc), 
        .exme_instr(exme_instr), 
        .exme_alu_result(exme_alu_result),
        .exme_rd (exme_rd),
        .exme_regwrite(exme_regwrite),
        .idex_reg1(idex_reg1),
        .idex_reg2(idex_reg2),
        .idex_immed(idex_immed),
//        .idex_instr_str(idex_instr_str),
    // Phase 4 control signals decoded from instruction
        .idex_alu_op(idex_alu_op),
        .idex_alu_src2_sel(idex_alu_src2_sel),
        .idex_regwrite(idex_regwrite),
        .idex_rd(idex_rd),   // destination register address, so WB stage can know destination register
        .idex_rs1(idex_rs1),
        .idex_rs2(idex_rs2),
        .mewb_alu_result(mewb_alu_result),
        .mewb_rd(mewb_rd),
        .mewb_regwrite(mewb_regwrite),
        .idex_alu_src1_sel(idex_alu_src1_sel), // phase 6 part 2
        .idex_branch_sel(idex_branch_sel), // phase 6 part 3a
        .idex_rfwt_sel(idex_rfwt_sel), // phase 6  part 3a
        .idex_branch_op(idex_branch_op), // phase 6  part 3a
        .exme_target_address(exme_target_address), // phase 6 part 3a
        .exme_rfwt_sel(exme_rfwt_sel), // phase 6 part 3a
        .exme_alu_zero(exme_alu_zero), // phase 6 part 3a
        .exme_branch_op(exme_branch_op), // phase 6 part 3a
        .s_flush_pipeline(s_flush_pipeline) // phase 6 part 3b


    );

    mem mem_stage (
        .clk(clk),
        .reset(reset),
        .exme_pc(exme_pc),
        .exme_instr(exme_instr),
        .mewb_pc(mewb_pc), // not connected further in this simplified CPU
        .mewb_instr(mewb_instr), // not connected further in this simplified CPU

        .exme_alu_result(exme_alu_result),
        .exme_rd(exme_rd),   // destination register address, so WB stage can know destination register
        .exme_regwrite(exme_regwrite),

        .mewb_alu_result(mewb_alu_result),
        .mewb_rd(mewb_rd),   // destination register address, so WB stage can know destination register
        .mewb_regwrite(mewb_regwrite),

        .exme_rfwt_sel(exme_rfwt_sel), // phase 6  part 3a
        .exme_alu_zero(exme_alu_zero), // phase 6  part 3a
        .exme_branch_op(exme_branch_op), // phase 6  part 3a
        .s_pc_src(s_pc_src), // phase 6  part 3a
        .mewb_rfwt_sel(mewb_rfwt_sel) // phase 6  part 3a
        
        

    );

    writeback writeback_stage (
        .clk(clk),
        .reset(reset),
        .mewb_pc(mewb_pc),
        .mewb_instr(mewb_instr),
        .mewb_alu_result(mewb_alu_result),
        .mewb_rd(mewb_rd),   // destination register address, so WB stage can know destination register
        .mewb_regwrite(mewb_regwrite),

        .s_wb_rd(wb_rd),         // destination register address
        .s_wb_writedata(wb_writedata), // data to write to destination register
        .s_wb_regwrite(wb_regwrite),         // write enable

        .mewb_rfwt_sel(mewb_rfwt_sel) // phase 6  part 3a

    );



endmodule

/*
Some warnings from icarus verilog (that are all fine)
warning: Static variable initialization requires explicit lifetime in this context.
warning: System task ($display) cannot be synthesized in an always_ff process
warning: Assinging to a non-integral variable (instr_string) cannot be synthesized in an always_comb process.
*/

