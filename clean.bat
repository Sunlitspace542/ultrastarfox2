cls
set path=%path%;c:\bin
set sasmheap=14400
cd sf
@echo off
echo Cleaning...
make clean
cd ..
del sf2.SFC
del symbols.txt
exit
