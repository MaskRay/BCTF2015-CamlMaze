.PHONY: all test clean force dist
CXXFLAGS += -g3 -std=c++1y
P := server *.tgz

# camlrun
C := $(addprefix runtime/,main.c compare.c error.c instruct.c io.c main.c prim.c str.c)

all: server CamlFeatherweight/camlfwc bytecode user.tgz

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

# for user

user.tgz: CamlFeatherweight/camlfwrun CamlFeatherweight/camlfwod bytecode
	strip -s $<
	tar zcf $@ --transform 's,CamlFeatherweight/,,' $^

# dist
dist:
	git archive --format=tgz HEAD -o dist.tgz

# poc
poc: poc.cc

clean:
	$(RM) $P

run_server: server
	@killall server || :
	socat tcp-l:1236 exec:./server </dev/null >/dev/null 2>&1 &

test: client
