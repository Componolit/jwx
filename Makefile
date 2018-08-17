GNATPROVE_OPTS = --prover=z3,cvc4 -j2 --codepeer=off --output-header --no-inlining --proof=progressive --steps=100
COMMON_OPTS = -Xlibtype=dynamic

EXAMPLES = b64 json area jwt authproxy
CALLGRAPH = none

all: JWX.gpr
	@time gnatprove $(COMMON_OPTS) -PJWX $(GNATPROVE_OPTS) | tee proof.log.tmp
	@egrep -v -q '\(medium\|warning\|error\):' proof.log.tmp
	@mv proof.log.tmp proof.log

clean:
	@make -C contrib/libsparkcrypto clean
	@gprclean $(COMMON_OPTS) -PJWX
	@gnatprove  $(COMMON_OPTS) -PJWX --clean
	@rm -rf obj adalib

doc: JWX.gpr
	@gnatdoc --no-subprojects -w --enable-build $(COMMON_OPTS) -PJWX

stack: COMMON_OPTS += -Xcallgraph=su_da
stack: CALLGRAPH = su_da
stack: JWX.gpr
	@gprbuild $(COMMON_OPTS) -PJWX
	@gnatstack -PJWX

test: JWX.gpr
	@gprbuild $(COMMON_OPTS) -P tests/test.gpr -gnata -p
	@obj/test

examples:: $(addprefix obj/,$(EXAMPLES))

$(addprefix obj/,$(EXAMPLES)): obj/lsc/libsparkcrypto.gpr examples/*.ad?
	@gprbuild $(COMMON_OPTS) -P examples/examples.gpr
	@gnatprove $(COMMON_OPTS) -P examples/examples.gpr $(GNATPROVE_OPTS)

JWX.gpr: obj/lsc/libsparkcrypto.gpr

contrib/libsparkcrypto/Makefile:
	@git submodule init
	@git submodule update

obj/lsc/libsparkcrypto.gpr: contrib/libsparkcrypto/Makefile
	@make -C contrib/libsparkcrypto/ NO_SPARK=1 NO_TESTS=1 DESTDIR=$(PWD)/obj/lsc CALLGRAPH=$(CALLGRAPH) install

.PHONY: test
