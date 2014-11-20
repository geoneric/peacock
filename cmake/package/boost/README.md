Boost
=====
http://www.boost.org

**Supported platforms**

| host platform | target platform | compiler | architecture |
| ------------- | --------------- | -------- | ------------ |
| linux         | linux           | gcc, 4.9 | x86-64       |
| linux         | linux           | clang-3  | x86-64       |
| linux         | windows         | mingw    | x86-32       |
| linux         | windows         | mingw    | x86-64       |
| windows       | windows         | mingw    | x86-64       |
| windows       | windows         | mingw    | x86-32       |
| macosx        | macosx          | gcc-4    | x86-64       |

Other platforms may work but have not been tested.


Platform specific notes
-----------------------
**Windows, Mingw, Cygwin Bash shell**

The build of Boost.Context requires the [ml or ml64 command](http://msdn.microsoft.com/en-us/library/s0ksfwcf.aspx) to be available. In case the command cannot be found, add the directory containing the command to the PATH environment variable before calling CMake:

```bash
# 32-bit build:
export PATH="$VS90COMNTOOLS/../../VC/BIN:$PATH"

# 64-bit build:
export PATH="$VS90COMNTOOLS/../../VC/BIN/amd64:$PATH"
```

If the command cannot be found, the build of Boost.Context will be skipped, including projects depending on it (Boost.Coroutine).
