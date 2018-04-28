all:
	@gprbuild -F -Pproj -p
	@gnatprove -Pproj --warnings=error --steps=10000 --prover=altergo,z3,cvc4


clean:
	@gprclean -Pproj
	@gnatprove -Pproj --clean
	@rm -rf obj adalib

test:
	@gnattest -Pproj
	@gprbuild -P obj/gnattest/harness/test_driver.gpr
	@obj/gnattest/harness/test_runner

.PHONY: test
