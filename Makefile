GNATPROVE_OPTS = -j0 --output-header
COMMON_OPTS = -Xlibtype=dynamic

EXAMPLES = b64 json area jwt authproxy
CALLGRAPH = none

all: JWX.gpr
	@time gnatprove $(COMMON_OPTS) -PJWX $(GNATPROVE_OPTS) | tee proof.log.tmp
	@egrep -v -q '\(medium\|warning\|error\):' proof.log.tmp
	@mv proof.log.tmp proof.log

clean: JWX.gpr
	@make -C contrib/libsparkcrypto clean
	@gprclean $(COMMON_OPTS) -PJWX
	@gnatprove  $(COMMON_OPTS) -PJWX --clean
	@rm -rf obj adalib proof.log* undefined.ciu graph.vcg

doc: doc/api/index.html

doc/api/index.html: JWX.gpr
	@gprbuild -P JWX -Xlibtype=dynamic
	@gnatdoc -q -P JWX --no-subprojects -Xlibtype=dynamic -XRTS=native -Xcallgraph=none -w -l --enable-build
	@gnatdoc -P JWX --no-subprojects -Xlibtype=dynamic -XRTS=native -Xcallgraph=none -w -l --enable-build

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
