import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from cocotb.triggers import FallingEdge
from cocotb.utils import get_sim_time

@cocotb.test()
async def test(dut):
    c = Clock(dut.clk, 10, "ns")
    c.start()

    dut.instr_data_i.value = 0
    dut.mem_rdata_i.value = 0
    dut.rst_n.value = 1
    await FallingEdge(dut.clk)

    dut.rst_n.value = 0
    await FallingEdge(dut.clk)

    dut.rst_n.value = 1
    for _ in range(50):
        await RisingEdge(dut.clk)
        time_ns = get_sim_time(unit="ns")
        print(f"Time: {time_ns:5}ns PC: {dut.instr_addr_o.value.to_unsigned()}")

