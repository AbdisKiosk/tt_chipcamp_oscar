/*
 * Copyright (c) 2024 AbdisKiosk
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none

module tt_um_abdiskiosk_test (
	input  wire [7:0] ui_in,    // Dedicated inputs
	output wire [7:0] uo_out,   // Dedicated outputs
	input  wire [7:0] uio_in,   // IOs: Input path
	output wire [7:0] uio_out,  // IOs: Output path
	output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
	input  wire       ena,      // always 1 when the design is powered, so you can ignore it
	input  wire       clk,      // clock
	input  wire       rst_n     // reset_n - low to reset
	);

	// All output pins must be assigned. If not used, assign to 0.
	assign uio_out = 0;
	assign uio_oe  = 0;

	// The core logic for the Collatz conjecture step.
	// This is purely combinatorial based on the input.
	assign uo_out = (ui_in == 1) ? 1 :
				(ui_in[0] == 0) ? (ui_in >> 1) : // Even
				(3 * ui_in + 1);                 // Odd

endmodule
