TOP      = top
TB       = top_test
SNAPSHOT = ${TB}_snapshot

VFILES   = top.sv top_tb.sv controller_alu.sv spi_slave.sv

.PHONY: all parse elab run gui clean

all: run

parse:
	xvlog -sv ${VFILES}

elab: parse
	xelab -debug typical ${TB} -s ${SNAPSHOT}

run: elab
	xsim ${SNAPSHOT} -R

gui: elab
	xsim ${SNAPSHOT} -gui

clean:
	rm -rf xsim.dir *.log *.jou *.pb *.wdb webtalk* .Xil
