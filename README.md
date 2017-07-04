MIPS_CPU

A pipeline MIPS_CPU implemented by verilog and ISE

---

1.Environment

	OS:windows 8.1 home

	platform:ISE14.7

	Development Borad:Xilinx Nexys3

2.The way of implementation

	1.To make PC switch correctly

	In this stage,I only implement PC switch module and the basic data 	path(including I-Mem,D-Mem,reg,ALU and basic control unit),using ISIM to see whether PC switches well. 

	2.To implement logical instructions

	3.To implement algorithm instructions

	4.To implement branch and jump instructions

	5.To implement load and store instructions and solving load risk

	6.To download to the development board 	

	7.Make branch prediction

3.Technical Index

	1.support 26 insturctions

	2.5 stages pipeline

	3. static branch prediction

	4. three-level-forwarding
