GNATPROVE_OPTS = --prover=z3,cvc4,altergo -j0 --codepeer=off --output-header --no-inlining --proof=progressive
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

examples::
	@gprbuild $(COMMON_OPTS) -P examples/examples.gpr
	@gnatprove $(COMMON_OPTS) -P examples/examples.gpr $(GNATPROVE_OPTS)
	@obj/b64

authproxy:
	@gprbuild $(COMMON_OPTS) -P doc/authproxy.gpr

.PHONY: test
