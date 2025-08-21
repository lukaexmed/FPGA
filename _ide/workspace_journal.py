# 2025-08-03T14:13:43.326591800
import vitis

client = vitis.create_client()
client.set_workspace(path="FPGA")

vitis.dispose()

