#include <cassert>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vcore.h"
#include "Vcore___024unit.h"
#include "Vcore__Syms.h"
#include "util.hh"

static const char* binary_path = "testbenches/rvasm/build/branchtest.bin";

vluint64_t sim_time = 0;
static size_t memory_size;

typedef Vcore___024unit::opcode_t opcode_t;

#define REG(dut, n) (dut->rootp->core__DOT__gp_regfile__DOT__regs[n])
#define T5 (30)

int main(int argc, char** argv, char** env) 
{
    Vcore *dut = new Vcore;
    
    auto contents = load_binary(binary_path);
    auto phy_mem = std::move(contents.first);
    memory_size = contents.second;
    
    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);

    dut->clk = 1;
    dut->ce = 1;
    dut->reset = 0;
    
    while(sim_time < memory_size*4)
    {
        dut->memout = (vluint32_t)phy_mem[(dut->memaddr / 4)];

        dut->clk ^= 1; 
        
        assert(WORD_ALIGNED(dut->memaddr));
        
        dut->eval();
        ++sim_time;
        m_trace->dump(sim_time);
    }
    
    assert(REG(dut, T5) == 0);
    
    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}
