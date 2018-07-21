#![feature(panic_implementation)]
#![no_std]
#![no_main]

extern crate bootloader_precompiled;
extern crate volatile;

use core::panic::PanicInfo;

mod vga_buffer;

#[no_mangle] // don't mangle the name of this function
pub extern "C" fn _start() -> ! {
    vga_buffer::print_something();
    loop {}
}

#[panic_implementation]
#[no_mangle]
pub fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
