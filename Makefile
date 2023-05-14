VERILATOR=verilator

RTL_PATH=rtl
TBS_PATH=testbenches

VERILATOR_FLAGS=--trace -cc
WAVEFORM_PATH=waveforms


all: sp_ram register_file instr_decoder


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


clean:
	rm -Rf obj_dir
	rm -R  ${WAVEFORM_PATH}/*
