#!/bin/bash

rm -rf chisel_output/*
sbt test
sbt run
