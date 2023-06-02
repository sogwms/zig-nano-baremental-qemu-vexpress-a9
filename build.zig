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
    const mode = b.standardReleaseOptions();
    const elf = b.addExecutable("zig-qemu-vexpress-a9.elf", "src/startup.zig");
    elf.setTarget(target);
    elf.setBuildMode(mode);

    // add other files
    elf.addAssemblyFileSource(.{ .path = "src/startup.s" });

    // add linker script
    elf.setLinkerScriptPath(.{ .path = "src/link.ld" });

    // std.debug.print("mode:{}\n", .{mode});

    // BIN STEP
    const bin = b.addInstallRaw(elf, "zig-qemu-vexpress-a9.bin", .{});
    const bin_step = b.step("bin", "Generate binary file to be flashed");
    bin_step.dependOn(&bin.step);

    // .
    b.default_step.dependOn(&elf.step);
    b.installArtifact(elf);
}
