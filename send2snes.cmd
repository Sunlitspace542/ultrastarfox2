@echo off
echo UPLOADING TO SNES, DO NOT CLOSE THIS WINDOW
usb2snes-cli.exe --upload SF2.SFC --path ./SF2.SFC
usb2snes-cli.exe --boot ./SF2.SFC