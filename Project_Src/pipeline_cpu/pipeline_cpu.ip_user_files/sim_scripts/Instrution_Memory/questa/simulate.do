onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Instrution_Memory_opt

do {wave.do}

view wave
view structure
view signals

do {Instrution_Memory.udo}

run -all

quit -force
