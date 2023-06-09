#include <cassert>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vcore.h"
#include "Vcore___024unit.h"
#include "Vcore__Syms.h"
#include <cstdio>
#include <memory>
#include "util.hh"

static const char* waveform_path = "waveforms/tb_core.vcd";

static const char* binary_path = "testbenches/rvasm/build/testprog.bin";

vluint64_t sim_time = 0;
static constexpr vluint64_t MAX_SIM_TIME = 80;
static size_t memory_size;

typedef Vcore___024unit::opcode_t opcode_t;

void dump_regs(FILE* fd, Vcore* dut);
void dump_mem(FILE* fd, vluint32_t* memptr, size_t length);

int main(int argc, char** argv, char** env) 
{
    Vcore *dut = new Vcore;

    auto contents = load_binary(binary_path);
    auto phy_mem = std::move(contents.first);
    memory_size = contents.second;
    
    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open(waveform_path);

    dut->clk = 1;
    dut->ce = 1;
    dut->reset = 0;
    while(sim_time < MAX_SIM_TIME) 
    {
        dut->memout = (vluint32_t)phy_mem[(dut->memaddr / 4)];

        dut->clk ^= 1; 
        
        assert(WORD_ALIGNED(dut->memaddr));
        
        dut->eval();
        ++sim_time;
        m_trace->dump(sim_time);
    }

    dump_regs(stdout, dut);
    //dump_mem(stdout, phy_mem.get(), memory_size / 4);

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

void dump_mem(FILE* fd, vluint32_t* memptr, size_t length)
{
    fprintf(fd, "--- memory dump ---\n\r");
    for(size_t i = 0; i < length; ++i)
    {
        fprintf(fd, "%08x:\t%08x\t%4s\n\r", i * 4UL, memptr[i], reinterpret_cast<char*>(memptr));
    }
    fprintf(fd, "------\n\r");
}
