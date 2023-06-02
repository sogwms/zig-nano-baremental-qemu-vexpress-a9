const main = @import("main.zig");

// These symbols come from the linker script
extern const _data_loadaddr: u32;
extern var _data_start: u32;
extern const _data_end: u32;
extern var _bss_start: u32;
extern const _bss_end: u32;

export fn resetHandler() callconv(.C) void {
    // Copy data from flash to RAM
    const data_loadaddr = @ptrCast([*]const u8, &_data_loadaddr);
    const data = @ptrCast([*]u8, &_data_start);
    const data_size = @ptrToInt(&_data_end) - @ptrToInt(&_data_start);
    for (data_loadaddr[0..data_size]) |d, i| data[i] = d;

    // Clear the bss
    const bss = @ptrCast([*]u8, &_bss_start);
    const bss_size = @ptrToInt(&_bss_end) - @ptrToInt(&_bss_start);
    for (bss[0..bss_size]) |*b| b.* = 0;

    // Call contained in main.zig
    main.main();

    unreachable;
}
