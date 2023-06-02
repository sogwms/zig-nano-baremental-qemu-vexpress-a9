/*
 * This file is part of the libopencm3 project.
 *
 * Copyright (C) 2009 Uwe Hermann <uwe@hermann-uwe.de>
 * Copyright (C) 2011 Stephen Caudle <scaudle@doceme.com>
 *
 * This library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library.  If not, see <http://www.gnu.org/licenses/>.
 */

/* Linker script for ST STM32F4DISCOVERY (STM32F407VG, 1024K flash, 128K RAM,
 * 64K Core Coupled Memory RAM).
 */

/* Define memory regions. */
MEMORY
{
  ROM (rx)  : ORIGIN = 0x60010000, LENGTH = 1M
  RAM (rwx) : ORIGIN = 0x70000000, LENGTH = 32M
}

/* Define the entry point of the output file. */
ENTRY(RawResetHandler)

/* Define sections. */
SECTIONS
{
  .text : {
    . = ALIGN(4);
    KEEP(*(.text.vector_table)); /* Vector table and pretect this section from removing (the optmization will remove unrefered code) */
    *(.text)  /* Program code */
    *(.text*)  /* Program code */
    *(.rodata)  /* Read-only data */
    *(.rodata*)  /* Read-only data */
    . = ALIGN(4);
  } >ROM

  _data_loadaddr = LOADADDR(.data);
  .data : {
    . = ALIGN(4);
    _data_start = .;
    *(.data)  /* Read-write initialized data */
    *(.data*)  /* Read-write initialized data */
    . = ALIGN(4);
    _data_end = .;
  } >RAM AT>ROM

  .bss : {
    . = ALIGN(4);
    _bss_start = .;
    *(.bss) /* zero-initialized data */
    *(.bss*) /* zero-initialized data */
    . = ALIGN(4);
    _bss_end = .;
  } > RAM 

  _fiq_stack_start = ADDR(.bss) + SIZEOF(.bss);
  _fiq_stack_end = _fiq_stack_start + 0x1000; /* 64 KB */

  _irq_stack_start = _fiq_stack_end;
  _irq_stack_end = _irq_stack_start + 0x1000; /* 64 KB */

  _stack_start = _irq_stack_end;
  _stack_end = _stack_start + 0x1000; /* 64 KB */

  _irq_stack_size = _irq_stack_end - _irq_stack_start;
  _fiq_stack_size = _fiq_stack_end - _fiq_stack_start;

}

PROVIDE(_stack = ORIGIN(RAM) + LENGTH(RAM));
