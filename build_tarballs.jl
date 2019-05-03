# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "YasmBuilder"
version = v"1.3.0"

# Collection of sources required to build YasmBuilder
sources = [
    "http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz" =>
    "3dce6601b495f5b3d45b59f7d2492a340ee7e84b5beca17e48f862502bd5603f",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd yasm-1.3.0/
./configure --prefix=$prefix --host=$target CCLD_FOR_BUILD="$CC"
make -j${nproc}
make install
make distclean
make clean

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libyasm", :libyasm),
    ExecutableProduct(prefix, "", :yasm),
    ExecutableProduct(prefix, "", :ytasm),
    LibraryProduct(prefix, "libyasmstd", :libyasmstd),
    ExecutableProduct(prefix, "", :vsyasm)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

