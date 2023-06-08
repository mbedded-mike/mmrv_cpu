VERILATOR=verilator

RTL_PATH=rtl
TBS_PATH=testbenches

VERILATOR_FLAGS=--trace -cc
WAVEFORM_PATH=waveforms


all: sp_ram register_file instr_decoder main_ctl alu core


sp_ram:
	${VERILATOR} ${VERILATOR_FLAGS} ${RTL_PATH}/sp_ram.v --exe ${TBS_PATH}/tb_sp_ram.cc
	make -C obj_dir -f Vsp_ram.mk Vsp_ram
	./obj_dir/Vsp_ram

register_file:
	${VERILATOR} ${VERILATOR_FLAGS} ${RTL_PATH}/register_file.v --exe ${TBS_PATH}/tb_register_file.cc
	make -C obj_dir -f Vregister_file.mk Vregister_file
	./obj_dir/Vregister_file

instr_decoder:
	${VERILATOR} ${VERILATOR_FLAGS} ${RTL_PATH}/instr_decoder.sv --exe ${TBS_PATH}/tb_instr_decoder.cc
	make -C obj_dir -f Vinstr_decoder.mk Vinstr_decoder
	./obj_dir/Vinstr_decoder

main_ctl:
	${VERILATOR} ${VERILATOR_FLAGS} ${RTL_PATH}/main_ctl.sv --exe ${TBS_PATH}/tb_main_ctl.cc
	make -C obj_dir -f Vmain_ctl.mk Vmain_ctl
	./obj_dir/Vmain_ctl

core:
	make -C ${TBS_PATH}/rvasm/
	${VERILATOR} ${VERILATOR_FLAGS} ${RTL_PATH}/core.sv \
		${RTL_PATH}/instr_decoder.sv \
		${RTL_PATH}/register_file.v  \
		${RTL_PATH}/alu.sv           \
		--exe ${TBS_PATH}/tb_core.cc
	make -C obj_dir -f Vcore.mk Vcore
	./obj_dir/Vcore

alu:
	${VERILATOR} ${VERILATOR_FLAGS} ${RTL_PATH}/alu.sv --exe ${TBS_PATH}/tb_alu.cc
	make -C obj_dir -f Valu.mk Valu
	./obj_dir/Valu



clean:
	rm -Rf obj_dir
	rm -R  ${WAVEFORM_PATH}/*
