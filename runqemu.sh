programFile=`ls zig-out/bin/*.elf | head -n 1`

qemu-system-arm -M vexpress-a9 -m 512M -no-reboot -nographic  -serial mon:stdio -kernel ${programFile}