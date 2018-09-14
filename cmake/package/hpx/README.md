HPX
===
http://stellar-group.org/libraries/hpx


Supported platforms
-------------------

| host platform | target platform | compiler   | architecture |
| ------------- | --------------- | ---------- | ------------ |
| linux         | linux           | gcc, 4.9   | x86-64       |
| macOS         | macOS           | clang, 3.8 | x86-64       |

Other platforms may work but have not been tested.


Package-specific options
------------------------

| variable                       | description                                 |
| ------------------------------ | --------------------------------------------|
| `hpx_version`                  | Version of HPX to build                     |
| `hpx_build_examples`           | Build the examples                          |


Platform-specific notes
-----------------------
**Linux**

Use the package manager to install gperftools, hwloc and jemalloc.

Debian-based distribution:
- `libgoogle-perftools-dev`
- `libhwloc-dev`
- `libjemalloc-dev`

Redhat-based distribution:
- `gperftools-devel`
- `hwloc-devel`
- `jemalloc-devel`


**macOS**

Tested with compiler installed by macports. Use the package manager to
install `hwloc`, `jemalloc` and `google-perftools`.
