#![feature(panic_implementation)]
#![feature(abi_x86_interrupt)]
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
    deko_os::gdt::init();
    init_idt();
    fn stack_overflow() {
        stack_overflow(); // for each recursion, the return address is pushed
    }
    stack_overflow();
    serial_println!("failed");
    serial_println!("No exception occured");
    loop {}
}

#[cfg(not(test))]
#[panic_implementation]
#[no_mangle]
pub fn panic(_info: &PanicInfo) -> ! {
    serial_println!("failed");
    serial_println!("{}", _info);
    loop {}
}

extern crate x86_64;
use x86_64::structures::idt::{InterruptDescriptorTable, ExceptionStackFrame};

#[macro_use]
extern crate lazy_static;

lazy_static! {
    static ref IDT: InterruptDescriptorTable = {
        let mut idt = InterruptDescriptorTable::new();
        unsafe {
            idt.double_fault.set_handler_fn(double_fault_handler).set_stack_index(deko_os::gdt::DOUBLE_FAULT_IST_INDEX);;
        }
        idt
    };
}
pub fn init_idt() {
        IDT.load();
}

extern "x86-interrupt" fn double_fault_handler(
    stack_frame: &mut ExceptionStackFrame, _error_code: u64)
{
    serial_println!("ok");
    unsafe {
        exit_qemu();
    }
}
