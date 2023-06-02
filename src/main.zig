const regs = @import("registers.zig");

// const uart0 = @intToPtr(*volatile u32, 0x10009000);

// used to test variable
var tmpv: u32 = 'h';

pub fn main() void {
    putc(tmpv);
    putc('e');
    putc('l');
    putc('l');
    tmpv = 'o';
    putc(tmpv);

    putc('w');
    putc('o');
    putc('r');
    putc('l');
    putc('d');

    while (true) {
        putc('.');
        delay();
    }
}

fn putc(c: u32) void {
    regs.UART.DR.write(.{ .RNDATA = c });
}

fn delay() void {
    var i: u32 = 0;
    while (i < 80000000) {
        i += 1;
    }
}
