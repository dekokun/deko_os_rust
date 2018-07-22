#![feature(panic_implementation)]
#![no_std]
#![cfg_attr(not(test), no_main)]
#[macro_use]
extern crate lazy_static;
extern crate spin;

extern crate bootloader_precompiled;
extern crate volatile;

#[cfg_attr(test, allow(unused_imports))]
use core::panic::PanicInfo;

#[macro_use]
mod vga_buffer;

#[no_mangle] // don't mangle the name of this function
pub extern "C" fn _start() -> ! {
    print!("Hello again deko");
    println!(", some numbers: {} {}", 42, 1.337);
    loop {}
}

#[cfg(not(test))]
#[panic_implementation]
#[no_mangle]
pub fn panic(info: &PanicInfo) -> ! {
    println!("{}", info);
    loop {}
}
