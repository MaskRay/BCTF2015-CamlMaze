.PHONY: all test clean
CXXFLAGS += -g3 -std=c++1y
P := server client

server: server.cc
client: client.cc
poc: poc.cc

clean:
	$(RM) $P

run_server: server
	./server </dev/null >/dev/null 2>&1

test: client
