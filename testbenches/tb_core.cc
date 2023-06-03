#include <cassert>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vcore.h"
#include "Vcore___024unit.h"
#include "Vcore__Syms.h"
#include <cstdio>

vluint64_t sim_time = 0;
static constexpr vluint64_t MAX_SIM_TIME = 32;

typedef Vcore___024unit::opcode_t opcode_t;

#define MEM_SIZE_IN_WORDS 4

vluint32_t phy_mem[] = {
    /* lui 4096, r0 */
    (1 << 12) | opcode_t::LUI,  
    /* auipc 4096, r1 */
    (1 << 12) | (1 << 7) | opcode_t::AUIPC,
    /* jal 8, r2*/
    (0b100000000000 << 12) | (1 << 8) | opcode_t::JAL,
    /* auipc c00h, r4 <-- this instruction should never execute because of the previous jump */
    (12 << 12) | (1 << 9) | opcode_t::AUIPC,
};

#define WORD_ALIGNED(x) ((x & 0b11U) == 0)

void dump_regs(FILE* fd, Vcore* dut);

int main(int argc, char** argv, char** env) 
{
    Vcore *dut = new Vcore;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveforms/tb_core.vcd");

    dut->clk = 1;
    dut->ce = 1;
    dut->reset = 0;

    while(sim_time < MAX_SIM_TIME) 
    {
        dut->memout = phy_mem[(dut->memaddr / 4) % MEM_SIZE_IN_WORDS];

        dut->clk ^= 1; 
        
        assert(WORD_ALIGNED(dut->memaddr));
        
        dut->eval();
        ++sim_time;
        m_trace->dump(sim_time);
    }

    dump_regs(stdout, dut);
        
    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}


void dump_regs(FILE* fd, Vcore* dut)
{
    fprintf(fd, "--- register dump ---\n\r");
    fprintf(fd, "PC: %08x\n\r", dut->rootp->core__DOT__pc);
    fprintf(fd, "--- GP REGS ---\n\r");
    for(size_t i = 0; i < 32; ++i) 
    {
        fprintf(fd, "x%d: %08x\n\r", i, dut->rootp->core__DOT__gp_regfile__DOT__regs[i]);
    }
    fprintf(fd, "------\n\r");
}
