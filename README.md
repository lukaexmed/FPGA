"# FPGA" 
all docs from https://docs.amd.com/r/en-US/ug480_7Series_XADC
### XADC
The signals from the XADC are on RDP interface

![[misc/Screenshot 2025-05-15 at 4.38.54 PM.png]]
![[misc/Screenshot 2025-05-15 at 4.45.51 PM.png]]
#### DRP interface
register address is on *daddr_in*
when conversion is done, eoc (end of conversion) is sent to den_in
register enable signal, *den_in* is seto to 1 and write enable signakl, *dwe_in* to 0
XADC retrieves data from the designated register (addres in daddr_in)
after the operation is complete, XADC places data on *do_out* and assert *drdy_out* to signal that data is ready

this reading operation takes multiple cycles, so its incopatible with fpro bus specifications (1 cycle)




channel reading;
![[misc/Screenshot 2025-05-15 at 8.25.32 PM.png]]
 internal temp -> 5'b00000
internal vcc -> 5'b00001 

![[misc/Screenshot 2025-05-15 at 8.26.38 PM.png]]

vauxp/n 2 -> 5'b10010
vauxp/n 3 ->5'b10011 
vauxp/n 10 -> 5'b11010 
vauxp/n 11 -> 5'b11011
