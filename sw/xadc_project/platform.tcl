# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct /home/luka/FPGA/sw/xadc_project/platform.tcl
# 
# OR launch xsct and run below command.
# source /home/luka/FPGA/sw/xadc_project/platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {xadc_project}\
-hw {/home/luka/FPGA/digitalnoNacrt/xadc/top.xsa}\
-proc {microblaze_I} -os {standalone} -out {/home/luka/FPGA/sw}

platform write
platform generate -domains 
platform active {xadc_project}
platform generate
