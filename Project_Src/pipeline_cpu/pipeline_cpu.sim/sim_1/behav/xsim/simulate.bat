@echo off
REM ****************************************************************************
REM Vivado (TM) v2019.2 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
<<<<<<< HEAD
REM Generated by Vivado on Wed Sep 08 15:01:26 +0800 2021
=======
REM Generated by Vivado on Wed Sep 08 14:02:06 +0800 2021
>>>>>>> dd94231bb477af599c2ba6672cf728a3df5a205a
REM SW Build 2708876 on Wed Nov  6 21:40:23 MST 2019
REM
REM Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
echo "xsim testbench_behav -key {Behavioral:sim_1:Functional:testbench} -tclbatch testbench.tcl -view C:/Users/91867/Desktop/pipeline-cpu/Project_Src/pipeline_cpu/pipeline_cpu.sim/testbench_behav.wcfg -log simulate.log"
call xsim  testbench_behav -key {Behavioral:sim_1:Functional:testbench} -tclbatch testbench.tcl -view C:/Users/91867/Desktop/pipeline-cpu/Project_Src/pipeline_cpu/pipeline_cpu.sim/testbench_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
