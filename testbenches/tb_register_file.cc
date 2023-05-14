#include <cassert>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vregister_file.h"
#include "Vregister_file___024root.h"

static constexpr vluint64_t NREGS = 32;

vluint64_t sim_time = 0;

inline void reg_write_imm(Vregister_file* regfile, vluint8_t rd_idx, vluint32_t imm);

int main(int argc, char** argv, char** env) 
{
    Vregister_file *dut = new Vregister_file;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);

    m_trace->open("waveforms/tb_register_file.vcd");
   
    dut->rd_idx = 0;
    dut->rs1_idx = 0;
    dut->rs2_idx = 1;
    dut->ce = 1;

    /* load an immediate to a register */
    constexpr vluint32_t expected_imm = 0xFF00FF00;
    
    dut->clk = 0;
    dut->write_en = 1;
    reg_write_imm(dut, 0, 0xFF00FF00);
    dut->eval();

    m_trace->dump(sim_time);
    ++sim_time;

    dut->clk = 1;
    dut->eval();
    
    m_trace->dump(sim_time);
    ++sim_time;

    /* another clock cycle to read the rs1 */
    dut->clk = 0;
    dut->eval();
    m_trace->dump(sim_time);
    ++sim_time;

    dut->clk = 1;
    dut->eval();
    m_trace->dump(sim_time);
    ++sim_time;

    dut->clk = 0;
    dut->eval();
    m_trace->dump(sim_time);
    ++sim_time;


    m_trace->close();

    assert(dut->rs1 == expected_imm);
    assert(dut->rs2 == 0);

    delete dut;
    exit(EXIT_SUCCESS);
}

inline void reg_write_imm(Vregister_file* regfile, vluint8_t rd_idx, vluint32_t imm) 
{
    regfile->rd_idx = rd_idx;
    regfile->data_in = imm;
}
