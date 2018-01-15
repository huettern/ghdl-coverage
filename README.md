# ghdl-coverage
## Setup
```bash
# Requirements
apt install gnat build-essential libmpc-dev flex bison libz-dev lcov
# Download ghdl
wget https://github.com/ghdl/ghdl/archive/v0.35.tar.gz
tar -xvzf v0.35.tar.gz
cd ghdl-0.35/
mkdir build
cd build
# Download gcc 7.2 sources
wget ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-7.2.0/gcc-7.2.0.tar.gz
tar -xvf gcc-7.2.0.tar.gz
# Configure and build first gcc then ghdl
../configure --with-gcc=gcc-7.2.0  --prefix=/usr/local
make copy-sources
mkdir gcc-objs; cd gcc-objs
../gcc-7.2.0/configure --prefix=/usr/local --enable-languages=c,vhdl \
 --disable-bootstrap --disable-lto --disable-multilib --disable-libssp \
 --disable-libgomp --disable-libquadmath
make -j4 && make install MAKEINFO=true
make ghdllib
make install
```

## Usage

## Example
Full adder example from [here](https://blog.brixandersen.dk/2016/12/29/ghdl-gcov/) using code from [here](http://ghdl.readthedocs.io/en/latest/using/QuickStartGuide.html)
```bash
cd projects/full_adder
ghdl -a -Wc,-fprofile-arcs -Wc,-ftest-coverage adder.vhd
ghdl -a adder_tb.vhd
ghdl -e -Wl,-lgcov adder_tb
ghdl -r adder_tb
# Generate code coverage report using gcov
gcov -s $PWD adder.vhd
# Generate code coverage report using lcov
lcov -c -d . -o adder_tb.info
genhtml -o html adder_tb.info
```
