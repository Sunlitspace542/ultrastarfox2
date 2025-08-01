# UltraStarFox2
Star Fox 2, with modifications for easier creation of ROM hacks and general ease-of-use.  

## Notes
- **This codebase is difficult to work with.**  
- In the source code, the Normal, Hard and Expert difficulties are referred to as Easy, Normal, and Hard.  
- Many source files use the DOS (CP437) encoding. Make sure you configure this in your editor. Note that the message files are in UTF-8 format.  
- The assembler will fail to assemble files with Unix (LF) line endings. Make sure your editor is configured for DOS/Windows (CRLF) line endings.  

## Features
- PAL version support, change ``pal`` to 1 in ``VARS.INC`` (StarWing 2 Logo by Josete2k, edited by Sunlitspace542)  
- File structure reorganized to make the codebase somewhat easier to work with    
- Kando was involved  

## Building on Windows

Requirements: Microsoft Windows

Download repo as ZIP and extract somewhere, or clone the repo with git via the command line.  

To build ROM, run ``build.cmd``.  

To build ROM with Logging, run ``build to log.cmd``.  

To clean, run ``clean.cmd``.  

After building, a debug symbol map will be created at ``SYMBOLS.TXT``, and a bank space report at ``BANKS.CSV``.  

## Building on Linux

**NOTE: this was tested on WSL with Ubuntu installed. Your mileage may vary.**  

Requirements: Ubuntu (might work with other distros) snap, DOSBox-X, git  

Install snapstore: ``sudo apt install snapd``  

Install DOSBOX-X from snap: ``sudo snap install dosbox-x``  

Clone repository: ``git clone https://github.com/Sunlitspace542/ultrastarfox2``  

To build ROM, run ``make``.  

To build ROM with logging, run ``make log``.  

To clean, run ``make clean``.  

After building, a debug symbol map will be created at ``SYMBOLS.TXT``, and a bank space report at ``BANKS.CSV``.  

## Uploading ROM to SNES over USB with SD2SNES/FXPak(Pro)
Uses [USB2SNES-cli](https://github.com/Hyphen-ated/usb2snes-cli) fork by Hyphen-ated. A prebuilt windows EXE is provided.  
Download [QUSB2SNES](https://github.com/Skarsnik/QUsb2snes/releases).  
Extract it somewhere and run it. Set it up for an SD2SNES/FXPak Pro.  
**QUSB2SNES must be running in the background for uploading to function.**  
You can then run ``send2snes.cmd`` or ``build and send to snes.cmd`` to either upload the current ROM to the SNES or rebuild and upload the freshly built ROM.  

## Project Structure
```
ultrastarfox2
├── BIN: exe files needed to assemble game code
├── SF2: Main source code is located here
│   ├── ASM: Main game code located here (65816)
│   ├── BANK: Bank data\ASM files
│   ├── DATA: GFX files
│   │   └── COL: Palette files and Palette Packer
│   ├── EXT: .ext files needed by several .asm files
│   ├── FONT: .bin font files
│   ├── INC: .inc files, arc tangent table
│   ├── MAPS: map scripts
│   ├── MARIO: .MC MARIO chip (SuperFX) code 
│   ├── MSG: Message files for English and Japanese (UTF-8)
│   ├── MSPRITES: contains interleaved FXGfx format textures
│   ├── PATH: contains all PATH language code
│   ├── SHAPES: contains all shape files
│   ├── SOUND: sound/music data
│   └── STRAT: Code for Strategies (Object behaviors)
├── TOOLS: tools such as PACKER and SHAPED
├── DOCS: .md format text files covering various aspects of Star Fox 2
├── OPTIONALSTUFF: optional graphics files
└── OTHER: Files for building MSPRITES /bin files
```
