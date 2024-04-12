programElfFile=`ls zig-out/bin/*.elf | head -n 1`
programBinFile=`ls zig-out/bin/*.bin | head -n 1`

build:
	zig build

run:
	qemu-system-arm -M vexpress-a9 -m 512M -no-reboot -nographic  -serial mon:stdio -kernel ${programElfFile}

runbin:
	qemu-system-arm -M vexpress-a9 -m 512M -no-reboot -nographic  -serial mon:stdio -kernel ${programBinFile}

rundbg:
    # this will start a gdb server(port:1234) and then you can use gdb to debug 
	qemu-system-arm -M vexpress-a9 -m 512M -no-reboot -nographic -serial mon:stdio -kernel ${programElfFile} -s -S

clean:
	rm -rf zig-cache 
	rm -rf zig-out