Boost
=====

Platform specific notes
-----------------------
**Windows, Mingw-w64, Cygwin Bash shell**

The build of Boost.Context requires the [ml64 command](http://msdn.microsoft.com/en-us/library/hb5z4sxd.aspx) to be available. In case the command cannot be found, add the directory containing the command to the PATH environment variable before calling CMake:

```bash
export PATH="$VS90COMNTOOLS/../../VC/BIN/amd64:$PATH"
```
