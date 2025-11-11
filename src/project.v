/*
 * Copyright (c) 2024 AbdisKiosk
 * SPDX-License-Identifier: Apache-2.0
 */

define default_nettype none

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

  assign uio_out = 0;
  assign uio_oe  = 0;

  reg [7:0] n_current;
  reg [7:0] n_next;

  always @(*) begin
    if (n_current == 1) begin
      n_next = 1;

    end else if (n_current[0] == 0) begin
      n_next = n_current >> 1;
    end else begin
      n_next = 3 * n_current + 1;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      n_current <= 8'd1; // Reset to 1
    end else begin
      n_current <= ui_in;
    end
  end

  // Assign the calculated next value to the output
  assign uo_out = n_next;
endmodule