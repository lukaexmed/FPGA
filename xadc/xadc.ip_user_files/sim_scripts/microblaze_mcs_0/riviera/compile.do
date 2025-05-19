transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xpm
vlib riviera/microblaze_v11_0_13
vlib riviera/xil_defaultlib
vlib riviera/lib_cdc_v1_0_3
vlib riviera/proc_sys_reset_v5_0_15
vlib riviera/lmb_v10_v3_0_14
vlib riviera/lmb_bram_if_cntlr_v4_0_24
vlib riviera/blk_mem_gen_v8_4_8
vlib riviera/iomodule_v3_1_10

vmap xpm riviera/xpm
vmap microblaze_v11_0_13 riviera/microblaze_v11_0_13
vmap xil_defaultlib riviera/xil_defaultlib
vmap lib_cdc_v1_0_3 riviera/lib_cdc_v1_0_3
vmap proc_sys_reset_v5_0_15 riviera/proc_sys_reset_v5_0_15
vmap lmb_v10_v3_0_14 riviera/lmb_v10_v3_0_14
vmap lmb_bram_if_cntlr_v4_0_24 riviera/lmb_bram_if_cntlr_v4_0_24
vmap blk_mem_gen_v8_4_8 riviera/blk_mem_gen_v8_4_8
vmap iomodule_v3_1_10 riviera/iomodule_v3_1_10

vlog -work xpm  -incr -l xpm -l microblaze_v11_0_13 -l xil_defaultlib -l lib_cdc_v1_0_3 -l proc_sys_reset_v5_0_15 -l lmb_v10_v3_0_14 -l lmb_bram_if_cntlr_v4_0_24 -l blk_mem_gen_v8_4_8 -l iomodule_v3_1_10 \
"E:/Xilinx/Vivado/2024.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  -incr \
"E:/Xilinx/Vivado/2024.1/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work microblaze_v11_0_13 -93  -incr \
"../../../ipstatic/hdl/microblaze_v11_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../../vaje7.gen/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_0/sim/bd_fc5c_0_microblaze_I_0.vhd" \

vcom -work lib_cdc_v1_0_3 -93  -incr \
"../../../ipstatic/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_15 -93  -incr \
"../../../ipstatic/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../../vaje7.gen/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_1/sim/bd_fc5c_0_rst_0_0.vhd" \

vcom -work lmb_v10_v3_0_14 -93  -incr \
"../../../ipstatic/hdl/lmb_v10_v3_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../../vaje7.gen/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_2/sim/bd_fc5c_0_ilmb_0.vhd" \
"../../../../vaje7.gen/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_3/sim/bd_fc5c_0_dlmb_0.vhd" \

vcom -work lmb_bram_if_cntlr_v4_0_24 -93  -incr \
"../../../ipstatic/hdl/lmb_bram_if_cntlr_v4_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../../vaje7.gen/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_4/sim/bd_fc5c_0_dlmb_cntlr_0.vhd" \
"../../../../vaje7.gen/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_5/sim/bd_fc5c_0_ilmb_cntlr_0.vhd" \

vlog -work blk_mem_gen_v8_4_8  -incr -v2k5 -l xpm -l microblaze_v11_0_13 -l xil_defaultlib -l lib_cdc_v1_0_3 -l proc_sys_reset_v5_0_15 -l lmb_v10_v3_0_14 -l lmb_bram_if_cntlr_v4_0_24 -l blk_mem_gen_v8_4_8 -l iomodule_v3_1_10 \
"../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -incr -v2k5 -l xpm -l microblaze_v11_0_13 -l xil_defaultlib -l lib_cdc_v1_0_3 -l proc_sys_reset_v5_0_15 -l lmb_v10_v3_0_14 -l lmb_bram_if_cntlr_v4_0_24 -l blk_mem_gen_v8_4_8 -l iomodule_v3_1_10 \
"../../../../vaje7.gen/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_6/sim/bd_fc5c_0_lmb_bram_I_0.v" \

vcom -work iomodule_v3_1_10 -93  -incr \
"../../../ipstatic/hdl/iomodule_v3_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../../vaje7.gen/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_7/sim/bd_fc5c_0_iomodule_0_0.vhd" \

vlog -work xil_defaultlib  -incr -v2k5 -l xpm -l microblaze_v11_0_13 -l xil_defaultlib -l lib_cdc_v1_0_3 -l proc_sys_reset_v5_0_15 -l lmb_v10_v3_0_14 -l lmb_bram_if_cntlr_v4_0_24 -l blk_mem_gen_v8_4_8 -l iomodule_v3_1_10 \
"../../../../vaje7.gen/sources_1/ip/microblaze_mcs_0/bd_0/sim/bd_fc5c_0.v" \
"../../../../vaje7.gen/sources_1/ip/microblaze_mcs_0/sim/microblaze_mcs_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

