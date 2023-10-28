const regs = @import("registers.zig");

pub fn putc(c: u8) void {
    while (regs.UART.FR.read().TXFF == 1) {}
    regs.UART.DR.write(.{ .DATA = c });
}

pub fn getc() ?u8 {
    if (regs.UART.FR.read().RXFE == 1) {
        return null;
    }

    return regs.UART.DR.read().DATA;
}
