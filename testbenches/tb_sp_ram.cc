#include <cassert>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vsp_ram.h"
#include "Vsp_ram___024root.h"

static constexpr vluint64_t MEMORY_SIZE = 32;

vluint64_t sim_time = 0;

int main(int argc, char** argv, char** env) {
    Vsp_ram *dut = new Vsp_ram;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveforms/waveform.vcd");

    dut->address = 0x00000000;
    dut->data_le = 1;
    dut->data_in = 0x00000000;
    dut->ce = 1;

    for(vluint64_t i = 0UL; i < (MEMORY_SIZE / 4); ++i) {
        dut->clk ^= 1;
        dut->eval();
        
        m_trace->dump(sim_time);
       
        dut->clk ^= 1;
        dut->eval();
        
        assert(dut->data_in == dut->data_out);

        ++sim_time;
        dut->address += 4;
        dut->data_in += 1;
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}
