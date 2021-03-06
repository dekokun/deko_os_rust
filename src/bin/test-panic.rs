#![no_std]
#![cfg_attr(not(test), no_main)]
#![cfg_attr(test, allow(dead_code, unused_macros, unused_imports))]

#[macro_use]
extern crate deko_os;

use core::panic::PanicInfo;
use deko_os::exit_qemu;

#[cfg(not(test))]
#[no_mangle]
pub extern "C" fn _start() -> ! {
    panic!();
}

#[cfg(not(test))]
#[panic_handler]
#[no_mangle]
pub fn panic(_info: &PanicInfo) -> ! {
    serial_println!("ok");

    unsafe {
        exit_qemu();
    }
    loop {}
}
