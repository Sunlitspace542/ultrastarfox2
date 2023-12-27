cls
set path=%path%;c:\bin
cd sf2
@echo off
echo Cleaning...
make clean
cd ..
del sf2.SFC
del symbols.txt
exit
