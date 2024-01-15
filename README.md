# RISC-V Pipelined Processor

This is a verilog code for a 5-stage pipelined RISC-V Processor with forwarding, stalling, and flushing functionality. Here is the circuit diagramme of the processor.

![image](https://user-images.githubusercontent.com/56905673/117547053-f932fe00-b046-11eb-91af-9291291d4f52.png)

## RISC-V Assembly Language. 
![image]![Ảnh1](https://github.com/Vietngo2748/RICS-V-simple-core/assets/150679207/2428d09b-d6a1-4c81-962b-0c6e0980929a)
![image]![Ảnh2](https://github.com/Vietngo2748/RICS-V-simple-core/assets/150679207/b0614e91-e0d9-4a5d-b7a4-d08ffee7d511)

### Instructions
For simulation purposes, open a new waveform and load cpu.sv files. In the tab for cpu.sv, add all other sv files in the repository.

#### Instruction for my cpu
# Initialize i iterator and offset tracker
addi x8, x0, 0    # i iterator (starts at 0)
addi x18, x0, 0   # to track a[i] offset

# Outer loop: check if i < 10
outerloop:
  beq x8, x11, outerexit # exit if i >= 10

  # Set j iterator to i for each outer loop
  add x29, x0, x8

  # Calculate offset for a[j] (j * 8)
  add x19, x8, x0
  add x19, x19, x19
  add x19, x19, x19

  # Inner loop: check if j < 10
  innerloop:
    beq x29, x11, innerexit # exit if j >= 10

    # Increment j and calculate offset for a[j] (j * 8)
    addi x29, x29, 1
    addi x19, x19, 8

    # Load a[i] and a[j] into registers
    ld x26, 0x0(x18)
    ld x27, 0x0(x19)

    # Compare a[i] and a[j], if a[i] < a[j], perform bubble sort
    blt x26, x27, bubblesort

    # Unconditional loop
    beq x0, x0, innerloop

  # Bubble sort: swap a[i] and a[j]
  bubblesort:
    add x5, x0, x26   # int temp = a[i]
    sd x27, 0(x18)     # a[i] = a[j]
    sd x5, 0(x19)      # a[j] = temp

    # Unconditional loop
    beq x0, x0, innerloop

  # Increment i and offset tracker
  innerexit:
    addi x8, x8, 1
    addi x18, x18, 8

  # Unconditional loop for outer loop
  beq x0, x0, outerloop

# Exit the program
outerexit:

