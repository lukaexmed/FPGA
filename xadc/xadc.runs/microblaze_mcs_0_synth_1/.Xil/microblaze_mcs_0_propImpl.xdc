set_property SRC_FILE_INFO {cfile:e:/FAX/digitalnoNacrt/vaje7/vaje7.gen/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_0/bd_fc5c_0_microblaze_I_0.xdc rfile:../../../vaje7.gen/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_0/bd_fc5c_0_microblaze_I_0.xdc id:1 order:EARLY scoped_inst:inst/microblaze_I/U0} [current_design]
set_property SRC_FILE_INFO {cfile:e:/FAX/digitalnoNacrt/vaje7/vaje7.gen/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_1/bd_fc5c_0_rst_0_0.xdc rfile:../../../vaje7.gen/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_1/bd_fc5c_0_rst_0_0.xdc id:2 order:EARLY scoped_inst:inst/rst_0/U0} [current_design]
current_instance inst/microblaze_I/U0
set_property src_info {type:SCOPED_XDC file:1 line:2 export:INPUT save:INPUT read:READ} [current_design]
create_waiver -internal -quiet -scoped -user microblaze -tags 12436 -type CDC -id CDC-26 -description "Invalid LUTRAM collision warning" -to [get_pins -quiet "LOCKSTEP_Out_reg\[*\]/R"]
set_property src_info {type:SCOPED_XDC file:1 line:4 export:INPUT save:INPUT read:READ} [current_design]
create_waiver -internal -quiet -scoped -user microblaze -tags 12436 -type CDC -id CDC-26 -description "Invalid LUTRAM collision warning" -to [get_pins -quiet "MicroBlaze_Core_I/*Interrupt_DFF/Single_Synchronize.use_sync_reset.sync_reg/D"]
set_property src_info {type:SCOPED_XDC file:1 line:8 export:INPUT save:INPUT read:READ} [current_design]
create_waiver -internal -quiet -scoped -user microblaze -tags 12436 -type DRC -id PDCN-1569 -description "Valid LUT-6 instantiation" -objects [get_cells -quiet -hierarchical -filter {HLUTNM=~LUT6_2} *LUT*]
current_instance
current_instance inst/rst_0/U0
set_property src_info {type:SCOPED_XDC file:2 line:50 export:INPUT save:INPUT read:READ} [current_design]
create_waiver -type CDC -id {CDC-11} -user "proc_sys_reset" -desc "Timing uncritical paths" -tags "1171415" -scope -internal -to [get_pins -quiet -filter REF_PIN_NAME=~*D -of_objects [get_cells -hierarchical -filter {NAME =~ */ACTIVE_LOW_AUX.ACT_LO_AUX/GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_IN_cdc_to}]]
