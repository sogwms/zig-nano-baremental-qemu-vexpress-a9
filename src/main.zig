const uart = @import("uart.zig");
const putc = uart.putc;
const getc = uart.getc;

pub fn main() void {
    puts("hello world\r\n");

    while (true) {
        uart.putc('.');
        delay();
        if (uart.getc()) |d| {
            uart.putc(d);
        }
    }
}

fn delay() void {
    var i: u32 = 0;
    while (i < 100000000) {
        i += 1;
    }
}

fn puts(s: []const u8) void {
    for (s) |c| {
        uart.putc(c);
    }
}
