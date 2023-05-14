VERILATOR=verilator

RTL_PATH=rtl
TBS_PATH=testbenches

VERILATOR_FLAGS=--trace -cc
WAVEFORM_PATH=waveforms


all: sp_ram


sp_ram:
	${VERILATOR} ${VERILATOR_FLAGS} ${RTL_PATH}/sp_ram.v --exe ${TBS_PATH}/tb_sp_ram.cc
	make -C obj_dir -f Vsp_ram.mk Vsp_ram
	./obj_dir/Vsp_ram


clean:
	rm -Rf obj_dir
	rm -R  ${WAVEFORM_PATH}/*
