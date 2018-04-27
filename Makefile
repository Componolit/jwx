all:
	@gprbuild -F -Pbase64 -p
	@gnatprove -Pbase64 --warnings=error --timeout=0


clean:
	@gprclean -Pbase64
	@gnatprove -Pbase64 --clean
	@rm -rf obj adalib

test:
	@gnattest -Pbase64
	@gprbuild -P obj/gnattest/harness/test_driver.gpr
	@obj/gnattest/harness/test_runner

.PHONY: test
