const main = @import("main.zig");

// These symbols come from the linker script
extern const _data_loadaddr: u32;
extern var _data_start: u32;
extern const _data_end: u32;
extern var _bss_start: u32;
extern const _bss_end: u32;

export fn resetHandler() callconv(.C) void {
    // fill .bss with zeroes
    {
        const bss_start: [*]u8 = @ptrCast(&_bss_start);
        const bss_end: [*]u8 = @ptrCast(&_bss_end);
        const bss_len = @intFromPtr(bss_end) - @intFromPtr(bss_start);

        @memset(bss_start[0..bss_len], 0);
    }

    // load .data from flash
    {
        const data_start: [*]u8 = @ptrCast(&_data_start);
        const data_end: [*]u8 = @ptrCast(&_data_end);
        const data_len = @intFromPtr(data_end) - @intFromPtr(data_start);
        const data_src: [*]const u8 = @ptrCast(&_data_loadaddr);

        @memcpy(data_start[0..data_len], data_src[0..data_len]);
    }


    // Call contained in main.zig
    main.main();

    unreachable;
}
