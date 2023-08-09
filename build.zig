const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    // const target = b.standardTargetOptions(.{});

    const target = .{
        .cpu_arch = std.Target.Cpu.Arch.thumb,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_a9 },
        .os_tag = std.Target.Os.Tag.freestanding,
        .abi = std.Target.Abi.eabi,
    };

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    // b.setPreferredReleaseMode(std.builtin.Mode.ReleaseSmall);
    const optimize = b.standardOptimizeOption(.{});

    const elf = b.addExecutable(.{
            .name = "zig-qemu-vexpress-a9.elf",
            // In this case the main source file is merely a path, however, in more
            // complicated build scripts, this could be a generated file.
            .root_source_file = .{ .path = "src/startup.zig" },
            .target = target,
            .optimize = optimize,
    });

    // add other files
    elf.addAssemblyFile(.{ .path = "src/startup.s" });

    // add linker script
    elf.setLinkerScriptPath(.{ .path = "src/link.ld" });

    // std.debug.print("mode:{}\n", .{mode});

    // BIN STEP
    const _bin = elf.addObjCopy(.{ .format = .bin });
    const bin = b.addInstallBinFile(_bin.getOutputSource(), "zig-program.bin");
    b.getInstallStep().dependOn(&bin.step);

    // .
    b.installArtifact(elf);
    b.getInstallStep().dependOn(&bin.step);
}

