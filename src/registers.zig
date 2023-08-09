// refer to https://github.com/rbino/svd4zig

pub fn Register(comptime R: type) type {
    return RegisterRW(R, R);
}

pub fn RegisterRW(comptime Read: type, comptime Write: type) type {
    return struct {
        raw_ptr: *volatile u32,

        const Self = @This();

        pub fn init(address: usize) Self {
            return Self{ .raw_ptr = @ptrFromInt(address) };
        }

        pub fn initRange(address: usize, comptime dim_increment: usize, comptime num_registers: usize) [num_registers]Self {
            var registers: [num_registers]Self = undefined;
            var i: usize = 0;
            while (i < num_registers) : (i += 1) {
                registers[i] = Self.init(address + (i * dim_increment));
            }
            return registers;
        }

        pub fn read(self: Self) Read {
            return @bitCast(self.raw_ptr.*);
        }

        pub fn write(self: Self, value: Write) void {
            self.raw_ptr.* = @bitCast(value);
        }

        pub fn modify(self: Self, new_value: anytype) void {
            if (Read != Write) {
                @compileError("Can't modify because read and write types for this register aren't the same.");
            }
            var old_value = self.read();
            const info = @typeInfo(@TypeOf(new_value));
            inline for (info.Struct.fields) |field| {
                @field(old_value, field.name) = @field(new_value, field.name);
            }
            self.write(old_value);
        }

        pub fn read_raw(self: Self) u32 {
            return self.raw_ptr.*;
        }

        pub fn write_raw(self: Self, value: u32) void {
            self.raw_ptr.* = value;
        }

        pub fn default_read_value(_: Self) Read {
            return Read{};
        }

        pub fn default_write_value(_: Self) Write {
            return Write{};
        }
    };
}

/// Random number generator
pub const UART = struct {
    const base_address = 0x10009000;
    /// DR
    const DR_val = packed struct {
        /// RNDATA [0:31]
        /// Random data
        RNDATA: u32 = 0,
    };
    /// data register
    pub const DR = Register(DR_val).init(base_address + 0x0);
};
