#include <cassert>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vmain_ctl.h"
#include "Vmain_ctl___024unit.h"

vluint64_t sim_time = 0;
static constexpr vluint64_t MAX_SIM_TIME = 30;

typedef Vmain_ctl___024unit::opcode_t opcode_t;

int main(int argc, char** argv, char** env) 
{
    Vmain_ctl *dut = new Vmain_ctl;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveforms/tb_main_ctl.vcd");

    dut->clk = 1;
    dut->ce = 1;
    /* lui 0, r0 instruction */
    dut->instr = opcode_t::LUI;

    while(sim_time < MAX_SIM_TIME) 
    {
        dut->clk ^= 1;

        if(sim_time >= 0 && sim_time < 4) {
            dut->reset = 1;
        } else {
            dut->reset = 0;
        }
    
        dut->eval();
        ++sim_time;
        m_trace->dump(sim_time);
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}
