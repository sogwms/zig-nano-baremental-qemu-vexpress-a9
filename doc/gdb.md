```shell

programElfFile=`ls zig-out/bin/*.elf | head -n 1`

arm-none-eabi-gdb ${programElfFile}

# the followings are in gdb cli
target remote :1234

xxx

```