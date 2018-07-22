#![feature(panic_implementation)]
#![no_std]
#![no_main]
#[macro_use]
extern crate lazy_static;
extern crate spin;

extern crate bootloader_precompiled;
extern crate volatile;

use core::panic::PanicInfo;

mod vga_buffer;

#[no_mangle] // don't mangle the name of this function
pub extern "C" fn _start() -> ! {
    use core::fmt::Write;
    vga_buffer::WRITER.lock().write_str("Hello again").unwrap();
    write!(vga_buffer::WRITER.lock(), ", some numbers: {} {}", 42, 1.337).unwrap();
    loop {}
}

#[panic_implementation]
#[no_mangle]
pub fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
