#include <cassert>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vinstr_decoder.h"
#include "Vinstr_decoder___024root.h"

vluint64_t sim_time = 0;

int main(int argc, char** argv, char** env) {
    Vinstr_decoder *dut = new Vinstr_decoder;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveforms/tb_instr_decoder.vcd");

    dut->clk = 1;
    dut->ce = 1;
    /* LUI instruction */
    dut->instr = 0b0110111;

    dut->clk ^= 1;
    dut->eval();
    ++sim_time;

    m_trace->dump(sim_time);
   
    dut->clk ^= 1;
    dut->eval();
    ++sim_time;
   
    m_trace->dump(sim_time);

     dut->clk ^= 1;
    dut->eval();
    ++sim_time;
  
    m_trace->dump(sim_time);

    assert(dut->ctl_signals == 1);

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}
