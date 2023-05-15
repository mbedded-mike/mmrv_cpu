#include <cassert>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vcore.h"
#include "Vcore___024unit.h"

vluint64_t sim_time = 0;
static constexpr vluint64_t MAX_SIM_TIME = 6;

typedef Vcore___024unit::opcode_t opcode_t;

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
    /* lui h4096, r0 instruction */
    dut->memout = (1 << 12) | opcode_t::LUI;

    while(sim_time < MAX_SIM_TIME) 
    {
        dut->clk ^= 1;
    
        dut->eval();
        ++sim_time;
        m_trace->dump(sim_time);
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}
