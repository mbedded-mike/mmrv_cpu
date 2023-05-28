#include <cassert>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Valu.h"
#include "Valu___024unit.h"

vluint64_t sim_time = 0;
static constexpr vluint64_t MAX_SIM_TIME = 6;

typedef Valu___024unit::alu_op_t alu_op_t;

int main(int argc, char** argv, char** env) 
{
    Valu *dut = new Valu;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveforms/tb_alu.vcd");

    dut->clk = 1;
    dut->ce = 1;
    dut->operand1 = 32;
    dut->operand2 = 64;

    alu_op_t operations[] = {
        alu_op_t::ADD,
        alu_op_t::SUB,
    };

    while(sim_time < MAX_SIM_TIME) 
    {
        dut->op_sel = operations[(sim_time / 2) % 2];
        dut->clk ^= 1;
    
        dut->eval();
        ++sim_time;
        m_trace->dump(sim_time);
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}
