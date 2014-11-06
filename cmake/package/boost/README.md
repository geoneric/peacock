Boost
=====
http://www.boost.org

**Supported platforms**

| host platform | target platform | compiler | architecture |
| ------------- | --------------- | -------- | ------------ |
| linux         | linux           | gcc-4    | x86-64       |
| linux         | linux           | clang-3  | x86-64       |
| linux         | windows         | mingw    | x86-32       |
| linux         | windows         | mingw    | x86-64       |
| windows       | windows         | mingw    | x86-64       |

Other platforms may work but have not been tested.


Platform specific notes
-----------------------
**Windows, Mingw-w64, Cygwin Bash shell**

The build of Boost.Context requires the [ml64 command](http://msdn.microsoft.com/en-us/library/hb5z4sxd.aspx) to be available. In case the command cannot be found, add the directory containing the command to the PATH environment variable before calling CMake:

```bash
export PATH="$VS90COMNTOOLS/../../VC/BIN/amd64:$PATH"
```
