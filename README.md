# Basic Systolic Array

Parameterizable Weight-Stationary Systolic Array implemented in Verilog designed to accelerate matrix multiplication through 2D grid of Processing Elements (PEs)

## Features
* Configurable Square Array Size via Verilog parameters
* Staggered data movement
* Includes a top-level wrapper for VIO Integration
* Verified on Digilent Arty S7-25 FPGA (constraints file for Arty S7-25 included)

# Architecture
Consists of 2D grid of PEs with each responsible for following operations:
1. Multiplying horizontal activations to PE stored weight
2. Adds product to sum arriving from PE above
3. Passes activation to the right and calculated sum to the bottom

## License
This project is licensed under the MIT License.
