GNATPROVE_OPTS = --prover=z3,cvc4,altergo -j0 --codepeer=on --output-header
COMMON_OPTS = -Xlibtype=dynamic

all:
	@time gnatprove $(COMMON_OPTS) -Pproj $(GNATPROVE_OPTS) | tee proof.log.tmp
	@egrep -q '\(medium\|warning\|error\):' proof.log.tmp
	@mv proof.log.tmp proof.log

clean:
	@gprclean $(COMMON_OPTS) -Pproj
	@gnatprove  $(COMMON_OPTS) -Pproj --clean
	@rm -rf obj adalib

test:
	@gprbuild $(COMMON_OPTS) -P tests/test.gpr -gnata -p
	@obj/test

example:
	@gprbuild $(COMMON_OPTS) -P doc/example.gpr
	@gnatprove $(COMMON_OPTS) -P doc/example.gpr $(GNATPROVE_OPTS)
	@obj/example

.PHONY: test
