import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_collatz_sequence(dut):
    """Test for n=25 sequence"""
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test Collatz sequence for n=25")

    # The sequence for n=25 is:
    # 25, 76, 38, 19, 58, 29, 88, 44, 22, 11, 34, 17, 52, 26, 13, 40, 20, 10, 5, 16, 8, 4, 2, 1
    expected_sequence = [25, 76, 38, 19, 58, 29, 88, 44, 22, 11, 34, 17, 52, 26, 13, 40, 20, 10, 5, 16, 8, 4, 2, 1]

    # Set initial input
    n = expected_sequence[0]
    dut.ui_in.value = n

    # Iterate through the sequence to check the DUT's output at each step
    for i in range(len(expected_sequence) - 1):
        # Wait for one clock cycle for the module to compute the next value
        await ClockCycles(dut.clk, 1)

        next_n_expected = expected_sequence[i+1]
        dut_output = dut.uo_out.value.integer

        dut._log.info(f"Input: {n}, Output: {dut_output}, Expected: {next_n_expected}")

        # Assert that the DUT's output matches the expected next value
        assert dut_output == next_n_expected, f"Fejl ved trin {i}: fik {dut_output}, forventede {next_n_expected}"

        # Set the input for the next iteration
        n = dut_output
        dut.ui_in.value = n

    # Final check to ensure the sequence ends at 1
    await ClockCycles(dut.clk, 1)
    dut._log.info("Collatz sequence test passed")
