transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+xadc_ip  -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.xadc_ip xil_defaultlib.glbl

do {xadc_ip.udo}

run 1000ns

endsim

quit -force
