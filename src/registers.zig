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

/// PL011
pub const UART = struct {
    const base_address = 0x10009000;
    /// DR
    const DR_val = packed struct(u32) {
        DATA: u8 = 0,
        FE: u1 = 0,
        PE: u1 = 0,
        BE: u1 = 0,
        OE: u1 = 0,
        reserved: u20 = 0,
    };

    /// RSRECR
    const RSRECR_val = packed struct(u32) {
        FE: u1 = 0,
        PE: u1 = 0,
        BE: u1 = 0,
        OE: u1 = 0,
        reserved: u28 = 0,
    };
    /// FR
    const FR_val = packed struct(u32) {
        CTS: u1 = 0,
        DSR: u1 = 0,
        DCD: u1 = 0,
        BUSY: u1 = 0,
        RXFE: u1 = 0,
        TXFF: u1 = 0,
        RXFF: u1 = 0,
        TXFE: u1 = 0,
        RI: u1 = 0,

        reserved: u23 = 0,
    };

    /// CR
    const CR_val = packed struct(u32) {
        UARTEN: u1 = 0,
        SIREN: u1 = 0,
        SIRLP: u1 = 0,
        reserved1: u4 = 0,

        LBE: u1 = 0,
        TXE: u1 = 0,
        RXE: u1 = 0,
        DTR: u1 = 0,
        RTS: u1 = 0,
        Out1: u1 = 0,
        Out2: u1 = 0,
        RTSEn: u1 = 0,
        CTSEn: u1 = 0,

        reserved2: u16 = 0,
    };

    pub const DR = Register(DR_val).init(base_address + 0x0);
    pub const RSRECR = Register(RSRECR_val).init(base_address + 0x04);
    pub const FR = Register(FR_val).init(base_address + 0x18);
    pub const CR = Register(CR_val).init(base_address + 0x30);
};
