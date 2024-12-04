# Seasick

The smallest seastar program you've ever seen just to test out how certain flags (`--memory`, `--smp`, `--reserve-memory`) play with cgroups.

## Usage

```bash
nix build

systemd-run --user --scope -p MemoryMax=6G ./result/bin/seasick
```

## Useful links
- https://docs.seastar.io/master/tutorial.html#threads-and-memory
- https://github.com/scylladb/seastar/blob/b63b02a1f674a96365ec688f257294cebac3b865/src/core/resource.cc#L241
