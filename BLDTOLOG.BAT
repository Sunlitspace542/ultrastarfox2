cls
set path=%path%;c:\bin
set starfoxuser=dylan
cd sf2
make NOANSI=-sNOANSI > ..\build.log
cd ..
exit
