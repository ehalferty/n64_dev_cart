#!/bin/bash

mkdir tmp
cp chisel_output/N64DevCartMain.v tmp/
cp src/verilog/cart_rom.v tmp/
cp src/verilog/main.v tmp/
cp src/verilog/testbench.sv tmp/

cd tmp

iverilog '-Wall' '-g2012' \
main.v \
N64DevCartMain.v \
cart_rom.v \
testbench.sv \
&& vvp a.out
