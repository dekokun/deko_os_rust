#![feature(panic_implementation)]
#![no_std]
#![cfg_attr(not(test), no_main)]
#![cfg_attr(test, allow(dead_code, unused_macros, unused_imports))]

#[cfg(test)]
extern crate std;
#[cfg(test)]
extern crate array_init;


#[macro_use]
extern crate lazy_static;
extern crate spin;

extern crate bootloader_precompiled;
extern crate volatile;
extern crate uart_16550;
extern crate x86_64;

pub unsafe fn exit_qemu() {
    use x86_64::instructions::port::Port;

    let mut port = Port::<u32>::new(0xf4);
    port.write(0);
}

use core::panic::PanicInfo;

#[macro_use]
mod vga_buffer;
#[macro_use]
mod serial;

#[no_mangle] // don't mangle the name of this function
pub extern "C" fn _start() -> ! {
    print!("Hello again deko");
    println!(", some numbers: {} {}", 42, 1.337);
    serial_println!("Hello Host{}", "!");
    unsafe { exit_qemu(); }
    loop {}
}

#[cfg(not(test))]
#[panic_implementation]
#[no_mangle]
pub fn panic(info: &PanicInfo) -> ! {
    println!("{}", info);
    loop {}
}
