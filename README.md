# BCTF 2015 CamlMaze

## Build user.tgz

For users to download:

```bash
make user.tgz
```

## Build server

Server-side program:

```bash
make server
```

Run the server locally:

```bash
make run_server
# alternatively, socat tcp-l:1236,fork exec:./server
```

## POC

Applicable POC: [poc.rb](poc.rb)

Substitue `spawn ['CamlFeatherweight/camlfwrun', ''], '-h', '127.0.0.1', '-p', '1212', '/tmp/bytecode', in: pr, out: slave` for the line `spawn ...` to attack againt a remote server.
