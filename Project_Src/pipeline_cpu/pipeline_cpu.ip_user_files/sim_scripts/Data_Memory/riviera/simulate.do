onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+Data_Memory -L dist_mem_gen_v8_0_13 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.Data_Memory xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {Data_Memory.udo}

run -all

endsim

quit -force
