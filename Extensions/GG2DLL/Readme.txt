This DLL uses libpng, which needs zlib.

GG2DLL/GG2DLL.cbp is a Code::Blocks project file you can use to build the DLL.

It references 4 directories:
  libpng_include
  libpng_lib
  zlib_include
  zlib_lib
These should be symlinked to the appropriate include and library directories for
GCC to find headers and compiled binaries for libpng and zlib.

GG2DLL should be built as a static binary with no dependencies on external DLLs.
libpng and zlib can produce DLLs but these should not be used by GG2DLL.