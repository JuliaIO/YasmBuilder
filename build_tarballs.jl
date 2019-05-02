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
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain
make -j${nproc}
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    # Windows
    Windows(:i686),
    Windows(:x86_64),

    # linux
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc),
    Linux(:powerpc64le, :glibc),

    # musl
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),

    # The BSD's
    FreeBSD(:x86_64),
    MacOS(:x86_64),
]

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

