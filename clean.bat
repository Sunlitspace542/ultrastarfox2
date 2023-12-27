cls
set path=%path%;c:\bin
set sasmheap=14400
cd sf
@echo off
echo Cleaning...
make clean
cd ..
del SF2\BANK\*.SOB
del SF2\MSPRITES\*.BIN
del SF2\DATA\COL\ALLCOLS.COL
del SF2\DATA\COL\*.PAC
del SF2\DATA\COL\*.TMP
del SF2\DATA\*.CCR
del SF2\DATA\*.PCR
del SF2\SF2.SFC
del sf2.SFC
del symbols.txt
exit
