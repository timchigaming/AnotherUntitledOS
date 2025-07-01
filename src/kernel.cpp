#include "kernel_tools/kernel.cxx"

extern "C" void kmain()
{
    vm_print("Hello guys!", 0, 0, 0x0A);
}