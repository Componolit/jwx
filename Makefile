all:
	@time gnatprove -Pproj --prover=z3,cvc4,altergo -j0 --codepeer=on --output-header | tee proof.log.tmp
	@egrep -q '\(medium\|warning\|error\):' proof.log.tmp
	@mv proof.log.tmp proof.log

clean:
	@gprclean -Pproj
	@gnatprove -Pproj --clean
	@rm -rf obj adalib

test:
	@gnattest -Pproj
	@gprbuild -P obj/gnattest/harness/test_driver.gpr -gnata
	@obj/gnattest/harness/test_runner

.PHONY: test
