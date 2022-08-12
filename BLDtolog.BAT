cls
set path=%path%;c:\bin
cd sf2
echo deleting any pre-existing SOB files. An "unable to delete" error means the .SOB files were properly cleared after the previous assembly.
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
del .\sf2\*.map
copy .\sf2\symbols.txt symbols.txt
del .\sf2\symbols.txt
pause
exit
