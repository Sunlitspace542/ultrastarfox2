# UltraStarFox2
Star Fox 2 (SNES, 1996/2017), with modifications for easier creation of ROM hacks and general ease-of-use.

## Notes
- **This codebase is difficult to work with.**  
- The game will not assemble without some files being present in the root of the SF2 directory for some reason.
- In the source code, the Normal, Hard and Expert difficulties are referred to as Easy, Normal, and Hard.
- A lot of source files use the DOS (CP437) encoding.

## Features
- PAL version support, change ``pal`` to 1 in ``VARS.INC`` (StarWing 2 Logo by Josete2k, edited by Sunlitspace542)  
- Kando was involved

## Building on Windows

Requirements: Microsoft Windows, Python 3

Download repo as ZIP and extract somewhere, or clone the repo with git via the command line.  

to build ROM, run ``build.cmd``  

to build ROM with Logging, run ``build to log.cmd``

to rebuild color palettes, run ``build palette.cmd``  

After building, a debug symbol map will be created at ``SYMBOLS.TXT``.

Build flags can be found in ``SF2/VARS.INC``

## Building on Linux (Ubuntu)

**NOTE: this was tested on WSL with Ubuntu installed. there is a chance stuff doesn't work.**  

Requirements: Ubuntu (might work with Debian) DOSBox-x, Python 3, git

DOSBox-X deb package: https://cdn.discordapp.com/attachments/928458781266960415/1007476106485583872/dosbox-x_0.83.4-0.83.4_amd64-SDL2-deb.zip

Clone repository: ``git clone https://github.com/Sunlitspace542/ultrastarfox2`` 

to build ROM, run ``build.sh``  

to build ROM with Logging, run ``buildtolog.sh``

to rebuild color palettes, run ``buildpalette.sh`` 

After building, a debug symbol map will be created at ``SYMBOLS.TXT``.

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
│   ├── MARIO: .MC SuperFX Code files
│   ├── MSG: Message files for English and Japanese
│   ├── MSPRITES: contains 7 BIN files (interleaved textures)
│   ├── SHAPES: contains all shape files
│   └── SOUND: sound/music data
├── TOOLS: tools such as packer and ShapeEd
├── DOCS: .md format text files covering various aspects of SF2
├── OPTIONALSTUFF: optional graphics files
└── OTHER: Files for building MSPRITES /bin files
```
