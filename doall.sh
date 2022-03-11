#!/bin/bash


mkdir tmp
cp src/verilog/MisterSdram32MBController.v tmp/
cp src/verilog/testbench.sv tmp/

cd tmp

iverilog '-Wall' '-g2012' \
MisterSdram32MBController.v \
testbench.sv \
&& vvp a.out


# rm -rf ./chisel_output/*
# sbt compile
# sbt run
