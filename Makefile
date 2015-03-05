.PHONY: all test clean force submit
CXXFLAGS += -g3 -std=c++1y
P := server client

# camlrun
C := $(addprefix runtime/,main.c compare.c error.c instruct.c io.c main.c prim.c str.c)

all: server CamlFeatherweight/camlfwc bytecode

# server
server: server.cc

# client
CamlFeatherweight/camlfwc: force
	$(MAKE) -C CamlFeatherweight

camlfwrun: $(C) $(HD)
	$(LINK.c) -I runtime $(filter %.c,$^) -o $@

runtime/jumptable.h: runtime/instruct.h
	sed -rn 's/([[:upper:]]+)/\&\&lbl_\1/;T;p' $< > $@

runtime/instruct.c: runtime/instruct.h
	{ echo 'const char *name_of_instructions[] = {'; sed -rn 's/([[:upper:][:digit:]]+).*/"\1",/;T;p' $<; echo '};';} > $@

bytecode: CamlFeatherweight/camlfwc client.ml
	CamlFeatherweight/camlfwc client.ml -o $@

# submit

submit: CamlFeatherweight/camlfwrun CamlFeatherweight/camlfwod bytecode
	tar zcf submit.tgz --transform 's,CamlFeatherweight/,,' $^

# poc
poc: poc.cc

clean:
	$(RM) $P

run_server: server
	@killall server || :
	socat tcp-l:1236 exec:./server </dev/null >/dev/null 2>&1 &

test: client
