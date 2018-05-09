all:
	@time gnatprove -Pproj --prover=z3,cvc4,altergo -j0 --codepeer=on --output-header | tee proof.log.tmp
	@egrep -q '\(medium\|warning\|error\):' proof.log.tmp
	@mv proof.log.tmp proof.log

clean:
	@gprclean -Pproj
	@gnatprove -Pproj --clean
	@rm -rf obj adalib

test:
	@gprbuild -P tests/test.gpr -gnata
	@obj/test

.PHONY: test
