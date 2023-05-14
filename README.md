# mmrv\_cpu

My implementation of RV32I ISA ;\]

## behavioral\_simulation

Requirements:

* GNU/Linux machine (no, I don't plan on supporting windows ever ;\], please use a sane OS)

* verilator 5.010 (or newer)

* GNU Make 4.x

* g++ 12.x


Optional:

* gtkwave


Steps:


1. Clone the repository

2. cd into the repository's main directory

3. ``mkdir waveforms``

4. ``make``

5. Now all of waveforms generated by all of the testbenches in the project are present in /waveforms directory


If you want to know what some testbench does, just read the code (it doesn't bite)


## milestones

[ ] Somewhat functional multicycle CPU design

[ ] Pipelined CPU

[ ] Simple branch predictor

[ ] Out-of-order execution support

