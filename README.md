# freedom-elf2hex

    ./freedom-elf2hex [--help] --bit-width BIT_WIDTH --input INPUT.ELF [--output OUTPUT.HEX]

SiFive's Verilog test harnesses can't directly read ELF binaries but are
instead required to be provided with a hexidecimal dump of a particular
width and depth.  This project allows users to easily create these
files.

## Building `freedom-elf2hex` from git

The latest source for `freedom-elf2hex` can be found on [SiFive's GitHub]
(https://github.com/sifive/freedom-elf2hex).  While the master branch is
always meant to be stable, there are no guarantees.  To build from
git sources you must regenerate the build scripts from their sources and
then follow the standard build flow

    git clone git://github.com/sifive/freedom-elf2hex.git
    cd freedom-elf2hex
    make
    make install INSTALL_PATH=/tmp/freedom-elf2hex
