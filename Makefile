GNATPROVE_OPTS = --prover=z3,cvc4,altergo -j0 --codepeer=on --output-header

all:
	@time gnatprove -Pproj $(GNATPROVE_OPTS) | tee proof.log.tmp
	@egrep -q '\(medium\|warning\|error\):' proof.log.tmp
	@mv proof.log.tmp proof.log

clean:
	@gprclean -Pproj
	@gnatprove -Pproj --clean
	@rm -rf obj adalib

test:
	@gprbuild -P tests/test.gpr -gnata -p
	@obj/test

example:
	@gprbuild -P doc/example.gpr
	@gnatprove -P doc/example.gpr $(GNATPROVE_OPTS)
	@obj/example

.PHONY: test
