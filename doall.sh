#!/bin/bash

cd tmp
rm -rf *

# /Users/ed/n64/n64_dev_cart/src/verilog/MisterSdram32MBController.v

iverilog '-Wall' '-g2012' \
../src/verilog/MisterSdram32MBController.v \
../src/verilog/sdram_tester_00.v \
../src/verilog/testbench.sv \
&& vvp a.out


# rm -rf ./chisel_output/*
# sbt compile
# sbt run
