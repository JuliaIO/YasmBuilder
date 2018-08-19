# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

# Collection of sources required to build YasmBuilder
sources = [
    "http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz" =>
    "3dce6601b495f5b3d45b59f7d2492a340ee7e84b5beca17e48f862502bd5603f",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd yasm-1.3.0/
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain
make -j${nproc}
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, :glibc)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libyasm", Symbol("")),
    ExecutableProduct(prefix, "", Symbol("")),
    ExecutableProduct(prefix, "", Symbol("")),
    LibraryProduct(prefix, "libyasmstd", Symbol("")),
    ExecutableProduct(prefix, "", Symbol(""))
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "YasmBuilder", sources, script, platforms, products, dependencies)

