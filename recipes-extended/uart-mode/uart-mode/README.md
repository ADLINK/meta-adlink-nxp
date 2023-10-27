# UART-Mode script to set uart to different operation mode

Bash Scripts to set gpio pins to switch operation modes on SP399E IC.

## Types of uart mode supported:

### Loopback (MODE1 PIN = 0, MODE0 PIN = 0):

A local loopback on the SP399E IC.

### RS232 (MODE1 PIN = 0, MODE0 PIN = 1):

Switch to run RS232 on the SP399E IC, and no CTS/RTS required.

### RS485 Half Duplex (MODE1 PIN = 1, MODE0 PIN = 0):

Switch to run RS485 running in half duplex on the SP399E IC, and RTS is required to change the direction on SP399E IC. Note: RTS = 0, Receiving Data, RST = 1, Sending Data.

### RS422 Full Duplex (MODE1 PIN = 1, MODE0 PIN = 1):

Switch to run RS422 running in full duplex on the SP399E IC, no CTS/RTS required.


