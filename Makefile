all:
	@time gnatprove -Pproj --steps=5000 --prover=z3 -j0 --codepeer=on --output-header | tee proof.log
	@egrep -q '\(medium\|warning\|error\):' proof.log

clean:
	@gprclean -Pproj
	@gnatprove -Pproj --clean
	@rm -rf obj adalib

test:
	@gnattest -Pproj
	@gprbuild -P obj/gnattest/harness/test_driver.gpr
	@obj/gnattest/harness/test_runner

.PHONY: test
