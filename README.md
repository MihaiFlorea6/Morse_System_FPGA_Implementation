# Morse System FPGA Implementation

# Technical Description
VHDL-based implementation of a real-time Morse code detection and signaling system on the Basys 3 FPGA board. The project integrates digital signal control, timing synchronization, and finite-state machine (FSM) logic to interpret and display Morse code sequences through LEDs and a seven-segment display.

# Mechanisms and architecture
The system employs edge detection and precise timing mechanisms to distinguish between short and long pulses (dots and dashes), using debounced input signals and clock division for stable operation. The architecture is built around a deterministic FSM that transitions between states corresponding to input duration and signal spacing, ensuring reliable Morse pattern decoding and output signaling.

# Skills
This project demonstrates a strong understanding of:
→ Real-time digital system design and synchronization on FPGA.
→ Finite State Machine (FSM) implementation and control logic design.
→ Edge detection and timing-based event classification.
→ Hardware description and simulation using VHDL.
→ Signal visualization via LEDs and seven-segment displays for debugging and real-time feedback.

# Key Technologies
VHDL, FPGA (Basys 3), Real-Time Edge Detection, Finite State Machines (FSM), Digital Signal Processing, RTL Design.
