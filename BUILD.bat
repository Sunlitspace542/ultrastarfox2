set path=%path%;c:\bin
cd sf2
make sf.rom
cd ..
copy sf2\sf.rom sf2.sfc
del sf2\*.rom
del sf2\*.sob
pause
exit