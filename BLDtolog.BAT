cls
set path=%path%;c:\bin
cd sf2
del .\bank\*.sob
make sf.rom > ..\build.log
cd ..
copy sf2\sf.rom sf2.sfc
del .\sf2\*.rom
del .\sf2\BANK\*.sob
del .\sf2\msgtable.tmp
del .\sf2\alvars.txt
del .\sf2\techdata.txt
del .\sf2\externs.log
pause
exit