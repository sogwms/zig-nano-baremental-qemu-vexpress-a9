## Environement

- zig@0.10.1
- qemu@8.0.0
- git-bash (needed on windows)

## Usage

- use elf
```shell
zig build 

bash runqemu.sh
```

Or

- use bin
```shell
zig build bin

bash runqemuWithBin.sh
```

## Debug

see rungdbqemu.sh and doc/gdb.md