all:
	@gprbuild -P base64 -p
	@gnatprove -P base64 --warnings=error


clean:
	@gprclean -P base64
	@gnatprove -P base64 --clean
	@rm -rf obj adalib

test:
	@gnattest -P base64
	@gprbuild -P obj/gnattest/harness/test_driver.gpr
	@obj/gnattest/harness/test_runner

.PHONY: test
